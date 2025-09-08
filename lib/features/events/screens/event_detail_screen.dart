import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_avif/flutter_avif.dart';
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
import 'package:get/get.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/widgets/GalleryGrid.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/event_detail_controller.dart';
import '../widgets/event_term_condition.dart';
<<<<<<< HEAD
import 'event_gallery_girdview.dart';
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
import 'event_save_datetime_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({required this.eventId, Key? key}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final EventByIdController controller = Get.put(EventByIdController());
  var _showFullDescription = false;

  @override
  void initState() {
    super.initState();
    controller.fetchEventById(widget.eventId);
  }

  // Helper methods for formatting dates and times
  String formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (e) {
      return "";
    }
  }

  String formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(dateTime);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return "";
    }
  }

  String calculateDuration(String? start, String? end) {
    if (start == null || end == null || start.isEmpty || end.isEmpty) return "";
    try {
      DateTime startDt = DateTime.parse(start);
      DateTime endDt = DateTime.parse(end);
      Duration diff = endDt.difference(startDt);
      int hours = diff.inHours;
      int minutes = diff.inMinutes.remainder(60);
      if (hours > 0 && minutes > 0) {
        return "$hours hr $minutes min";
      } else if (hours > 0) {
        return "$hours hr";
      } else {
        return "$minutes min";
      }
    } catch (e) {
      return "";
    }
  }

  // URL launching methods
  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  Future<void> openMap(String lat, String lng) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint("❌ Could not launch $url");
      }
    } catch (e) {
      debugPrint("⚠️ Error launching map: $e");
    }
  }
  // Responsive layout helpers
  double _getImageHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 450;
    if (width > 800) return 400;
    if (width > 600) return 350;
    return 231;
  }

  double _getArtistItemWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 220;
    if (width > 800) return 200;
    if (width > 600) return 180;
    return 122;
  }

  double _getArtistImageHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 270;
    if (width > 800) return 250;
    if (width > 600) return 220;
    return 101;
  }

  EdgeInsets _getContentPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) {
      return EdgeInsets.symmetric(horizontal: width * 0.1);
    } else if (width > 600) {
      return EdgeInsets.symmetric(horizontal: width * 0.08);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  // Skeleton loading widget
  Widget _buildSkeletonLoading(BuildContext context) {
    final contentPadding = _getContentPadding(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppHeader(
            title: "Event Details",
            showSearch: false,
            showMenu: false,
          ),
          Container(
            padding: contentPadding,
            width: double.infinity,
            height: _getImageHeight(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 24,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 16,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 150,
                  height: 16,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const CommonDivider(),
          Container(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 20,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
  Widget _buildNetworkImage(String url, double height) {
    if (url.toLowerCase().endsWith(".avif")) {
      return AvifImage.network(
        url,
        height: height - 11,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height - 11,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 60),
        ),
      );
    } else {
      return Image.network(
        url,
        height: height - 11,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: height - 11,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 60),
        ),
      );
    }
  }
=======

>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  @override
  Widget build(BuildContext context) {
    final contentPadding = _getContentPadding(context);
    final imageHeight = _getImageHeight(context);
    final artistItemWidth = _getArtistItemWidth(context);
    final artistImageHeight = _getArtistImageHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeletonLoading(context);
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: contentPadding,
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final event = controller.eventData.value;
        if (event == null) {
          return const Center(child: Text("No Event Data Found"));
        }

        final eventTitle = event['event_title']?.toString() ?? 'Untitled Event';
        final capitalizedTitle = eventTitle.isNotEmpty
            ? '${eventTitle[0].toUpperCase()}${eventTitle.substring(1)}'
            : 'Untitled Event';

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   AppHeader(
                    title: "Event Details",
                    shareUrl: event['deeplinkurl'].toString(),

                  ),
                  Container(
                    padding: contentPadding,
                    width: double.infinity,
                    height: imageHeight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                      child: (event['thumbnail']?.toString().isNotEmpty ?? false)
                          ? _buildNetworkImage(event['thumbnail'].toString(), imageHeight)
                          : Container(
                        height: imageHeight - 11,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 60),
                      ),
                    ),
                  ),

=======
                      child: event['thumbnail']?.toString().isNotEmpty ?? false
                          ? Image.network(
                              event['thumbnail'].toString(),
                              height: imageHeight - 11,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: imageHeight - 11,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 60),
                              ),
                            )
                          : Container(
                              height: imageHeight - 11,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 60),
                            ),
                    ),
                  ),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                  const SizedBox(height: 10),

                  // Event Basic Info Card
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        Text(
                          capitalizedTitle,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 26
                                : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Date and Time
                        if (event["startDateTime"] is List &&
                            event["endDateTime"] is List)
                          Column(
                            children: List.generate(
                              (event["startDateTime"] as List).length,
                              (index) {
                                final start =
                                    event["startDateTime"][index]?.toString();
                                final end =
                                    event["endDateTime"][index]?.toString();
                                final date = formatDate(start);
                                final time = formatTime(start);
                                final duration = calculateDuration(start, end);

                                if (date.isEmpty &&
                                    time.isEmpty &&
                                    duration.isEmpty) {
                                  return const SizedBox();
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '$date, Start: $time, Duration: $duration',
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 12),

                        // Language
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.music_note,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event['event_category']?['categoryname']
                                          ?.toString() ??
                                      'Unknown',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed:(){
                                  openMap(event['latitude'].toString(), event['longitude'].toString());
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: const Color(0xFF4976C2),
                                ),
                                child: const Text(
                                  'Get Direction',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Venue
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${event['address']?.toString() ?? ''}, ${event['city']?['name']?.toString() ?? ''}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const CommonDivider(),

                  // About the Event
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About the Event',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 20
                                : 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: AppTextStyles.medium14.copyWith(
                              color: Colors.black87,
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 16
                                  : 14,
                            ),
                            children: [
                              TextSpan(
                                  text: _showFullDescription
                                      ? (event['description']?.toString() ??
                                          "No Description Provided")
                                      : ((event['description']?.toString() ??
                                                      "No Description Provided")
                                                  .length >
                                              100
                                          ? (event['description']!
                                                  .toString()
                                                  .substring(0, 100) +
                                              '...')
                                          : (event['description']?.toString() ??
                                              "No Description Provided"))),
                              if ((event['description']?.toString() ?? "")
                                      .length >
                                  100)
                                TextSpan(
                                  text: _showFullDescription
                                      ? ' Read Less'
                                      : ' Read More',
                                  style: const TextStyle(
                                    color: Color(0xFF4976C2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        _showFullDescription =
                                            !_showFullDescription;
                                      });
                                    },
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Artist
                  if (event['artists'] is List &&
                      (event['artists'] as List).isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Artist',
                            style: AppTextStyles.bold16.copyWith(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 20
                                  : 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: artistImageHeight +
                                80, // height for image + text
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (event['artists'] as List).length,
                              itemBuilder: (context, index) {
                                final artist = event['artists'][index];
                                final artistName =
                                    artist['name']?.toString() ?? 'Unknown';
                                final artistProfession = (artist['profession']
                                        is List)
                                    ? (artist['profession'] as List).join(", ")
                                    : "";

                                return Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  width: artistItemWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Artist Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: artist['image']
                                                    ?.toString()
                                                    .isNotEmpty ??
                                                false
                                            ? Image.network(
                                                artist['image'].toString(),
                                                width: artistItemWidth,
                                                height: artistImageHeight,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Container(
                                                    width: artistItemWidth,
                                                    height: artistImageHeight,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                        Icons.person,
                                                        size: 40),
                                                  );
                                                },
                                              )
                                            : Container(
                                                width: artistItemWidth,
                                                height: artistImageHeight,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.person,
                                                    size: 40),
                                              ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Artist Name
                                      Text(
                                        artistName,
                                        style: AppTextStyles.medium15.copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 16
                                              : 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      // Artist Profession
                                      Text(
                                        artistProfession,
                                        style: AppTextStyles.medium15.copyWith(
                                          fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  600
                                              ? 16
                                              : 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Gallery
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gallery',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 20
                                : 18,
                          ),
                        ),
                        const SizedBox(height: 12),
<<<<<<< HEAD
                        EventGalleryGrid(
                          eventImages: (event['gallery_image'] is List &&
                              (event['gallery_image'] as List).isNotEmpty)
                              ? (event['gallery_image'] as List).cast<Map<String, dynamic>>()
                              : [],
=======
                        GalleryGrid(
                          images: (event['gallery_image'] is List &&
                                  (event['gallery_image'] as List).isNotEmpty)
                              ? (event['gallery_image'] as List)
                                  .map<String>(
                                      (img) => img['url']?.toString() ?? '')
                                  .where((url) => url.isNotEmpty)
                                  .toList()
                              : ['assets/images/events/featured_event_img.png'],
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                          padding: EdgeInsets.zero,
                        )
                      ],
                    ),
                  ),

                  const CommonDivider(),

                  // Organizer
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organizer',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 18
                                : 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['organizer']?['name']?.toString() ?? 'Unknown',
                          style: AppTextStyles.medium15.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 16
                                : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Social Media
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Social Media',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 20
                                : 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Facebook icon
                            if (event['facebook']?.toString().isNotEmpty ??
                                false)
                              GestureDetector(
                                onTap: () => _launchUrl(
                                    'https://facebook.com/${event['facebook']}'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.facebook,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            if (event['facebook']?.toString().isNotEmpty ??
                                false)
                              const SizedBox(width: 12),
                            // Instagram icon
                            if (event['instagram']?.toString().isNotEmpty ??
                                false)
                              GestureDetector(
                                onTap: () => _launchUrl(
                                    'https://instagram.com/${event['instagram']}'),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            if (event['instagram']?.toString().isNotEmpty ??
                                false)
                              const SizedBox(width: 12),
                            // YouTube icon
                            if (event['youtube_link']?.toString().isNotEmpty ??
                                false)
                              GestureDetector(
                                onTap: () => _launchUrl(
                                    event['youtube_link']?.toString() ?? ""),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Website
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Website',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 18
                                : 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _launchUrl(
                              event['external_link']?.toString() ?? ""),
                          child: Text(
                            event['external_link']?.toString() ?? "N/A",
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Email
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 18
                                : 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['contact_email']?.toString() ?? "N/A",
                          style: AppTextStyles.medium15.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 16
                                : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Contact
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: AppTextStyles.bold16.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 18
                                : 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event['contact_number']?.toString() ?? "N/A",
                          style: AppTextStyles.medium15.copyWith(
                            fontSize: MediaQuery.of(context).size.width > 600
                                ? 16
                                : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CommonDivider(),
                  const SizedBox(height: 8),

                  // Terms & Conditions
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: contentPadding,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) => EventTermCondition(
                            condition:
                                event['terms_and_conditions']?.toString() ??
                                    "N/A",
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms & Conditions',
                            style: AppTextStyles.bold16.copyWith(
                              fontSize: MediaQuery.of(context).size.width > 600
                                  ? 18
                                  : 16,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),

            // Fixed price and booking button at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          color: Color(0xFFFC6E30),
                          size: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                        ),
                        Text(
<<<<<<< HEAD
                          "${event['paidLowestPrice']?.toString() ?? '00'}" == "00"
                              ? "Free"
                              : "${event['paidLowestPrice']?.toString() ?? '00'} Onwards",
=======
                          "${event['paidLowestPrice']?.toString() ?? '00'} Onwards",
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600 ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFC6E30),
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black26,
                              ),
                            ],
                          ),
<<<<<<< HEAD
                        )
=======
                        ),
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDataTime(
                              startDateTime: (event["startDateTime"] as List<dynamic>)
                                  .map((e) => e.toString())
                                  .toList(), // 👈 converts List<dynamic> → List<String>
                              eventId: event["_id"].toString(),
                            ),
                          ),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE54B4D),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width > 600 ? 40 : 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              MediaQuery.of(context).size.width > 600 ? 18 : 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
