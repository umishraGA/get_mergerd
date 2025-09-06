import '../widgets/PostCardWidget.dart';

/// Provides sample posts data for the social feed
class SamplePostsData {
  /// Returns a list of sample posts with various media types and content
  static List<Map<String, Object>> getSamplePosts() {
    return [
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
        'description': 'Special promotion for this weekend only! Don\'t miss out!',
        'postImage': 'assets/images/post_image.png',
        'likes': 45,
        'comments': 12,
      },
    ];
  }
}
