import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/screens/live_darshan_fullscreen_player.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controller/live_darshan_detail_controller.dart';

class LiveDarshanPlayerScreen extends StatefulWidget {
  final String id;

  const LiveDarshanPlayerScreen({
    super.key,
    required this.id,
  });

  @override
  State<LiveDarshanPlayerScreen> createState() => _LiveDarshanPlayerScreenState();
}

class _LiveDarshanPlayerScreenState extends State<LiveDarshanPlayerScreen>
    with SingleTickerProviderStateMixin {
  final DetailLiveDarshanController controller = Get.put(DetailLiveDarshanController());
  YoutubePlayerController? _youtubeController;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isVideoTapped = false;
  late AnimationController _animationController;
  late Animation<double> _playPauseAnimation;

  @override
  void initState() {
    super.initState();
    controller.fetchLiveDarshan(widget.id).then((_) {
      if (mounted && controller.data.isNotEmpty) {
        _initializeYoutubePlayer();
      }
    });

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

  String get _videoUrl => controller.data['embeddedLink']?.toString() ?? '';

  void _initializeYoutubePlayer() {
    try {
      final videoId = YoutubePlayer.convertUrlToId(_videoUrl);
      if (videoId == null || videoId.isEmpty) {
        throw Exception('Invalid YouTube URL');
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      )..addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _youtubeController?.value.isPlaying ?? false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (_youtubeController == null) return;

    setState(() {
      _isVideoTapped = true;
      if (_youtubeController!.value.isPlaying) {
        _youtubeController!.pause();
        _animationController.forward();
      } else {
        _youtubeController!.play();
        _animationController.reverse();
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
    if (_videoUrl.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveDarshanFullscreenPlayer(
          videoUrl: _videoUrl,
          onBack: () => Navigator.of(context).pop(),
          thumbnailUrl: controller.data['thumbnail']?.toString() ?? '',
          title: controller.data['title']?.toString() ?? '',
          temple: controller.data['temple']?['name']?.toString() ?? '',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDate(dynamic dateInput) {
    try {
      DateTime date;

      if (dateInput is String) {
        date = DateTime.parse(dateInput);
      } else if (dateInput is int) {
        date = DateTime.fromMillisecondsSinceEpoch(dateInput);
      } else if (dateInput is DateTime) {
        date = dateInput;
      } else {
        return '';
      }

      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  Widget _buildYoutubePlayer() {
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 200,
          width:double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 8),
              const Text('No live video'),
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                  });
                  _initializeYoutubePlayer();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_youtubeController == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.white,
              progressColors: const ProgressBarColors(
                playedColor: Colors.white,
                handleColor: Colors.white,
                bufferedColor: Colors.white54,
                backgroundColor: Colors.white24,
              ),
              onReady: () {
                setState(() {
                  _isPlaying = true;
                });
              },
              onEnded: (error) {
                setState(() {
                  _hasError = true;
                });
              },
            ),

            if (!_isPlaying || _isVideoTapped)
              AnimatedBuilder(
                animation: _playPauseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _playPauseAnimation.value,
                    child: GestureDetector(
                      onTap: _togglePlayPause,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                },
              ),

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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.data.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        return Column(
          children: [
            const AppHeader(title: 'Live Darshan'),
            _buildYoutubePlayer(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          Text(
                            'Live ${_formatDate(controller.data['createdAt'])}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.data['title']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.data['temple']?['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF909090),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
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
                          const Icon(
                            Icons.share,
                            color: Colors.grey,
                            size: 24,
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
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.relatedDarshans.length,
                        separatorBuilder: (context, index) => const Divider(
                          color: Color(0xFFEEEEEE),
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          final item = controller.relatedDarshans[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 12),
                            child: DarshanCard(
                              image: item['mobile_image']?.toString() ?? '',
                              title: item['title']?.toString() ?? '',
                              temple: item['temple']?["name"].toString() ?? '',
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LiveDarshanPlayerScreen(
                                      id: item['_id']?.toString() ?? '',
                                    ),
                                  ),
                                );
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
        );
      }),
    );
  }
}