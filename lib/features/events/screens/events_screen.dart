import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
import 'package:cached_network_image/cached_network_image.dart';
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import '../controller/all_event_controller.dart';
import '../controller/category_controller.dart';
<<<<<<< HEAD
import 'event_detail_screen.dart';
import '../screens/event_banner.dart';
=======
import '../controller/test.dart';
import '../controller/test2.dart';
import '../screens/event_banner.dart';
import 'event_detail_screen.dart';
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final AllEventsController controller = Get.put(AllEventsController());
  final CategoryFilterController categoryFilterController =
<<<<<<< HEAD
  Get.put(CategoryFilterController());
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

=======
      Get.put(CategoryFilterController());
  final TextEditingController _searchController = TextEditingController();

  final RxString searchQuery = ''.obs; // Search query observable

>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  String formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    } catch (_) {
      return date;
    }
  }

<<<<<<< HEAD
=======
  /// ✅ Helper function to show event date safely
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  String getEventDate(dynamic event) {
    final dynamic rawDate = event["startDateTime"];

    if (rawDate == null) return "Date not available";

<<<<<<< HEAD
=======
    // Case 1: If it's a List (range of dates)
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    if (rawDate is List && rawDate.isNotEmpty) {
      if (rawDate.length > 1) {
        return "${formatDate(rawDate[0].toString())} to ${formatDate(rawDate[1].toString())}";
      } else {
        return formatDate(rawDate[0].toString());
      }
    }

<<<<<<< HEAD
=======
    // Case 2: If it's a String
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    if (rawDate is String && rawDate.isNotEmpty) {
      return formatDate(rawDate);
    }

    return "Date not available";
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final size = MediaQuery.of(context).size; // screen size
    final isTablet = size.width > 600; // simple tablet check

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() {
          List<dynamic> filteredEvents =
          categoryFilterController.selectedCategory.value == "All Events"
              ? controller.events
              : controller.events
              .where((event) =>
          event["event_category"]["categoryname"]?.toString() ==
              categoryFilterController.selectedCategory.value)
              .toList();

          if (searchQuery.value.isNotEmpty) {
            filteredEvents = filteredEvents.where((event) {
              final title =
                  event["event_title"]?.toString().toLowerCase() ?? "";
              return title.contains(searchQuery.value.toLowerCase());
            }).toList();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopAppBarCustom(isVisibleSearchBar: false),
                _buildSearchBar(size),
                EventBannerSlider(),
                SizedBox(height: size.height * 0.02),
                _buildCategoryFilter(size),
                SizedBox(height: size.height * 0.025),
                if (filteredEvents.any((event) =>
                event["is_feature"]?.toString().toLowerCase() == "yes"))
                  _buildFeaturedEvents(filteredEvents, size, isTablet),
                _buildUpcomingEvents(filteredEvents, size, isTablet),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// ---------------------- SEARCH BAR ----------------------
  Widget _buildSearchBar(Size size) {
    return Container(
      margin: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all( // Customize border color and width
          color: Colors.grey[400]!,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search events...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: size.width * 0.04),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: searchQuery.value.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              searchQuery.value = '';
              FocusScope.of(context).unfocus();
            },
            icon: Icon(Icons.clear, color: Colors.grey[600]),
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.015,
          ),
        ),
        onChanged: (value) => searchQuery.value = value,
      ),
    );
  }  /// ---------------------- CATEGORY FILTER ----------------------
  Widget _buildCategoryFilter(Size size) {
    return SizedBox(
      height: size.height * 0.05,
      child: Obx(() {
        if (categoryFilterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryFilterController.categories.length,
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          itemBuilder: (context, index) {
            final category = categoryFilterController.categories[index];
            final isSelected =
                categoryFilterController.selectedCategory.value == category;

            return GestureDetector(
              onTap: () => categoryFilterController.selectCategory(category),
              child: Container(
                margin: EdgeInsets.only(right: size.width * 0.03),
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFC6E30) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFFC6E30)
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: size.width * 0.035,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// ---------------------- FEATURED EVENTS ----------------------
  Widget _buildFeaturedEvents(List<dynamic> filteredEvents, Size size, bool isTablet) {
    final featuredEvents = filteredEvents
        .where(
            (event) => event["is_feature"]?.toString().toLowerCase() == "yes")
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Text(
            'Featured Events',
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.015),
        SizedBox(
          height: isTablet ? size.height * 0.45 : size.height * 0.38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            itemCount: featuredEvents.length,
            itemBuilder: (context, index) {
              final event = featuredEvents[index];

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventDetailScreen(eventId: event["_id"]?.toString() ?? ""),
                  ),
                ),
                child: Container(
                  width: isTablet ? size.width * 0.35 : size.width * 0.6,
                  margin: EdgeInsets.only(right: size.width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBackground(event["thumbnail"].toString(),
                          height: size.height * 0.2),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(size.width * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  event["event_title"]?.toString() ?? "",
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              _buildInfoRow(
                                Icons.schedule_outlined,
                                getEventDate(event),
                                Colors.blue,
                                fontSize: size.width * 0.032,
                              ),
                              SizedBox(height: size.height * 0.005),
                              _buildInfoRow(
                                Icons.location_on_outlined,
                                '${event["venue"] ?? ""} ${event["city"]["name"] ?? ""}',
                                Colors.red,
                                fontSize: size.width * 0.032,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${event["paidLowestPrice"] != null ? "₹${event["paidLowestPrice"]}" : "Free"}',
                                    style: TextStyle(
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFC6E30),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE54B4D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Book',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: size.height * 0.03),
      ],
    );
  }

  /// ---------------------- UPCOMING EVENTS ----------------------
  Widget _buildUpcomingEvents(List<dynamic> filteredEvents, Size size, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.015),
        if (filteredEvents.isEmpty)
          Padding(
            padding: EdgeInsets.all(size.width * 0.1),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: size.width * 0.12, color: Colors.grey),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    'No events found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: isTablet ? 300 : 200,
                mainAxisSpacing: size.height * 0.02,
                crossAxisSpacing: size.width * 0.04,
                childAspectRatio: isTablet ? 0.9 : 0.75,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventDetailScreen(eventId: event["_id"]?.toString() ?? ""),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBackground(event["thumbnail"].toString(),
                            height: size.height * 0.15),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.03),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    event["event_title"]?.toString() ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.width * 0.035,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                _buildInfoRow(
                                  Icons.schedule_outlined,
                                  getEventDate(event),
                                  Colors.blue,
                                  fontSize: size.width * 0.03,
                                ),
                                SizedBox(height: size.height * 0.005),
                                _buildInfoRow(
                                  Icons.location_on_outlined,
                                  event["city"]["name"]?.toString() ?? "",
                                  Colors.red,
                                  fontSize: size.width * 0.03,
                                ),
                                const Spacer(),
                                Text(
                                  '${event["paidLowestPrice"] != null ? "₹${event["paidLowestPrice"]}" : "Free"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: size.width * 0.04,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  /// ---------------------- INFO ROW ----------------------
  Widget _buildInfoRow(IconData icon, String text, Color iconColor,
      {double fontSize = 12}) {
    return Row(
      children: [
        Icon(icon, size: fontSize + 4, color: iconColor),
=======
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
                          MediaQuery.of(context).size.width > 600 ? 1 : 0.75,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      final isTablet = MediaQuery.of(context).size.width > 600;

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
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
<<<<<<< HEAD
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[600],
            ),
=======
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  /// ---------------------- IMAGE LOGIC ----------------------
  Widget _buildBackground(String? imageUrl,
      {double height = 140, double borderRadius = 16}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      String optimizedUrl = imageUrl;

      if (imageUrl.endsWith('.avif') || imageUrl.endsWith('.webp')) {
        optimizedUrl = imageUrl.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
      }

      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        child: CachedNetworkImage(
          imageUrl: optimizedUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildShimmerEffect(height),
          errorWidget: (context, url, error) =>
              _buildPlaceholderWithIcon(Icons.broken_image, "Failed to load", height),
        ),
      );
    }

    return _buildPlaceholderWithIcon(Icons.auto_awesome, "Event Image", height);
  }

  Widget _buildShimmerEffect([double height = 140]) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[300],
    );
  }

  Widget _buildPlaceholderWithIcon(IconData icon, String text,
      [double height = 140]) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: height * 0.25, color: Colors.grey),
          SizedBox(height: height * 0.05),
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: height * 0.12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
}
