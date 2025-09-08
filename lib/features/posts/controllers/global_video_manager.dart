import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Global singleton to manage all video players in the app
class GlobalVideoManager extends ChangeNotifier {
  static final GlobalVideoManager _instance = GlobalVideoManager._internal();
  factory GlobalVideoManager() => _instance;
  GlobalVideoManager._internal();

  // Map to track all video controllers by their unique ID
  final Map<String, VideoPlayerController> _videoControllers = {};
  
  // Currently playing video ID
  String? _currentlyPlayingVideoId;
  
  // Global pause state (for when stories are opened)
  bool _isGloballyPaused = false;

  /// Register a video controller with a unique ID
  void registerVideoController(String videoId, VideoPlayerController controller) {
    _videoControllers[videoId] = controller;
    debugPrint('GlobalVideoManager: Registered video controller for $videoId');
  }

  /// Unregister a video controller
  void unregisterVideoController(String videoId) {
    _videoControllers.remove(videoId);
    if (_currentlyPlayingVideoId == videoId) {
      _currentlyPlayingVideoId = null;
    }
    debugPrint('GlobalVideoManager: Unregistered video controller for $videoId');
  }

  /// Start playing a specific video (pause all others)
  void playVideo(String videoId) {
    if (_isGloballyPaused) return;
    
    // Pause all other videos
    pauseAllVideos();
    
    // Play the requested video
    final controller = _videoControllers[videoId];
    if (controller != null && controller.value.isInitialized) {
      controller.play();
      _currentlyPlayingVideoId = videoId;
      debugPrint('GlobalVideoManager: Playing video $videoId');
    }
  }

  /// Pause a specific video
  void pauseVideo(String videoId) {
    final controller = _videoControllers[videoId];
    if (controller != null && controller.value.isInitialized) {
      controller.pause();
      if (_currentlyPlayingVideoId == videoId) {
        _currentlyPlayingVideoId = null;
      }
      debugPrint('GlobalVideoManager: Paused video $videoId');
    }
  }

  /// Pause all videos in the app
  void pauseAllVideos() {
    final keysToRemove = <String>[];
    
    for (final entry in _videoControllers.entries) {
      final controller = entry.value;
      try {
        if (controller.value.isInitialized && controller.value.isPlaying) {
          controller.pause();
          debugPrint('GlobalVideoManager: Paused video ${entry.key}');
        }
      } catch (e) {
        debugPrint('GlobalVideoManager: Error pausing video ${entry.key}: $e');
        // Mark disposed controllers for removal
        keysToRemove.add(entry.key);
      }
    }
    
    // Remove disposed controllers after iteration
    for (final key in keysToRemove) {
      _videoControllers.remove(key);
    }
    
    _currentlyPlayingVideoId = null;
  }

  /// Globally pause all videos (used when stories are opened)
  void setGlobalPause(bool isPaused) {
    _isGloballyPaused = isPaused;
    if (_isGloballyPaused) {
      pauseAllVideos();
      debugPrint('GlobalVideoManager: Global pause enabled - all videos paused');
    } else {
      debugPrint('GlobalVideoManager: Global pause disabled - videos can play');
    }
    notifyListeners();
  }

  /// Check if a video is currently playing
  bool isVideoPlaying(String videoId) {
    return _currentlyPlayingVideoId == videoId;
  }

  /// Get the currently playing video ID
  String? get currentlyPlayingVideoId => _currentlyPlayingVideoId;
  
  /// Check if globally paused
  bool get isGloballyPaused => _isGloballyPaused;

  /// Get existing video controller if it exists
  VideoPlayerController? getVideoController(String videoId) {
    return _videoControllers[videoId];
  }
}