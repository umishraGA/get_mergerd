import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _initialized = false;
  final AudioPlayer _likePlayer = AudioPlayer();

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _likePlayer.setAsset('assets/audio/quiz/like button audio.mp3');
      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing audio service: $e');
    }
  }

  Future<void> playLikeSound() async {
    try {
      await _likePlayer.seek(Duration.zero);
      await _likePlayer.play();
    } catch (e) {
      debugPrint('Error playing like sound: $e');
    }
  }

  void dispose() {
    _likePlayer.dispose();
  }
}
