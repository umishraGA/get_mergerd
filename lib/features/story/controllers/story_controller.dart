import 'package:flutter/material.dart';

import '../../posts/models/post_poll_models.dart';
import '../models/story_response_models.dart';
import '../data/story_viewmodel.dart';
import '../repository/story_repository.dart';
import '../../../utils/dio/api_service.dart';

/// Controller for managing story state and data
class StoryController extends ChangeNotifier {
  final StoryViewModel _storyViewModel = StoryViewModel();
  late final StoryRepository _repository;

  // Story data state
  List<StoryItem> _stories = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Like and reaction state
  bool _isLiking = false;
  bool _isReacting = false;
  String? _likeError;
  String? _reactionError;

  // Getters
  List<StoryItem> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLiking => _isLiking;
  bool get isReacting => _isReacting;
  String? get likeError => _likeError;
  String? get reactionError => _reactionError;

  /// Initialize controller and load stories
  Future<void> initialize() async {
    // Initialize repository
    final apiService = ApiService();
    _repository = StoryRepository(apiService: apiService);
    
    await loadStories();
  }

  /// Load stories from API
  Future<void> loadStories() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _storyViewModel.fetchStories();

      print("My Response: ${response.data}");
      response.data?.forEach((element) {
        print("My Element: ${element.media}");
      });
      
      if (response.success == true && response.data?.isNotEmpty == true) {
        _stories = List<StoryItem>.from(response.data ?? []);
        print("My Stories Length: ${_stories.length}");
        _errorMessage = null;
      } else {
        // Fallback to static data if API fails or returns empty
        _stories = List<StoryItem>.from(_storyViewModel.getStaticStories());
        _errorMessage = null;
      }
    } catch (e) {
      debugPrint('Error loading stories: $e');
      // Use static data as fallback
      _stories = List<StoryItem>.from(_storyViewModel.getStaticStories());
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh stories
  Future<void> refreshStories() async {
    _stories.clear();
    await loadStories();
  }

  /// Get grouped stories by username
  Map<String, List<StoryItem>> getGroupedStories() {
    final Map<String, List<StoryItem>> grouped = {};
    
    for (final story in _stories) {
      // Use createdBy name as username
      final username = '${story.createdBy?.firstName ?? ''} ${story.createdBy?.lastName ?? ''}'.trim();
      if (grouped.containsKey(username)) {
        grouped[username]!.add(story);
      } else {
        grouped[username] = [story];
      }
    }
    
    // Sort stories within each group by creation time
    grouped.forEach((username, stories) {
      stories.sort((a, b) => (a.createdAt ?? '').compareTo(b.createdAt ?? ''));
    });
    
    return grouped;
  }

  /// Get stories that have media (images or videos)
  List<StoryItem> getStoriesWithMedia() {
    return _stories.where((story) => 
      (story.media?.isNotEmpty ?? false) && 
      story.media!.any((media) => (media.url?.isNotEmpty ?? false))
    ).toList();
  }


  /// Toggle like status for a story
  Future<bool> toggleStoryLike(String storyId) async {
    if (_isLiking) return false;

    try {
      _isLiking = true;
      _likeError = null;
      notifyListeners();

      final response = await _repository.likeStory(storyId);

      if (response.success == true) {
        // Update local story state
        _updateStoryLikeStatus(storyId);
        return true;
      } else {
        _likeError = response.message ?? 'Failed to like story';
        return false;
      }
    } catch (e) {
      _likeError = 'Error liking story: $e';
      debugPrint(_likeError);
      return false;
    } finally {
      _isLiking = false;
      notifyListeners();
    }
  }

  /// Add reaction to a story
  Future<bool> addStoryReaction(String storyId, String reactionType) async {
    if (_isReacting) return false;

    try {
      _isReacting = true;
      _reactionError = null;
      notifyListeners();

      // Map reaction type similar to posts
      final mappedReactionType = _mapReactionTypeToApi(reactionType);
      
      final reaction = AddPostReaction(
        IdReactedFor: storyId,
        reactionType: mappedReactionType,
        type: '',
      );


      final response = await _repository.addStoryReaction(reaction);

      if (response.success == true) {
        // Update local story reaction state
        _updateStoryReaction(storyId, reactionType);
        return true;
      } else {
        _reactionError = response.message ?? 'Failed to add reaction';
        return false;
      }
    } catch (e) {
      _reactionError = 'Error adding reaction: $e';
      debugPrint(_reactionError);
      return false;
    } finally {
      _isReacting = false;
      notifyListeners();
    }
  }

  /// Update story like status in local state
  void _updateStoryLikeStatus(String storyId) {
    final storyIndex = _stories.indexWhere((story) => story.id == storyId);
    if (storyIndex != -1) {
      final story = _stories[storyIndex];
      final updatedStory = story.copyWith(
        isLikedByUser: !(story.isLikedByUser ?? false),
        likesCount: (story.isLikedByUser ?? false) 
            ? (story.likesCount ?? 0) - 1 
            : (story.likesCount ?? 0) + 1,
      );
      _stories[storyIndex] = updatedStory;
      notifyListeners();
    }
  }

  /// Update story reaction in local state
  void _updateStoryReaction(String storyId, String reactionType) {
    final storyIndex = _stories.indexWhere((story) => story.id == storyId);
    if (storyIndex != -1) {
      final story = _stories[storyIndex];
      final currentReactions = <String, int>{};
      
      // Increment reaction count
      currentReactions[reactionType] = (currentReactions[reactionType] ?? 0) + 1;
      
      final updatedStory = story.copyWith(userReaction: reactionType);
      _stories[storyIndex] = updatedStory;
      notifyListeners();
    }
  }

  /// Get story by ID
  StoryItem? getStoryById(String storyId) {
    try {
      return _stories.firstWhere((story) => story.id == storyId);
    } catch (e) {
      return null;
    }
  }

  static const Map<String, String> _reactionIdMap = {
    'HAHA': '685b8ee2521c10ea3f72e32d',
    'LOVE': '687a2dd064c066a255fc6b83',
    'ANGRY': '687a2de364c066a255fc6b8e',
    'SAD': '688768f6693697410460acf0',
    'SURPRISE': '6887693e693697410460acfb',
  };
  /// Map reaction type to API format similar to posts
  String _mapReactionTypeToApi(String reactionType) {
    return _reactionIdMap[reactionType.toUpperCase()] ?? '687a2dd064c066a255fc6b83';
  }

  @override
  void dispose() {
    super.dispose();
  }
}