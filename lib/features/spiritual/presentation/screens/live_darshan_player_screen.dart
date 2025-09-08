import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/spiritual/presentation/widgets/DarshanCard.dart';
import 'package:myapp/features/utsav/widgets/AppHeader.dart';
import '../controller/live_darshan_detail_controller.dart';
import 'package:video_player/video_player.dart';

class LiveDarshanPlayerScreen extends StatefulWidget {
  final String id;

  const LiveDarshanPlayerScreen({super.key, required this.id});

  @override
  State<LiveDarshanPlayerScreen> createState() =>
      _LiveDarshanPlayerScreenState();
}

class _LiveDarshanPlayerScreenState extends State<LiveDarshanPlayerScreen> {
  final DetailLiveDarshanController controller =
  Get.put(DetailLiveDarshanController());

  VideoPlayerController? _videoController;
  bool _hasError = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller.fetchLiveDarshan(widget.id).then((_) {
      if (mounted && controller.data.isNotEmpty) {
        _initializeVideoPlayer();
      }
    });
  }

  String get _videoUrl => controller.data['embeddedLink']?.toString() ?? '';

  void _initializeVideoPlayer() {
    try {
      if (_videoUrl.isEmpty) throw Exception("Invalid video URL");

      _videoController = VideoPlayerController.networkUrl(Uri.parse(_videoUrl))
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
          _isPlaying = true;
        }).catchError((_) {
          setState(() {
            _hasError = true;
          });
        });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
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

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text("No live video available"),
        ),
      );
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_videoController!),
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 60,
                  color: Colors.white,
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
            _buildVideoPlayer(),
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
                                    builder: (context) =>
                                        LiveDarshanPlayerScreen(
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
