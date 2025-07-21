import 'package:flutter/material.dart';
import 'package:myapp/features/listings/views/EnquiryPage.dart';
import 'package:myapp/features/listings/views/ReportIssuePage.dart';
import 'package:myapp/features/listings/views/WriteReviewPage.dart';
import 'package:myapp/features/listings/widgets/AboutUs.dart';
import 'package:myapp/features/listings/widgets/GalleryGrid.dart';
import 'package:myapp/features/listings/widgets/ProductsList.dart';
import 'package:myapp/features/listings/widgets/ReviewsList.dart';
import 'package:myapp/features/mainPage/widgets/PostCardWidget.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

class ClinicDetailsPage extends StatefulWidget {
  const ClinicDetailsPage({super.key});

  @override
  State<ClinicDetailsPage> createState() => _ClinicDetailsPageState();
}

class _ClinicDetailsPageState extends State<ClinicDetailsPage>
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

  // Track whether detail is exiting to handle smooth animation
  bool _isPostDetailExiting = false;

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
                  child: Column(
                    children: [
                      AppHeader(
                        title: "",
                        showMenu: true,
                        showDivider: false,
                        onWriteReview: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WriteReviewPage(
                                clinicName:
                                    'SSR Ayurvedic and Panchkarma Clinic',
                                address:
                                    'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
                              ),
                            ),
                          );
                        },
                        onReportBusiness: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportIssuePage(
                                clinicName:
                                    'SSR Ayurvedic and Panchkarma Clinic',
                                address:
                                    'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida ,Uttar Pradesh',
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
                                    _buildClinicImage(),

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
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                                    const SingleChildScrollView(
                                        child: Aboutus()),
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
                  ),
                ),
                if (_showingPostDetail)
                  PostCardWidget.buildPostDetailView(
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
                    onPressed: () {},
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
                            builder: (context) => const EnquiryPage(
                                  clinicName: 'Jiva Ayurvedic Clinic',
                                  category: 'Ayurvedic',
                                  subCategory: 'Clinic',
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
                    onPressed: () {},
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

  Widget _buildClinicImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/listings/items/food_item_horizontal.png',
          width: double.infinity,
          height: 228,
          fit: BoxFit.fill,
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinic name
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Jiva Ayurvedic Clinic',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.verified,
                color: Colors.green[600],
                size: 24,
              )
            ],
          ),
          const SizedBox(height: 6),

          // Address
          Text(
            'Shop No. 51, Shalimar Building, Near Hospital, Sector 18, Noida, Uttar Pradesh',
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
                        '201 Followers',
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
  }

  Widget _buildProductsTab() {
    return const ProductsList();
  }

  Widget _buildGalleryTab() {
    return const GalleryGrid(
      isShowOtherDetails: true,
    );
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
              _buildTimeRow('Monday', '11:00 AM - 11:00 PM'),
              _buildTimeRow('Tuesday', '11:00 AM - 11:00 PM'),
              _buildTimeRow('Wednesday', '11:00 AM - 11:00 PM'),
              _buildTimeRow('Thursday', '11:00 AM - 11:00 PM'),
              _buildTimeRow('Friday', '11:00 AM - 11:00 PM',
                  isHighlighted: true),
              _buildTimeRow('Saturday', '11:00 AM - 11:00 PM'),
              _buildTimeRow('Sunday', '11:00 AM - 11:00 PM'),
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
