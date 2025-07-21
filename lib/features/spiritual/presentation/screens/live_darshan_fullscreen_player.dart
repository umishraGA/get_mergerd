import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/core/services/orientation_service.dart';
import 'package:myapp/features/mainPage/data/open_video_from.dart';
import 'package:myapp/features/mainPage/widgets/VideoPostWidget.dart';

class LiveDarshanFullscreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  final String title;
  final String temple;
  final VoidCallback? onBack;

  const LiveDarshanFullscreenPlayer({
    super.key,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.title,
    required this.temple,
    this.onBack,
  });

  @override
  State<LiveDarshanFullscreenPlayer> createState() =>
      _LiveDarshanFullscreenPlayerState();
}

class _LiveDarshanFullscreenPlayerState
    extends State<LiveDarshanFullscreenPlayer> {
  final OrientationService _orientationService = OrientationService();
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _setupFullscreenMode();
  }

  void _setupFullscreenMode() async {
    // Force landscape orientation
    await _orientationService.setLandscapeMode();

    // Hide system UI for immersive experience
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Set system UI overlay style for dark theme
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _handleExitFullscreen() {
    if (_isExiting) return;

    setState(() {
      _isExiting = true;
    });

    // Restore portrait orientation
    _orientationService.setPortraitMode();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Exit the screen
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Make sure we're back to portrait mode
    _orientationService.setPortraitMode();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _handleExitFullscreen();
        return false; // We handle the back navigation ourselves
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video Player
              Center(
                child: VideoPostWidget(
                  videoPath: widget.videoUrl,
                  thumbnailPath: widget.thumbnailUrl,
                  onDoubleTap:
                      () {}, // Disable double tap to focus on video controls
                  autoPlay: true,
                  openVideoFrom: OpenVideoFrom.fullscreen,
                  allowFullscreenToggle: true,
                  rememberPosition: true,
                ),
              ),

              // Top overlay with live indicator and title
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title section
                      Expanded(
                        child: Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: _handleExitFullscreen,
                            ),
                            const SizedBox(width: 12),

                            // Title and temple
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.temple,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Live badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Exit fullscreen button
              Positioned(
                bottom: 80,
                right: 16,
                child: GestureDetector(
                  onTap: _handleExitFullscreen,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.fullscreen_exit,
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
    );
  }
}
