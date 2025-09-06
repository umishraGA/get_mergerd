import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import '../controller/all_event_controller.dart';
import '../controller/category_controller.dart';
import '../controller/test.dart';
import '../controller/test2.dart';
import '../screens/event_banner.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final AllEventsController controller = Get.put(AllEventsController());
  final CategoryFilterController categoryFilterController =
      Get.put(CategoryFilterController());
  final TextEditingController _searchController = TextEditingController();

  final RxString searchQuery = ''.obs; // Search query observable

  String formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    } catch (_) {
      return date;
    }
  }

  /// ✅ Helper function to show event date safely
  String getEventDate(dynamic event) {
    final dynamic rawDate = event["startDateTime"];

    if (rawDate == null) return "Date not available";

    // Case 1: If it's a List (range of dates)
    if (rawDate is List && rawDate.isNotEmpty) {
      if (rawDate.length > 1) {
        return "${formatDate(rawDate[0].toString())} to ${formatDate(rawDate[1].toString())}";
      } else {
        return formatDate(rawDate[0].toString());
      }
    }

    // Case 2: If it's a String
    if (rawDate is String && rawDate.isNotEmpty) {
      return formatDate(rawDate);
    }

    return "Date not available";
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Obx(() {
        // Filter events based on selected category
        List<dynamic> filteredEvents =
            categoryFilterController.selectedCategory.value == "All Events"
                ? controller.events
                : controller.events
                    .where((event) =>
                        event["event_category"]["categoryname"]?.toString() ==
                        categoryFilterController.selectedCategory.value)
                    .toList();

        // Apply search filter on event titles
        if (searchQuery.value.isNotEmpty) {
          filteredEvents = filteredEvents.where((event) {
            final title = event["event_title"]?.toString().toLowerCase() ?? "";
            return title.contains(searchQuery.value.toLowerCase());
          }).toList();
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopAppBarCustom(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(() => TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade400, width: 1),
                            ),
                            isDense: true,
                            suffixIcon: searchQuery.value.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      searchQuery.value = '';
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Icon(Icons.clear,
                                        color: Colors.grey[600]),
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 18, horizontal: 20),
                          ),
                          onChanged: (value) {
                            searchQuery.value = value;
                          },
                        )),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              EventBannerSlider(),
              const SizedBox(height: 16),

              SizedBox(
                height: 40,
                child: Obx(() {
                  if (categoryFilterController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryFilterController.categories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final category =
                          categoryFilterController.categories[index];
                      final isSelected =
                          categoryFilterController.selectedCategory.value ==
                              category;

                      return GestureDetector(
                        onTap: () =>
                            categoryFilterController.selectCategory(category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFC6E30)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFFC6E30)
                                  : const Color(0xFF909090),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF909090),
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Featured Events Section
              if (filteredEvents.any((event) =>
                  event["is_feature"]?.toString().toLowerCase() == "yes")) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Featured Events',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: isTablet
                      ? 480
                      : 320, // Adjusted height to prevent overflow
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    itemCount: filteredEvents
                        .where((event) =>
                            event["is_feature"]?.toString().toLowerCase() ==
                            "yes")
                        .length,
                    itemBuilder: (context, index) {
                      final featuredList = filteredEvents
                          .where((event) =>
                              event["is_feature"]?.toString().toLowerCase() ==
                              "yes")
                          .toList();
                      final event = featuredList[index];

                      return Container(
                        width: isTablet ? 300 : 260,
                        height: 150, // Adjusted width
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize
                                  .min, // Important for preventing overflow
                              children: [
                                // Event Image
                                SizedBox(
                                  height: constraints.maxWidth *
                                      0.6, // Responsive height based on width
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12)),
                                        child: Image.network(
                                          event["thumbnail"]?.toString() ??
                                              "",
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[800],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.56),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              event["event_category"]
                                                          ["categoryname"]
                                                      ?.toString() ??
                                                  "",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Event title
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    event["event_title"]?.toString() ?? "",
                                    style: const TextStyle(
                                      fontSize:
                                          16, // Slightly reduced font size
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Date and time - Combined into one row

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          color: Colors.red, size: 16),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          getEventDate(event),
                                          style:
                                              const TextStyle(fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Venue
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 2),
                                        child: Icon(Icons.location_on,
                                            color: Colors.red, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${event["venue"] ?? ""} ${event["city"]["name"] ?? ""}',
                                          style: const TextStyle(
                                              fontSize:
                                                  13), // Reduced font size
                                          maxLines:
                                              2, // Allow 2 lines for venue
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Price and book button
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${event["paidLowestPrice"] != null ? "₹${event["paidLowestPrice"]}" : "N/A"}',
                                        style: const TextStyle(
                                          fontSize:
                                              18, // Slightly reduced font size
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFFC6E30),
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 36, // Fixed height for button
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetailScreen(
                                                        eventId: event["_id"]
                                                                ?.toString() ??
                                                            ""),
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFE54B4D),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                    16), // Reduced padding
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'Book',
                                            style: TextStyle(
                                                fontSize:
                                                    13), // Reduced font size
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'No featured events available at the moment.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],

              const Divider(color: Color(0xFFEEEEEE), height: 1),

              // Upcoming Events
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Upcoming Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (filteredEvents.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  child: Center(
                    child: Text(
                      'No upcoming events found.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio:
                          MediaQuery.of(context).size.width > 600 ? 1 : 0.63,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(
                                  eventId: event["_id"]?.toString() ?? ""),
                            ),
                          );
                        },
                        child:Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  event["thumbnail"]?.toString() ?? "",
                                  width: double.infinity,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 120,
                                    width: double.infinity,
                                    color: Colors.grey[100],
                                    child: Icon(Icons.image_rounded, size: 32, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event["event_title"]?.toString().split(' ').map((word) =>
                                        word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ') ?? "",
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildInfoRow(Icons.schedule_rounded, getEventDate(event), Colors.blue),
                                      const SizedBox(height: 4),
                                      _buildInfoRow(Icons.location_on_rounded, event["city"]["name"]?.toString() ?? "", Colors.red),
                                      const Spacer(),
                                      Text(
                                        '${event["paidLowestPrice"] != null ? "₹${event["paidLowestPrice"]}" : "Free"}',
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        // child: Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     border: Border.all(
                        //         color: Colors.black.withOpacity(0.22)),
                        //     color: Colors.white,
                        //   ),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Stack(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(0),
                        //             child: ClipRRect(
                        //               borderRadius: const BorderRadius.vertical(
                        //                 top: Radius.circular(12),
                        //                 bottom: Radius.circular(0),
                        //               ),
                        //               child: AspectRatio(
                        //                 aspectRatio:
                        //                     isTablet ? 16 / 9 : 16 / 10,
                        //                 child: Image.network(
                        //                   event["thumbnail"]?.toString() ?? "",
                        //                   fit: BoxFit.cover,
                        //                   errorBuilder:
                        //                       (context, error, stackTrace) {
                        //                     return Container(
                        //                       color: Colors.grey[300],
                        //                       child: const Center(
                        //                         child: Icon(
                        //                           Icons.image_not_supported,
                        //                           size: 40,
                        //                         ),
                        //                       ),
                        //                     );
                        //                   },
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           Positioned(
                        //             bottom: 8,
                        //             left: 8,
                        //             child: Container(
                        //               padding: const EdgeInsets.symmetric(
                        //                 horizontal: 8,
                        //                 vertical: 4,
                        //               ),
                        //               decoration: BoxDecoration(
                        //                 color: Colors.black.withOpacity(0.7),
                        //                 borderRadius: BorderRadius.circular(4),
                        //               ),
                        //               child: Text(
                        //                 event["event_category"]["categoryname"]
                        //                         ?.toString() ??
                        //                     "",
                        //                 style: const TextStyle(
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.bold,
                        //                   fontSize: 12,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       Padding(
                        //         padding:
                        //             const EdgeInsets.symmetric(horizontal: 12),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               (event["event_title"]?.toString() ?? "")
                        //                   .split(' ')
                        //                   .map((word) => word.isNotEmpty
                        //                       ? '${word[0].toUpperCase()}${word.substring(1)}'
                        //                       : '')
                        //                   .join(' '),
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.w500,
                        //                 fontSize: 14,
                        //               ),
                        //               maxLines: 1,
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(4.0),
                        //               child: Row(
                        //                 children: [
                        //                   const Icon(Icons.calendar_today,
                        //                       color: Colors.red, size: 16),
                        //                   const SizedBox(width: 4),
                        //                   Expanded(
                        //                     child: Text(
                        //                       getEventDate(event),
                        //                       style:
                        //                           const TextStyle(fontSize: 13),
                        //                       overflow: TextOverflow.ellipsis,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             Row(
                        //               children: [
                        //                 const Icon(Icons.location_on,
                        //                     size: 14, color: Colors.redAccent),
                        //                 const SizedBox(width: 4),
                        //                 Expanded(
                        //                   child: Text(
                        //                     event["city"]["name"]?.toString() ??
                        //                         "",
                        //                     style:
                        //                         const TextStyle(fontSize: 12),
                        //                     maxLines: 1,
                        //                     overflow: TextOverflow.ellipsis,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 5),
                        //             Text(
                        //               '${event["paidLowestPrice"] != null ? "₹${event["paidLowestPrice"]}" : "N/A"}',
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 16,
                        //                 color: Colors.orangeAccent,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 100),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}
