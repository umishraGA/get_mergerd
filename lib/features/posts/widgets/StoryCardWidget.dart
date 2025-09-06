import 'package:flutter/material.dart';

import '../../story/models/story_response_models.dart';
import '../../story/controllers/story_controller.dart';
import '../../story/views/StoryViewSequential.dart';
import 'NetworkImageWidget.dart';

class StoryCardWidget extends StatelessWidget {
  final StoryItem story;
  final int storyIndex;
  final List<StoryItem>? allStories; // Add optional parameter for all stories

  const StoryCardWidget({
    super.key,
    required this.story,
    required this.storyIndex,
    this.allStories,
  });

  /// Check if the given URL is a network URL
  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    // Get the first media URL if available
    final mediaUrl = (story.media?.isNotEmpty ?? false) ? (story.media!.first.url ?? '') : '';
    final username = (story.chooseTypeId?.additional_info?.isNotEmpty == true) 
        ? story.chooseTypeId!.additional_info!.first.title ?? 'Unknown'
        : story.chooseTypeId?.companyInfo?.companyName ?? 'Unknown';
    
    return Hero(
      tag: 'story_${username}_$storyIndex',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Create individual stories from the current story's media items
            final List<StoryItem> individualStories = [];
            
            if ((story.media?.isNotEmpty ?? false)) {
              // Create a separate story for each media item of this specific story
              for (var mediaItem in story.media!) {
                final individualStory = story.copyWith(
                  media: [mediaItem], // Single media item per story
                );
                individualStories.add(individualStory);
              }
            }

            // Create stories map with just this user's stories
            final Map<String, List<StoryItem>> storiesByUser = {
              username: individualStories,
            };
            final List<String> usernames = [username];

            // Always start with index 0 since we only have one user
            final userIndex = 0;

            // Create and initialize story controller for API interactions
            final storyController = StoryController();
            try {
              await storyController.initialize();
            } catch (e) {
              debugPrint('Failed to initialize story controller: $e');
              // Continue without controller - like/reaction features will be disabled
            }

            if (!context.mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StoryViewSequential(
                  allStoriesByUser: storiesByUser,
                  usernames: usernames,
                  initialUserIndex: userIndex >= 0 ? userIndex : 0,
                  storyController: storyController,
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
                  NetworkImageWidget(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorWidget: Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey),
                      ),
                    ),
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
                      child: () {
                        // Get profile image from chooseTypeId
                        final profileImage = story.chooseTypeId?.image ?? story.chooseTypeId?.logo?.url;
                        final hasValidImage = profileImage != null && _isNetworkUrl(profileImage);
                        
                        return CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          backgroundImage: hasValidImage ? NetworkImage(profileImage!) : null,
                          onBackgroundImageError: hasValidImage ? (_, __) {} : null,
                          child: !hasValidImage ? Text(
                            username.isNotEmpty ? username[0].toUpperCase() : 'U',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF426DB3),
                            ),
                          ) : null,
                        );
                      }(),
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
                        username,
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
