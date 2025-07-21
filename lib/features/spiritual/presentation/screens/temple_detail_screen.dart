import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/listings/widgets/GalleryGrid.dart';
import 'package:myapp/features/mainPage/widgets/PostCardWidget.dart';
import 'package:myapp/features/spiritual/presentation/screens/following_screen.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';

import '../widgets/AboutUs.dart';
import '../widgets/DarshanPage.dart';
import '../widgets/DonationPage.dart';

class TempleDetailScreen extends StatefulWidget {
  final String templeName;
  final String location;
  final String imagePath;
  final String description;
  final int followers;

  const TempleDetailScreen({
    super.key,
    required this.templeName,
    required this.location,
    required this.imagePath,
    required this.description,
    required this.followers,
  });

  @override
  State<TempleDetailScreen> createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends State<TempleDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  bool _showingPostDetail = false;
  Map<String, Object> _postDetail = {};
  final Map<String, bool> _followStates = {};
  final bool _isTabBarSticky = false;
  final GlobalKey _tabBarKey = GlobalKey();
  final double _tabBarPosition = 0.0;
  late AnimationController _transitionController;

  // Track whether detail is exiting to handle smooth animation
  bool _isPostDetailExiting = false;

  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _transitionController.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  const SliverToBoxAdapter(
                    child: AppHeader(title: ""),
                  ),
                  SliverToBoxAdapter(
                    child: _buildHeader(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildStatsRow(),
                  ),
                  SliverPersistentHeader(
                    delegate: _StickyTabBarDelegate(
                      TabBar(
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.red,
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        labelStyle: AppTextStyles.medium16,
                        unselectedLabelStyle: AppTextStyles.regular16,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        indicatorPadding: EdgeInsets.zero,
                        dividerColor: const Color(0xFFEEEEEE),
                        tabs: const [
                          Tab(text: 'About us'),
                          Tab(text: 'Gallery'),
                          Tab(text: 'Donation'),
                          Tab(text: 'Darshan'),
                          Tab(text: 'Visit'),
                          Tab(text: 'Posts'),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  const AboutUs(),
                  GalleryGrid(
                    images: [
                      widget.imagePath,
                      widget.imagePath,
                      widget.imagePath,
                      widget.imagePath,
                    ],
                    isShowOtherDetails: false,
                  ),
                  DonationPage(imagePath: widget.imagePath),
                  const DarshanPage(),
                  _buildVisitTab(),
                  _buildPostsTab(),
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
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Temple image
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            )),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.templeName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 16,
                  ),
                ],
              ),
              Text(
                widget.location,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('6.63k', 'visits', () {}),
              _buildStatItem('1.10k', 'followers', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FollowingScreen(),
                  ),
                );
              }),
              _buildStatItem('10.8k', 'Likes', () {}),
            ],
          ),
        ]));
  }

  Widget _buildStatItem(String count, String label, Function()? callback) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
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

  Widget _buildVisitTab() {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan Your Visit',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Date Chooser
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 90)),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFFF5A5F),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today,
                                color: Color(0xFFFF5A5F)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Time Chooser
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFFFF5A5F),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedTime) {
                          setState(() {
                            selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${selectedTime.hourOfPeriod}:${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.access_time,
                                color: Color(0xFFFF5A5F)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Booking action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Visit booked successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5A5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BOOK NOW',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Additional Information
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visit Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Regular visit hours: 6:00 AM to 8:00 PM\n'
                        '• Special puja times: 8:00 AM, 12:00 PM, 6:00 PM\n'
                        '• Please arrive 15 minutes before your selected time\n'
                        '• Dress code: Traditional or modest attire recommended',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
}

// Custom delegate for sticky TabBar
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return true;
  }
}
