import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MakkahLiveScreen extends StatefulWidget {
  const MakkahLiveScreen({super.key});

  @override
  State<MakkahLiveScreen> createState() => _MakkahLiveScreenState();
}

class _MakkahLiveScreenState extends State<MakkahLiveScreen>
    with SingleTickerProviderStateMixin {
  final String currentDate = DateTime.now().toString().split(' ')[0];
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isVideoTapped = false;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _playPauseAnimation;

  // Sample video URL (replace with actual Makkah live stream URL in production)
  String get _videoUrl =>
      'https://www.shutterstock.com/shutterstock/videos/1101002587/preview/stock-footage-varanasi-india-jan-ganga-aarti-ceremony-rituals-performed-by-hindu-priests-at-dashashwamedh.webm';

  final List<Map<String, String>> _otherLiveStreams = [
    {
      'title': 'Masjid al-Haram - Inside View',
      'location': 'Makkah, Saudi Arabia',
    },
    {
      'title': 'Masjid an-Nabawi',
      'location': 'Madinah, Saudi Arabia',
    },
    {
      'title': 'Kaaba Tawaf',
      'location': 'Makkah, Saudi Arabia',
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

          // Loop the video
          _controller.setLooping(true);
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

  void _openFullscreen() {
    // Could implement fullscreen functionality similar to LiveDarshanFullscreenPlayer
    // For now, we'll just toggle a dialog indicating this feature
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fullscreen'),
        content: const Text('Fullscreen view would open here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Makkah Live',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Video player
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video or placeholder
                    _isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),

                    // Play/Pause button overlay with animation
                    AnimatedBuilder(
                      animation: _playPauseAnimation,
                      builder: (context, child) {
                        return _isInitialized && (!_isPlaying || _isVideoTapped)
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
                          onTap: _openFullscreen,
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

          // Bottom panel
          Container(
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Live indicator and date
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Live indicator
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Date
                      Text(
                        'Live • $currentDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Title and description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kaaba Live Stream',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Masjid al-Haram, Makkah, Saudi Arabia',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Actions bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Donate button
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/spiritual/islam/donation');
                        },
                        icon: const Icon(
                          Icons.favorite,
                          size: 18,
                        ),
                        label: const Text('Donate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Share button
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Other live streams
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Other Live Streams',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        _otherLiveStreams.length,
                        (index) => _buildLiveStreamItem(
                          _otherLiveStreams[index]['title']!,
                          _otherLiveStreams[index]['location']!,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStreamItem(String title, String location) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Thumbnail with play icon
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/black_image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
