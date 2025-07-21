import 'package:flutter/material.dart';
import 'package:myapp/common/navigation/route_manager.dart' show RouteManager;
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/location/LocationSearchPage.dart';
import 'package:myapp/features/mainPage/widgets/PostCardWidget.dart';
import 'package:myapp/features/story/services/StoryService.dart';

import '../../postDetail/TestDescriptionPage.dart';
import 'StoryCardWidget.dart';
import 'TabBarWidget.dart';

class SocialFeedWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Function(bool)?
  onDetailViewVisible; // Callback for when detail view is shown/hidden

  const SocialFeedWidget({
    super.key,
    required this.scrollController,
    this.onDetailViewVisible,
  });

  @override
  State<SocialFeedWidget> createState() => _SocialFeedWidgetState();
}

class _SocialFeedWidgetState extends State<SocialFeedWidget>
    with SingleTickerProviderStateMixin {
  // Map to track follow state for each user
  final Map<String, bool> _followStates = {};
  bool _isTabBarSticky = false;
  final GlobalKey _tabBarKey = GlobalKey();
  double _tabBarPosition = 0.0;
  bool _showingPostDetail = false;
  Map<String, Object> _postDetail = {};

  // Track whether detail is exiting to handle smooth animation
  bool _isPostDetailExiting = false;

  // Animation controller for smoother transitions
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Add listener to detect when tab bar should become sticky
    widget.scrollController.addListener(_updateTabBarPosition);

    // Initialize animation controller for transitions with smoother timing
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    ));
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateTabBarPosition);
    _transitionController.dispose();
    super.dispose();
  }

  void _updateTabBarPosition() {
    final RenderBox? renderBox =
    _tabBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final tabBarPosition = renderBox.localToGlobal(Offset.zero).dy;
      final topPadding = MediaQuery.of(context).padding.top;
      final appBarHeight = kToolbarHeight + topPadding;

      // Calculate if the tab bar should be sticky based on its position relative to app bar
      final shouldBeSticky = tabBarPosition <= appBarHeight;

      // Only update state if there's a change to prevent unnecessary rebuilds
      if (shouldBeSticky != _isTabBarSticky) {
        setState(() {
          _isTabBarSticky = shouldBeSticky;
          if (_isTabBarSticky) {
            _tabBarPosition = tabBarPosition;
          }
        });
      }
    }
  }

  void _handleFollowChanged(String username, bool isFollowing) {
    setState(() {
      _followStates[username] = isFollowing;
    });
  }

  bool _isFollowing(String username) {
    return _followStates[username] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // Sample posts data with explicit typing
    final List<Map<String, Object>> posts = [
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'Happening Bazar',
        'date': '25 Jan 2025 9:48 am',
        'description':
        'Announcing our biggest sale of the year! 🎉 Starting tomorrow, enjoy up to 70% off on all fashion items, accessories, and home decor. This limited-time event features exclusive collections and one-of-a-kind pieces that you won\'t find anywhere else. Members get early access starting at midnight, plus additional discounts and free shipping on all orders. Don\'t miss this opportunity to refresh your wardrobe and home with the latest trends at unbeatable prices. Save the date and set your alarms—the best items always sell out fast!',
        'postImage': 'assets/images/post_image.png',
        'likes': 23,
        'comments': 36,
      },
      // Poll post
      {
        'profileImage': 'assets/images/story_logo2.png',
        'username': 'Sofia Su',
        'date': '15 Feb',
        'description': 'Tire Pressure Monitoring System Design Vote! 📸',
        'postImage': 'assets/images/post_image.png',
        'mediaType': PostMediaType.poll,
        'likes': 4,
        'comments': 15,
        'pollOptions': {
          'A': ['John', 'Sarah', 'Emma'],
          'B': ['Mike', 'David', 'Lisa', 'Amy', 'Tom'],
          'C': ['Alex', 'Chris'],
        },
        'totalVotes': 15,
      },

      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'User One',
        'date': '24 Jan 2025 8:30 am',
        'description':
        'Just unboxed the latest tech gadget everyone\'s been talking about! After months of anticipation, I finally got my hands on this amazing device. The design is sleek, the performance is lightning-fast, and the camera quality exceeds all expectations. Setting it up was incredibly intuitive, and I\'m already discovering features that weren\'t mentioned in any of the reviews. If you\'re on the fence about getting one, I highly recommend taking the plunge. This will definitely change how you work and play. #NewTech #ProductReview #TechEnthusiast',
        'postImage': 'assets/images/post_image.png',
        'likes': 157,
        'comments': 42,
      },
      // Video post
      {
        'profileImage': 'assets/images/story_logo2.png',
        'username': 'Video Creator',
        'date': '23 Jan 2025 2:30 pm',
        'description':
        'Check out this amazing video I created! Perfect for social media sharing. #VideoContent #CreatorLife',
        'postImage': 'assets/images/black_image.png',
        'videoPath':
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        'mediaType': PostMediaType.video,
        'likes': 452,
        'comments': 87,
        // This video will auto-play when it becomes visible in the scroll view
      },
      // Another test video post with a different video file
      {
        'profileImage': 'assets/images/story_logo3.png',
        'username': 'Video Tester',
        'date': '23 Jan 2025 1:15 pm',
        'description':
        'Testing video playback in our app. Let me know if you can see this properly! #Testing #VideoTest',
        'postImage': 'assets/images/black_image.png',
        'videoPath':
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'mediaType': PostMediaType.video,
        'likes': 35,
        'comments': 11,
        // This video will auto-play when it becomes visible in the scroll view
      },
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

    return WillPopScope(
      onWillPop: () async {
        // If showing post detail, go back to feed instead of exiting app
        if (_showingPostDetail) {
          // Notify parent widget that detail view is closing
          widget.onDetailViewVisible?.call(false);

          // Start smooth exit animation sequence
          setState(() {
            _isPostDetailExiting = true;
          });

          // Wait for exit animations to complete before changing view state
          await Future.delayed(const Duration(milliseconds: 200));

          if (mounted) {
            setState(() {
              _showingPostDetail = false;
              _isPostDetailExiting = false; // Reset flag
            });
            _transitionController.reverse();
          }

          return false;
        }
        return true;
      },
      child: SafeArea(
        // Don't add padding to edges for true full screen experience
        top: false,
        bottom: false,
        left: false,
        right: false,
        child: Stack(
          children: [
            // Main content - always rendered but with adjustable opacity
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: IgnorePointer(
                    // Disable interaction when detail view is showing
                    ignoring: _showingPostDetail,
                    child: child,
                  ),
                );
              },
              child: Stack(
                children: [
                  // Main content
                  ListView.builder(
                    controller: widget.scrollController,
                    // Add padding at top to avoid status bar overlap
                    padding: EdgeInsets.zero,
                    // padding: const EdgeInsets.only(bottom: 120, top: 0),
                    itemCount:
                    posts.length + 3, // Top bar, stories, tab bar + posts
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildTopBar(context);
                      } else if (index == 1) {
                        return _buildStoriesRow(context);
                      } else if (index == 2) {
                        return Visibility(
                          // Only show the in-place tab bar when the sticky one is NOT visible
                          visible: !_isTabBarSticky,
                          // Maintain the space even when invisible to prevent layout jumps
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Container(
                            key: _tabBarKey,
                            child: const TabBarWidget(),
                          ),
                        );
                      } else {
                        final post = posts[index - 3];
                        final String username = post['username'] as String;
                        final String postId =
                        post['postImage'].toString().hashCode.toString();

                     //  This is the post show code
                        return PostCardWidget(
                          key: ValueKey('post-$postId'),
                          profileImage: post['profileImage'] as String,
                          username: username,
                          date: post['date'] as String,
                          description: post['description'] as String,
                          postImage: post['postImage'] as String,
                          likes: post['likes'] as int,
                          comments: post['comments'] as int,
                          mediaType: post.containsKey('mediaType')
                              ? post['mediaType'] as PostMediaType
                              : PostMediaType.image,
                          videoPath: post.containsKey('videoPath')
                              ? post['videoPath'] as String
                              : null,
                          additionalImages: post.containsKey('additionalImages')
                              ? (post['additionalImages'] as List<String>)
                              : null,
                          pollOptions: post.containsKey('pollOptions')
                              ? (post['pollOptions']
                          as Map<String, List<String>>)
                              : null,
                          totalVotes: post.containsKey('totalVotes')
                              ? post['totalVotes'] as int
                              : null,
                          isFollowing: _isFollowing(username),
                          onFollowChanged: (isFollowing) =>
                              _handleFollowChanged(username, isFollowing),
                          onTap: () {
                            // Skip detail view for poll posts
                            if (post.containsKey('mediaType') &&
                                post['mediaType'] == PostMediaType.poll) {
                              return;
                            }

                            // Save post detail and start transition
                            _postDetail = post;

                            // Notify parent widget that detail view will be shown
                            widget.onDetailViewVisible?.call(true);

                            // Begin fade out animation of main content
                            _transitionController.forward();

                            // Show the detail view immediately with exit animation set to false
                            // This ensures the detail view is shown with proper initial animation state
                            setState(() {
                              _showingPostDetail = true;
                              _isPostDetailExiting = false;
                            });
                          },
                        );
                      }
                    },
                  ),


                ],
              ),
            ),

            // Post detail view with animation
            if (_showingPostDetail)
              PostCardWidget.buildPostDetailView(
                context: context,
                postDetail: _postDetail,
                showingPostDetail: _showingPostDetail,
                isPostDetailExiting: _isPostDetailExiting,
                isFollowingCallback: _isFollowing,
                handleFollowChangedCallback: _handleFollowChanged,
                onDetailBackPressed: () {
                  widget.onDetailViewVisible?.call(false);

                  // Start smooth exit animation sequence
                  setState(() {
                    _isPostDetailExiting = true;
                  });

                  // Wait for exit animations to complete before changing view state
                  // Future.delayed(const Duration(milliseconds: 200), () {
                  //   if (mounted) {
                  //     // Reset post detail visibility
                  //     setState(() {
                  //       _showingPostDetail = false;
                  //       _isPostDetailExiting = false; // Reset flag
                  //     });
                  //
                  //     // Start the fade animation for the main content
                  //     _transitionController.reverse();
                  //   }
                  // });
                },
                transitionController: _transitionController,
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToLocationSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationSearchPage(
        ),
      ),
    );
  }
  Widget _buildTopBar(BuildContext context) {
    // this will header location notification profile
    return Container(
      padding: EdgeInsets.only(
          left: 18,
          right: 18,
          top: 16 +
              MediaQuery.of(context)
                  .padding
                  .top, // Add status bar height padding
          bottom: 22),
      child: Row(
        children: [
          // Location icon and address
          GestureDetector(
            onTap: () => _navigateToLocationSearch(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF426DB3).withOpacity(0.23),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF426DB3),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToLocationSearch(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Charbag',
                        style: AppTextStyles.semiBold18,
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        'assets/images/down_arrow.png',
                        width: 13,
                        height: 9,
                      ),
                    ],
                  ),
                  Text(
                    'current location of user with pin code ',
                    style: AppTextStyles.regular12
                        .withColor(const Color(0xFF909090)),
                  ),
                ],
              ),
            ),
          ),
          // Test Description Button
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const TestDescriptionPage(),
          //       ),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.amber,
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //     minimumSize: const Size(30, 30),
          //   ),
          //   child: const Text('Test', style: TextStyle(fontSize: 12)),
          // ),
          const SizedBox(width: 5),
          // Notification bell
          const Icon(
            Icons.notifications_outlined,
            color: Color(0xFF426DB3),
            size: 25,
          ),
          const SizedBox(width: 10),
          // Profile image
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouteManager.profilePage);
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/profile_pic.png'),
            ),
          ),
        ],
      ),
    );
  }

  //this is for the story section
  Widget _buildStoriesRow(BuildContext context) {
    final stories = StoryService.getStories();
     // this container return story
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        physics:
        const ClampingScrollPhysics(), // Prevent parent scroll interference
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return StoryCardWidget(
            story: story,
            storyIndex: index,
          );
        },
      ),
    );
  }
}
