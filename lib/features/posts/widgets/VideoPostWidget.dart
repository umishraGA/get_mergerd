import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/features/posts/widgets/NetworkImageWidget.dart';
import 'package:myapp/core/services/orientation_service.dart';
import 'package:myapp/features/mainPage/data/open_video_from.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../controllers/global_video_manager.dart';
import '../services/video_post_cache_service.dart';

class VideoPostWidget extends StatefulWidget {
  final String videoPath;
  final String thumbnailPath;
  final Function() onDoubleTap;
  final Function()? onTap;
  final bool autoPlay;
  final OpenVideoFrom openVideoFrom;
  final bool allowFullscreenToggle;
  final bool rememberPosition;
  final VoidCallback? onFullscreenToggle;
  final VoidCallback? onFullscreenExit;
  final String postId; // Add postId for caching

  const VideoPostWidget({
    super.key,
    required this.videoPath,
    required this.thumbnailPath,
    required this.onDoubleTap,
    this.onTap,
    this.autoPlay = true,
    this.openVideoFrom = OpenVideoFrom.postDetail,
    this.allowFullscreenToggle = true,
    this.rememberPosition = true,
    this.onFullscreenToggle,
    this.onFullscreenExit,
    required this.postId, // Add postId parameter
  });

  @override
  State<VideoPostWidget> createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends State<VideoPostWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  final OrientationService _orientationService = OrientationService();
  final GlobalVideoManager _globalVideoManager = GlobalVideoManager();
  final VideoPostCacheService _cacheService = VideoPostCacheService();
  late String _videoId; // Unique ID for this video
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isVisible = false;
  bool _hasError = false;
  bool _isVideoTapped = false; // Track if video was tapped for play/pause
  bool _isFullscreen = false; // Track fullscreen state
  bool _showControls = true; // Controls visibility in fullscreen mode
  DateTime? _lastTapTime; // Track time of last tap for double tap detection
  int _lastPosition = 0; // Track the last position in milliseconds
  bool _isPositionRestored = false; // Flag to check if position was restored

  // Position save delay timer - to avoid excessive writes
  DateTime? _lastPositionSaveTime;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _playPauseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Create stable video ID based on video path only (no timestamp)
    _videoId = 'video_${widget.videoPath.hashCode}_${widget.openVideoFrom.name}';

    // Try to restore the last position first, then initialize the video
    if (widget.rememberPosition) {
      _retrieveSavedPosition().then((_) {
        _initializeVideo();
      });
    } else {
      _initializeVideo();
    }

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _playPauseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    // Listen to global video manager changes
    _globalVideoManager.addListener(_onGlobalVideoStateChanged);
  }

  // Get a unique key for storing this video's position
  String get _positionKey => 'video_position_${widget.videoPath.hashCode}';
  
  // Handle global video manager state changes
  void _onGlobalVideoStateChanged() {
    if (!mounted) return;
    
    // If globally paused (e.g., when story is opened), pause this video
    if (_globalVideoManager.isGloballyPaused && _isPlaying) {
      _pauseVideo();
      debugPrint('VideoPostWidget: Paused due to global pause state');
    }
  }
  
  // Pause this video
  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      try {
        _controller.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
          _animationController.forward(); // Show play button
        }
      } catch (e) {
        debugPrint('VideoPostWidget: Error pausing video: $e');
        // Ensure state is consistent even if pause fails
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    }
  }
  
  // Play this video (through global manager)
  void _playVideo() {
    if (_isInitialized && !_isPlaying && !_globalVideoManager.isGloballyPaused) {
      _globalVideoManager.playVideo(_videoId);
      setState(() {
        _isPlaying = true;
      });
      _animationController.reverse(); // Hide play button
    }
  }

  // Helper method to retrieve the last watched position from SharedPreferences
  Future<void> _retrieveSavedPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final position = prefs.getInt(_positionKey);
      if (position != null) {
        _lastPosition = position;
      }
    } catch (e) {
      // If we can't get the saved position, just start from beginning
      _lastPosition = 0;
    }
  }

  // Save the current position to persistent image
  Future<void> _savePosition() async {
    if (!widget.rememberPosition || !_isInitialized) return;

    // Avoid saving too frequently - only save if it's been at least 1 second since last save
    final now = DateTime.now();
    if (_lastPositionSaveTime != null &&
        now.difference(_lastPositionSaveTime!).inSeconds < 1) {
      return;
    }

    _lastPositionSaveTime = now;

    try {
      final prefs = await SharedPreferences.getInstance();
      final position = _controller.value.position.inMilliseconds;

      // Only save if we've watched some of the video and if it's not at the very end
      if (position > 0 &&
          position < _controller.value.duration.inMilliseconds - 1000) {
        await prefs.setInt(_positionKey, position);
        _lastPosition = position;
      } else if (position >= _controller.value.duration.inMilliseconds - 1000) {
        // If the video is nearly finished, clear the saved position to start from beginning next time
        await prefs.remove(_positionKey);
        _lastPosition = 0;
      }
    } catch (e) {
      // If we can't save the position, just continue
    }
  }

  Future<void> _initializeVideo() async {
    try {
      // First try to get cached controller from cache service
      try {
        _controller = await _cacheService.getCachedVideoController(widget.videoPath, widget.postId);
        debugPrint("VideoPostWidget: Using cached video controller for post: ${widget.postId}");
        
        // Register with global video manager
        _globalVideoManager.registerVideoController(_videoId, _controller);
      } catch (e) {
        debugPrint("VideoPostWidget: Cache failed, trying global manager for $_videoId: $e");
        
        // Fallback to global manager
        final existingController = _globalVideoManager.getVideoController(_videoId);
        
        if (existingController != null && existingController.value.isInitialized) {
          // Reuse existing controller
          _controller = existingController;
          print('VideoPostWidget: Reusing existing video controller for $_videoId');
        } else {
          // Create new controller as last resort
          _controller = VideoPlayerController.networkUrl(
            Uri.parse(widget.videoPath),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          );

          await _controller.initialize();

          // Register with global video manager
          _globalVideoManager.registerVideoController(_videoId, _controller);
          print('VideoPostWidget: Created new video controller for $_videoId');
        }
      }

      // Only auto-play if the video is visible and autoPlay is true
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // Add listeners
        _controller.addListener(_onVideoPositionChanged);
        _controller.addListener(() {
          if (mounted) {
            setState(() {
              // Update UI when video finishes and loops
              if (_controller.value.position >= _controller.value.duration) {
                _controller.seekTo(Duration.zero);
              }
            });
          }
        });

        // Restore the saved position if there is one
        if (_lastPosition > 0 && !_isPositionRestored) {
          await _controller.seekTo(Duration(milliseconds: _lastPosition));
          _isPositionRestored = true;
        }

        // Start playing if visible and autoplay is enabled (only if not globally paused)
        if (_isVisible && widget.autoPlay && !_globalVideoManager.isGloballyPaused) {
          _globalVideoManager.playVideo(_videoId);
          _isPlaying = true;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  // Listen to position changes to update saved position
  void _onVideoPositionChanged() {
    if (!mounted || !_isInitialized) return;

    // Save position when video is playing
    if (_controller.value.isPlaying) {
      _savePosition();
    }
  }

  void _togglePlayPause() {
    if (!_isInitialized || _globalVideoManager.isGloballyPaused) return;

    setState(() {
      _isVideoTapped = true;
      _showControls = true; // Always show controls when toggling play/pause

      if (_isPlaying) {
        _pauseVideo();
      } else {
        _playVideo();
      }
    });

    // Auto-hide controls after 3 seconds if the video is playing
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }

    // Reset the tap flag after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVideoTapped = false;
        });
      }
    });
  }

  void _handleTap() {
    // In fullscreen mode, first tap toggles controls visibility, second tap toggles play/pause
    if (_isFullscreen) {
      final now = DateTime.now();
      if (_lastTapTime != null &&
          now.difference(_lastTapTime!).inMilliseconds < 300) {
        // Second tap within 300ms - toggle play/pause
        _togglePlayPause();
        _lastTapTime = null; // Reset tap timer
      } else {
        // First tap - toggle controls visibility
        setState(() {
          _showControls = !_showControls;
          _lastTapTime = now;
        });

        // Auto-hide controls after 3 seconds if video is playing
        if (_showControls && _isPlaying) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && _isPlaying && _showControls) {
              setState(() {
                _showControls = false;
              });
            }
          });
        }
      }
    } else {
      // In normal mode: always just toggle controls visibility on first tap
      // We'll use the actual play/pause buttons to control playback
      setState(() {
        _showControls = !_showControls;
      });

      // Auto-hide controls after 3 seconds if video is playing
      if (_showControls && _isPlaying) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isPlaying && _showControls) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }
    }

    // Only call the parent's onTap if not in fullscreen mode and the video was not tapped recently
    if (!_isFullscreen && !_isVideoTapped && widget.onTap != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onTap!();
      });
    }
  }

  // Toggle fullscreen mode
  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      _showControls = true; // Always show controls when toggling fullscreen
    });

    if (_isFullscreen) {
      // Set to landscape mode for fullscreen
      _orientationService.setLandscapeMode();

      // Hide system UI for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      // Auto-hide controls after 3 seconds if video is playing
      if (_isPlaying) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _isPlaying && _showControls) {
            setState(() {
              _showControls = false;
            });
          }
        });
      }

      // Call the fullscreen toggle callback if provided
      if (widget.onFullscreenToggle != null) {
        widget.onFullscreenToggle!();
      }
    } else {
      // When exiting fullscreen in a post detail page with video,
      // allow all orientations instead of forcing portrait
      if (widget.openVideoFrom == OpenVideoFrom.postDetail) {
        _orientationService.setAllOrientations();
      } else {
        // In other contexts (like posts), return to portrait
        _orientationService.setPortraitMode();
      }

      // Restore system UI when exiting fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Call the fullscreen exit callback if provided
      if (widget.onFullscreenExit != null) {
        widget.onFullscreenExit!();
      }
    }
  }

  @override
  void dispose() {
    // Save position when disposing
    if (_isInitialized && widget.rememberPosition) {
      _savePosition();
    }

    // Ensure video is paused before disposing to prevent audio overlap
    if (_isInitialized && _isPlaying) {
      _pauseVideo();
      debugPrint('VideoPostWidget: Paused video before disposal to prevent audio overlap');
    }

    // Unregister from global video manager
    _globalVideoManager.unregisterVideoController(_videoId);
    _globalVideoManager.removeListener(_onGlobalVideoStateChanged);

    try {
      _controller.removeListener(_onVideoPositionChanged);
      // Don't dispose cached controllers - let the cache service manage them
      // The cache service will handle disposal when needed
    } catch (e) {
      debugPrint('VideoPostWidget: Error during controller cleanup: $e');
    }
    
    _animationController.dispose();
    // Ensure we're not leaving in fullscreen or landscape mode
    if (_isFullscreen) {
      _orientationService.setPortraitMode();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.videoPath.hashCode}'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        // Consider video visible if at least 50% is in view (more aggressive pausing)
        final isVisible = visiblePercentage > 50;

        if (isVisible != _isVisible) {
          setState(() {
            _isVisible = isVisible;
          });

          // Auto-play when visible and pause when not visible
          if (_isInitialized && widget.autoPlay) {
            if (isVisible && !_globalVideoManager.isGloballyPaused) {
              _playVideo();
              debugPrint('VideoPostWidget: Playing video - visible: ${visiblePercentage.toStringAsFixed(1)}%');
            } else {
              // Save position before pausing
              _savePosition();
              _pauseVideo();
              debugPrint('VideoPostWidget: Pausing video - visible: ${visiblePercentage.toStringAsFixed(1)}%');
            }
          }
        }
      },
      child: GestureDetector(
        onDoubleTap: widget.onDoubleTap,
        onTap: _handleTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video or thumbnail with smooth fade transition
            _isInitialized
<<<<<<< HEAD
                ? VideoPlayer(_controller)
            // AspectRatio(
            //         aspectRatio: _isFullscreen
            //             ? _controller.value.aspectRatio
            //             : (widget.openVideoFrom == OpenVideoFrom.mainPage
            //                 ? _controller.value.aspectRatio
            //                 : 3.4),
            //         child: VideoPlayer(_controller),
            //       )
=======
                ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: FittedBox(
                      fit: BoxFit.contain, // Always use contain to prevent cutting/stretching
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
                : AnimatedOpacity(
                    opacity: _isInitialized ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: NetworkImageWidget(
                      imageUrl: widget.thumbnailPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                      placeholder: Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      errorWidget: Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

            // Loading indicator or error
            if (!_isInitialized && !_hasError)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: const CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),

            // Center play/pause control - only show when controls are visible
            if (_isInitialized && _showControls)
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _togglePlayPause,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),

            // Animation for play button when paused
            if (_isInitialized && !_isPlaying && !_showControls)
              AnimatedBuilder(
                animation: _playPauseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _playPauseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),

            // Message showing tap to reveal controls when video is playing and controls are hidden
            if (_isInitialized && _isPlaying && !_showControls)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: 0.0),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Tap to show controls',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),

            // Error message with animation
            if (_hasError)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            'Unable to load video',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _hasError = false;
                              });
                              _initializeVideo();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            // Video controls overlay at bottom with animation - only show when controls are visible
            if (_isInitialized && _showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _isVideoTapped ? 1.0 : 0.7,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black.withOpacity(0.6),
                    child: Row(
                      children: [
                        // Play/Pause icon in controls
                        IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _togglePlayPause,
                        ),

                        // Mute/Unmute button
                        IconButton(
                          icon: Icon(
                            _controller.value.volume > 0
                                ? Icons.volume_up
                                : Icons.volume_off,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.volume > 0) {
                                _controller.setVolume(0);
                              } else {
                                _controller.setVolume(1.0);
                              }
                            });
                          },
                        ),

                        // Progress indicator
                        Expanded(
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.white,
                              bufferedColor: Colors.white54,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                        ),

                        // Video duration
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Fullscreen toggle button - only show when controls are visible
            if (_isInitialized &&
                widget.allowFullscreenToggle &&
                _showControls &&
                widget.openVideoFrom == OpenVideoFrom.postDetail)
              Positioned(
                bottom: 60, // Position above the progress bar
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    _toggleFullscreen();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),

            // Tap instructions for fullscreen mode - show briefly when entering fullscreen
            if (_isFullscreen && _showControls)
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: 0.0),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Tap once to toggle controls, tap twice to play/pause',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Format duration to MM:SS
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
