import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../Islam_controller/mackkalive_controller.dart';

class MakkahLiveScreen extends StatefulWidget {
  const MakkahLiveScreen({super.key});

  @override
  State<MakkahLiveScreen> createState() => _MakkahLiveScreenState();
}

class _MakkahLiveScreenState extends State<MakkahLiveScreen> {
  final MakkaLiveController controller = Get.put(MakkaLiveController());
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    await controller.fetchMakkaLiveUrl();
    if (controller.videoUrl.value.isNotEmpty) {
      try {
        _videoController =
        VideoPlayerController.networkUrl(Uri.parse(controller.videoUrl.value))
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

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return const Center(
        child: Text("Error loading video"),
      );
    }

    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_videoController!),
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateTime.now().toString().split(' ')[0];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Makkah Live',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.videoUrl.value.isEmpty) {
          return const Center(child: Text("No video available"));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Video Player Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildVideoPlayer(),
              ),
            ),

            const SizedBox(height: 20),

            // LIVE Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.red, size: 10),
                    SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Live • $currentDate',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Watch Makkah Live - Holy Kaaba 24/7',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5364),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Experience the live stream of the holiest site in Islam. Join millions around the world in spiritual connection.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/spiritual/islam/donation');
              },
              icon: const Icon(Icons.favorite),
              label: const Text('Donate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
