import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/features/common/widgets/BannerCorousal.dart';
import 'package:myapp/features/common/widgets/TopAppBarCustom.dart';
import '../controller/all_event_controller.dart';
import '../controller/category_controller.dart';
import 'event_detail_screen.dart';
import '../screens/event_banner.dart';

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
  final RxString searchQuery = ''.obs;

  String formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat("dd MMM, hh:mm a").format(dt);
    } catch (_) {
      return date;
    }
  }

  String getEventDate(dynamic event) {
    final dynamic rawDate = event["startDateTime"];

    if (rawDate == null) return "Date not available";

    if (rawDate is List && rawDate.isNotEmpty) {
      if (rawDate.length > 1) {
        return "${formatDate(rawDate[0].toString())} to ${formatDate(rawDate[1].toString())}";
      } else {
        return formatDate(rawDate[0].toString());
      }
    }

    if (rawDate is String && rawDate.isNotEmpty) {
      return formatDate(rawDate);
    }

    return "Date not available";
  }

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

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
}
