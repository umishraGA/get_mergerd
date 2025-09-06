import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../Islam_controller/mackkalive_controller.dart';

class MakkahLiveScreen extends StatefulWidget {
  MakkahLiveScreen({super.key});

  @override
  State<MakkahLiveScreen> createState() => _MakkahLiveScreenState();
}

class _MakkahLiveScreenState extends State<MakkahLiveScreen> {
  final MakkaLiveController controller = Get.put(MakkaLiveController());

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
      body: FutureBuilder(
        future: controller.fetchMakkaLiveUrl(),
        builder: (context, snapshot) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final url = controller.videoUrl.value;

            if (url.isEmpty) {
              return const Center(child: Text("No video available"));
            }

            final videoId = YoutubePlayer.convertUrlToId(url);

            if (videoId == null) {
              return const Center(child: Text("Invalid YouTube URL"));
            }

            final YoutubePlayerController _ytController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
                controlsVisibleAtStart: true,
              ),
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // YouTube Player Card
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
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _ytController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                      ),
                      builder: (context, player) {
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: player,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LIVE Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.red, size: 10),
                        const SizedBox(width: 6),
                        const Text(
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
          });
        },
      ),
    );
  }
}
