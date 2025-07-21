import 'package:flutter/material.dart';

import '../../../features/story/models/StoryModel.dart';
import '../../../features/story/services/StoryService.dart';
import '../../../features/story/views/StoryViewSequential.dart';

class StoryCardWidget extends StatelessWidget {
  final StoryModel story;
  final int storyIndex;

  const StoryCardWidget({
    super.key,
    required this.story,
    required this.storyIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'story_${story.username}_$storyIndex',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Get all stories
            final allStories = StoryService.getStories();

            // Group stories by username
            final Map<String, List<StoryModel>> storiesByUser = {};
            final List<String> usernames = [];

            for (var s in allStories) {
              if (!storiesByUser.containsKey(s.username)) {
                storiesByUser[s.username] = [];
                usernames.add(s.username);
              }
              storiesByUser[s.username]!.add(s);
            }

            // Find the index of the current user
            final userIndex = usernames.indexOf(story.username);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryViewSequential(
                  allStoriesByUser: storiesByUser,
                  usernames: usernames,
                  initialUserIndex: userIndex,
                ),
              ),
            );
          },
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 118,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Story background image
                  Image.asset(
                    story.mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.grey),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  // Logo in circle with active story ring
                  Positioned(
                    top: 12,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF426DB3),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(story.profileImage),
                        onBackgroundImageError: (_, __) {},
                      ),
                    ),
                  ),
                  // Username at bottom
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        story.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FacebookSans',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
