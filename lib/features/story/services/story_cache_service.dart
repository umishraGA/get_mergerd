import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/story_response_models.dart';

/// Service to handle caching of story media (videos and images)
class StoryCacheService {
  static final StoryCacheService _instance = StoryCacheService._internal();
  factory StoryCacheService() => _instance;
  StoryCacheService._internal();

  // Cache managers for different media types
  static final CacheManager _videoCacheManager = CacheManager(
    Config(
      'story_video_cache',
      stalePeriod: const Duration(hours: 2), // Videos cached for 2 hours
      maxNrOfCacheObjects: 50, // Max 50 videos
    ),
  );

  static final CacheManager _imageCacheManager = CacheManager(
    Config(
      'story_image_cache', 
      stalePeriod: const Duration(hours: 4), // Images cached for 4 hours
      maxNrOfCacheObjects: 100, // Max 100 images
    ),
  );

  // Cache for initialized video controllers
  final Map<String, VideoPlayerController> _videoControllerCache = {};
  final Map<String, File> _cachedImageFiles = {};
  final Map<String, bool> _loadingStates = {};

  /// Get cached video controller or create new one
  Future<VideoPlayerController> getCachedVideoController(String videoUrl, String storyId) async {
    final cacheKey = '${storyId}_$videoUrl';
    
    // Return existing controller if available and still valid
    if (_videoControllerCache.containsKey(cacheKey)) {
      final controller = _videoControllerCache[cacheKey]!;
      try {
        // Check if controller is disposed by trying to access its value
        final value = controller.value;
        if (value.isInitialized && !value.hasError) {
          debugPrint('StoryCacheService: Reusing cached video controller for $storyId');
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
        debugPrint('StoryCacheService: Controller was disposed, removing from cache: $e');
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
      // Try to get cached file
      final cachedFile = await _videoCacheManager.getSingleFile(videoUrl);
      
      // Create new controller with cached file
      final controller = VideoPlayerController.file(cachedFile);
      await controller.initialize();
      
      // Cache the controller
      _videoControllerCache[cacheKey] = controller;
      
      debugPrint('StoryCacheService: Created and cached video controller for $storyId');
      return controller;
    } catch (e) {
      debugPrint('StoryCacheService: Error creating video controller for $storyId: $e');
      // Fallback to network URL
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await controller.initialize();
      _videoControllerCache[cacheKey] = controller;
      return controller;
    } finally {
      _loadingStates[cacheKey] = false;
    }
  }

  /// Get cached image file
  Future<File> getCachedImageFile(String imageUrl, String storyId) async {
    final cacheKey = '${storyId}_$imageUrl';
    
    // Return existing cached file if available
    if (_cachedImageFiles.containsKey(cacheKey)) {
      final cachedFile = _cachedImageFiles[cacheKey]!;
      if (await cachedFile.exists()) {
        debugPrint('StoryCacheService: Using cached image file for $storyId');
        return cachedFile;
      } else {
        _cachedImageFiles.remove(cacheKey);
      }
    }

    try {
      // Get file from cache manager
      final cachedFile = await _imageCacheManager.getSingleFile(imageUrl);
      _cachedImageFiles[cacheKey] = cachedFile;
      
      debugPrint('StoryCacheService: Cached image file for $storyId');
      return cachedFile;
    } catch (e) {
      debugPrint('StoryCacheService: Error caching image for $storyId: $e');
      rethrow;
    }
  }

  /// Check if story media is cached
  bool isStoryMediaCached(StoryItem story) {
    if (story.media?.isEmpty ?? true) return true; // No media to cache
    
    final firstMedia = story.media!.first;
    final mediaUrl = firstMedia.url;
    if (mediaUrl?.isEmpty ?? true) return true;
    
    final cacheKey = '${story.id ?? ''}_$mediaUrl';
    
    if (firstMedia.type == 'video') {
      return _videoControllerCache.containsKey(cacheKey);
    } else {
      return _cachedImageFiles.containsKey(cacheKey);
    }
  }

  /// Preload story media for faster access
  Future<void> preloadStoryMedia(List<StoryItem> stories) async {
    for (final story in stories.take(5)) { // Preload first 5 stories
      if (story.media?.isNotEmpty ?? false) {
        final firstMedia = story.media!.first;
        final mediaUrl = firstMedia.url;
        
        if (mediaUrl?.isNotEmpty ?? false) {
          try {
            if (firstMedia.type == 'video') {
              // Preload video file to cache (don't initialize controller yet)
              await _videoCacheManager.getSingleFile(mediaUrl!);
              debugPrint('StoryCacheService: Preloaded video for story ${story.id ?? ''}');
            } else {
              // Preload image file
              await getCachedImageFile(mediaUrl!, story.id ?? '');
              debugPrint('StoryCacheService: Preloaded image for story ${story.id ?? ''}');
            }
          } catch (e) {
            debugPrint('StoryCacheService: Error preloading media for story ${story.id ?? ''}: $e');
          }
        }
      }
    }
  }

  /// Remove cached controller for a specific story
  void removeCachedController(String storyId, String videoUrl) {
    final cacheKey = '${storyId}_$videoUrl';
    final controller = _videoControllerCache.remove(cacheKey);
    if (controller != null) {
      try {
        if (controller.value.isInitialized) {
          controller.dispose();
        }
      } catch (e) {
        // Controller already disposed, ignore
        debugPrint('StoryCacheService: Controller already disposed: $e');
      }
    }
    debugPrint('StoryCacheService: Removed cached controller for $storyId');
  }

  /// Clear all cached controllers (call when stories are refreshed)
  void clearAllCachedControllers() {
    for (final controller in _videoControllerCache.values) {
      try {
        if (controller.value.isInitialized) {
          controller.dispose();
        }
      } catch (e) {
        // Controller already disposed, ignore
        debugPrint('StoryCacheService: Controller already disposed: $e');
      }
    }
    _videoControllerCache.clear();
    _cachedImageFiles.clear();
    debugPrint('StoryCacheService: Cleared all cached controllers');
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
        debugPrint('StoryCacheService: Controller already disposed during cleanup: $e');
        keysToRemove.add(entry.key);
      }
    }
    
    for (final key in keysToRemove) {
      _videoControllerCache.remove(key);
    }
    
    debugPrint('StoryCacheService: Cleaned up ${keysToRemove.length} invalid controllers');
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    return {
      'cachedVideos': _videoControllerCache.length,
      'cachedImages': _cachedImageFiles.length,
    };
  }
}