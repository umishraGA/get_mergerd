import 'package:flutter/foundation.dart';
import '../data/PostPollViewModel.dart';
import '../models/post_poll_models.dart';
import '../widgets/PostCardWidget.dart';
import '../widgets/ReactionDisplayWidget.dart';
import 'post_controller.dart';

/// Common reaction controller to handle reaction state synchronization
/// between PostDetailPageWithZoom and SocialFeedWidget
class ReactionController extends ChangeNotifier {
  final PostPollViewModel _viewModel = PostPollViewModel();
  
  // Map to store reaction state for each post
  final Map<String, PostReactionState> _postReactions = {};
  
  // Getter for reaction updates
  Map<String, PostReactionState> get reactionUpdates => Map.from(_postReactions);
  
  /// Initialize reaction state for a post
  void initializePostReaction(String postId, {
    int? initialLikeCount,
    bool? isLikedByUser,
    ReactionType? userReaction,
    bool? isBookmarked,
  }) {
    final state = PostReactionState(
      postId: postId,
      likeCount: initialLikeCount ?? 0,
      isLiked: isLikedByUser ?? false,
      selectedReaction: userReaction,
      isBookmarked: isBookmarked ?? false,
    );
    
    _postReactions[postId] = state;
    notifyListeners();
    
    print('ReactionController: Initialized reaction state for post $postId - likes: ${state.likeCount}, isLiked: ${state.isLiked}, reaction: ${state.selectedReaction}');
  }
  
  /// Get current reaction state for a post
  PostReactionState? getPostReactionState(String postId) {
    return _postReactions[postId];
  }
  
  /// Toggle like for a post with API integration
  Future<bool> toggleLike(String postId, PostPollItem? postData, PostMediaType mediaType) async {
    final currentState = _postReactions[postId];
    if (currentState == null) return false;
    
    try {
      if (postData != null) {
        // Determine if this is a post or poll
        final isPost = mediaType != PostMediaType.poll;
        
        PostPollResponse response;
        if (isPost) {
          response = await _viewModel.likePost(postId);
        } else {
          response = await _viewModel.likePoll(postId);
        }

        if (response.success == true) {
          // Update state based on API response
          final newState = currentState.copyWith(
            isLiked: !currentState.isLiked,
            likeCount: currentState.isLiked 
                ? (currentState.likeCount > 0 ? currentState.likeCount - 1 : 0)
                : currentState.likeCount + 1,
            selectedReaction: !currentState.isLiked ? ReactionType.heart : null,
          );
          
          _updatePostReactionState(postId, newState);
          print('ReactionController: API like success for post $postId - new state: likes: ${newState.likeCount}, isLiked: ${newState.isLiked}');
          return true;
        } else {
          // Fallback to local state on API failure
          _handleLocalLikeToggle(postId);
          print('ReactionController: API like failed for post $postId, using local fallback');
          return false;
        }
      } else {
        // No API data, use local state
        _handleLocalLikeToggle(postId);
        print('ReactionController: No API data for post $postId, using local state');
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      // Fallback to local state on error
      _handleLocalLikeToggle(postId);
      print('ReactionController: Error toggling like for post $postId, using local fallback');
      return false;
    }
  }
  
  /// Handle local like toggle fallback
  void _handleLocalLikeToggle(String postId) {
    final currentState = _postReactions[postId];
    if (currentState == null) return;
    
    final newState = currentState.copyWith(
      isLiked: !currentState.isLiked,
      likeCount: currentState.isLiked 
          ? (currentState.likeCount > 0 ? currentState.likeCount - 1 : 0)
          : currentState.likeCount + 1,
      selectedReaction: !currentState.isLiked ? ReactionType.heart : null,
    );
    
    _updatePostReactionState(postId, newState);
  }
  
  /// Toggle reaction for a post with API integration
  Future<bool> toggleReaction(String postId, ReactionType reaction, PostPollItem? postData, PostMediaType mediaType) async {
    final currentState = _postReactions[postId];
    if (currentState == null) return false;
    
    try {
      if (postData != null) {
        // Determine if this is a post or poll
        final isPost = mediaType != PostMediaType.poll;
        
        PostPollResponse? response;
        bool useReactionApi = true;
        
        try {
          // Try reaction API first
          if (isPost) {
            // Map ReactionType to API format and get the actual reaction ID
            String apiReactionType = _mapReactionTypeToApi(reaction);
            String? reactionId = PostController.getReactionId(apiReactionType);
            
            if (reactionId == null) {
              debugPrint('No reaction ID found for type: $apiReactionType');
              // Fall back to like API if no reaction ID is found
              useReactionApi = false;
              response = await _viewModel.likePost(postId);
            } else {
              final reactionRequest = AddPostReaction(
                IdReactedFor: postData.id,
                reactionType: reactionId, // Use the actual reaction ID
                type: 'Post',
              );
              response = await _viewModel.addPostReaction(reactionRequest);
            }
          } else {
            // Map ReactionType to API format and get the actual reaction ID for polls too
            String apiReactionType = _mapReactionTypeToApi(reaction);
            String? reactionId = PostController.getReactionId(apiReactionType);
            
            if (reactionId == null) {
              debugPrint('No reaction ID found for poll type: $apiReactionType');
              // Fall back to like API if no reaction ID is found
              useReactionApi = false;
              response = await _viewModel.likePost(postId);
            } else {
              final pollReaction = PollReaction(
                reactionId: reactionId, // Use the actual reaction ID
              );
              response = await _viewModel.addPollReaction(postData.id, pollReaction);
            }
          }
        } catch (reactionError) {
          debugPrint('Reaction API failed: $reactionError');
          debugPrint('Falling back to like API...');
          useReactionApi = false;
          
          // Fallback to like API if reaction API fails
          if (isPost) {
            response = await _viewModel.likePost(postId);
          } else {
            response = await _viewModel.likePoll(postId);
          }
        }

        if (response?.success == true) {
          // Update state based on API response
          ReactionType? newReaction;
          bool newIsLiked;
          int newLikeCount;
          
          if (currentState.selectedReaction == reaction) {
            // Tapping the same reaction removes it
            newReaction = null;
            newIsLiked = false;
            newLikeCount = currentState.likeCount > 0 ? currentState.likeCount - 1 : 0;
          } else {
            // Setting a different reaction
            if (currentState.selectedReaction == null) {
              // If no previous reaction, increment count
              newLikeCount = currentState.likeCount + 1;
            } else {
              // Changing reaction, keep same count
              newLikeCount = currentState.likeCount;
            }
            newReaction = reaction;
            newIsLiked = true;
          }
          
          final newState = currentState.copyWith(
            isLiked: newIsLiked,
            likeCount: newLikeCount,
            selectedReaction: newReaction,
          );
          
          _updatePostReactionState(postId, newState);
          print('ReactionController: API reaction ${useReactionApi ? "reaction" : "like"} success for post $postId - new state: likes: ${newState.likeCount}, isLiked: ${newState.isLiked}, reaction: ${newState.selectedReaction}');
          return true;
        } else {
          // Handle API failure
          print('ReactionController: API reaction failed for post $postId: ${response?.message ?? "Unknown error"}');
          return false;
        }
      } else {
        // Fallback to local state if no API data
        _handleLocalReactionToggle(postId, reaction);
        print('ReactionController: No API data for post $postId, using local reaction state');
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling reaction: $e');
      // Fallback to local state on error
      _handleLocalReactionToggle(postId, reaction);
      print('ReactionController: Error toggling reaction for post $postId, using local fallback');
      return false;
    }
  }
  
  /// Handle local reaction toggle fallback
  void _handleLocalReactionToggle(String postId, ReactionType reaction) {
    final currentState = _postReactions[postId];
    if (currentState == null) return;
    
    ReactionType? newReaction;
    bool newIsLiked;
    int newLikeCount;
    
    if (currentState.selectedReaction == reaction) {
      // Tapping the same reaction removes it
      newReaction = null;
      newIsLiked = false;
      newLikeCount = currentState.likeCount > 0 ? currentState.likeCount - 1 : 0;
    } else {
      // Setting a different reaction
      if (currentState.selectedReaction == null) {
        // If no previous reaction, increment count
        newLikeCount = currentState.likeCount + 1;
      } else {
        // Changing reaction, keep same count
        newLikeCount = currentState.likeCount;
      }
      newReaction = reaction;
      newIsLiked = true;
    }
    
    final newState = currentState.copyWith(
      isLiked: newIsLiked,
      likeCount: newLikeCount,
      selectedReaction: newReaction,
    );
    
    _updatePostReactionState(postId, newState);
  }
  
  /// Toggle bookmark for a post with API integration
  Future<bool> toggleBookmark(String postId, PostPollItem? postData) async {
    final currentState = _postReactions[postId];
    if (currentState == null) return false;
    
    try {
      if (postData != null) {
        // Create save post request
        final savePostRequest = SavePost(
          postId: postId,
          postModel: postData.type == 'Polls' ? 'Polls' : 'Post',
        );

        // Call API to save/unsave post
        final response = await _viewModel.savePost(savePostRequest);

        if (response.success == true) {
          final newState = currentState.copyWith(
            isBookmarked: !currentState.isBookmarked,
          );
          
          _updatePostReactionState(postId, newState);
          print('ReactionController: API bookmark success for post $postId - new state: isBookmarked: ${newState.isBookmarked}');
          return true;
        } else {
          print('ReactionController: API bookmark failed for post $postId: ${response.message ?? "Unknown error"}');
          return false;
        }
      } else {
        // Fallback to local state if no API data
        final newState = currentState.copyWith(
          isBookmarked: !currentState.isBookmarked,
        );
        
        _updatePostReactionState(postId, newState);
        print('ReactionController: No API data for post $postId, using local bookmark state');
        return true;
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      return false;
    }
  }
  
  /// Update comment count for a post
  void updateCommentCount(String postId, int newCommentCount) {
    final currentState = _postReactions[postId];
    if (currentState == null) return;
    
    final newState = currentState.copyWith(commentCount: newCommentCount);
    _updatePostReactionState(postId, newState);
    print('ReactionController: Updated comment count for post $postId to $newCommentCount');
  }
  
  /// Update the reaction state and notify observers
  void _updatePostReactionState(String postId, PostReactionState newState) {
    _postReactions[postId] = newState;
    notifyListeners();
    print('ReactionController: Updated state for post $postId - likes: ${newState.likeCount}, isLiked: ${newState.isLiked}, reaction: ${newState.selectedReaction}, isBookmarked: ${newState.isBookmarked}');
  }
  
  /// Map UI ReactionType to API reaction string
  String _mapReactionTypeToApi(ReactionType reactionType) {
    switch (reactionType) {
      case ReactionType.like:
        return 'LIKE';
      case ReactionType.love:
        return 'LOVE';
      case ReactionType.haha:
        return 'HAHA';
      case ReactionType.wow:
        return 'SURPRISE';
      case ReactionType.sad:
        return 'SAD';
      case ReactionType.angry:
        return 'ANGRY';
      case ReactionType.heart:
        return 'LOVE';
    }
  }
  
  /// Map API UserReaction to UI ReactionType
  ReactionType _mapApiReactionToReactionType(UserReaction apiReaction) {
    switch (apiReaction) {
      case UserReaction.love:
        return ReactionType.love;
      case UserReaction.haha:
        return ReactionType.haha;
      case UserReaction.sad:
        return ReactionType.sad;
      case UserReaction.angry:
        return ReactionType.angry;
      case UserReaction.surprise:
        return ReactionType.wow;
    }
  }
  
  /// Manual update of reaction state (for external updates)
  void updateReactionState(String postId, {
    int? likeCount,
    bool? isLiked,
    ReactionType? selectedReaction,
    bool? isBookmarked,
    int? commentCount,
  }) {
    final currentState = _postReactions[postId];
    if (currentState == null) return;
    
    final newState = currentState.copyWith(
      likeCount: likeCount,
      isLiked: isLiked,
      selectedReaction: selectedReaction,
      isBookmarked: isBookmarked,
      commentCount: commentCount,
    );
    
    _updatePostReactionState(postId, newState);
  }
}

/// Sentinel value to distinguish between "not provided" and "provided as null"
const _notProvided = Object();

/// Class to hold reaction state for a post
class PostReactionState {
  final String postId;
  final int likeCount;
  final bool isLiked;
  final ReactionType? selectedReaction;
  final bool isBookmarked;
  final int commentCount;
  
  PostReactionState({
    required this.postId,
    required this.likeCount,
    required this.isLiked,
    this.selectedReaction,
    required this.isBookmarked,
    this.commentCount = 0,
  });
  
  PostReactionState copyWith({
    String? postId,
    int? likeCount,
    bool? isLiked,
    Object? selectedReaction = _notProvided,
    bool? isBookmarked,
    int? commentCount,
  }) {
    return PostReactionState(
      postId: postId ?? this.postId,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      selectedReaction: selectedReaction == _notProvided 
          ? this.selectedReaction 
          : selectedReaction as ReactionType?,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      commentCount: commentCount ?? this.commentCount,
    );
  }
  
  @override
  String toString() {
    return 'PostReactionState(postId: $postId, likeCount: $likeCount, isLiked: $isLiked, selectedReaction: $selectedReaction, isBookmarked: $isBookmarked, commentCount: $commentCount)';
  }
}