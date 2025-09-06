import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:myapp/features/listings/views/ReportIssuePage.dart';
import 'package:myapp/features/listings/views/WriteReviewPage.dart';
import 'package:myapp/features/listings/controller/vendor_detail_controller.dart';
import 'package:myapp/features/listings/widgets/AboutUs.dart';
import 'package:myapp/features/listings/widgets/GalleryGrid.dart';
import 'package:myapp/features/listings/widgets/ProductsList.dart';
import 'package:myapp/features/listings/widgets/ReviewsList.dart';
import 'package:myapp/features/posts/widgets/PostCardWidget.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/vendor_image_controller.dart';

class VendorDetailsPage extends StatefulWidget {
  final String id;

  const VendorDetailsPage({super.key, required this.id});
  @override
  State<VendorDetailsPage> createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<VendorDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final bool _isClinicFollowed = false;
  bool _showingPostDetail = false;
  bool _showReportSuccess = false;
  bool _clinicFollowState = false;
  Map<String, Object> _postDetail = {};
  final Map<String, bool> _followStates = {};
  final bool _isTabBarSticky = false;
  final GlobalKey _tabBarKey = GlobalKey();
  final double _tabBarPosition = 0.0;
  late AnimationController _transitionController;
  late AnimationController _reportNotificationController;
  final VendorDetailController vendorController = Get.put(VendorDetailController());
  final VendorImagesController vendorImagesController = Get.put(VendorImagesController());

  // Track whether detail is exiting to handle smooth animation
  bool _isPostDetailExiting = false;

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    vendorController.fetchVendorDetails(widget.id);
    vendorImagesController.fetchVendorImages(widget.id);
    _tabController = TabController(length: 5, vsync: this);
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _reportNotificationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transitionController.dispose();
    _reportNotificationController.dispose();
    super.dispose();
  }

  // Show report success notification
  void _showReportSuccessNotification() {
    setState(() {
      _showReportSuccess = true;
    });

    _reportNotificationController.forward();

    // Auto hide after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _reportNotificationController.reverse().then((_) {
          setState(() {
            _showReportSuccess = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    ));

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: IgnorePointer(
                        ignoring: _showingPostDetail,
                        child: child,
                      ),
                    );
                  },
                  child: Obx(() {
                    if (vendorController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (vendorController.errorMessage.value.isNotEmpty) {
                      return Center(
                        child: Text(
                            'Error: ${vendorController.errorMessage.value}'),
                      );
                    }

                    return Column(
                      children: [
                        AppHeader(
                          title: "",
                          showMenu: true,
                          showDivider: false,
                          onWriteReview: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WriteReviewPage(
                                  clinicName: vendorController.companyName,
                                  address: vendorController.address,
                                ),
                              ),
                            );
                          },
                          onReportBusiness: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportIssuePage(
                                  clinicName: vendorController.companyName,
                                  address: vendorController.address,
                                  onReportSubmitted: () {
                                    Navigator.pop(context);
                                    _showReportSuccessNotification();
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        // Scrollable content for image and info
                        Expanded(
                          child: NestedScrollView(
                            headerSliverBuilder: (context, innerBoxIsScrolled) {
                              return [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      // Clinic image
                                      _buildClinicImage(vendorController
                                          .vendorData['coverImage']?['url']
                                          .toString()),

                                      // Clinic info section
                                      _buildClinicInfo(),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            body: Column(
                              children: [
                                // Tab bar
                                TabBar(
                                  tabAlignment: TabAlignment.start,
                                  controller: _tabController,
                                  labelColor: Colors.black,
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: Colors.red,
                                  isScrollable: true,
                                  padding: EdgeInsets.zero,
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  unselectedLabelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  indicatorPadding: EdgeInsets.zero,
                                  dividerColor: const Color(0xFFEEEEEE),
                                  tabs: const [
                                    Tab(text: 'About us'),
                                    Tab(text: 'Products'),
                                    Tab(text: 'Gallery'),
                                    Tab(text: 'Posts'),
                                    Tab(text: 'Reviews'),
                                  ],
                                ),
                                // Tab content
                                Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                  SingleChildScrollView(
                                  child: Aboutus(
                                  aboutText: vendorController.vendorData['companyInfo']?['aboutUs']?.toString() ?? '',
                                  companyInfo: vendorController.vendorData['companyInfo'] as Map<String, dynamic>?? {},
                                  contactInfo: vendorController.vendorData['contactInfo'] as Map<String, dynamic> ?? {},
                                  locationInfo: vendorController.vendorData['locationInfo'] as Map<String, dynamic> ?? {},
                                ),
                                      ),
                                      SingleChildScrollView(
                                          child: _buildProductsTab()),
                                      SingleChildScrollView(
                                          child: _buildGalleryTab()),
                                      _buildPostsTab(),
                                      const SingleChildScrollView(
                                          child: ReviewsList()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                if (_showingPostDetail)
                  PostCardWidget.buildPostDetailViewFromMap(
                    context: context,
                    postDetail: _postDetail,
                    showingPostDetail: _showingPostDetail,
                    isPostDetailExiting: _isPostDetailExiting,
                    isFollowingCallback: _isFollowing,
                    handleFollowChangedCallback: _handleFollowChanged,
                    onDetailBackPressed: () {
                      // widget.onDetailViewVisible?.call(false);

                      // Start smooth exit animation sequence
                      setState(() {
                        _isPostDetailExiting = true;
                      });

                      // Wait for exit animations to complete before changing view state
                      Future.delayed(const Duration(milliseconds: 200), () {
                        if (mounted) {
                          // Reset post detail visibility
                          setState(() {
                            _showingPostDetail = false;
                            _isPostDetailExiting = false; // Reset flag
                          });

                          // Start the fade animation for the main content
                          _transitionController.reverse();
                        }
                      });
                    },
                    transitionController: _transitionController,
                  ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Call functionality
                      if (vendorController.phone.isNotEmpty) {
                        final phoneNumber = "tel:${vendorController.phone}";
                        launchUrl(Uri.parse(phoneNumber));
                      } else {
                        Get.snackbar(
                          'Error',
                          'Phone number not available',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F9D58),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call, size: 16),
                        SizedBox(width: 8),
                        Text('Call'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EnquiryPage(
                                  clinicName: vendorController.companyName,
                                  category: vendorController
                                          .vendorData['businessCategory']
                                              ?['name']
                                          ?.toString() ??
                                      '',
                                  subCategory: vendorController
                                          .vendorData['businessNature']?['name']
                                          ?.toString() ??
                                      '',
                                  businessId: vendorController.vendorData['_id']
                                          ?.toString() ??
                                      '',
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBC02D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text('Enquiry'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Direction functionality
                      if (vendorController.latitude != 0 &&
                          vendorController.longitude != 0) {
                        final mapsUrl =
                            "https://www.google.com/maps/search/?api=1&query=${vendorController.latitude},${vendorController.longitude}";
                        launchUrl(Uri.parse(mapsUrl));
                      } else {
                        Get.snackbar(
                          'Error',
                          'Location not available',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4976C2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions, size: 16),
                        SizedBox(width: 8),
                        Text('Direction'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Report success overlay - positioned outside the Scaffold
        if (_showReportSuccess)
          AnimatedBuilder(
            animation: _reportNotificationController,
            builder: (context, child) {
              return Material(
                color: Colors.black
                    .withOpacity(0.5 * _reportNotificationController.value),
                child: Center(
                  child: Opacity(
                    opacity: _reportNotificationController.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Report Submitted Successfully',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _handleFollowChanged(String username, bool isFollowing) {
    setState(() {
      _followStates[username] = isFollowing;
    });
  }

  bool _isFollowing(String username) {
    return _followStates[username] ?? false;
  }

  Widget _buildClinicImage(String? imageUrl) {
    String? finalUrl = imageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Convert .avif or .webp → .jpg fallback
      if (imageUrl.endsWith('.avif') || imageUrl.endsWith('.webp')) {
        finalUrl = imageUrl.replaceAll(RegExp(r'\.(avif|webp)$'), '.jpg');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: finalUrl != null && finalUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: finalUrl,
                width: double.infinity,
                height: 228,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 40,
                  color: Colors.grey,
                ),
              )
            : SizedBox(
                width: double.infinity,
                height: 228,
                child: const Icon(
                  Icons.broken_image,
                  size: 80, // icon size
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _buildRatingItem() {
    return Row(children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 1,
            color: const Color(0xFF059E54),
          ),
        ),
        child: Row(
          children: [
            // Star icon with rating (green part)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xFF059E54), // Green background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '4.3',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Number in white background
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: const Text(
                '120',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildClinicInfo() {
    return Obx(() {
      final companyInfo = vendorController.vendorData['companyInfo'] ?? {};
      final contactInfo = vendorController.vendorData['contactInfo'] ?? {};
      final locationInfo = vendorController.vendorData['locationInfo'] ?? {};

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic name
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child:Row(
                    children: [
                      Flexible(
                        child: Text(
                          companyInfo['companyName']?.toString() ?? 'Business Name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.verified,
                        color: Colors.green[600],
                        size: 24,
                      ),
                    ],
                  )),

              ],
            ),
            const SizedBox(height: 6),

            // Address
            Text(
              locationInfo['address']?.toString() ?? 'Address not available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Rating and timing row
            Row(
              children: [
                GestureDetector(
                  onTap: _showOpeningHoursModal,
                  child: Row(
                    children: [
                      Text(
                        'Opens',
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(' • Closes 9:30 pm'),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_drop_down,
                          size: 18, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _clinicFollowState = !_clinicFollowState;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _clinicFollowState
                        ? Colors.white
                        : const Color(0xFF4976C2),
                    backgroundColor: _clinicFollowState
                        ? const Color(0xFF4976C2)
                        : Colors.transparent,
                    side: const BorderSide(color: Color(0xFF4976C2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    minimumSize: const Size(80, 30),
                  ),
                  child: Text(
                    _clinicFollowState ? 'Following' : 'Follow',
                    style: TextStyle(
                      fontFamily: 'FacebookSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _clinicFollowState
                          ? Colors.white
                          : const Color(0xFF4976C2),
                    ),
                  ),
                ),
              ],
            ),

            // Action buttons - REMOVED FROM HERE

            const SizedBox(height: 10),
            Row(
              children: [
                _buildRatingItem(),
                const SizedBox(width: 8),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${vendorController.vendorData['followers']?.toString() ?? '0'} Followers',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            '100 likes',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildProductsTab() {
    return const ProductsList();
  }

  Widget _buildGalleryTab() {
    return Obx(() {
      if (vendorImagesController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (vendorImagesController.errorMessage.value.isNotEmpty) {
        return Center(
          child: Text('Error: ${vendorImagesController.errorMessage.value}'),
        );
      }

      return GalleryGrid(
        isShowOtherDetails: true,
        businessImages: vendorImagesController.businessImages.toList(),
      );
    });
  }
  Widget _buildPostsTab() {
    // Sample posts data with explicit typing
    final List<Map<String, Object>> posts = [
      // Another test video post with a different video file
      {
        'profileImage': 'assets/images/story_logo3.png',
        'username': 'User Three',
        'date': '22 Jan 2025 2:20 pm',
        'description': 'New project coming soon! Stay tuned for updates...',
        'postImage': 'assets/images/post_image.png',
        'likes': 203,
        'comments': 54,
      },
      // Multi-image post
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'Photo Gallery',
        'date': '21 Jan 2025 11:30 am',
        'description':
            'Swipe through to see all the amazing photos from our latest adventure! Each image tells a different part of the story. #PhotoGallery #Adventure #Memories',
        'postImage': 'assets/images/post_image.png',
        'mediaType': PostMediaType.multiImage,
        'additionalImages': [
          'assets/images/post_image.png',
          'assets/images/post_image.png',
          'assets/images/post_image.png',
        ],
        'likes': 521,
        'comments': 104,
      },
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'Happening Bazar',
        'date': '21 Jan 2025 11:30 am',
        'description':
            'Special promotion for this weekend only! Don\'t miss out!',
        'postImage': 'assets/images/post_image.png',
        'likes': 45,
        'comments': 12,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final String postId = post['postImage'].toString().hashCode.toString();
        final String username = post['username'] as String;
        return PostCardWidget(
          key: ValueKey('post-$postId'),
          profileImage: post['profileImage'] as String,
          username: post['username'] as String,
          date: post['date'] as String,
          description: post['description'] as String,
          postImage: post['postImage'] as String,
          likes: post['likes'] as int,
          comments: post['comments'] as int,
          mediaType: PostMediaType.image,
          isFollowing: _isFollowing(username),
          onFollowChanged: (isFollowing) =>
              _handleFollowChanged(username, isFollowing),
          onTap: () {
            // Save post detail
            setState(() {
              _postDetail = {
                ...post,
                'mediaType': post.containsKey('mediaType')
                    ? post['mediaType'] as PostMediaType
                    : PostMediaType.image,
                'videoPath': post.containsKey('videoPath')
                    ? post['videoPath'] as String
                    : '',
                'additionalImages': post.containsKey('additionalImages')
                    ? (post['additionalImages'] as List<String>)
                    : <String>[],
              };
            });

            // Start transition
            _transitionController.forward().then((_) {
              setState(() {
                _showingPostDetail = true;
                _isPostDetailExiting = false;
              });
            });
          },
        );
      },
    );
  }

  // Replace the _showOpeningHoursModal method with this
  void _showOpeningHoursModal() {
    final businessHours = vendorController.businessHours;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding:
              const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Opening hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'x',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (businessHours.isEmpty)
                const Text('No business hours available')
              else
                ...businessHours.map((hour) {
                  final day = hour['day']?.toString() ?? '';
                  final openTime = hour['openTime']?.toString() ?? '';
                  final closeTime = hour['closeTime']?.toString() ?? '';
                  final isClosed = hour['isClosed'] as bool? ?? false;

                  return _buildTimeRow(
                      day, isClosed ? 'Closed' : '$openTime - $closeTime',
                      isHighlighted: day == 'Friday');
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRow(String day, String hours, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
