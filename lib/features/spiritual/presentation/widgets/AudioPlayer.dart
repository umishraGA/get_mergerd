import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../controller/Hinduism_controller.dart';
import '../controller/chnatcount_conutroller.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final HinduismController hinduismController = Get.put(HinduismController());
  final ChantCountController chantCountController = Get.put(ChantCountController());

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _selectedTab = 0;
  bool _isLoadingAudio = false;
  int _playCount = 0; // Track number of completions

  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) async {
      // Handle audio completion
      if (state.processingState == ProcessingState.completed) {
        _playCount++;
        debugPrint('Audio completed. Count: $_playCount');

        // Update chant count on every completion
         await _updateChantCount();

        // Automatically restart if still in playing state
        if (_isPlaying) {
          await _audioPlayer.seek(Duration.zero);
          await _audioPlayer.play();
        } else {
          setState(() {
            _isPlaying = false;
          });
        }
      }

      // Update playing state
      if (state.playing && !_isPlaying) {
        setState(() {
          _isPlaying = true;
          _isLoadingAudio = false;
        });
      }
    });
  }

  Future<void> _updateChantCount() async {
    try {
      debugPrint('Updating chant count for tab_${_selectedTab + 1}');
      await chantCountController.updateChantCount(
        religion: "hinduism",
        chant_tab: "tab_${_selectedTab + 1}",
      );
      // hinduismController.fetchSpiritualData();
    } catch (e) {
      debugPrint('Error updating chant count: $e');
    }
  }

  Future<void> _initAndPlayAudio() async {
    if (_isLoadingAudio) return;

    setState(() {
      _isLoadingAudio = true;
      _playCount = 0; // Reset play counter when starting new audio
    });

    try {
      final chantKeys = hinduismController.chants.keys.toList();
      if (_selectedTab >= chantKeys.length) return;

      final selectedChantKey = chantKeys[_selectedTab];
      final chantData = hinduismController.chants[selectedChantKey];

      String audioUrl = '';
      if (chantData is Map && chantData['audio'] != null) {
        audioUrl = chantData['audio'].toString();
      }

      if (audioUrl.isEmpty) {
        debugPrint('No audio URL found for selected chant');
        return;
      }

      await _audioPlayer.stop();
      await _audioPlayer.setLoopMode(LoopMode.off); // We'll handle looping manually

      if (audioUrl.startsWith('http')) {
        await _audioPlayer.setUrl(audioUrl);
      } else {
        await _audioPlayer.setAsset(audioUrl);
      }

      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      setState(() {
        _isPlaying = false;
        _isLoadingAudio = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _stopAudio();
    } else {
      await _initAndPlayAudio();
    }
  }

  void _changeTab(int newTab) async {
    if (_selectedTab == newTab) return;

    if (_isPlaying) {
      await _stopAudio();
    }

    setState(() {
      _selectedTab = newTab;
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      height: isTablet ? 320 : 220,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Obx(() {
                String imageUrl = 'assets/images/spiritual/hanuman.png';
                try {
                  if (hinduismController.chants.isNotEmpty) {
                    final chantKeys = hinduismController.chants.keys.toList();
                    if (_selectedTab < chantKeys.length) {
                      final selectedChantKey = chantKeys[_selectedTab];
                      final chantData = hinduismController.chants[selectedChantKey];
                      if (chantData is Map &&
                          chantData['image'] is Map &&
                          chantData['image']['mobile_image'] is String &&
                          (chantData['image']['mobile_image'] as String).isNotEmpty) {
                        imageUrl = chantData['image']['mobile_image'].toString();
                      }
                    }
                  }
                } catch (e) {
                  debugPrint('Error getting image URL: $e');
                }

                if (imageUrl.startsWith('http')) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/spiritual/hanuman.png',
                        fit: BoxFit.cover,
                      );
                    },
                  );
                } else {
                  return Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                }
              }),
            ),
          ),

          // Counter section
          Positioned(
            right: isTablet ? 100 : 12,
            bottom: isTablet ? 100 : 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Number counter with reset button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      final chantKeys = hinduismController.chants.keys.toList();
                      String count = '0';
                      if (_selectedTab < chantKeys.length) {
                        final selectedChantKey = chantKeys[_selectedTab];
                        final chantData = hinduismController.chants[selectedChantKey];
                        if (chantData is Map && chantData['chant_count'] != null) {
                          count = chantData['chant_count'].toString();
                        }
                      }
                      return Text(
                        count,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'FacebookSans',
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _updateChantCount,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.refresh,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),

                // Label text
                Text(
                  _selectedTab == 0 ? 'Todays Chants' : 'Todays Chalisa',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'FacebookSans',
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Start/Stop button
                GestureDetector(
                  onTap: _isLoadingAudio ? null : _togglePlayback,
                  child: Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isLoadingAudio ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoadingAudio
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(
                        _isPlaying ? 'Stop' : 'Start',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'FacebookSans',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab selector
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Obx(() {
              if (hinduismController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (hinduismController.chants.isEmpty) {
                return const Center(child: Text("Tabs not available"));
              }

              final chantKeys = hinduismController.chants.keys.toList();

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Row(
                    children: [
                      for (int index = 0; index < chantKeys.length; index++)
                        (() {
                          final chantKey = chantKeys[index];
                          final chant = hinduismController.chants[chantKey];

                          String chantName = 'Chant ${index + 1}';
                          try {
                            if (chant is Map && chant['title'] != null) {
                              chantName = chant['title'].toString();
                            }
                          } catch (e) {
                            debugPrint('Error getting chant name: $e');
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _changeTab(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedTab == index
                                      ? Colors.red
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Center(
                                  child: Text(
                                    chantName,
                                    style: TextStyle(
                                      color: _selectedTab == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                      fontWeight: _selectedTab == index
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      fontFamily: 'FacebookSans',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        })(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}