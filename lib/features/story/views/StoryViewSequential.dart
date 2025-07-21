import 'package:flutter/material.dart';

import '../models/StoryModel.dart';
import 'StoryView.dart';

/// A view that automatically navigates through all users' stories in sequence
class StoryViewSequential extends StatefulWidget {
  final Map<String, List<StoryModel>> allStoriesByUser;
  final List<String> usernames;
  final int initialUserIndex;

  const StoryViewSequential({
    super.key,
    required this.allStoriesByUser,
    required this.usernames,
    this.initialUserIndex = 0,
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
    if (_currentUserIndex < widget.usernames.length - 1) {
      setState(() {
        _isChangingUser = true;
        _currentUserIndex++;
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
      // Last user, close the entire view
      Navigator.of(context).pop();
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
    // Close the entire story view sequence
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          // Handle back button to navigate to previous user
          if (_currentUserIndex > 0) {
            _moveToPreviousUser();
            return false; // Prevent actual back navigation
          }
          return true; // Allow back navigation if on first user
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
          child: PageView.builder(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
