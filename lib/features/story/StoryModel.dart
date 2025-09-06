class Story {
  final String imageUrl;
  final DateTime timestamp;

  Story({
    required this.imageUrl,
    required this.timestamp,
  });
}

class StoryGroup {
  final String userProfileImage;
  final String username;
  final List<Story> stories;

  StoryGroup({
    required this.userProfileImage,
    required this.username,
    required this.stories,
  });

  // Static method to get demo story groups
  static List<StoryGroup> getDemoStoryGroups() {
    return [
      StoryGroup(
        userProfileImage: 'assets/images/story_logo1.png',
        username: 'User One',
        stories: [
          Story(
            imageUrl: 'assets/images/story_image3.png',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          Story(
            imageUrl: 'assets/images/story_image1.png',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          ),
        ],
      ),
      StoryGroup(
        userProfileImage: 'assets/images/story_logo2.png',
        username: 'User Two',
        stories: [
          Story(
            imageUrl: 'assets/images/story_image2.png',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          ),
          Story(
            imageUrl: 'assets/images/story_image3.png',
            timestamp:
                DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
          ),
          Story(
            imageUrl: 'assets/images/story_image1.png',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      ),
      StoryGroup(
        userProfileImage: 'assets/images/story_logo3.png',
        username: 'User Three',
        stories: [
          Story(
            imageUrl: 'assets/images/story_image1.png',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          ),
          Story(
            imageUrl: 'assets/images/story_image2.png',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
        ],
      ),
    ];
  }
}
