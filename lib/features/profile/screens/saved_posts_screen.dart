import 'package:flutter/material.dart';
import 'package:myapp/features/mainPage/widgets/PostCardWidget.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  // Track follow state for each user
  final Map<String, bool> _followStates = {};

  // List to store saved posts
  List<Map<String, Object>> _savedPosts = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadSavedPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Load saved posts (simulated)
  Future<void> _loadSavedPosts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Sample posts data from SocialFeedWidget
    final List<Map<String, Object>> allPosts = [
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'Happening Bazar',
        'date': '25 Jan 2025 9:48 am',
        'description':
            'Announcing our biggest sale of the year! 🎉 Starting tomorrow, enjoy up to 70% off on all fashion items, accessories, and home decor.',
        'postImage': 'assets/images/post_image.png',
        'likes': 23,
        'comments': 36,
        'savedDaysAgo': 3,
      },
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'User One',
        'date': '24 Jan 2025 8:30 am',
        'description':
            'Just unboxed the latest tech gadget everyone\'s been talking about! After months of anticipation, I finally got my hands on this amazing device.',
        'postImage': 'assets/images/post_image.png',
        'likes': 157,
        'comments': 42,
        'savedDaysAgo': 7,
      },
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
        'savedDaysAgo': 14,
      },
      {
        'profileImage': 'assets/images/story_logo1.png',
        'username': 'Photo Gallery',
        'date': '21 Jan 2025 11:30 am',
        'description':
            'Swipe through to see all the amazing photos from our latest adventure!',
        'postImage': 'assets/images/post_image.png',
        'mediaType': PostMediaType.multiImage,
        'additionalImages': [
          'assets/images/post_image.png',
          'assets/images/post_image.png',
          'assets/images/post_image.png',
        ],
        'likes': 521,
        'comments': 104,
        'savedDaysAgo': 30,
      },
    ];

    // Pretend these are the user's saved posts
    setState(() {
      _savedPosts = allPosts;
      _isLoading = false;
    });
  }

  void _handleFollowChanged(String username, bool isFollowing) {
    setState(() {
      _followStates[username] = isFollowing;
    });
  }

  bool _isFollowing(String username) {
    return _followStates[username] ?? false;
  }

  void _removePost(int index) {
    setState(() {
      _savedPosts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post removed from saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Saved Posts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedPosts.isEmpty
              ? _buildEmptyState()
              : _buildSavedPostsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save posts to view them later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the feed
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Go to Feed'),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPostsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: _savedPosts.length,
      itemBuilder: (context, index) {
        final post = _savedPosts[index];
        final String username = post['username'] as String;
        final String postId = post['postImage'].toString().hashCode.toString();
        final int savedDaysAgo = post['savedDaysAgo'] as int;

        return Column(
          children: [
            // Compact saved info bar
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //   color: Colors.white,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'Saved $savedDaysAgo days ago',
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: Colors.grey[600],
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       IconButton(
            //         icon: const Icon(Icons.bookmark, color: Colors.black),
            //         onPressed: () => _removePost(index),
            //         padding: EdgeInsets.zero,
            //         constraints: const BoxConstraints(),
            //       ),
            //     ],
            //   ),
            // ),

            // Post card
            PostCardWidget(
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
              isFollowing: _isFollowing(username),
              onFollowChanged: (isFollowing) =>
                  _handleFollowChanged(username, isFollowing),
            ),
          ],
        );
      },
    );
  }
}
