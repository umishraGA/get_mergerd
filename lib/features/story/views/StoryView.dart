import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';

import '../models/story_response_models.dart';
import '../controllers/story_controller.dart';
import '../../posts/widgets/NetworkImageWidget.dart';

class StoryView extends StatefulWidget {
  final List<StoryItem> stories;
  final int initialIndex;
  final VoidCallback? onNext; // Callback when all stories are done
  final VoidCallback? onPrevious; // Callback to show previous user's stories
  final VoidCallback? onClose; // Callback when user taps close button
  final bool disableGestures; // Whether to disable gesture detection
  final StoryController? storyController; // Controller for API interactions

  const StoryView({
    super.key,
    required this.stories,
    this.initialIndex = 0,
    this.onNext,
    this.onPrevious,
    this.onClose,
    this.disableGestures = false,
    this.storyController,
  });

  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  VideoPlayerController? _videoController;
  int _currentIndex = 0;
  double _progress = 0.0;
  bool _isPaused = false;
  bool _isVideoLoading = false;
  bool _hasVideoError = false;
  String _debugInfo = '';
  late AnimationController _loadingAnimationController;
  final AudioPlayer _commentAudioPlayer = AudioPlayer();
  final AudioPlayer _reactionAudioPlayer = AudioPlayer();

  // Define story durations
  static const Duration _imageDuration = Duration(seconds: 5);
  static const Duration _progressInterval = Duration(milliseconds: 50);

  // Add properties for slide-down animation
  double _dragOffset = 0.0;
  double _dragOpacity = 1.0;

  // Comment and reaction properties
  final TextEditingController _commentController = TextEditingController();
  final ValueNotifier<String?> _selectedReaction = ValueNotifier<String?>(null);
  // Map to store comments for each story ID
  final Map<String, ValueNotifier<List<String>>> _storyComments = {};
  final ScrollController _commentsScrollController = ScrollController();
  // Keyboard detection
  final FocusNode _commentFocusNode = FocusNode();
  bool _isKeyboardVisible = false;
  // Track comment text changes for UI updates
  final ValueNotifier<bool> _hasCommentText = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Set up keyboard listener
    _commentFocusNode.addListener(_onFocusChange);

    // Set up text controller listener
    _commentController.addListener(_onCommentTextChange);

    // Initialize audio players
    _initAudio();

    // Delay slightly to ensure the widget is fully built
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _initializeStory();
      }
    });
  }

  void _onFocusChange() {
    if (_commentFocusNode.hasFocus) {
      // When the text field gets focus, mark keyboard as visible and pause the story
      setState(() {
        _isKeyboardVisible = true;
        _isPaused = true;
      });

      // Pause video if playing
      if (_videoController != null && _videoController!.value.isPlaying) {
        _videoController!.pause();
      }
    } else {
      // When focus is lost, give some time for keyboard to dismiss
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && !_commentFocusNode.hasFocus) {
          setState(() {
            _isKeyboardVisible = false;
            // Resume playback if the story was paused because of keyboard
            _isPaused = false;
          });

          // Resume video if it was playing before
          if (_videoController != null && !_videoController!.value.isPlaying) {
            _videoController!.play();
          }

          // If the current story is an image, restart progress simulation
          final currentStory = widget.stories[_currentIndex];
          final mediaType = (currentStory.media?.isNotEmpty ?? false) 
            ? currentStory.media!.first.type 
            : 'image';
          if (mediaType == 'image') {
            _simulateProgress();
          }
        }
      });
    }
  }

  void _onCommentTextChange() {
    _hasCommentText.value = _commentController.text.isNotEmpty;
  }

  void _initializeStory() {
    final currentStory = widget.stories[_currentIndex];
    final mediaType = (currentStory.media?.isNotEmpty ?? false) 
      ? currentStory.media!.first.type 
      : 'image';
    final mediaUrl = (currentStory.media?.isNotEmpty ?? false) 
      ? currentStory.media!.first.url 
      : '';
      
    debugPrint(
        "Initializing story: ${currentStory.id}, media type: $mediaType, mediaUrl: $mediaUrl");

    setState(() {
      _hasVideoError = false;
      _debugInfo = '';
      _progress = 0.0;
    });

    if (mediaType == 'video' && mediaUrl?.isNotEmpty == true) {
      _initializeVideo(mediaUrl!);
    } else {
      // For image stories, we'll simulate progress
      _simulateProgress();
    }
  }

  void _simulateProgress() {
    // Reset progress
    setState(() {
      _progress = 0.0;
    });

    // Calculate the interval steps
    final totalSteps =
        _imageDuration.inMilliseconds ~/ _progressInterval.inMilliseconds;
    final stepIncrement = 1.0 / totalSteps;

    Future.doWhile(() async {
      if (!mounted || _isPaused || _isKeyboardVisible) {
        await Future.delayed(_progressInterval);
        return true;
      }

      if (_progress >= 1.0) {
        debugPrint("StoryView: Progress completed, moving to next story");
        // Ensure we're still mounted before calling moveToNextStory
        if (mounted) {
          _moveToNextStory();
        }
        return false;
      }

      setState(() {
        _progress += stepIncrement;
      });

      await Future.delayed(_progressInterval);
      return true;
    });
  }

  void _initializeVideo(String videoUrl) {
    // Clean up any existing controller
    if (_videoController != null) {
      _videoController!.removeListener(_updateProgress);
      _videoController!.dispose();
      _videoController = null;
    }

    setState(() {
      _isVideoLoading = true;
      _progress = 0.0;
      _hasVideoError = false;
      _debugInfo = 'Loading: $videoUrl';
    });

    debugPrint("Initializing video: $videoUrl");

    try {
      // Check if the video is an asset or a network URL
      if (videoUrl.startsWith('assets/')) {
        debugPrint("Asset video detected - switching to network fallback");
        // For asset videos, immediately use fallback since we've had issues with them
        _tryFallbackVideo();
        return;
      } else {
        // For network videos - Fix URL if needed
        if (videoUrl.startsWith('http:')) {
          videoUrl = videoUrl.replaceFirst('http:', 'https:');
          debugPrint("Fixed URL to HTTPS: $videoUrl");
        }

        // Add headers for Vimeo videos to prevent access issues
        Map<String, String> headers = {};
        if (videoUrl.contains('vimeo.com') ||
            videoUrl.contains('player.vimeo.com')) {
          headers = {
            'User-Agent': 'Mozilla/5.0',
            'Referer': 'https://vimeo.com/',
          };
          debugPrint("Added Vimeo headers");
        }

        // Create a network controller
        _videoController = VideoPlayerController.network(
          videoUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          httpHeaders: headers,
        );
      }

      _videoController!.initialize().then((_) {
        debugPrint(
            "Video initialized successfully: ${_videoController!.value.size}");

        if (!mounted) return;

        setState(() {
          _isVideoLoading = false;
          _debugInfo =
              'Successfully loaded video: ${_videoController!.value.size.width}x${_videoController!.value.size.height}';
        });

        if (_videoController!.value.isInitialized) {
          _videoController!.addListener(_updateProgress);
          _videoController!.addListener(_checkVideoCompletion);
          _videoController!.play();

          // Force a rebuild
          setState(() {});
        } else {
          setState(() {
            _hasVideoError = true;
            _debugInfo = 'Video initialized but not ready';
          });
          _tryFallbackVideo();
        }
      }).catchError((error) {
        debugPrint("Error initializing video: $error");
        if (!mounted) return;

        // Try fallback video on any error
        _tryFallbackVideo();
      });

      // Add timeout
      Future.delayed(const Duration(seconds: 8), () {
        if (_isVideoLoading && mounted) {
          debugPrint("Video loading timed out");

          // Use fallback on timeout
          _tryFallbackVideo();
        }
      });
    } catch (error) {
      debugPrint("Error creating video controller: $error");
      if (!mounted) return;

      // Try fallback on any error
      _tryFallbackVideo();
    }
  }

  void _tryFallbackVideo() {
    // Use a known working vertical video URL as fallback
    const fallbackUrl =
        'https://player.vimeo.com/external/394567489.hd.mp4?s=fc2dfe0717f8b8bec96e4c33ff762dd1552e8450&profile_id=175&oauth2_token_id=57447761';

    debugPrint("Trying fallback vertical video: $fallbackUrl");

    if (!mounted) return;

    // Clean up any existing controller
    if (_videoController != null) {
      _videoController!.removeListener(_updateProgress);
      _videoController!.dispose();
      _videoController = null;
    }

    setState(() {
      _debugInfo = 'Using fallback vertical video';
      _hasVideoError = false;
      _isVideoLoading = true; // Set loading state again
    });

    try {
      _videoController = VideoPlayerController.network(fallbackUrl,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          httpHeaders: {
            'User-Agent': 'Mozilla/5.0',
            'Referer': 'https://vimeo.com/'
          });

      _videoController!.initialize().then((_) {
        if (!mounted) return;

        setState(() {
          _isVideoLoading = false;
          _debugInfo = 'Successfully loaded fallback video';
        });

        if (_videoController!.value.isInitialized) {
          _videoController!.addListener(_updateProgress);
          _videoController!.addListener(_checkVideoCompletion);
          _videoController!.play();

          // Force a rebuild
          setState(() {});
        } else {
          setState(() {
            _hasVideoError = true;
            _debugInfo = 'Fallback video initialized but not ready';
          });
          // Try one more fallback - the most reliable video
          _tryLastResortFallback();
        }
      }).catchError((error) {
        debugPrint("Error initializing fallback video: $error");
        if (!mounted) return;

        // Try one more fallback
        _tryLastResortFallback();
      });

      // Add a shorter timeout for fallback
      Future.delayed(const Duration(seconds: 8), () {
        if (_isVideoLoading && mounted) {
          debugPrint("Fallback video loading timed out");
          _tryLastResortFallback();
        }
      });
    } catch (error) {
      debugPrint("Error creating fallback video controller: $error");
      if (!mounted) return;

      // Try one more fallback
      _tryLastResortFallback();
    }
  }

  void _tryLastResortFallback() {
    // Use the most reliable video as absolute last resort (Google's sample)
    const lastResortUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    debugPrint("Trying last resort video: $lastResortUrl");

    if (!mounted) return;

    // Clean up any existing controller
    if (_videoController != null) {
      _videoController!.removeListener(_updateProgress);
      _videoController!.dispose();
      _videoController = null;
    }

    setState(() {
      _debugInfo = 'Using last resort video';
      _hasVideoError = false;
      _isVideoLoading = true;
    });

    try {
      _videoController = VideoPlayerController.network(
        lastResortUrl,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      _videoController!.initialize().then((_) {
        if (!mounted) return;

        setState(() {
          _isVideoLoading = false;
          _debugInfo = 'Successfully loaded last resort video';
        });

        if (_videoController!.value.isInitialized) {
          _videoController!.addListener(_updateProgress);
          _videoController!.addListener(_checkVideoCompletion);
          _videoController!.play();

          // Force a rebuild
          setState(() {});
        } else {
          setState(() {
            _hasVideoError = true;
            _debugInfo = 'All video fallbacks failed';
          });
        }
      }).catchError((error) {
        debugPrint("Error initializing last resort video: $error");
        if (!mounted) return;

        setState(() {
          _isVideoLoading = false;
          _hasVideoError = true;
          _debugInfo = 'All video fallbacks failed';
        });
      });
    } catch (error) {
      debugPrint("Error creating last resort video controller: $error");
      if (!mounted) return;

      setState(() {
        _isVideoLoading = false;
        _hasVideoError = true;
        _debugInfo = 'All video fallbacks failed';
      });
    }
  }

  void _updateProgress() {
    if (!mounted) return;

    try {
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          _videoController!.value.duration.inMilliseconds > 0) {
        final progress = _videoController!.value.position.inMilliseconds /
            _videoController!.value.duration.inMilliseconds;

        setState(() {
          _progress = progress.clamp(0.0, 1.0);
        });
      }
    } catch (e) {
      debugPrint("Error updating progress: $e");
    }
  }

  void _checkVideoCompletion() {
    if (!mounted) return;

    try {
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          _videoController!.value.position >=
              _videoController!.value.duration) {
        // Video completed, move to next story
        _moveToNextStory();
      }
    } catch (e) {
      debugPrint("Error checking video completion: $e");
    }
  }

  void _moveToNextStory() {
    debugPrint("StoryView: Moving to next story. Current: $_currentIndex, Total: ${widget.stories.length}");
    
    if (_currentIndex < widget.stories.length - 1) {
      debugPrint("StoryView: Advancing to story ${_currentIndex + 1}");
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last story for this user, call the onNext callback
      debugPrint("StoryView: Last story reached for this user");
      
      // Add a brief pause to show story completion
      setState(() {
        _isPaused = true; // Pause any ongoing progress
      });
      
      // Brief delay before transitioning to next user or closing
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          if (widget.onNext != null) {
            debugPrint("StoryView: Calling onNext callback after delay");
            widget.onNext!();
          } else {
            debugPrint("StoryView: No onNext callback, popping navigation after delay");
            Navigator.of(context).pop();
          }
        }
      });
    }
  }

  void _moveToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.animateToPage(
        _currentIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // First story for this user, call the onPrevious callback
      if (widget.onPrevious != null) {
        widget.onPrevious!();
      }
    }
  }

  @override
  void dispose() {
    if (_videoController != null) {
      _videoController!.removeListener(_updateProgress);
      _videoController!.removeListener(_checkVideoCompletion);
      _videoController!.dispose();
    }
    _pageController.dispose();
    _loadingAnimationController.dispose();
    _commentController.removeListener(_onCommentTextChange);
    _commentController.dispose();
    _selectedReaction.dispose();
    _commentFocusNode.removeListener(_onFocusChange);
    _commentFocusNode.dispose();
    _commentAudioPlayer.dispose();
    _reactionAudioPlayer.dispose();
    _hasCommentText.dispose();

    // Dispose all comment notifiers
    for (final commentNotifier in _storyComments.values) {
      commentNotifier.dispose();
    }
    _storyComments.clear();

    _commentsScrollController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    // If gestures are disabled, don't respond
    if (widget.disableGestures) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    // Check if the tap is in the top-right corner (close button area)
    final topPadding = MediaQuery.of(context).padding.top;
    if (tapPosition > screenWidth - 60 &&
        details.globalPosition.dy < topPadding + 100) {
      // This is likely trying to tap the close button - ignore
      return;
    }

    if (tapPosition < screenWidth * 0.3) {
      // Left 30% of screen - go to previous story
      _moveToPreviousStory();
    } else if (tapPosition > screenWidth * 0.7) {
      // Right 30% of screen - go to next story
      _moveToNextStory();
    } else {
      // Middle 40% - toggle pause
      setState(() {
        _isPaused = !_isPaused;
      });

      if (_isPaused) {
        _videoController?.pause();
      } else {
        _videoController?.play();
      }
    }
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isPaused = true;
    });
    _videoController?.pause();
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isPaused = false;
    });
    _videoController?.play();
  }

  @override
  Widget build(BuildContext context) {
    final StoryItem currentStory = widget.stories[_currentIndex];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false, // Prevent automatic resizing
      body: Stack(
        children: [
          // Main content with gesture detection for story navigation
          GestureDetector(
            onTapDown: _handleTapDown,
            onLongPressStart: _handleLongPressStart,
            onLongPressEnd: _handleLongPressEnd,
            child: Stack(
              children: [
                // Story Content
                GestureDetector(
                  // Enhanced vertical drag for interactive dismissal
                  onVerticalDragStart: (_) {
                    setState(() {
                      _dragOffset = 0;
                      _dragOpacity = 1.0;
                    });
                  },
                  onVerticalDragUpdate: (details) {
                    // Only handle downward drags
                    if (details.delta.dy > 0) {
                      setState(() {
                        // Update drag offset for animation
                        _dragOffset += details.delta.dy;

                        // Calculate opacity based on drag distance
                        // Reduce opacity more aggressively
                        _dragOpacity =
                            1.0 - (_dragOffset / 300).clamp(0.0, 0.8);
                      });
                    }
                  },
                  onVerticalDragEnd: (details) {
                    // Lower threshold and higher velocity sensitivity for easier dismissal
                    if (_dragOffset > 80 ||
                        details.velocity.pixelsPerSecond.dy > 80) {
                      // Immediate visual feedback before actual dismissal
                      setState(() {
                        _dragOffset += 100; // Push it further down
                        _dragOpacity = 0.2; // Fade it out more
                      });

                      // Short delay to show the animation before dismissing
                      Future.delayed(const Duration(milliseconds: 100), () {
                        debugPrint('StoryView: Swipe down detected, closing story');
                        if (mounted) {
                          if (widget.onClose != null) {
                            widget.onClose!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      });
                    } else {
                      // Otherwise, animate back to original position with spring effect
                      setState(() {
                        _dragOffset = 0;
                        _dragOpacity = 1.0;
                      });
                    }
                  },
                  // Apply both translation and scale for better visual effect
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, _dragOffset)
                      ..scale(1.0 -
                          (_dragOffset / 1000)
                              .clamp(0.0, 0.1)), // Subtle scaling effect
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Opacity(
                        opacity: _dragOpacity,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                              _progress = 0.0;
                            });
                            _initializeStory();
                          },
                          itemCount: widget.stories.length,
                          itemBuilder: (context, index) {
                            final story = widget.stories[index];
                            return _buildStoryContent(story);
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // User info row
                Positioned(
                  top: MediaQuery.of(context).padding.top + 40 + (_dragOffset * 0.5),
                  left: 8,
                  right: 8,
                  child: Opacity(
                      opacity: _dragOpacity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: () {
                                        final profileImage = currentStory.chooseTypeId?.image ?? currentStory.chooseTypeId?.logo?.url;
                                        if (profileImage != null) {
                                          return NetworkImage(profileImage) as ImageProvider;
                                        }
                                        return const AssetImage('assets/images/default_avatar.png') as ImageProvider;
                                      }(),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${currentStory.createdBy?.firstName ?? ''} ${currentStory.createdBy?.lastName ?? ''}'.trim().isNotEmpty ? '${currentStory.createdBy?.firstName ?? ''} ${currentStory.createdBy?.lastName ?? ''}'.trim() : 'User',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if ((currentStory.likesCount ?? 0) > 0)
                                            Text(
                                              '${currentStory.likesCount ?? 0} likes',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Check if current story is a video
                                    if ((currentStory.media?.isNotEmpty ?? false) && 
                                        currentStory.media!.first.type == 'video')
                                      Row(
                                        children: [
                                          const SizedBox(width: 8),
                                          Text(
                                            _isVideoLoading
                                                ? "Loading..."
                                                : (_hasVideoError
                                                    ? "Error"
                                                    : ""),
                                            style: TextStyle(
                                              color: _hasVideoError
                                                  ? Colors.red
                                                  : Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                // Like button
                                // Material(
                                //   color: Colors.transparent,
                                //   child: InkWell(
                                //     onTap: () => _handleStoryLike(currentStory.id ?? ''),
                                //     borderRadius: BorderRadius.circular(16),
                                //     child: Container(
                                //       padding: const EdgeInsets.all(4),
                                //       decoration: BoxDecoration(
                                //         color: Colors.black26,
                                //         borderRadius: BorderRadius.circular(16),
                                //       ),
                                //       child: Icon(
                                //         (currentStory.isLikedByUser ?? false)
                                //             ? Icons.favorite
                                //             : Icons.favorite_border,
                                //         color: (currentStory.isLikedByUser ?? false)
                                //             ? Colors.red
                                //             : Colors.white,
                                //         size: 20,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ])
                      ),
                ),

                // Pause indicator
                if (_isPaused)
                  const Center(
                    child: Icon(
                      Icons.pause_circle_filled,
                      color: Colors.white54,
                      size: 80,
                    ),
                  ),

                // Tap navigation hint overlay (only shown for 2 seconds on first load)
                _buildTapNavigationHint(),
              ],
            ),
          ),

          // Close button - use Positioned instead of SafeArea
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 8,
            child: Opacity(
              opacity: _dragOpacity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    debugPrint('StoryView: Close button tapped');
                    if (mounted) {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Story Progress Indicators - positioned in outer Stack for visibility
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Opacity(
              opacity: _dragOpacity,
              child: Row(
                children: List.generate(
                  widget.stories.length,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                      child: index == _currentIndex
                          ? FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              ),
                            )
                          : FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: index < _currentIndex ? 1.0 : 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Add Facebook-style comment bar and emoji reactions at bottom
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            // Position based on keyboard visibility using our controller
            bottom: _isKeyboardVisible
                ? bottomInset > 0
                    ? bottomInset + 50
                    : 20 // Use the actual keyboard height when visible
                : 0, // At bottom when keyboard is hidden
            left: 0,
            right: 0,
            child: _buildStoryInteractionBar(currentStory),
          ),
        ],
      ),
    );
  }

  // Updated emoji reaction section with more distinctive background
  Widget _buildStoryInteractionBar(StoryItem story) {
    // Get keyboard height directly from MediaQuery
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.95), // More solid background at bottom
            Colors.black.withOpacity(0.85),
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 0.9],
        ),
      ),
      padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: _isKeyboardVisible
              ? 4
              : 10, // Reduce top padding when keyboard is visible
          bottom: _isKeyboardVisible
              ? 4 // Less padding when keyboard is visible
              : MediaQuery.of(context).padding.bottom + 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Comments display area - hide when keyboard is visible to save space
          if (!_isKeyboardVisible)
            ValueListenableBuilder<List<String>>(
              valueListenable: _getCommentsForStory(story.id ?? ''),
              builder: (context, commentsList, _) {
                // Don't show anything if there are no comments
                if (commentsList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  // Fixed height container only when comments exist
                  height: 150,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      // Add a slight background to make comments pop
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // Show comments with newest at the bottom
                    child: ListView.builder(
                      controller: _commentsScrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      // Reverse the list to show newest at bottom
                      reverse: true,
                      itemCount: commentsList.length,
                      itemBuilder: (context, index) {
                        // Reverse the index to get newest at bottom
                        final reversedIndex = commentsList.length - 1 - index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundImage:
                                    AssetImage('assets/images/story_logo1.png'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "You",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        // Use a slightly blue tint for better visibility
                                        color: Colors.blueGrey.shade900
                                            .withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        commentsList[reversedIndex],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

          // Main interaction bar
          Container(
            height: 55, // Reduced height
            decoration: BoxDecoration(
              // Use more vibrant background with a subtle blue tint
              color: _isKeyboardVisible
                  ? Colors.blueGrey.shade900
                      .withOpacity(0.9) // More opaque when keyboard visible
                  : Colors.blueGrey.shade900.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
              // Add subtle border for definition
              border:
                  Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text field with send button inside
                // Expanded(
                //   flex: 2,
                //   child: Stack(
                //     alignment: Alignment.centerRight,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 8),
                //         child: ValueListenableBuilder<bool>(
                //             valueListenable: _hasCommentText,
                //             builder: (context, hasText, child) {
                //               return TextField(
                //                 cursorColor: Colors.white,
                //                 controller: _commentController,
                //                 focusNode:
                //                     _commentFocusNode, // Use our focus node for keyboard detection
                //                 style: const TextStyle(color: Colors.white),
                //                 decoration: InputDecoration(
                //                   hintText: 'Reply to ${'${story.createdBy?.firstName ?? ''} ${story.createdBy?.lastName ?? ''}'.trim()}...',
                //                   hintStyle: TextStyle(
                //                     color: Colors.white.withOpacity(0.6),
                //                     fontWeight: FontWeight.w300,
                //                     fontSize: 14,
                //                   ),
                //                   border: InputBorder.none,
                //                   isDense: true,
                //                   filled: true,
                //                   // Darken text field background for contrast
                //                   fillColor: hasText
                //                       ? Colors.blue.withOpacity(
                //                           0.2) // Slight blue tint when text is present
                //                       : Colors.black.withOpacity(0.5),
                //                   contentPadding: const EdgeInsets.symmetric(
                //                       vertical: 12, horizontal: 12),
                //                   // Add padding to the right to make room for the send button
                //                   suffixIcon: const SizedBox(width: 40),
                //                   enabledBorder: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(20),
                //                     borderSide: hasText
                //                         ? BorderSide(
                //                             color: Colors.blue.withOpacity(0.3),
                //                             width: 1)
                //                         : BorderSide.none,
                //                   ),
                //                   focusedBorder: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(20),
                //                     borderSide: BorderSide(
                //                         color: Colors.blue.withOpacity(0.5),
                //                         width: 1),
                //                   ),
                //                 ),
                //                 onSubmitted: (text) {
                //                   if (text.trim().isNotEmpty) {
                //                     _getCommentsForStory(story.id??"").value = [
                //                       ..._getCommentsForStory(story.id ?? "").value,
                //                       text
                //                     ];
                //                     _commentController.clear();
                //                     // Safe scrolling - check if controller is attached first
                //                     Future.delayed(
                //                         const Duration(milliseconds: 100), () {
                //                       if (_commentsScrollController
                //                           .hasClients) {
                //                         _commentsScrollController.animateTo(
                //                           0, // Scroll to top when reversed list
                //                           duration:
                //                               const Duration(milliseconds: 300),
                //                           curve: Curves.easeOut,
                //                         );
                //                       }
                //                     });
                //
                //                     // Unfocus to hide keyboard after submitting
                //                     _commentFocusNode.unfocus();
                //
                //                     // Resume story playback
                //                     setState(() {
                //                       _isPaused = false;
                //                     });
                //                     // Resume video if needed
                //                     if (_videoController != null &&
                //                         !_videoController!.value.isPlaying) {
                //                       _videoController!.play();
                //                     }
                //                   } else {
                //                     // If empty submission, just unfocus without clearing
                //                     _commentFocusNode.unfocus();
                //                   }
                //                 },
                //               );
                //             }),
                //       ),
                //       // Send button inside the TextField (simplified)
                //       Positioned(
                //         right: 14,
                //         child: ValueListenableBuilder<bool>(
                //             valueListenable: _hasCommentText,
                //             builder: (context, hasText, _) {
                //               return Material(
                //                 color: Colors.transparent,
                //                 child: InkWell(
                //                   borderRadius: BorderRadius.circular(30),
                //                   onTap: () async {
                //                     final text = _commentController.text;
                //                     if (text.trim().isNotEmpty) {
                //                       // Play comment sound
                //                       await _playCommentSound();
                //
                //                       _getCommentsForStory(story.id ?? '').value = [
                //                         ..._getCommentsForStory(story.id ?? '').value,
                //                         text
                //                       ];
                //                       _commentController.clear();
                //                       // Safe scrolling - check if controller is attached first
                //                       Future.delayed(
                //                           const Duration(milliseconds: 100),
                //                           () {
                //                         if (_commentsScrollController
                //                             .hasClients) {
                //                           _commentsScrollController.animateTo(
                //                             0, // Scroll to top when reversed list
                //                             duration: const Duration(
                //                                 milliseconds: 300),
                //                             curve: Curves.easeOut,
                //                           );
                //                         }
                //                       });
                //
                //                       // Unfocus to hide keyboard after sending
                //                       _commentFocusNode.unfocus();
                //
                //                       // Resume story playback
                //                       setState(() {
                //                         _isPaused = false;
                //                       });
                //                       // Resume video if needed
                //                       if (_videoController != null &&
                //                           !_videoController!.value.isPlaying) {
                //                         _videoController!.play();
                //                       }
                //                     } else {
                //                       // If empty text, just unfocus without clearing
                //                       _commentFocusNode.unfocus();
                //                     }
                //                   },
                //                   child: AnimatedContainer(
                //                     duration: const Duration(milliseconds: 200),
                //                     padding: const EdgeInsets.all(6),
                //                     decoration: BoxDecoration(
                //                       color: hasText
                //                           ? Colors.blue.withOpacity(0.6)
                //                           : Colors.transparent,
                //                       shape: BoxShape.circle,
                //                     ),
                //                     child: Icon(
                //                       Icons.send_rounded,
                //                       color: hasText
                //                           ? Colors.white
                //                           : Colors.lightBlueAccent,
                //                       size: 22,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             }),
                //       ),
                //     ],
                //   ),
                // ),

                // Reduced to only three emoji reactions - hide when keyboard is visible to save space
                // if (!_isKeyboardVisible)
                Flexible(
                  flex: 1,
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 350, maxHeight: 55),
                    height: 50,
                    margin: const EdgeInsets.only(right: 8, left: 4),
                    decoration: BoxDecoration(
                      // Dark blue-grey tint with higher opacity
                      color: Colors.blueGrey.shade900.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(28),
                      // Add subtle shadow for depth
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildReactionButton('👍', 'LIKE'),
                          _buildReactionButton('❤️', 'LOVE'),
                          _buildReactionButton('😂', 'HAHA'),
                          _buildReactionButton('😮', 'WOW'),
                          _buildReactionButton('😢', 'SAD'),
                          _buildReactionButton('😡', 'ANGRY'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  // Helper method to build each reaction button
  Widget _buildReactionButton(String emoji, String label) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedReaction,
      builder: (context, selected, _) {
        final currentStory = widget.stories[_currentIndex];
        
        // Check if this reaction is selected either locally or from API
        final isSelectedLocally = selected == emoji;
        final isSelectedFromApi = _isReactionSelectedFromApi(currentStory, emoji, label);
        final isSelected = isSelectedLocally || isSelectedFromApi;

        return Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, // Slightly smaller
                height: 40, // Slightly smaller
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    splashColor: Colors.blue.withOpacity(0.3),
                    highlightColor: Colors.blue.withOpacity(0.2),
                    onTap: () async {
                      // Unfocus the text field to dismiss the keyboard
                      _commentFocusNode.unfocus();

                      // Play sound when selecting a new reaction (not when deselecting)
                      if (!isSelected) {
                        await _playReactionSound();
                      }

                      if (isSelected) {
                        // If already selected, deselect it
                        _selectedReaction.value = null;
                        // TODO: Add API call to remove reaction if backend supports it
                      } else {
                        // Always clear any existing selection first to ensure mutual exclusivity
                        _selectedReaction.value = null;
                        
                        final currentStory = widget.stories[_currentIndex];
                        
                        // Call reaction API for all emojis including heart
                        final success = await _handleStoryReaction(currentStory.id ?? '', label.toUpperCase());
                        
                        // Only set the local selection if API call was successful
                        if (success) {
                          _selectedReaction.value = emoji;
                          
                          // Force a rebuild to update the UI immediately
                          // This will refresh the story data and clear any previously selected reactions from API
                          setState(() {});
                        }
                      }
                    },
                    child: Center(
                      child: Text(
                        emoji,
                        style: TextStyle(
                          fontSize: isSelected ? 22 : 20,
                          height: 1.2, // Better vertical centering for emojis
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              // Show a dot indicator below the selected reaction
              if (isSelected)
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTapNavigationHint() {
    return FutureBuilder<bool>(
      future: Future.delayed(const Duration(milliseconds: 100), () => true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 1.0, end: 0.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: child,
          ),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            child: Stack(
              children: [
                // Left arrow
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Previous',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right arrow
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Center tap
                // Center(
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       const Icon(
                //         Icons.touch_app,
                //         color: Colors.white70,
                //         size: 24,
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         'Hold to pause',
                //         style: TextStyle(
                //           color: Colors.white.withOpacity(0.7),
                //           fontSize: 10,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoryContent(StoryItem story) {
    final mediaType = (story.media?.isNotEmpty ?? false) 
      ? story.media!.first.type 
      : 'image';
    final mediaUrl = (story.media?.isNotEmpty ?? false) 
      ? story.media!.first.url 
      : '';
      
    // For video stories
    if (mediaType == 'video' && mediaUrl?.isNotEmpty == true) {
      // Show loading state
      if (_isVideoLoading) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Show static image while loading
            NetworkImageWidget(
              imageUrl: mediaUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Loading video...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      // Show video player if initialized
      if (_videoController != null &&
          _videoController!.value.isInitialized &&
          !_hasVideoError) {
        // Get the screen dimensions
        final screenSize = MediaQuery.of(context).size;
        final videoSize = _videoController!.value.size;

        // Detect if video is vertical (height > width)
        final isVerticalVideo = videoSize.height > videoSize.width;

        // For vertical videos, we want them to fill the height and be centered horizontally
        if (isVerticalVideo) {
          final videoHeight = screenSize.height;
          final videoWidth = videoSize.width * (videoHeight / videoSize.height);

          return Container(
            color: Colors.black,
            height: screenSize.height,
            width: screenSize.width,
            child: Center(
              child: SizedBox(
                height: videoHeight,
                width: videoWidth,
                child: VideoPlayer(_videoController!),
              ),
            ),
          );
        } else {
          // For horizontal videos, use the standard AspectRatio approach
          return Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            ),
          );
        }
      } else if (_hasVideoError) {
        // Show error state with retry button
        return Stack(
          fit: StackFit.expand,
          children: [
            // Show static image on error
            NetworkImageWidget(
              imageUrl: mediaUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Video couldn't be played",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (mediaUrl?.isNotEmpty == true) {
                          _initializeVideo(mediaUrl!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                    // Show debug info in development
                    if (_debugInfo.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _debugInfo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }

    // For image stories
    return NetworkImageWidget(
      imageUrl: mediaUrl ?? '',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  // Helper method to get or create a comment list for a story
  ValueNotifier<List<String>> _getCommentsForStory(String storyId) {
    if (!_storyComments.containsKey(storyId)) {
      _storyComments[storyId] = ValueNotifier<List<String>>([]);
    }
    return _storyComments[storyId]!;
  }

  // Initialize all audio resources
  Future<void> _initAudio() async {
    try {
      // Initialize comment audio
      await _commentAudioPlayer.setAsset('assets/audio/comment_audio.mp3');

      // Initialize reaction audio
      await _reactionAudioPlayer.setAsset('assets/audio/like_button_audio.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  Future<void> _playCommentSound() async {
    try {
      await _commentAudioPlayer.seek(Duration.zero);
      await _commentAudioPlayer.play();
    } catch (e) {
      debugPrint('Error playing comment sound: $e');
    }
  }

  Future<void> _playReactionSound() async {
    try {
      await _reactionAudioPlayer.seek(Duration.zero);
      await _reactionAudioPlayer.play();
    } catch (e) {
      debugPrint('Error playing reaction sound: $e');
    }
  }

  /// Handle story like toggle
  Future<void> _handleStoryLike(String storyId) async {
    debugPrint('StoryView: _handleStoryLike called for storyId: $storyId');
    
    if (widget.storyController == null) {
      debugPrint('StoryView: storyController is null, cannot like story');
      return;
    }

    debugPrint('StoryView: Calling toggleStoryLike API...');
    final success = await widget.storyController!.toggleStoryLike(storyId);
    debugPrint('StoryView: toggleStoryLike API returned: $success');
    
    if (mounted) {
      if (success) {
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Story ${widget.storyController!.getStoryById(storyId)?.isLikedByUser == true ? 'liked' : 'unliked'}!'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error feedback
        final errorMessage = widget.storyController!.likeError ?? 'Failed to like story';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Check if reaction is selected based on API data
  bool _isReactionSelectedFromApi(StoryItem story, String emoji, String label) {
    // Get the most up-to-date story data from the controller if available
    StoryItem? updatedStory;
    if (widget.storyController != null) {
      updatedStory = widget.storyController!.getStoryById(story.id ?? '');
    }
    
    // Use the updated story data if available, otherwise fall back to the original story
    final storyToCheck = updatedStory ?? story;
    
    // Check userReaction field for all emojis including heart
    final userReaction = storyToCheck.userReaction;
    if (userReaction == null) return false;
    
    // Map emoji/label to expected API reaction values
    switch (emoji) {
      case '👍':
        return userReaction.toUpperCase() == 'LIKE';
      case '❤️':
        return userReaction.toUpperCase() == 'LOVE';
      case '😂':
        return userReaction.toUpperCase() == 'HAHA';
      case '😮':
        return userReaction.toUpperCase() == 'SURPRISE' || userReaction.toUpperCase() == 'WOW';
      case '😢':
        return userReaction.toUpperCase() == 'SAD';
      case '😡':
        return userReaction.toUpperCase() == 'ANGRY';
      default:
        return false;
    }
  }

  /// Handle story reaction
  Future<bool> _handleStoryReaction(String storyId, String reactionType) async {
    debugPrint('StoryView: _handleStoryReaction called for storyId: $storyId, reactionType: $reactionType');
    
    if (widget.storyController == null) {
      debugPrint('StoryView: storyController is null, cannot add reaction');
      return false;
    }

    debugPrint('StoryView: Calling addStoryReaction API...');
    final success = await widget.storyController!.addStoryReaction(storyId, reactionType);
    debugPrint('StoryView: addStoryReaction API returned: $success');
    
    if (mounted) {
      if (success) {
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(reactionType, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                const Text('Reaction added!'),
              ],
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show error feedback
        final errorMessage = widget.storyController!.reactionError ?? 'Failed to add reaction';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    
    return success;
  }
}
