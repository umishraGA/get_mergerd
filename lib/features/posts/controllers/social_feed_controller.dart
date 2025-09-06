import 'package:flutter/material.dart';

import '../data/PostPollViewModel.dart';
import '../models/post_poll_models.dart';
import '../widgets/PostCardWidget.dart';
import '../widgets/ReactionDisplayWidget.dart';

/// Controller for managing social feed state and animations
class SocialFeedController extends ChangeNotifier {
  // Map to track follow state for each user
  final Map<String, bool> _followStates = {};
  final PostPollViewModel _postPollViewModel = PostPollViewModel();

  // Tab bar sticky state
  bool _isTabBarSticky = false;
  double _tabBarPosition = 0.0;

  // Post detail state
  bool _showingPostDetail = false;
  PostPollItem? _postDetail;
  bool _isPostDetailExiting = false;

  // Animation controller for smoother transitions
  AnimationController? _transitionController;
  Animation<double>? _fadeAnimation;

  // API data state
  List<PostPollItem> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Tab selection state
  bool _isFollowingTab = false;
  
  // Pagination state
  int _currentPage = 1;
  int _pageSize = 10;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;

  // Getters
  /// Whether the tab bar should be sticky at the top
  bool get isTabBarSticky => _isTabBarSticky;

  /// Current position of the tab bar
  double get tabBarPosition => _tabBarPosition;

  /// Whether post detail view is currently showing
  bool get showingPostDetail => _showingPostDetail;

  /// Current post detail data
  PostPollItem? get postDetail => _postDetail;

  /// Whether post detail is in the process of exiting
  bool get isPostDetailExiting => _isPostDetailExiting;

  /// Fade animation for transitions
  Animation<double>? get fadeAnimation => _fadeAnimation;

  /// Animation controller for transitions
  AnimationController? get transitionController => _transitionController;

  /// List of posts from API
  List<PostPollItem> get posts => _posts;

  /// Whether data is currently loading
  bool get isLoading => _isLoading;

  /// Current error message if any
  String? get errorMessage => _errorMessage;
  
  /// Whether the following tab is currently selected
  bool get isFollowingTab => _isFollowingTab;
  
  /// Current page number for pagination
  int get currentPage => _currentPage;
  
  /// Whether there is more data to load
  bool get hasMoreData => _hasMoreData;
  
  /// Whether more posts are currently being loaded
  bool get isLoadingMore => _isLoadingMore;
  
  /// Debug method to check pagination state
  void debugPaginationState() {
    print('=== Pagination Debug ===');
    print('currentPage: $_currentPage');
    print('pageSize: $_pageSize');
    print('hasMoreData: $_hasMoreData');
    print('isLoadingMore: $_isLoadingMore');
    print('isLoading: $_isLoading');
    print('posts.length: ${_posts.length}');
    print('isFollowingTab: $_isFollowingTab');
    print('========================');
  }

  /// Initialize animation controller with the provided ticker
  void initializeAnimations(TickerProvider vsync) {
    _transitionController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.3, // Changed from 0.0 to 0.3 so main feed remains partially visible
    ).animate(CurvedAnimation(
      parent: _transitionController!,
      curve: Curves.easeOutQuart,
      reverseCurve: Curves.easeInQuart,
    ));
  }

  /// Fetch posts and polls from the API
  Future<void> fetchPosts({bool refresh = false}) async {
    // Reset pagination state for refresh or first load
    if (refresh || _posts.isEmpty) {
      _currentPage = 1;
      _hasMoreData = true;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final PostPollResponse response;
      if (_isFollowingTab) {
        response = await _postPollViewModel.fetchPostPollsForFollowingSafe(
          pageNo: _currentPage,
          pageSize: _pageSize,
        );
      } else {
        response = await _postPollViewModel.fetchPostPollsSafe(
          pageNo: _currentPage,
          pageSize: _pageSize,
        );
      }
      
      if(response.data != null ){
        final newPosts = List<PostPollItem>.from(response.data!);
        
        if (refresh || _posts.isEmpty) {
          // Replace posts for refresh or initial load
          _posts = newPosts;
        } else {
          // Append posts for pagination
          _posts.addAll(newPosts);
        }
        
        // Check if we have more data to load
        _hasMoreData = newPosts.length >= _pageSize;
        
        print('SocialFeedController: Successfully loaded ${newPosts.length} posts (page $_currentPage)');
        print('SocialFeedController: Total posts: ${_posts.length}, hasMoreData: $_hasMoreData');
        print('SocialFeedController: Pagination logic - newPosts.length: ${newPosts.length}, _pageSize: $_pageSize, hasMoreData: $_hasMoreData');
        
        if (_posts.isNotEmpty) {
          print('SocialFeedController: First post ID: ${_posts.first.id}, description: ${_posts.first.description}');
        } else {
          print('SocialFeedController: Response has no posts - empty array');
        }
      } else {
        print('SocialFeedController: Response data is null - setting empty array');
        if (refresh || _posts.isEmpty) {
          _posts = [];
        }
        _hasMoreData = false;
      }
      _errorMessage = null;
    } catch (e) {
      print('SocialFeedController: Error loading posts: $e');
      
      // Check if the error is related to no posts available or empty response
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('no posts') || 
          errorString.contains('empty') || 
          errorString.contains('null') ||
          errorString.contains('not found') ||
          errorString.contains('no approved posts') ||
          errorString.contains('404') ||
          errorString.contains('no following posts')) {
        // For "no posts" scenarios, don't show error - just show empty state
        _errorMessage = null;
        if (refresh || _posts.isEmpty) {
          _posts = [];
        }
        _hasMoreData = false;
        print('SocialFeedController: Treating as empty posts scenario - error: $errorString');
      } else {
        // For genuine errors, show error message
        _errorMessage = e.toString();
        if (refresh || _posts.isEmpty) {
          _posts = [];
        }
        _hasMoreData = false;
        print('SocialFeedController: Setting error message: $_errorMessage');
      }
    } finally {
      _isLoading = false;
      print('SocialFeedController: Loading complete - posts: ${_posts.length}, error: $_errorMessage');
      debugPaginationState();
      notifyListeners();
    }
  }

  /// Refresh posts data
  Future<void> refreshPosts() async {
    await fetchPosts(refresh: true);
  }

  /// Load more posts for pagination
  Future<void> loadMorePosts() async {
    print('SocialFeedController: loadMorePosts called');
    
    // Don't load more if already loading or no more data available
    if (_isLoadingMore || !_hasMoreData || _isLoading) {
      print('SocialFeedController: Cannot load more - isLoadingMore: $_isLoadingMore, hasMoreData: $_hasMoreData, isLoading: $_isLoading');
      return;
    }

    _isLoadingMore = true;
    _currentPage++;
    print('SocialFeedController: Loading more posts - page $_currentPage');
    notifyListeners();

    try {
      final PostPollResponse response;
      if (_isFollowingTab) {
        response = await _postPollViewModel.fetchPostPollsForFollowingSafe(
          pageNo: _currentPage,
          pageSize: _pageSize,
        );
      } else {
        response = await _postPollViewModel.fetchPostPollsSafe(
          pageNo: _currentPage,
          pageSize: _pageSize,
        );
      }

      if (response.data != null) {
        final newPosts = List<PostPollItem>.from(response.data!);
        
        // Append new posts to existing list
        _posts.addAll(newPosts);
        
        // Check if we have more data to load
        _hasMoreData = newPosts.length >= _pageSize;
        
        print('SocialFeedController: Successfully loaded ${newPosts.length} more posts (loadMorePosts)');
        print('SocialFeedController: Total posts now: ${_posts.length}, hasMoreData: $_hasMoreData');
        print('SocialFeedController: LoadMore pagination logic - newPosts.length: ${newPosts.length}, _pageSize: $_pageSize, hasMoreData: $_hasMoreData');
      } else {
        print('SocialFeedController: No more posts available');
        _hasMoreData = false;
      }
    } catch (e) {
      print('SocialFeedController: Error loading more posts: $e');
      
      // Revert page number on error
      _currentPage--;
      
      // Check if this is a "no more posts" scenario
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('no posts') || 
          errorString.contains('empty') || 
          errorString.contains('null') ||
          errorString.contains('not found') ||
          errorString.contains('no approved posts') ||
          errorString.contains('404') ||
          errorString.contains('no following posts')) {
        // This is expected when no more posts are available
        _hasMoreData = false;
        print('SocialFeedController: No more posts available');
      } else {
        // For genuine errors, show error in console but don't affect UI too much
        print('SocialFeedController: Genuine error loading more posts: $e');
      }
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Switch between For You and Following tabs
  void switchTab(bool isFollowingTab) {
    if (_isFollowingTab != isFollowingTab) {
      _isFollowingTab = isFollowingTab;
      // Automatically fetch posts for the new tab
      fetchPosts();
    }
  }

  /// Update tab bar position and sticky state based on scroll position
  void updateTabBarPosition(GlobalKey tabBarKey, BuildContext context) {
    final RenderBox? renderBox =
        tabBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final tabBarPosition = renderBox.localToGlobal(Offset.zero).dy;
      final topPadding = MediaQuery.of(context).padding.top;
      final appBarHeight = kToolbarHeight + topPadding;

      // Calculate if the tab bar should be sticky based on its position
      // relative to app bar
      final shouldBeSticky = tabBarPosition <= appBarHeight;

      // Only update state if there's a change to prevent unnecessary rebuilds
      if (shouldBeSticky != _isTabBarSticky) {
        _isTabBarSticky = shouldBeSticky;
        if (_isTabBarSticky) {
          _tabBarPosition = tabBarPosition;
        }
        notifyListeners();
      }
    }
  }

  /// Handle follow state changes for a specific user
  void handleFollowChanged(String username, bool isFollowing) {
    _followStates[username] = isFollowing;
    notifyListeners();
  }

  void handleNewFollowFollowing(
      PostPollItem post, bool isFollowing, SocialFeedController controller) {
    // Find the index of the post to update
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      // Replace the post with updated follow state
      _posts[index] = _posts[index].copyWith(follow: isFollowing);
      notifyListeners();
    }
  }

  /// Update comment count for a specific post
  void updatePostCommentCount(String postId, int newCommentCount) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(commentCount: newCommentCount);
      notifyListeners();
    }
    
    // Also update the detail post if it matches
    if (_postDetail != null && _postDetail!.id == postId) {
      _postDetail = _postDetail!.copyWith(commentCount: newCommentCount);
    }
  }

  /// Update like state for a specific post
  void updatePostLikeState(String postId, int likeCount, bool isLiked, [ReactionType? reaction]) {
    print('SocialFeedController: Updating post $postId - likes: $likeCount, isLiked: $isLiked, reaction: $reaction');
    
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      // Map ReactionType to UserReaction if provided
      UserReaction? userReaction;
      if (reaction != null && isLiked) {
        userReaction = _mapReactionTypeToUserReaction(reaction);
        print('SocialFeedController: Mapped reaction $reaction to UserReaction $userReaction');
      }
      
      _posts[index] = _posts[index].copyWith(
        likesCount: likeCount,
        isLikedByUser: isLiked,
        userReaction: userReaction,
      );
      print('SocialFeedController: Updated post at index $index in main feed');
      notifyListeners();
    } else {
      print('SocialFeedController: Post $postId not found in main feed');
    }
    
    // Also update the detail post if it matches
    if (_postDetail != null && _postDetail!.id == postId) {
      // Map ReactionType to UserReaction if provided
      UserReaction? userReaction;
      if (reaction != null && isLiked) {
        userReaction = _mapReactionTypeToUserReaction(reaction);
      }
      
      _postDetail = _postDetail!.copyWith(
        likesCount: likeCount,
        isLikedByUser: isLiked,
        userReaction: userReaction,
      );
      print('SocialFeedController: Updated detail post');
    }
  }
  
  /// Map ReactionType to UserReaction for API compatibility
  UserReaction? _mapReactionTypeToUserReaction(ReactionType reactionType) {
    switch (reactionType) {
      case ReactionType.love:
      case ReactionType.heart:
        return UserReaction.love;
      case ReactionType.haha:
        return UserReaction.haha;
      case ReactionType.sad:
        return UserReaction.sad;
      case ReactionType.angry:
        return UserReaction.angry;
      case ReactionType.wow:
        return UserReaction.surprise;
      case ReactionType.like:
        return UserReaction.love; // Default to love since API doesn't have simple like
    }
  }

  /// Update bookmark state for a specific post
  void updatePostBookmarkState(String postId, bool isBookmarked) {
    print('SocialFeedController: Updating bookmark for post $postId - isBookmarked: $isBookmarked');
    
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(isPostSaved: isBookmarked);
      print('SocialFeedController: Updated bookmark at index $index in main feed');
      notifyListeners();
    } else {
      print('SocialFeedController: Post $postId not found in main feed for bookmark update');
    }
    
    // Also update the detail post if it matches
    if (_postDetail != null && _postDetail!.id == postId) {
      _postDetail = _postDetail!.copyWith(isPostSaved: isBookmarked);
      print('SocialFeedController: Updated bookmark in detail post');
    }
  }

  /// Remove a reported post from the feed
  void removeReportedPost(String postId) {
    print('Attempting to remove post with ID: $postId');
    print('Posts before removal: ${_posts.length}');
    print('Current post IDs: ${_posts.map((p) => p.id).toList()}');
    
    final initialLength = _posts.length;
    _posts.removeWhere((post) => post.id == postId);
    
    print('Posts after removal: ${_posts.length}');
    print('Post removed: ${initialLength != _posts.length}');
    print('Remaining post IDs: ${_posts.map((p) => p.id).toList()}');
    
    notifyListeners();
  }

  /// Check if a user is being followed
  bool isFollowing(String username) {
    return _followStates[username] ?? false;
  }

  /// Show post detail view with animation
  void showPostDetail(PostPollItem post, Function(bool)? onDetailViewVisible) {
    // Store the PostPollItem directly
    _postDetail = post;

    onDetailViewVisible?.call(true);
    _transitionController?.forward();
    _showingPostDetail = true;
    _isPostDetailExiting = false;
    notifyListeners();
  }

  /// Get post media type enum
  PostMediaType _getPostMediaType(PostPollItem post) {
    if (post.type == 'Polls') return PostMediaType.poll;
    if (post.media.isNotEmpty) {
      bool hasVideo = post.media.any((media) => media.type == 'video');
      if (hasVideo) return PostMediaType.video;
      
      if (post.media.length > 1) return PostMediaType.multiImage;
      return PostMediaType.image;
    }
    return PostMediaType.image;
  }

  /// Get username from post data
  String _getUsername(PostPollItem post) {
    if (post.chooseTypeId != null) {
      // Handle business posts - check if it's a Map
      if (post.chooseTypeId is Map<String, dynamic>) {
        final chooseType = post.chooseTypeId as Map<String, dynamic>;
        
        // Try to get company name from companyInfo
        if (chooseType['companyInfo'] is Map<String, dynamic>) {
          final companyInfo = chooseType['companyInfo'] as Map<String, dynamic>;
          final companyName = companyInfo['companyName'] as String?;
          if (companyName != null) {
            return companyName;
          }
        }
        
        // Handle temple posts - use temple_id or fallback
        final templeId = chooseType['temple_id'] as String?;
        if (templeId != null) {
          return templeId;
        }
      }
    }
    return 'Unknown User';
  }

  /// Get profile image from post data
  String _getProfileImage(PostPollItem post) {
    if (post.chooseTypeId != null) {
      // Handle business posts - check if it's a Map
      if (post.chooseTypeId is Map<String, dynamic>) {
        final chooseType = post.chooseTypeId as Map<String, dynamic>;
        
        // Try to get logo URL from logo object
        if (chooseType['logo'] is Map<String, dynamic>) {
          final logo = chooseType['logo'] as Map<String, dynamic>;
          final logoUrl = logo['url'] as String?;
          if (logoUrl != null) {
            return logoUrl;
          }
        }
        
        // Handle temple posts - use image field
        final imageUrl = chooseType['image'] as String?;
        if (imageUrl != null) {
          return imageUrl;
        }
      }
    }
    return 'assets/images/story_logo1.png';
  }

  /// Get main post image from post data
  String _getMainPostImage(PostPollItem post) {
    if (post.media.isEmpty) return '';
    
    // For video posts, find the first video thumbnail/url
    final firstVideoIndex = post.media.indexWhere(
      (media) => media.type == 'video',
    );
    
    // If we found a video, use it
    if (firstVideoIndex != -1) {
      return post.media[firstVideoIndex].url ?? '';
    }
    
    // For image posts, use first image
    final firstImageIndex = post.media.indexWhere(
      (media) => media.type == 'image',
    );
    
    if (firstImageIndex != -1) {
      return post.media[firstImageIndex].url ?? '';
    }
    
    // Fallback to first media item if available
    return post.media.isNotEmpty ? (post.media.first.url ?? '') : '';
  }

  /// Get video path from post data
  String? _getVideoPath(PostPollItem post) {
    for (final media in post.media) {
      if (media.type == 'video') {
        return media.url;
      }
    }
    return null;
  }

  /// Get additional images from post data
  List<String>? _getAdditionalImages(PostPollItem post) {
    if (post.media.length > 1) {
      List<String> imageUrls = [];
      bool skipFirst = true;
      
      for (final media in post.media) {
        if (media.type == 'image') {
          if (skipFirst) {
            skipFirst = false;
            continue; // Skip the first image as it's the main image
          }
          imageUrls.add(media.url ?? '');
        }
      }
      
      return imageUrls.isNotEmpty ? imageUrls : null;
    }
    return null;
  }

  /// Convert poll options from API format to display format
  Map<String, List<String>>? _convertPollOptions(
      List<PollOptionsItem> options) {
    if (options.isEmpty) return null;
    
    final Map<String, List<String>> result = {};
    for (int i = 0; i < options.length; i++) {
      final option = options[i];
      // Use provided option text or generate placeholder
      final optionText = option.option ?? 'Option ${String.fromCharCode(65 + i)}';
      result[optionText] = List.generate(option.votes, (index) => 'User${index + 1}');
    }
    return result;
  }

  /// Format date string for display
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Hide post detail view with animation
  Future<void> hidePostDetail(Function(bool)? onDetailViewVisible) async {
    onDetailViewVisible?.call(false);
    _isPostDetailExiting = true;
    notifyListeners();

    // Wait for exit animations to complete before changing view state
    await Future.delayed(const Duration(milliseconds: 200));

    _showingPostDetail = false;
    _isPostDetailExiting = false;
    _transitionController?.reverse();
    notifyListeners();
  }

  /// Handle back button press - returns false if handled, true if should exit
  Future<bool> handleBackPress(Function(bool)? onDetailViewVisible) async {
    if (_showingPostDetail) {
      await hidePostDetail(onDetailViewVisible);
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _transitionController?.dispose();
    super.dispose();
  }
}
