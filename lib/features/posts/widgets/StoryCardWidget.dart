import 'package:flutter/material.dart';

import '../../story/models/story_response_models.dart';
import '../../story/controllers/story_controller.dart';
import '../../story/views/StoryViewSequential.dart';
import 'NetworkImageWidget.dart';

class StoryCardWidget extends StatelessWidget {
  final StoryItem story;
  final int storyIndex;
  final List<StoryItem>? allStories; // Add optional parameter for all stories
<<<<<<< HEAD
=======
  final StoryController? storyController; // Add story controller for pause/resume functionality
  final VoidCallback? onStoryOpened; // Callback when story is opened
  final VoidCallback? onStoryClosed; // Callback when story is closed
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b

  const StoryCardWidget({
    super.key,
    required this.story,
    required this.storyIndex,
    this.allStories,
<<<<<<< HEAD
=======
    this.storyController,
    this.onStoryOpened,
    this.onStoryClosed,
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  });

  /// Check if the given URL is a network URL
  bool _isNetworkUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // Get the first media URL if available
    final mediaUrl = (story.media?.isNotEmpty ?? false) ? (story.media!.first.url ?? '') : '';
    final username = (story.chooseTypeId?.additional_info?.isNotEmpty == true) 
        ? story.chooseTypeId!.additional_info!.first.title ?? 'Unknown'
        : story.chooseTypeId?.companyInfo?.companyName ?? 'Unknown';
=======
    // Get the first media URL, using thumbnail for videos if available
    String mediaUrl = '';
    if (story.media?.isNotEmpty ?? false) {
      final firstMedia = story.media!.first;
      if (firstMedia.type == 'video' && firstMedia.thumbnail?.isNotEmpty == true) {
        mediaUrl = firstMedia.thumbnail!; // Use thumbnail for videos
      } else {
        mediaUrl = firstMedia.url ?? ''; // Use original URL for images
      }
    }
    
    final username = story.displayName;
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    
    return Hero(
      tag: 'story_${username}_$storyIndex',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
<<<<<<< HEAD
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
=======
          onTap: () {
            // Notify immediately that a story is being opened (pauses other media)
            onStoryOpened?.call();
            storyController?.pauseAllStories();
            
            // Navigate immediately to provide instant feedback
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _StoryViewWrapper(
                  story: story,
                  username: username,
                  onStoryClosed: () {
                    storyController?.resumeAllStories();
                    onStoryClosed?.call();
                  },
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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
<<<<<<< HEAD
=======

class _StoryViewWrapper extends StatelessWidget {
  final StoryItem story;
  final String username;
  final VoidCallback onStoryClosed;

  const _StoryViewWrapper({
    required this.story,
    required this.username,
    required this.onStoryClosed,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-process stories immediately without async operations
    final List<StoryItem> individualStories = [];
    
    if ((story.media?.isNotEmpty ?? false)) {
      for (var mediaItem in story.media!) {
        final individualStory = story.copyWith(
          media: [mediaItem],
        );
        individualStories.add(individualStory);
      }
    }

    final Map<String, List<StoryItem>> storiesByUser = {
      username: individualStories,
    };

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onStoryClosed();
        }
      },
      child: _FastStoryView(
        storiesByUser: storiesByUser,
        username: username,
      ),
    );
  }
}

class _FastStoryView extends StatefulWidget {
  final Map<String, List<StoryItem>> storiesByUser;
  final String username;

  const _FastStoryView({
    required this.storiesByUser,
    required this.username,
  });

  @override
  State<_FastStoryView> createState() => _FastStoryViewState();
}

class _FastStoryViewState extends State<_FastStoryView> {
  StoryController? storyController;

  @override
  void initState() {
    super.initState();
    // Initialize controller in background without blocking UI
    _initializeControllerInBackground();
  }

  void _initializeControllerInBackground() async {
    storyController = StoryController();
    try {
      await storyController!.initialize();
    } catch (e) {
      debugPrint('Failed to initialize story controller: $e');
    }
  }

  @override
  void dispose() {
    storyController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show story view immediately without waiting for controller
    return StoryViewSequential(
      allStoriesByUser: widget.storiesByUser,
      usernames: [widget.username],
      initialUserIndex: 0,
      storyController: storyController, // null initially, gets set when ready
    );
  }
}
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
