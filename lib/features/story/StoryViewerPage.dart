import 'dart:async';

import 'package:flutter/material.dart';

import 'StoryModel.dart';

class StoryViewerPage extends StatefulWidget {
  final String initialStoryImage;
  final String logoImage;
  final int initialGroupIndex;

  const StoryViewerPage({
    super.key,
    required this.initialStoryImage,
    required this.logoImage,
    this.initialGroupIndex = 0,
  });

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage> {
  // Get all story groups
  final List<StoryGroup> _storyGroups = StoryGroup.getDemoStoryGroups();

  // Current group and story indices
  late int _currentGroupIndex;
  int _currentStoryIndex = 0;

  // Progress value between 0 and 1
  double _progress = 0.0;

  // Timer for story progress
  Timer? _timer;

  // Story duration in seconds
  final int _storyDuration = 5;

  @override
  void initState() {
    super.initState();

    // Initialize with the group containing the initial story image
    _currentGroupIndex = widget.initialGroupIndex;

    // Find the story index if the initial image matches
    final currentGroup = _storyGroups[_currentGroupIndex];
    for (int i = 0; i < currentGroup.stories.length; i++) {
      if (currentGroup.stories[i].imageUrl == widget.initialStoryImage) {
        _currentStoryIndex = i;
        break;
      }
    }

    // Start the story timer
    _startStoryTimer();
  }

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  // Start the story timer
  void _startStoryTimer() {
    // Cancel existing timer if any
    _timer?.cancel();

    // Reset progress
    setState(() {
      _progress = 0.0;
    });

    // Start a new timer
    const updateInterval = Duration(milliseconds: 100);
    final totalUpdates = _storyDuration * 1000 ~/ updateInterval.inMilliseconds;
    final progressIncrement = 1.0 / totalUpdates;

    _timer = Timer.periodic(updateInterval, (timer) {
      setState(() {
        _progress += progressIncrement;

        // When progress reaches 1, move to next story
        if (_progress >= 1.0) {
          _timer?.cancel();
          _moveToNextStory();
        }
      });
    });
  }

  // Move to the next story
  void _moveToNextStory() {
    final currentGroup = _storyGroups[_currentGroupIndex];

    if (_currentStoryIndex < currentGroup.stories.length - 1) {
      // Move to next story within the current group
      setState(() {
        _currentStoryIndex++;
        _progress = 0.0;
      });
      _startStoryTimer();
    } else if (_currentGroupIndex < _storyGroups.length - 1) {
      // Move to first story of the next group
      setState(() {
        _currentGroupIndex++;
        _currentStoryIndex = 0;
        _progress = 0.0;
      });
      _startStoryTimer();
    } else {
      // No more stories, close the viewer
      Navigator.pop(context);
    }
  }

  // Move to the previous story
  void _moveToPreviousStory() {
    if (_currentStoryIndex > 0) {
      // Move to previous story within the current group
      setState(() {
        _currentStoryIndex--;
        _progress = 0.0;
      });
      _startStoryTimer();
    } else if (_currentGroupIndex > 0) {
      // Move to last story of the previous group
      setState(() {
        _currentGroupIndex--;
        _currentStoryIndex =
            _storyGroups[_currentGroupIndex].stories.length - 1;
        _progress = 0.0;
      });
      _startStoryTimer();
    }
  }

  // Close the story and navigate back
  void _closeStory() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentGroup = _storyGroups[_currentGroupIndex];
    final currentStory = currentGroup.stories[_currentStoryIndex];
    final totalStoriesInGroup = currentGroup.stories.length;

    return WillPopScope(
      onWillPop: () async {
        _timer?.cancel();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Main story content with gesture detection
            GestureDetector(
              onTapUp: (details) {
                // Determine whether left or right side was tapped
                final screenWidth = MediaQuery.of(context).size.width;
                final tapPosition = details.globalPosition.dx;

                if (tapPosition < screenWidth / 3) {
                  // Left side tapped, go to previous story
                  _moveToPreviousStory();
                } else {
                  // Right side tapped, go to next story
                  _moveToNextStory();
                }
              },
              onLongPress: () {
                // Pause the timer when user holds the screen
                _timer?.cancel();
              },
              onLongPressEnd: (details) {
                // Resume the timer when user releases the screen
                _startStoryTimer();
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Story image with hero animation
                  Hero(
                    tag:
                        'story_${currentGroup.userProfileImage}_$_currentGroupIndex',
                    child: Image.asset(
                      currentStory.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade800,
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.white, size: 48),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // UI overlay with progress bar, user info, and close button
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 12.0),
                    child: Row(
                      children: List.generate(totalStoriesInGroup, (index) {
                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: index == _currentStoryIndex
                                ? FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  )
                                : index < _currentStoryIndex
                                    ? Container(color: Colors.white)
                                    : const SizedBox(),
                          ),
                        );
                      }),
                    ),
                  ),

                  // User info with close button
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Profile image
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage(currentGroup.userProfileImage),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 8),

                        // Username and timestamp
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentGroup.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'FacebookSans',
                                ),
                              ),
                              Text(
                                _getTimeAgo(currentStory.timestamp),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontFamily: 'FacebookSans',
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Completely separate close button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _closeStory,
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Add a dedicated tap zone in the top-right corner for closing
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _closeStory,
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: 80,
                      height: 80,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format timestamp as "time ago"
  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
