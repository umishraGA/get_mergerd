import 'package:flutter/material.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_fullscreen_player.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:video_player/video_player.dart';

class LiveDarshanPlayerScreen extends StatefulWidget {
  final String image;
  final String title;
  final String temple;

  const LiveDarshanPlayerScreen({
    super.key,
    required this.image,
    required this.title,
    required this.temple,
  });

  @override
  State<LiveDarshanPlayerScreen> createState() =>
      _LiveDarshanPlayerScreenState();
}

class _LiveDarshanPlayerScreenState extends State<LiveDarshanPlayerScreen>
    with SingleTickerProviderStateMixin {
  final String currentDate = '10-Mar-2025';
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isVideoTapped = false;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _playPauseAnimation;

  // Add a getter for the video URL
  String get _videoUrl =>
      'https://www.shutterstock.com/shutterstock/videos/1101002587/preview/stock-footage-varanasi-india-jan-ganga-aarti-ceremony-rituals-performed-by-hindu-priests-at-dashashwamedh.webm';

  final List<Map<String, String>> _darshanList = [
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Morning Aarti',
      'temple': 'Sai Baba Temple',
    },
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Evening Aarti',
      'temple': 'Iskon Temple',
    },
    {
      'image': 'assets/images/spiritual/darshan.png',
      'title': 'Noon Aarti',
      'temple': 'Shiva Temple',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideo();

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
  }

  Future<void> _initializeVideo() async {
    try {
      // Replace this URL with your actual live stream URL
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(_videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _controller.play();
          _isPlaying = true;
        });

        _controller.addListener(() {
          if (mounted) {
            setState(() {
              if (_controller.value.position >= _controller.value.duration) {
                _controller.seekTo(Duration.zero);
              }
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (!_isInitialized) return;

    setState(() {
      _isPlaying = !_isPlaying;
      _isVideoTapped = true;
      if (_isPlaying) {
        _controller.play();
        _animationController.reverse();
      } else {
        _controller.pause();
        _animationController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVideoTapped = false;
        });
      }
    });
  }

  void _openFullscreenPlayer() {
    // Pause current video
    if (_isInitialized && _isPlaying) {
      _controller.pause();
    }

    // Navigate to fullscreen player
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveDarshanFullscreenPlayer(
          videoUrl: _videoUrl,
          thumbnailUrl: widget.image,
          title: widget.title,
          temple: widget.temple,
          onBack: () {
            Navigator.of(context).pop();
            // Resume playback when returning from fullscreen
            if (_isInitialized && _isPlaying) {
              _controller.play();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Format duration to MM:SS
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _selectDarshan(Map<String, String> darshan) {
    // Replace the current view with the selected darshan
    setState(() {
      // Update the current player with selected darshan data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(
            title: 'Live Darshan',
          ),
          // Fixed video player section
          Stack(
            children: [
              // Video player
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Video or thumbnail
                        _isInitialized
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayer(_controller),
                              )
                            : Image.asset(
                                "assets/images/black_image.png",
                                width: double.infinity,
                                height: 400,
                                fit: BoxFit.cover,
                              ),

                        // Loading indicator or error
                        if (!_isInitialized && !_hasError)
                          const CircularProgressIndicator(color: Colors.white),

                        // Play/Pause button overlay with animation
                        AnimatedBuilder(
                          animation: _playPauseAnimation,
                          builder: (context, child) {
                            return _isInitialized &&
                                    (!_isPlaying || _isVideoTapped)
                                ? Transform.scale(
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
                                  )
                                : const SizedBox.shrink();
                          },
                        ),

                        // Error message
                        if (_hasError)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 40,
                              ),
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

                        // Video controls at bottom
                        if (_isInitialized)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              color: Colors.black.withOpacity(0.6),
                              child: Row(
                                children: [
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
                                  // Duration
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
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

                        // Fullscreen button
                        if (_isInitialized)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _openFullscreenPlayer,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content section with scrollable bottom part
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Live indicator and date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Live indicator
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Live',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // Date
                        Text(
                          'Live $currentDate',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Title and temple
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      widget.temple,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF909090),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Donate and share buttons
                    Row(
                      children: [
                        // Donate button
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/donation.png',
                            width: 24,
                            height: 24,
                          ),
                          label: const Text('Donate Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF2D1),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Share button
                        Container(
                          child: const Icon(
                            Icons.share,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const CommonDivider(),
                    const SizedBox(height: 16),

                    const Text(
                      'More Live Darshans',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ListView for darshans
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _darshanList.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFFEEEEEE),
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final darshan = _darshanList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 12),
                          child: DarshanCard(
                            image: darshan['image'] ?? '',
                            title: darshan['title'] ?? '',
                            temple: darshan['temple'] ?? '',
                            onTap: () {
                              setState(() {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LiveDarshanPlayerScreen(
                                      image: darshan['image'] ?? '',
                                      title: darshan['title'] ?? '',
                                      temple: darshan['temple'] ?? '',
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
