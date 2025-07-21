import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/listings/widgets/GalleryGrid.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:myapp/features/utsav/widgets/TermsConditionsBottomSheet.dart';

import '../models/event_model.dart';
import 'ticket_options_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  var _showFullDescription = false;

  final String _fullDescription =
      'Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It\'s also called placeholder (or filler) text. It\'s a convenient tool for mockups. It helps to outline the visual elements of a document or presentation, eg typography, font, or layout. Lorem ipsum is mostly a part of a Latin text by the classical author and philosopher Cicero. Its words and letters have been changed by addition or removal, so to deliberately render its content nonsensical; it\'s not genuine, correct, or comprehensible Latin anymore.';

  final String _shortenedDescription =
      'Lorem ipsum is a pseudo-Latin text used in web design, typography, layout, and printing in place of English to emphasise design elements over content. It\'s also called placeholder (or filler) text. It\'s a convenient tool for mockups. It helps to outline the visual elements of a document or presentation, eg typography, font ';

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(title: "Event Details"),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  height: isTablet ? 400 : 231,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/events/featured_event_img.png',
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(height: 10),

                // Event Basic Info Card
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      const Text(
                        'Radio City Joke Studio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Date and Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tue, 05 June 2025',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '05:00 PM',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Get Directions Action
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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

                      const SizedBox(height: 12),

                      // Duration
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '1 hour 30 minutes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Age Groups
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'All age groups',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),

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
                            Text(
                              'Hindi Music',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
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
                              'Ikana Stadium, Banglore',
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

                const SizedBox(height: 23),

                const CommonDivider(),

                // About the Event
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About the Event',
                        style: AppTextStyles.bold16,
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: _showFullDescription
                                  ? _fullDescription
                                  : _shortenedDescription,
                            ),
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

                // Artist
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Artist',
                        style: AppTextStyles.bold16,
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Artist Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/events/artist.png',
                              width: isTablet ? 200 : 122,
                              height: isTablet ? 250 : 171,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 40),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Artist Info
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Shriya Ghoshal',
                                style: AppTextStyles.medium15,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Singer',
                                style: AppTextStyles.medium15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),
                const SizedBox(height: 16),

                // Gallery
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gallery',
                        style: AppTextStyles.bold16,
                      ),
                      SizedBox(height: 12),
                      // Custom gallery layout as per image
                      GalleryGrid(
                        images: [
                          'assets/images/events/featured_event_img.png',
                          'assets/images/events/featured_event_img.png',
                          'assets/images/events/featured_event_img.png',
                          'assets/images/events/featured_event_img.png',
                        ],
                        padding: EdgeInsets.all(0),
                      )
                      // Row(
                      //   children: [
                      //     // Left large image
                      //     Expanded(
                      //       flex: 1,
                      //       child: Column(
                      //         children: [
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: AspectRatio(
                      //               aspectRatio: 1,
                      //               child: Image.asset(
                      //                 'assets/images/events/featured_event_img.png',
                      //                 fit: BoxFit.cover,
                      //                 errorBuilder:
                      //                     (context, error, stackTrace) {
                      //                   return Container(
                      //                     color: Colors.grey[300],
                      //                     child:
                      //                         const Icon(Icons.image, size: 40),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: AspectRatio(
                      //               aspectRatio: 1,
                      //               child: Image.asset(
                      //                 'assets/images/events/carnival_banner.png',
                      //                 fit: BoxFit.cover,
                      //                 errorBuilder:
                      //                     (context, error, stackTrace) {
                      //                   return Container(
                      //                     color: Colors.grey[300],
                      //                     child:
                      //                         const Icon(Icons.image, size: 40),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     // Right column
                      //     Expanded(
                      //       flex: 1,
                      //       child: Column(
                      //         children: [
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: AspectRatio(
                      //               aspectRatio: 16 / 9,
                      //               child: Image.asset(
                      //                 'assets/images/events/artist.png',
                      //                 fit: BoxFit.cover,
                      //                 errorBuilder:
                      //                     (context, error, stackTrace) {
                      //                   return Container(
                      //                     color: Colors.grey[300],
                      //                     child:
                      //                         const Icon(Icons.image, size: 40),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           ClipRRect(
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: AspectRatio(
                      //               aspectRatio: 11 / 16,
                      //               child: Image.asset(
                      //                 'assets/images/events/featured_event_img.png',
                      //                 fit: BoxFit.cover,
                      //                 errorBuilder:
                      //                     (context, error, stackTrace) {
                      //                   return Container(
                      //                     color: Colors.grey[300],
                      //                     child:
                      //                         const Icon(Icons.image, size: 40),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Organizer
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organizer',
                        style: AppTextStyles.bold16,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Happening Bazar',
                        style: AppTextStyles.medium15,
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Social Media
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Social Media',
                        style: AppTextStyles.bold16,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Facebook icon
                          Container(
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
                          const SizedBox(width: 12),
                          // Instagram icon
                          Container(
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
                          const SizedBox(width: 12),
                          // YouTube icon
                          Container(
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
                        ],
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Website
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Website',
                        style: AppTextStyles.bold16,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'https://www.happeningbazar.com/',
                        style: AppTextStyles.medium15,
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Email
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: AppTextStyles.bold16,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'events@happeningbazar.com',
                        style: AppTextStyles.medium15,
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Contact
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact',
                        style: AppTextStyles.bold16,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '9655745696',
                        style: AppTextStyles.medium15,
                      ),
                    ],
                  ),
                ),

                const CommonDivider(),

                // Terms & Conditions
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) =>
                            const TermsConditionsBottomSheet(),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Terms & Conditions',
                          style: AppTextStyles.bold16,
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey[700]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80), // Extra space for bottom button
              ],
            ),
          ),

          // Fixed price and booking button at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Text(
                    '₹${widget.event.price.toInt()}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFC6E30),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketOptionsScreen(event: widget.event),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE54B4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
