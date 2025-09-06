import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../Islam_controller/quran_chapter_detail_controller.dart';


class QuranVersesPage extends StatefulWidget {
  final String chapterId;

  const QuranVersesPage({super.key, required this.chapterId});

  @override
  State<QuranVersesPage> createState() => _QuranVersesPageState();
}

class _QuranVersesPageState extends State<QuranVersesPage> {
  final QuranVerseController controller = QuranVerseController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentAudioUrl;

  @override
  void initState() {
    super.initState();
    controller.fetchVersesByChapter(widget.chapterId);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleAudioPlay(String url) async {
    if (_currentAudioUrl == url && _audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      _currentAudioUrl = url;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Verses'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.verses.isEmpty) {
          return const Center(child: Text("No verses found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.verses.length,
          itemBuilder: (context, index) {
            final verse = controller.verses[index];
            final isPlaying = _currentAudioUrl == verse.audioUrl && _audioPlayer.playing;

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Verse ${verse.sortingNo}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      verse.arabicVerse,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(verse.englishVerse),
                    const SizedBox(height: 8),
                    Text(
                      "Meaning: ${verse.verseMeaning}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Duration: ${verse.duration}"),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                            color: Colors.green,
                            size: 32,
                          ),
                          onPressed: () => _handleAudioPlay(verse.audioUrl),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
