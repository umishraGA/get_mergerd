import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/post_poll_models.dart';

/// Service to handle caching of post video media
class VideoPostCacheService {
  static final VideoPostCacheService _instance = VideoPostCacheService._internal();
  factory VideoPostCacheService() => _instance;
  VideoPostCacheService._internal();

  // Cache manager for video files
  static final CacheManager _videoCacheManager = CacheManager(
    Config(
      'post_video_cache',
      stalePeriod: const Duration(hours: 3), // Videos cached for 3 hours
      maxNrOfCacheObjects: 30, // Max 30 videos
    ),
  );

  // Cache for initialized video controllers
  final Map<String, VideoPlayerController> _videoControllerCache = {};
  final Map<String, bool> _loadingStates = {};

  /// Get cached video controller or create new one
  Future<VideoPlayerController> getCachedVideoController(String videoUrl, String postId) async {
    final cacheKey = '${postId}_$videoUrl';
    
    // Return existing controller if available and still valid
    if (_videoControllerCache.containsKey(cacheKey)) {
      final controller = _videoControllerCache[cacheKey]!;
      try {
        // Check if controller is disposed by trying to access its value
        final value = controller.value;
        if (value.isInitialized && !value.hasError) {
          debugPrint('VideoPostCacheService: Reusing cached video controller for $postId');
          return controller;
        } else {
          // Remove invalid controller
          _videoControllerCache.remove(cacheKey);
          if (!value.isInitialized || value.hasError) {
            controller.dispose();
          }
        }
      } catch (e) {
        // Controller was disposed, remove from cache
        debugPrint('VideoPostCacheService: Controller was disposed, removing from cache: $e');
        _videoControllerCache.remove(cacheKey);
      }
    }

    // Check if we're already loading this video
    if (_loadingStates[cacheKey] == true) {
      // Wait for the existing loading to complete
      while (_loadingStates[cacheKey] == true) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // Return the cached controller if it was created during the wait
      if (_videoControllerCache.containsKey(cacheKey)) {
        return _videoControllerCache[cacheKey]!;
      }
    }

    _loadingStates[cacheKey] = true;

    try {
      // Try to get cached file first
      final cachedFile = await _videoCacheManager.getSingleFile(videoUrl);
      
      // Create new controller with cached file
      final controller = VideoPlayerController.file(
        cachedFile,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
      
      // Cache the controller
      _videoControllerCache[cacheKey] = controller;
      
      debugPrint('VideoPostCacheService: Created and cached video controller for $postId');
      return controller;
    } catch (e) {
      debugPrint('VideoPostCacheService: Error creating video controller for $postId: $e');
      // Fallback to network URL
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
      _videoControllerCache[cacheKey] = controller;
      return controller;
    } finally {
      _loadingStates[cacheKey] = false;
    }
  }

  /// Check if post video is cached
  bool isPostVideoCached(String videoUrl, String postId) {
    final cacheKey = '${postId}_$videoUrl';
    return _videoControllerCache.containsKey(cacheKey);
  }

  /// Preload post videos for faster access
  Future<void> preloadPostVideos(List<PostPollItem> posts) async {
    for (final post in posts.take(3)) { // Preload first 3 post videos
      if (post.media?.isNotEmpty ?? false) {
        for (final media in post.media!) {
          if (media.type == 'video' && (media.url?.isNotEmpty ?? false)) {
            try {
              // Preload video file to cache (don't initialize controller yet)
              await _videoCacheManager.getSingleFile(media.url!);
              debugPrint('VideoPostCacheService: Preloaded video for post ${post.id ?? ''}');
            } catch (e) {
              debugPrint('VideoPostCacheService: Error preloading video for post ${post.id ?? ''}: $e');
            }
          }
        }
      }
    }
  }

  /// Remove cached controller for a specific post
  void removeCachedController(String postId, String videoUrl) {
    final cacheKey = '${postId}_$videoUrl';
    final controller = _videoControllerCache.remove(cacheKey);
    if (controller != null) {
      try {
        if (controller.value.isInitialized) {
          controller.dispose();
        }
      } catch (e) {
        // Controller already disposed, ignore
        debugPrint('VideoPostCacheService: Controller already disposed: $e');
      }
    }
    debugPrint('VideoPostCacheService: Removed cached controller for $postId');
  }

  /// Clear all cached controllers (call when posts are refreshed)
  void clearAllCachedControllers() {
    for (final controller in _videoControllerCache.values) {
      try {
        if (controller.value.isInitialized) {
          controller.dispose();
        }
      } catch (e) {
        // Controller already disposed, ignore
        debugPrint('VideoPostCacheService: Controller already disposed: $e');
      }
    }
    _videoControllerCache.clear();
    debugPrint('VideoPostCacheService: Cleared all cached video controllers');
  }

  /// Clean up expired or invalid controllers
  void cleanupCache() {
    final keysToRemove = <String>[];
    
    for (final entry in _videoControllerCache.entries) {
      try {
        final value = entry.value.value;
        if (value.hasError || !value.isInitialized) {
          entry.value.dispose();
          keysToRemove.add(entry.key);
        }
      } catch (e) {
        // Controller already disposed, mark for removal
        debugPrint('VideoPostCacheService: Controller already disposed during cleanup: $e');
        keysToRemove.add(entry.key);
      }
    }
    
    for (final key in keysToRemove) {
      _videoControllerCache.remove(key);
    }
    
    debugPrint('VideoPostCacheService: Cleaned up ${keysToRemove.length} invalid controllers');
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'cachedVideos': _videoControllerCache.length,
    };
  }
}