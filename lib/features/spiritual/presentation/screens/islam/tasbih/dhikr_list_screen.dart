import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../Islam_controller/tasbih_dhikr_controller.dart';

class DhikrListScreen extends StatefulWidget {
  const DhikrListScreen({super.key});

  @override
  State<DhikrListScreen> createState() => _DhikrListScreenState();
}

class _DhikrListScreenState extends State<DhikrListScreen> {
  final TasbihController controller = Get.put(TasbihController());
  final AudioPlayer _audioPlayer = AudioPlayer();
  final RxInt _currentlyPlayingIndex = (-1).obs;
  final RxBool _isPlaying = false.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchTasbihList();

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _currentlyPlayingIndex.value = -1;
        _isPlaying.value = false;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause(int index, String audioUrl) async {
    try {
      if (_currentlyPlayingIndex.value == index) {
        // Toggle play/pause for current item
        if (_isPlaying.value) {
          await _audioPlayer.pause();
          _isPlaying.value = false;
        } else {
          await _audioPlayer.play();
          _isPlaying.value = true;
        }
      } else {
        // New item selected - stop current and play new
        await _audioPlayer.stop();
        await _audioPlayer.setUrl(audioUrl);
        await _audioPlayer.play();

        // Update states
        _currentlyPlayingIndex.value = index;
        _isPlaying.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not play audio');
      _currentlyPlayingIndex.value = -1;
      _isPlaying.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dhikr',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.green,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tasbihList.isEmpty) {
          return const Center(child: Text("No dhikr found"));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.tasbihList.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final dhikr = controller.tasbihList[index];
                  return Obx(() {
                    // Determine if this item is the currently playing one
                    final bool isCurrentItem = _currentlyPlayingIndex.value == index;
                    // Determine if audio is playing (only if it's the current item)
                    final bool isPlaying = isCurrentItem && _isPlaying.value;

                    return InkWell(
                      onTap: (){},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: Colors.green,
                                    size: 28,
                                  ),
                                  onPressed: () => _togglePlayPause(index, dhikr.audioUrl),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        dhikr.dikhrNameArabic,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 22,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dhikr.dikhrNameEnglish,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        dhikr.dikhrMeaning,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.info_outline,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _showDhikrInfo(context, dhikr);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: Alignment.centerLeft,
              child: Text(
                "Total: ${controller.tasbihList.length}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showDhikrInfo(BuildContext context, dynamic dhikr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              dhikr.dikhrNameArabic.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 28,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              dhikr.dikhrNameEnglish.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dhikr.dikhrMeaning.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Benefits:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reciting this dhikr helps bring you closer to Allah and increases your spiritual well-being.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}