import 'dart:developer' as dev;

import '../models/StoryModel.dart';

class StoryService {
  static List<StoryModel> getStories() {
    dev.log("Creating story list with multiple stories per user");

    // Using reliable vertical video URLs
    const List<String> verticalVideoUrls = [
      // Vertical video from Pexels - Woman walking in city (vertical)
      'https://videocdn.cdnpk.net/videos/4314dd7b-5992-5d61-ac27-34e36417643f/vertical/previews/watermarked/small.mp4',

      // Vertical video from Pexels - Person waving hand (vertical)
      'https://videocdn.cdnpk.net/videos/d6561e52-ec57-5f61-8dc1-1480b1e9b61b/vertical/previews/clear/small.mp4?token=exp=1742350747~hmac=f5b1366a97e270666be48fedfb022a8d45f95e3184a7cc419e19378ef0e53a99',

      // Vertical video from Pexels - Woman dancing (vertical)
      'https://videocdn.cdnpk.net/videos/4314dd7b-5992-5d61-ac27-34e36417643f/vertical/previews/watermarked/small.mp4',

      // Vertical video from Pexels - Ballet dancer (vertical)
      'https://videocdn.cdnpk.net/videos/d6561e52-ec57-5f61-8dc1-1480b1e9b61b/vertical/previews/clear/small.mp4?token=exp=1742350747~hmac=f5b1366a97e270666be48fedfb022a8d45f95e3184a7cc419e19378ef0e53a99',

      // Vertical video from Pexels - Woman with sparkler (vertical)
      'https://videocdn.cdnpk.net/videos/4314dd7b-5992-5d61-ac27-34e36417643f/vertical/previews/watermarked/small.mp4',
    ];

    // Backup horizontal video in case vertical ones fail
    const String fallbackVideo =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    return [
      // John Doe's stories (single image stories)
      StoryModel(
        id: '1',
        username: 'john_doe',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image1.png',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      // Fashion Daily's stories (multiple individual image stories)
      StoryModel(
        id: '2a',
        username: 'fashion_daily',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image2.png',
        createdAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      ),
      StoryModel(
        id: '2b',
        username: 'fashion_daily',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image1.png',
        createdAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
      ),
      StoryModel(
        id: '2c',
        username: 'fashion_daily',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image2.png',
        createdAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
      ),
      StoryModel(
        id: '2d',
        username: 'fashion_daily',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image3.png',
        createdAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      ),

      // Mike Wilson's story (vertical video)
      StoryModel(
        id: '3',
        username: 'mike_wilson',
        profileImage: 'assets/images/story_logo3.png',
        mediaUrl: 'assets/images/story_image3.png',
        videoUrl: verticalVideoUrls[0], // Vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),

      // Travel Addict's stories (multiple individual video stories)
      StoryModel(
        id: '4a',
        username: 'travel_addict',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image1.png',
        videoUrl: verticalVideoUrls[1], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      StoryModel(
        id: '4b',
        username: 'travel_addict',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image1.png',
        videoUrl: verticalVideoUrls[2], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      ),
      StoryModel(
        id: '4c',
        username: 'travel_addict',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image1.png',
        videoUrl: verticalVideoUrls[3], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),

      // Tech Reviews stories (alternating image and video)
      StoryModel(
        id: '5a',
        username: 'tech_reviews',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image2.png',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      StoryModel(
        id: '5b',
        username: 'tech_reviews',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image2.png',
        videoUrl: verticalVideoUrls[4], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
      ),
      StoryModel(
        id: '5c',
        username: 'tech_reviews',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image3.png',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      StoryModel(
        id: '5d',
        username: 'tech_reviews',
        profileImage: 'assets/images/story_logo2.png',
        mediaUrl: 'assets/images/story_image3.png',
        videoUrl: verticalVideoUrls[0], // Back to first vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),

      // Fitness Guru's story (video)
      StoryModel(
        id: '6',
        username: 'fitness_guru',
        profileImage: 'assets/images/story_logo3.png',
        mediaUrl: 'assets/images/story_image1.png',
        videoUrl: verticalVideoUrls[1], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),

      // DIY Crafts stories (before/after pair)
      StoryModel(
        id: '7a',
        username: 'diy_crafts',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image3.png',
        createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
      ),
      StoryModel(
        id: '7b',
        username: 'diy_crafts',
        profileImage: 'assets/images/story_logo1.png',
        mediaUrl: 'assets/images/story_image3.png',
        videoUrl: verticalVideoUrls[2], // Different vertical video
        mediaType: StoryMediaType.video,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }
}
