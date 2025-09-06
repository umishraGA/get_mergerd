import 'package:flutter/material.dart';

import '../models/story_response_models.dart';
import '../controllers/story_controller.dart';
import 'StoryView.dart';

/// A view that automatically navigates through all users' stories in sequence
class StoryViewSequential extends StatefulWidget {
  final Map<String, List<StoryItem>> allStoriesByUser;
  final List<String> usernames;
  final int initialUserIndex;
  final StoryController? storyController;

  const StoryViewSequential({
    super.key,
    required this.allStoriesByUser,
    required this.usernames,
    this.initialUserIndex = 0,
    this.storyController,
  });

  @override
  State<StoryViewSequential> createState() => _StoryViewSequentialState();
}

class _StoryViewSequentialState extends State<StoryViewSequential> {
  late int _currentUserIndex;
  late PageController _pageController;
  bool _isChangingUser = false;

  // Add variables for swipe down dismissal
  double _verticalDragStart = 0.0;
  double _verticalDragUpdate = 0.0;

  @override
  void initState() {
    super.initState();
    _currentUserIndex = widget.initialUserIndex;
    _pageController = PageController(initialPage: _currentUserIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveToNextUser() {
    debugPrint('StoryViewSequential: _moveToNextUser called. Current: $_currentUserIndex, Total: ${widget.usernames.length}');
    
    if (_currentUserIndex < widget.usernames.length - 1) {
      // Show transition overlay immediately
      setState(() {
        _isChangingUser = true;
        _currentUserIndex++;
      });
      
      debugPrint('StoryViewSequential: Moving to next user: $_currentUserIndex');
      
      // Add a brief delay to show the transition overlay
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _pageController
              .animateToPage(
            _currentUserIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          )
              .then((_) {
            if (mounted) {
              // Add a small delay before removing overlay
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  setState(() {
                    _isChangingUser = false;
                  });
                  debugPrint('StoryViewSequential: Transition to user $_currentUserIndex completed');
                }
              });
            }
          }).catchError((error) {
            debugPrint('StoryViewSequential: Error during page transition: $error');
            if (mounted) {
              setState(() {
                _isChangingUser = false;
              });
            }
          });
        }
      });
    } else {
      // Last user, close the entire view with smooth transition
      debugPrint('StoryViewSequential: Last user reached, closing story view');
      
      // Show closing overlay
      setState(() {
        _isChangingUser = true;
      });
      
      // Longer delay for final close to ensure smooth transition
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  void _moveToPreviousUser() {
    if (_currentUserIndex > 0) {
      setState(() {
        _isChangingUser = true;
        _currentUserIndex--;
      });
      _pageController
          .animateToPage(
        _currentUserIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() {
          _isChangingUser = false;
        });
      });
    } else {
      // First user, just close if requested
      Navigator.of(context).pop();
    }
  }

  void _closeAllStories() {
    debugPrint('StoryViewSequential: _closeAllStories called');
    
    // Add smooth closing transition
    setState(() {
      _isChangingUser = true; // Show loading overlay during close
    });
    
    // Brief delay for smooth visual transition
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        debugPrint('StoryViewSequential: Popping navigation');
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          debugPrint('StoryViewSequential: Back button pressed. Current user: $_currentUserIndex');
          
          // Handle back button to navigate to previous user
          if (_currentUserIndex > 0) {
            _moveToPreviousUser();
            return false; // Prevent actual back navigation
          } else {
            // On first user, show smooth close transition
            debugPrint('StoryViewSequential: Back button on first user, closing smoothly');
            _closeAllStories();
            return false; // We handle the close ourselves
          }
        },
        child: GestureDetector(
          // Add direct gesture detection for swipe down dismissal
          onVerticalDragStart: (details) {
            _verticalDragStart = details.globalPosition.dy;
            _verticalDragUpdate = _verticalDragStart;
          },
          onVerticalDragUpdate: (details) {
            _verticalDragUpdate = details.globalPosition.dy;
          },
          onVerticalDragEnd: (details) {
            // If swiped down with sufficient distance or velocity, dismiss
            if ((_verticalDragUpdate - _verticalDragStart > 100) ||
                details.velocity.pixelsPerSecond.dy > 100) {
              _closeAllStories();
            }
          },
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.usernames.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentUserIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final username = widget.usernames[index];
                  final userStories = widget.allStoriesByUser[username]!;

                  return StoryView(
                    stories: userStories,
                    initialIndex: 0,
                    onNext: () => _moveToNextUser(),
                    onPrevious: () => _moveToPreviousUser(),
                    onClose: () => _closeAllStories(),
                    disableGestures: _isChangingUser,
                    storyController: widget.storyController,
                  );
                },
              ),
              // Show transition overlay when changing users
              if (_isChangingUser)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: Colors.black.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _currentUserIndex >= widget.usernames.length - 1 
                            ? 'Finishing stories...' 
                            : 'Loading next story...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentUserIndex >= widget.usernames.length - 1
                            ? 'Thanks for watching!'
                            : 'Loading ${widget.usernames.length > _currentUserIndex ? widget.usernames[_currentUserIndex] : ""}\'s stories',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
