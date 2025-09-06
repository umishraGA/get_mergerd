import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/comments/comments.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/mainPage/data/open_video_from.dart';
import 'package:myapp/features/postDetail/PostDetailPageWithZoom.dart';
import 'package:myapp/features/postDetail/widgets/SimpleReadMoreWidget.dart';
import 'package:myapp/features/posts/widgets/MultiImagePostWidget.dart';
import 'package:myapp/features/posts/widgets/NetworkImageWidget.dart';
import 'package:myapp/features/posts/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/posts/widgets/DynamicReactionDisplayWidget.dart';
import 'package:myapp/features/posts/widgets/VideoPostWidget.dart';
import 'package:myapp/features/posts/data/PostPollViewModel.dart';
import 'package:myapp/features/posts/models/post_poll_models.dart';
import 'package:myapp/features/posts/controller/post_controller.dart';
import 'package:myapp/features/posts/controller/reaction_controller.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

enum PostMediaType {
  image,
  video,
  multiImage,
  poll,
}

class PostCardWidget extends StatefulWidget {
  final String profileImage;
  final String username;
  final String date;
  final String description;
  final String postImage;
  final int likes;
  final int comments;
  final Function()? onTap;
  final PostMediaType mediaType;
  final List<String>? additionalImages;
  final String? videoPath;
  final bool isFollowing;
  final Function(bool)? onFollowChanged;
  final Function(int)? onCommentCountChanged;
  final Function()? onShare;
  final Map<String, List<String>>? pollOptions;
  final int? totalVotes;
  final String? postId;
  final bool? isLikedByUser;
  final bool? isBookmarked;
  final PostPollItem? postData; // Full post data for API calls
  final String? userId; // User ID for follow API calls
  final String? chooseTypeModel; // User ID for follow API calls
  final Function(String)? onPostReported; // Callback when post is reported and should be removed
  // Callback functions for state changes
  final Function(int likeCount, bool isLiked, ReactionType? reaction)? onLikeChanged;
  final Function(bool isBookmarked)? onBookmarkChanged;

  const PostCardWidget({
    super.key,
    required this.profileImage,
    required this.username,
    required this.date,
    required this.description,
    required this.postImage,
    required this.likes,
    required this.comments,
    this.onTap,
    this.mediaType = PostMediaType.image,
    this.additionalImages,
    this.videoPath,
    this.isFollowing = false,
    this.onFollowChanged,
    this.onCommentCountChanged,
    this.onShare,
    this.pollOptions,
    this.totalVotes,
    this.postId,
    this.isLikedByUser,
    this.isBookmarked,
    this.postData,
    this.userId,
    this.chooseTypeModel,
    this.onPostReported,
    // Callback functions for state changes
    this.onLikeChanged,
    this.onBookmarkChanged,
  });

  /// Builds a post detail view with zoom and animations
  ///
  /// This static method can be used to create a post detail view with animations
  /// when transitioning between posts and detail views.
  static Widget buildPostDetailView({
    required BuildContext context,
    required PostPollItem postDetail,
    required bool showingPostDetail,
    required bool isPostDetailExiting,
    required bool Function(String) isFollowingCallback,
    required Function(String, bool,) handleFollowChangedCallback,
    required VoidCallback onDetailBackPressed,
    required AnimationController transitionController,
    // Add callback parameters for state changes
    Function(int likeCount, bool isLiked, ReactionType? reaction)? onLikeChanged,
    Function(int commentCount)? onCommentCountChanged,
    Function(bool isBookmarked)? onBookmarkChanged,
    VoidCallback? onShare,
  }) {
    if (!showingPostDetail) return const SizedBox.shrink();

    // Extract username from chooseTypeId if available, otherwise use a fallback
    final String username = _getUsernameFromDynamicChooseTypeId(postDetail.chooseTypeId);

    // Use TweenAnimationBuilder for a more controlled initial animation when opening
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        // Only apply the scale animation when opening, not when closing
        final effectiveScale = isPostDetailExiting ? 0.9 : scale;

        return AnimatedOpacity(
          opacity: isPostDetailExiting ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Transform.scale(
            scale: effectiveScale,
            child: Material(
              color: Colors.white,
              child: SafeArea(
                top: false,
                bottom: false,
                left: false,
                right: false,
                child: PostDetailPageWithZoom(
                  key: const ValueKey('detail-page'),
                  username: username,
                  followers: '15k',
                  postImage: postDetail.media.isNotEmpty 
                      ? postDetail.media.first.url ?? ''
                      : '',
                  profileImage: _getProfileImageFromDynamicChooseTypeId(postDetail.chooseTypeId),
                  description: postDetail.description ?? '',
                  location: 'Location',
                  mediaType: _getMediaTypeFromPostData(postDetail),
                  videoPath: _getVideoPathFromPostData(postDetail),
                  additionalImages: _getAdditionalImagesFromPostData(postDetail),
                  isFollowing: isFollowingCallback(username),
                  onFollowChanged: (isFollowing) =>
                      handleFollowChangedCallback(username, isFollowing),
                  userId: postDetail.createdBy,
                  onBack: onDetailBackPressed,
                  // Add post data and interaction support
                  postData: postDetail,
                  postId: postDetail.id,
                  initialLikeCount: postDetail.likesCount,
                  initialCommentCount: postDetail.commentCount,
                  isLikedByUser: postDetail.isLikedByUser,
                  isBookmarked: postDetail.isPostSaved,
                  userReaction: postDetail.userReaction,
                  // Add callback functions for state changes
                  onLikeChanged: onLikeChanged,
                  onCommentCountChanged: onCommentCountChanged,
                  onBookmarkChanged: onBookmarkChanged,
                  onShare: onShare,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a post detail view with zoom and animations (legacy Map support)
  ///
  /// This static method provides backward compatibility for existing code
  /// that passes Map<String, Object> instead of PostPollItem.
  @Deprecated('Use buildPostDetailView with PostPollItem instead')
  static Widget buildPostDetailViewFromMap({
    required BuildContext context,
    required Map<String, Object> postDetail,
    required bool showingPostDetail,
    required bool isPostDetailExiting,
    required bool Function(String) isFollowingCallback,
    required Function(String, bool,) handleFollowChangedCallback,
    required VoidCallback onDetailBackPressed,
    required AnimationController transitionController,
  }) {
    if (!showingPostDetail) return const SizedBox.shrink();

    final String username = postDetail['username'] as String;

    // Use TweenAnimationBuilder for a more controlled initial animation when opening
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        // Only apply the scale animation when opening, not when closing
        final effectiveScale = isPostDetailExiting ? 0.9 : scale;

        return AnimatedOpacity(
          opacity: isPostDetailExiting ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Transform.scale(
            scale: effectiveScale,
            child: Material(
              color: Colors.white,
              child: SafeArea(
                top: false,
                bottom: false,
                left: false,
                right: false,
                child: PostDetailPageWithZoom(
                  key: const ValueKey('detail-page'),
                  username: username,
                  followers: '15k',
                  postImage: postDetail['postImage'] as String,
                  profileImage: postDetail['profileImage'] as String,
                  description: postDetail['description'] as String,
                  location: 'Location',
                  mediaType: postDetail.containsKey('mediaType')
                      ? postDetail['mediaType'] as PostMediaType
                      : PostMediaType.image,
                  videoPath: postDetail.containsKey('videoPath')
                      ? postDetail['videoPath'] as String
                      : '',
                  additionalImages: postDetail.containsKey('additionalImages')
                      ? (postDetail['additionalImages'] as List<String>)
                      : [],
                  isFollowing: isFollowingCallback(username),
                  onFollowChanged: (isFollowing) =>
                      handleFollowChangedCallback(username, isFollowing),
                  userId: postDetail.containsKey('userId') 
                      ? postDetail['userId'] as String?
                      : null,
                  onBack: onDetailBackPressed,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Helper method to determine media type from PostPollItem
  static PostMediaType _getMediaTypeFromPostData(PostPollItem postDetail) {
    if (postDetail.type == 'Polls') {
      return PostMediaType.poll;
    }
    
    if (postDetail.media.isNotEmpty) {
      final firstMedia = postDetail.media.first;
      if (firstMedia.type == 'video') {
        return PostMediaType.video;
      } else if (postDetail.media.length > 1) {
        return PostMediaType.multiImage;
      }
    }
    
    return PostMediaType.image;
  }

  /// Helper method to get video path from PostPollItem
  static String _getVideoPathFromPostData(PostPollItem postDetail) {
    if (postDetail.media.isNotEmpty) {
      final videoMedia = postDetail.media.firstWhere(
        (media) => media.type == 'video',
        orElse: () => PostItem(url: '', type: ''),
      );
      return videoMedia.url ?? '';
    }
    return '';
  }

  /// Helper method to safely get username from dynamic chooseTypeId
  static String _getUsernameFromDynamicChooseTypeId(dynamic chooseTypeId) {
    if (chooseTypeId != null) {
      // Handle business posts - check if it's a Map
      if (chooseTypeId is Map<String, dynamic>) {
        // Try to get company name from companyInfo
        if (chooseTypeId['companyInfo'] is Map<String, dynamic>) {
          final companyInfo = chooseTypeId['companyInfo'] as Map<String, dynamic>;
          final companyName = companyInfo['companyName'] as String?;
          if (companyName != null) {
            return companyName;
          }
        }
        
        // Handle temple posts - use temple_id or fallback
        final templeId = chooseTypeId['temple_id'] as String?;
        if (templeId != null) {
          return templeId;
        }
      }
    }
    return 'Unknown User';
  }

  /// Helper method to safely get profile image from dynamic chooseTypeId
  static String _getProfileImageFromDynamicChooseTypeId(dynamic chooseTypeId) {
    if (chooseTypeId != null) {
      // Handle business posts - check if it's a Map
      if (chooseTypeId is Map<String, dynamic>) {
        // Try to get logo URL from logo object
        if (chooseTypeId['logo'] is Map<String, dynamic>) {
          final logo = chooseTypeId['logo'] as Map<String, dynamic>;
          final logoUrl = logo['url'] as String?;
          if (logoUrl != null) {
            return logoUrl;
          }
        }
        
        // Handle temple posts - use image field
        final imageUrl = chooseTypeId['image'] as String?;
        if (imageUrl != null) {
          return imageUrl;
        }
      }
    }
    return 'assets/images/story_logo1.png';
  }

  /// Helper method to get additional images from PostPollItem
  static List<String> _getAdditionalImagesFromPostData(PostPollItem postDetail) {
    if (postDetail.media.length > 1) {
      return postDetail.media
          .skip(1) // Skip the first image
          .where((media) => media.type == 'image')
          .map((media) => media.url ?? '')
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFollowing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBigHeart = false;
  int _commentCount = 0;
  final CommentsService _commentsService = CommentsService();
  final PostPollViewModel _viewModel = PostPollViewModel();
  late final PostController _postController;
  late ReactionController _reactionController;
  bool _showReactionBar = false;
  final GlobalKey _likeButtonKey = GlobalKey();
  final _player = AudioPlayer();
  bool _showReactionsList = false;
  String? _selectedPollOption;
  bool _isProcessingLike = false;
  
  // Local poll options with updated vote counts
  Map<String, List<String>>? _localPollOptions;
  
  // Track the original selected option from API to handle vote count properly
  String? _originalApiSelectedOption;
  
  // Video aspect ratio for dynamic height calculation
  double? _videoAspectRatio;
  
  // Reaction state variables - will be replaced with ReactionController
  late int _likeCount;
  late bool _isLiked;
  late bool _isBookmarked;
  ReactionType? _selectedReaction;

  // Map to store recent reactions with usernames
  final Map<ReactionType, List<LikeItem>> _recentReactions = {
    ReactionType.love: <LikeItem>[
      const LikeItem(userName: 'John'),
      const LikeItem(userName: 'Sarah'),
    ],
    ReactionType.haha: <LikeItem>[
      const LikeItem(userName: 'Mike'),
    ],
    ReactionType.wow: <LikeItem>[
      const LikeItem(userName: 'Emma'),
    ],
  };

  @override
  void initState() {
    super.initState();
    
    
    // Initialize PostController - use Get.find if already exists, otherwise create new
    try {
      _postController = Get.find<PostController>();
    } catch (e) {
      _postController = Get.put(PostController());
    }
    
    // Initialize ReactionController from Provider context
    _reactionController = Provider.of<ReactionController>(context, listen: false);
    
    // Detect video aspect ratio for videos
    if (widget.mediaType == PostMediaType.video && widget.videoPath != null) {
      _detectVideoAspectRatio();
    }
    
    // Initialize post state in ReactionController if not already set
    if (widget.postId != null) {
      _reactionController.initializePostReaction(
        widget.postId!,
        initialLikeCount: widget.likes,
        isLikedByUser: widget.isLikedByUser ?? widget.postData?.isLikedByUser ?? false,
        userReaction: widget.postData?.userReaction != null 
            ? _mapApiReactionToReactionType(widget.postData!.userReaction!)
            : null,
        isBookmarked: widget.isBookmarked ?? widget.postData?.isPostSaved ?? false,
      );
    }
    
    // Initialize local state as fallback
    _likeCount = widget.likes;
    _commentCount = widget.comments;
    _isFollowing = widget.isFollowing;
    _isLiked = widget.isLikedByUser ?? widget.postData?.isLikedByUser ?? false;
    _isBookmarked = widget.isBookmarked ?? widget.postData?.isPostSaved ?? false;

    // Initialize poll state - check if user has already voted
    _initializePollState();
    
    // Initialize local poll options with current data
    _localPollOptions = widget.pollOptions != null 
        ? Map<String, List<String>>.from(widget.pollOptions!) 
        : null;
    
    // If user already had a selection from API, ensure "You" is in the vote list
    if (_localPollOptions != null && _originalApiSelectedOption != null) {
      if (_localPollOptions!.containsKey(_originalApiSelectedOption!)) {
        final votes = List<String>.from(_localPollOptions![_originalApiSelectedOption!]!);
        if (!votes.contains('You')) {
          votes.add('You');
          _localPollOptions![_originalApiSelectedOption!] = votes;
        }
      }
    }
    
    // Initialize reaction state from API data
    _initializeReactionState();
    _initAudio();

    // Optimized animation controller with same curve as MultiImagePostWidget
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Use easeInOut for smoother animations like MultiImagePostWidget
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Add status listener to reset big heart animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _showBigHeart = false;
            });
          }
        });
      }
    });

    // Listen for comment changes
    _commentsService.addListener(_updateCommentCount);
  }

  /// Initialize poll state - check if user has already voted
  void _initializePollState() {
    if (widget.mediaType == PostMediaType.poll && 
        widget.postData != null && 
        widget.postData!.options != null) {
      
      // First priority: Check API data for selected option
      for (final pollOption in widget.postData!.options!) {
        if (pollOption.selected == true) {
          // Use the option text or generate a placeholder if missing
          final optionText = pollOption.option ?? 
            'Option ${String.fromCharCode(65 + widget.postData!.options!.indexOf(pollOption))}';
          
          // Set the selected option to show the API-indicated selected option
          _selectedPollOption = optionText;
          _originalApiSelectedOption = optionText; // Track original API selection
          break;
        }
      }
      
      // Fallback: If no API selection found, check local image
      if (_selectedPollOption == null && widget.postId != null) {
        if (_postController.hasUserVoted(widget.postId!)) {
          final votedOptionId = _postController.getUserVotedOption(widget.postId!);
          
          if (votedOptionId != null) {
            // Find the option text for the voted option ID
            for (final pollOption in widget.postData!.options!) {
              if (pollOption.id == votedOptionId) {
                // Use the option text or generate a placeholder if missing
                final optionText = pollOption.option ?? 
                  'Option ${String.fromCharCode(65 + widget.postData!.options!.indexOf(pollOption))}';
                
                // Set the selected option to show the locally stored voted option
                _selectedPollOption = optionText;
                _originalApiSelectedOption = optionText; // Track original selection
                break;
              }
            }
          }
        }
      }
    }
  }

  Future<void> _initAudio() async {
    try {
      await _player.setAsset('assets/audio/like_button_audio.mp3');
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _commentsService.removeListener(_updateCommentCount);
    _player.dispose();
    super.dispose();
  }

  /// Initialize reaction state from API data
  void _initializeReactionState() {
    if (widget.postData?.userReaction != null) {
      _selectedReaction = _mapApiReactionToReactionType(widget.postData!.userReaction!);
      _isLiked = true; // If user has any reaction, they've interacted with the post
      
      // Add user to the recent reactions for their selected reaction
      if (_recentReactions.containsKey(_selectedReaction!)) {
        _recentReactions[_selectedReaction!]!.insert(0, const LikeItem(userName: 'You'));
      } else {
        _recentReactions[_selectedReaction!] = <LikeItem>[const LikeItem(userName: 'You')];
      }
    } else if (_isLiked) {
      // If isLikedByUser is true but no specific reaction, default to heart
      _selectedReaction = ReactionType.heart;
      
      // Add user to heart reactions
      if (_recentReactions.containsKey(ReactionType.heart)) {
        _recentReactions[ReactionType.heart]!.insert(0, const LikeItem(userName: 'You'));
      } else {
        _recentReactions[ReactionType.heart] = <LikeItem>[const LikeItem(userName: 'You')];
      }
    }
    
    // Initialize reaction counts from API data if available
    _initializeReactionCounts();
  }

  /// Initialize reaction counts from API reactionCount data
  void _initializeReactionCounts() {
    if (widget.postData?.reactionCount != null) {
      for (final reactionItem in widget.postData!.reactionCount) {
        final reactionType = _mapApiReactionNameToReactionType(reactionItem.name);
        if (reactionType != null && reactionItem.count > 0) {
          // Add placeholder users for reaction counts (since we don't have actual usernames)
          final placeholderUsers = List.generate(
            reactionItem.count - (reactionType == _selectedReaction ? 1 : 0),
            (index) => LikeItem(userName: 'User ${index + 1}'),
          );
          
          if (_recentReactions.containsKey(reactionType)) {
            _recentReactions[reactionType]!.addAll(placeholderUsers);
          } else if (placeholderUsers.isNotEmpty) {
            _recentReactions[reactionType] = List<LikeItem>.from(placeholderUsers);
          }
        }
      }
    }
  }

  /// Map API reaction name string to UI ReactionType enum
  ReactionType? _mapApiReactionNameToReactionType(String reactionName) {
    switch (reactionName.toUpperCase()) {
      case 'LOVE':
        return ReactionType.love;
      case 'HAHA':
        return ReactionType.haha;
      case 'SAD':
        return ReactionType.sad;
      case 'ANGRY':
        return ReactionType.angry;
      case 'SURPRISE':
        return ReactionType.wow;
      case 'LIKE':
        return ReactionType.like;
      default:
        return null;
    }
  }

  /// Map API UserReaction enum to UI ReactionType enum
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

  /// Calculate total reaction count from both likes and specific reactions
  int _calculateTotalReactionCount(int likeCount, PostPollItem? postData) {
    int totalCount = likeCount;
    
    // Add counts from specific reaction types
    if (postData?.reactionCount != null) {
      for (final reactionItem in postData!.reactionCount) {
        totalCount += reactionItem.count;
      }
    }
    
    return totalCount;
  }

  void _updateCommentCount() {
    final String? postId = widget.postId;
    if (postId == null) return;
    
    final newCount = _commentsService.getCommentCount(postId);

    if (newCount != _commentCount) {
      setState(() {
        _commentCount = newCount;
      });
      
      // Notify parent widget about comment count change
      widget.onCommentCountChanged?.call(newCount);
    }
  }

  Future<void> _playLikeSound() async {
    try {
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void _toggleLike() async {
    // Like button should behave as a heart reaction button
    _toggleReaction(ReactionType.heart);
  }

  void _doubleTapLike() async {
    // Get current state from ReactionController
    final String? postId = widget.postId;
    final PostReactionState? reactionState = postId != null 
        ? _reactionController.getPostReactionState(postId)
        : null;
    final bool currentIsLiked = reactionState?.isLiked ?? _isLiked;
    
    // Only animate if not already liked and not processing
    if (!currentIsLiked && !_isProcessingLike) {
      setState(() {
        _showBigHeart = true;
      });

      // Call the toggle like method to handle the API call
       _toggleLike();

      // Reset and play animation with smooth transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _showComments(BuildContext context, String? postId) {
    if(postId == null) {
      return;
    }
    
    // Convert UserReaction enum to string for dynamic widget
    String? currentUserReactionString;
    if (widget.postData?.userReaction != null) {
      switch (widget.postData!.userReaction!) {
        case UserReaction.love:
          currentUserReactionString = 'LOVE';
          break;
        case UserReaction.haha:
          currentUserReactionString = 'HAHA';
          break;
        case UserReaction.sad:
          currentUserReactionString = 'SAD';
          break;
        case UserReaction.angry:
          currentUserReactionString = 'ANGRY';
          break;
        case UserReaction.surprise:
          currentUserReactionString = 'SURPRISE';
          break;
      }
    }
    
    // Pass both old and new reaction data to the comments sheet
    CommentsBottomSheet.show(
      context,
      postId,
      recentReactions: _recentReactions,
      selectedReaction: _selectedReaction,
      likeCount: _likeCount,
      // New dynamic API data
      reactions: widget.postData?.reactions,
      reactionCountBreakdown: widget.postData?.reactionCount,
      currentUserReaction: currentUserReactionString,
    );
  }

  void _toggleBookmark() async {
    if (widget.postId == null) return;

    try {
      // Use ReactionController to handle the bookmark toggle
      final success = await _reactionController.toggleBookmark(widget.postId!, widget.postData);
      
      if (success) {
        _showBookmarkMessage();
        
        // Notify parent of bookmark change
        final newState = _reactionController.getPostReactionState(widget.postId!);
        widget.onBookmarkChanged?.call(newState?.isBookmarked ?? false);
      } else {
        // Show error message 
        if (mounted) {
          final currentState = _reactionController.getPostReactionState(widget.postId!);
          final isCurrentlyBookmarked = currentState?.isBookmarked ?? _isBookmarked;
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Failed to ${isCurrentlyBookmarked ? "remove" : "save"} post'),
          //     backgroundColor: Colors.red,
          //     duration: const Duration(seconds: 2),
          //   ),
          // );
        }
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      // Show error to user
      // if (mounted) {
      //   final currentState = _reactionController.getPostReactionState(widget.postId!);
      //   final isCurrentlyBookmarked = currentState?.isBookmarked ?? _isBookmarked;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Failed to ${isCurrentlyBookmarked ? "remove" : "save"} post: ${e.toString()}'),
      //       backgroundColor: Colors.red,
      //       duration: const Duration(seconds: 2),
      //     ),
      //   );
      // }
    }
  }

  void _showBookmarkMessage() {
    // Get current bookmark state from ReactionController
    final currentState = widget.postId != null 
        ? _reactionController.getPostReactionState(widget.postId!)
        : null;
    final isCurrentlyBookmarked = currentState?.isBookmarked ?? _isBookmarked;
    
    // Show a short feedback message
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCurrentlyBookmarked
              ? 'Post saved to your bookmarks'
              : 'Post removed from your bookmarks',
          style: const TextStyle(
            fontFamily: 'FacebookSans',
          ),
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String postId = widget.postImage.hashCode.toString();
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return Consumer<ReactionController>(
      builder: (context, reactionController, child) {
        // Get reaction state from controller if available, otherwise use local state
        final String? actualPostId = widget.postId;
        final PostReactionState? reactionState = actualPostId != null 
            ? reactionController.getPostReactionState(actualPostId)
            : null;
        
        final int currentLikeCount = reactionState?.likeCount ?? _likeCount;
        final bool currentIsLiked = reactionState?.isLiked ?? _isLiked;
        final ReactionType? currentReaction = reactionState?.selectedReaction ?? _selectedReaction;
        final bool currentIsBookmarked = reactionState?.isBookmarked ?? _isBookmarked;
        
        // Calculate total reaction count (likes + all other reactions)
        final int totalReactionCount = _calculateTotalReactionCount(currentLikeCount, widget.postData);

        return GestureDetector(
      onTap: () {
        // Close reaction selector if it's open
        if (_showReactionBar) {
          setState(() {
            _showReactionBar = false;
          });
          return;
        }

        // Close reactions list if it's open
        if (_showReactionsList) {
          setState(() {
            _showReactionsList = false;
          });
          return;
        }

        // Otherwise navigate to post detail
        widget.onTap?.call();
      },
      child: RepaintBoundary(
        // Avoid repainting when parent rebuilds
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post header with profile info
                  _buildPostHeader(),

                  // Post description
                  if (widget.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SimpleReadMoreWidget(
                        text: widget.description,
                        trimLines: 3,
                        style: AppTextStyles.medium15,
                        trimExpandedButtonStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'FacebookSans',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),

                  // Post media (image, video, multi-image, or poll)
                  widget.mediaType == PostMediaType.poll
                      ? _buildPollWidget(context)
                      : Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8),
                          width: double.infinity,
                          height: (switch (widget.mediaType) {
                            PostMediaType.video => _getVideoHeight(isTablet),
                            _ => isTablet ? 600 : 300,
                          }),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Media content based on type
                                _buildPostMedia(context, isTablet),

                                // Animated heart overlay on double tap with improved animation
                                if (_showBigHeart)
                                  AnimatedBuilder(
                                    animation: _scaleAnimation,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _scaleAnimation.value,
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                              size: 120 * _scaleAnimation.value,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),

                  // Recent reactions display
                  _buildRecentReactions(),

                  // Action bar (like, comment, bookmark)
                  if (!_showReactionBar) _buildActionBar(context, theme, totalReactionCount, currentIsLiked, currentReaction, currentIsBookmarked),
                  if (_showReactionBar) _buildActionBarHidden(context, theme),

                  // Divider
                  // const Divider(
                  //   height: 8,
                  //   thickness: 0.5,
                  //   color: Color(0xFFEEEEEE),
                  // ),
                  const CommonDivider(),
                ],
              ),
              // Reaction selector overlay
              if (_showReactionBar) _buildReactionSelector(),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildPostHeader() {
    //post header like name profile date fallow button and report 3 dot
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile info section (left side)
          Expanded(
            child: Row(
              children: [
                // Profile image with tap action
                GestureDetector(
                  onTap: widget.onTap,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: CachedNetworkImageProvider(widget.profileImage),
                    ),
                  ),
                ),
                const SizedBox(width: 13),

                // Username and date (with tap action)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: AppTextStyles.bold16,
                    ),
                    Text(
                      widget.date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'FacebookSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Follow button
          OutlinedButton(
            onPressed: () async {
              
              // If we have a userId, use the PostController API
              if (widget.userId != null && widget.userId!.isNotEmpty) {
                // Get the current state before API call
                final currentFollowState = _isFollowing;
                
                final result = await _postController.toggleFollowUser(
                  widget.userId!,
                  widget.chooseTypeModel!,
                  currentFollowState,
                );
                
                if (result['success'] == true) {
                  // Get the new state from API response
                  final newFollowState = result['newState'] as bool;
                  
                  // Update local widget state based on API response
                  setState(() {
                    _isFollowing = newFollowState;
                  });
                  
                  // Update the parent widget's post follow state
                  widget.onFollowChanged?.call(newFollowState);
                  
                  // Show success message with the new state
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(newFollowState ? 'User followed successfully!' : 'User unfollowed successfully!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                  
                  print('Follow button: Updated widget state from $currentFollowState to $newFollowState (API response)');
                } else {
                  // Show error message from API response
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message']?.toString() ?? 'Failed to ${currentFollowState ? "unfollow" : "follow"} user'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } else {
                // Fallback to the old callback method if no userId
                widget.onFollowChanged?.call(!widget.isFollowing);
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  _isFollowing ? Colors.white : const Color(0xFF4976C2),
              backgroundColor: _isFollowing
                  ? const Color(0xFF4976C2)
                  : Colors.transparent,
              side: const BorderSide(color: Color(0xFF4976C2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(80, 30),
            ),
            child: Text(
              _isFollowing ? 'Following' : 'Follow',
              style: AppTextStyles.semiBold14.copyWith(
                color:
                    _isFollowing ? Colors.white : const Color(0xFF4976C2),
              ),
            ),
          ),
          // const SizedBox(width: 8),

          // More options icon
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 24,
              color: Colors.black,
            ),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFEAEAEA), width: 1.5),
            ),
            elevation: 4,
            position: PopupMenuPosition.under,
            color: Colors.white,
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Report', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Why are you reporting this post?'),
              const SizedBox(height: 16),
              _buildReportOption(context, 'Inappropriate content'),
              _buildReportOption(context, 'Spam'),
              _buildReportOption(context, 'Harassment'),
              _buildReportOption(context, 'False information'),
              _buildReportOption(context, 'I just don\'t like it'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportOption(BuildContext context, String option) {
    return InkWell(
      onTap: () async {
        print('DEBUG: Report option tapped: $option');
        print('DEBUG: Post ID: ${widget.postId}');
        print('DEBUG: onPostReported callback exists: ${widget.onPostReported != null}');
        
        Navigator.of(context).pop();
        
        if (widget.postId != null) {
          // Capture ScaffoldMessenger reference before async operation
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          
          try {
            print('DEBUG: Starting report submission process');
            
            // Show loading indicator
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Reporting post...'),
                duration: Duration(seconds: 1),
              ),
            );
            
            // Create report
            final report = PostReport(
              message: option,
              postId: widget.postId!,
            );
            
            print('DEBUG: Created report object: ${report.toJson()}');
            
            // Submit report
            print('DEBUG: About to call _viewModel.reportPost()');
            final response = await _viewModel.reportPost(report);
            print('DEBUG: _viewModel.reportPost() completed successfully');
            print('DEBUG: Response: $response');
            
            // Check if widget is still mounted before UI operations
            if (!mounted) {
              print('DEBUG: Widget disposed, skipping all UI operations');
              return;
            }
            
            // Show success message using captured reference
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text('Post reported for: $option'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
            
            // Remove post from UI by calling callback (this doesn't use context)
            print('About to call onPostReported with postId: ${widget.postId}');
            if (widget.onPostReported != null) {
              print('onPostReported callback is not null, calling...');
              widget.onPostReported!(widget.postId!);
              print('onPostReported callback called successfully');
            } else {
              print('onPostReported callback is null!');
            }
          } catch (e) {
            print('DEBUG: Error in report submission: $e');
            // For error case, check mounted before showing message
            if (mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Failed to report post: $e'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              print('DEBUG: Widget disposed, skipping error message display');
            }
          }
        } else {
          print('DEBUG: Post ID is null');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot report post: Post ID not available'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.circle_outlined, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Text(option),
          ],
        ),
      ),
    );
  }

  // Detect video aspect ratio asynchronously
  Future<void> _detectVideoAspectRatio() async {
    if (widget.videoPath == null) return;
    
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoPath!));
      await controller.initialize();
      
      if (mounted && controller.value.isInitialized) {
        setState(() {
          _videoAspectRatio = controller.value.aspectRatio;
        });
      }
      
      await controller.dispose();
    } catch (e) {
      // If video detection fails, leave aspect ratio as null to use defaults
      print('Failed to detect video aspect ratio: $e');
    }
  }

  // Calculate video height based on video aspect ratio
  double _getVideoHeight(bool isTablet) {
    if (widget.videoPath == null) {
      return isTablet ? 400 : 350; // Default fallback
    }

    // Use detected aspect ratio if available, otherwise use defaults
    final aspectRatio = _videoAspectRatio;
    
    if (aspectRatio != null) {
      // Vertical videos (aspect ratio < 0.8) - like reels, stories
      if (aspectRatio < 0.8) {
        return isTablet ? 700 : 550;
      }
      // Horizontal videos (aspect ratio > 1.2) - like landscape videos
      else if (aspectRatio > 1.2) {
        return isTablet ? 300 : 200;
      }
      // Square videos (aspect ratio 0.8-1.2) - like 1:1 videos
      else {
        return isTablet ? 400 : 350;
      }
    }
    
    // Default if aspect ratio not detected yet
    return isTablet ? 400 : 350;
  }

  // if mediya is vedio then this screen open
  Widget _buildPostMedia(BuildContext context, bool isTablet) {
    switch (widget.mediaType) {
      case PostMediaType.video:
        // if mediya is vedio then this screen open
        return Container(
          // height: isTablet ? 400 : 250,
          decoration: const BoxDecoration(color: Colors.black),
          width: double.infinity,
          child: Stack(
            children: [
              // Main video
              Align(
                alignment: Alignment.center,
                child: VideoPostWidget(
                  videoPath: widget.videoPath!,
                  thumbnailPath: widget.postImage,
                  onDoubleTap: _doubleTapLike,
                  onTap: widget.onTap,
                  autoPlay: true,
                  openVideoFrom: OpenVideoFrom.mainPage,
                ),
              ),

              // Zoom indicator
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.zoom_out_map,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      case PostMediaType.multiImage:
        final allImages = [widget.postImage, ...?widget.additionalImages];
        return MultiImagePostWidget(
          imagePaths: allImages,
          height: isTablet ? 600 : 300,
          onTap: (_) => widget.onTap?.call(),
          onDoubleTap: _doubleTapLike,
        );
      case PostMediaType.image:
      default:
        // Using same structure as MultiImagePostWidget for consistency
        return SizedBox(
          height: isTablet ? 600 : 300,
          width: double.infinity,
          child: Stack(
            children: [
              // Main image using the same structure as in MultiImagePostWidget
              GestureDetector(
                onTap: widget.onTap,
                onDoubleTap: _doubleTapLike,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Image with hero animation and AVIF support
                      NetworkImageWidget(
                        imageUrl: widget.postImage,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                        height: isTablet ? 600 : 300,
                        heroTag: 'image-${widget.postImage}',
                        placeholder: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Zoom indicator - exactly as in MultiImagePostWidget
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  //in this  like comment share button is there
  Widget _buildActionBar(BuildContext context, ThemeData theme, int totalReactionCount, bool isLiked, ReactionType? selectedReaction, bool isBookmarked) {
    //in this  like comment share button is there
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button with reactions support
          GestureDetector(
            onTap: _toggleLike,
            onLongPress: () {
              _showReactionSelector();
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _buildReactionIcon(isLiked, selectedReaction),
                ),
                const SizedBox(width: 4),
                Text(
                  totalReactionCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'FacebookSans',
                    color: isLiked && selectedReaction != null
                        ? _getReactionColor(selectedReaction!)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Comment button
          GestureDetector(
            onTap: () =>
                _showComments(context, widget.postId),
            child: Row(
              children: [
                Icon(
                  MdiIcons.commentOutline,
                  size: 26,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  _commentCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'FacebookSans',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Share button - using GestureDetector to make it tappable
          GestureDetector(
            onTap: widget.onShare,
            child: Icon(
              MdiIcons.shareOutline,
              size: 26,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),

          // Bookmark button
          GestureDetector(
            onTap: _toggleBookmark,
            child: Icon(
              isBookmarked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
              color: isBookmarked ? const Color(0xFF4976C2) : Colors.grey[600],
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

//like button long press reaction open
  Widget _buildActionBarHidden(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button with reactions support
          GestureDetector(
            onTap: _toggleLike,
            onLongPress: () {
              _showReactionSelector();
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedReaction != null
                          ? _getReactionColor(_selectedReaction!)
                          : const Color(0xFFEEEEEE),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Comment button
          GestureDetector(
            onTap: () =>
                _showComments(context, widget.postId),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Share button - replaced with dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEEEEEE),
            ),
          ),
          const Spacer(),

          // Bookmark button
          GestureDetector(
            onTap: _toggleBookmark,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //reaction store karene ke liye
  Widget _buildReactionIcon(bool isLiked, ReactionType? selectedReaction) {
    if (selectedReaction == null) {
      return Icon(
        isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
        color: isLiked ? Colors.red : Colors.grey[600],
        size: 26,
      );
    }

    // Return the selected reaction
    switch (selectedReaction) {
      case ReactionType.like:
        return const Icon(Icons.thumb_up, color: Colors.blue, size: 28);
      case ReactionType.love:
        return const Text('❤️', style: TextStyle(fontSize: 24));
      case ReactionType.haha:
        return const Text('😂', style: TextStyle(fontSize: 24));
      case ReactionType.wow:
        return const Text('😮', style: TextStyle(fontSize: 24));
      case ReactionType.sad:
        return const Text('😢', style: TextStyle(fontSize: 24));
      case ReactionType.angry:
        return const Text('😡', style: TextStyle(fontSize: 24));
      default:
        return Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? Colors.red : Colors.grey[600],
          size: 26,
        );
    }
  }

  Color _getReactionColor(ReactionType reaction) {
    switch (reaction) {
      case ReactionType.like:
        return Colors.blue;
      case ReactionType.love:
        return Colors.red;
      case ReactionType.haha:
        return Colors.amber;
      case ReactionType.wow:
        return Colors.amber;
      case ReactionType.sad:
        return Colors.blue;
      case ReactionType.angry:
        return Colors.orange;
      case ReactionType.heart:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

//store reaction
  Widget _buildReactionSelector() {
    return Positioned(
      bottom: 60, // Position above like button
      left: 0,
      right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            height: 52,
            width: 320,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildReactionOption(ReactionType.like, '👍', 'Like'),
                  _buildReactionOption(ReactionType.love, '❤️', 'Love'),
                  _buildReactionOption(ReactionType.haha, '😂', 'Haha'),
                  _buildReactionOption(ReactionType.wow, '😮', 'Wow'),
                  _buildReactionOption(ReactionType.sad, '😢', 'Sad'),
                  _buildReactionOption(ReactionType.angry, '😡', 'Angry'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionOption(
      ReactionType reaction, String emoji, String tooltip) {
    final isSelected = _selectedReaction == reaction;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      verticalOffset: -40,
      child: GestureDetector(
        onTap: () {
          _toggleReaction(reaction);
          setState(() {
            _showReactionBar = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? _getReactionColor(reaction).withOpacity(0.2)
                : Colors.transparent,
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: isSelected ? 1.2 : 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Text(
              emoji,
              style: const TextStyle(
                fontSize: 26,
                fontFamily: 'FacebookSans',
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getReactionText(ReactionType? reaction) {
    if (reaction == null) return 'likes';

    switch (reaction) {
      case ReactionType.like:
        return 'likes';
      case ReactionType.love:
        return 'loves';
      case ReactionType.haha:
        return 'laughs';
      case ReactionType.wow:
        return 'wows';
      case ReactionType.sad:
        return 'sads';
      case ReactionType.angry:
        return 'angers';
      default:
        return 'likes';
    }
  }

  void _toggleReaction(ReactionType reaction) async {
    if (_isProcessingLike || widget.postId == null) return; // Prevent multiple simultaneous requests
    
    setState(() {
      _isProcessingLike = true;
    });

    try {
      // Use ReactionController to handle the reaction
      final success = await _reactionController.toggleReaction(widget.postId!, reaction, widget.postData, widget.mediaType);
      
      if (success) {
        // Get the new state from ReactionController to see if reaction was removed or added
        final newState = _reactionController.getPostReactionState(widget.postId!);
        final bool isStillLiked = newState?.isLiked ?? false;
        final ReactionType? newSelectedReaction = newState?.selectedReaction;
        
        // Update recent reactions for UI based on the new state
        _recentReactions.forEach((key, users) {
          users.removeWhere((user) => user.userName == 'You');
        });
        
        // Only add user to reactions if they still have a reaction
        if (isStillLiked && newSelectedReaction != null) {
          if (_recentReactions.containsKey(newSelectedReaction)) {
            _recentReactions[newSelectedReaction]!.insert(0, const LikeItem(userName: 'You'));
          } else {
            _recentReactions[newSelectedReaction] = <LikeItem>[const LikeItem(userName: 'You')];
          }
          _playLikeSound();
        }
        
        // Notify parent of reaction change
        widget.onLikeChanged?.call(
          newState?.likeCount ?? 0, 
          isStillLiked, 
          newSelectedReaction
        );
        
        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reaction updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        // Handle API failure
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('Failed to update reaction'),
        //       backgroundColor: Colors.red,
        //     ),
        //   );
        // }
      }
    } catch (e) {
      debugPrint('Error toggling reaction: $e');
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Failed to update reaction: ${e.toString()}'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingLike = false;
        });
      }
    }
  }

  String _mapReactionTypeToApi(ReactionType reaction) {
    String reactionString;
    switch (reaction) {
      case ReactionType.like:
        reactionString = 'LIKE';
        break;
      case ReactionType.love:
      case ReactionType.heart:
        reactionString = 'LOVE';
        break;
      case ReactionType.haha:
        reactionString = 'HAHA';
        break;
      case ReactionType.wow:
        reactionString = 'WOW';
        break;
      case ReactionType.sad:
        reactionString = 'SAD';
        break;
      case ReactionType.angry:
        reactionString = 'ANGRY';
        break;
      default:
        reactionString = 'LIKE';
        break;
    }
    // Use the PostController mapper for consistent mapping
    return PostController.mapReactionTypeToApi(reactionString);
  }

  // Show the reaction selector bar
  void _showReactionSelector() {
    setState(() {
      _showReactionBar = true;
    });
  }

  // Helper method to build recent reactions display
  Widget _buildRecentReactions() {
    // Convert UserReaction enum to string
    String? currentUserReactionString;
    if (widget.postData?.userReaction != null) {
      switch (widget.postData!.userReaction!) {
        case UserReaction.love:
          currentUserReactionString = 'LOVE';
          break;
        case UserReaction.haha:
          currentUserReactionString = 'HAHA';
          break;
        case UserReaction.sad:
          currentUserReactionString = 'SAD';
          break;
        case UserReaction.angry:
          currentUserReactionString = 'ANGRY';
          break;
        case UserReaction.surprise:
          currentUserReactionString = 'SURPRISE';
          break;
      }
    }

    // Calculate total reaction count for display
    final int totalReactionCount = _calculateTotalReactionCount(_likeCount, widget.postData);

    // Use DynamicReactionDisplayWidget for dynamic API data
    return DynamicReactionDisplayWidget(
      reactionCount: totalReactionCount,
      reactions: widget.postData?.reactions,
      likes: widget.postData?.likes,
      likesCount: widget.postData?.likesCount ?? 0,
      reactionCountBreakdown: widget.postData?.reactionCount,
      isLikedByUser: widget.postData?.isLikedByUser ?? false,
      currentUserReaction: currentUserReactionString,
    );
  }

  // Poll widget implementation
  Widget _buildPollWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    // Use local poll options if available, otherwise fallback to widget poll options
    final pollOptions = _localPollOptions ?? widget.pollOptions;
    
    if (pollOptions == null || pollOptions.isEmpty) {
      return const SizedBox();
    }
    
    // Calculate total votes from local poll options
    final totalVotes = pollOptions.values.fold<int>(0, (sum, voters) => sum + voters.length);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...pollOptions.entries.map((entry) {
            final option = entry.key;
            final voters = entry.value;
            final isSelected = _selectedPollOption == option;
            final voteCount = voters.length;
            final votePercentage =
                totalVotes > 0 ? (voteCount / totalVotes) * 100 : 0;

            return GestureDetector(
              onTap: () async {
                // Allow users to vote on any option including re-voting on same option
                if (widget.postData != null && widget.postId != null) {
                  // Update UI immediately for responsive feedback
                  final String? previousSelection = _selectedPollOption;
                  
                  // Update vote counts immediately in local poll options for UI
                  if (_localPollOptions != null) {
                    setState(() {
                      _selectedPollOption = option;
                      
                      // Handle vote count updates based on whether this is original API selection or new selection
                      if (_localPollOptions!.containsKey(option)) {
                        final currentVotes = List<String>.from(_localPollOptions![option]!);
                        
                        // If returning to original API selected option, don't add extra "You"
                        if (option == _originalApiSelectedOption) {
                          // Just ensure "You" is there (should already be there from initialization)
                          if (!currentVotes.contains('You')) {
                            currentVotes.add('You');
                          }
                        } else {
                          // This is a new selection different from original API selection
                          if (!currentVotes.contains('You')) {
                            currentVotes.add('You');
                          }
                        }
                        _localPollOptions![option] = currentVotes;
                      }
                      
                      // Decrease vote count for previous selection if different
                      if (previousSelection != null && 
                          previousSelection != option && 
                          _localPollOptions!.containsKey(previousSelection)) {
                        final previousVotes = List<String>.from(_localPollOptions![previousSelection]!);
                        if (previousVotes.contains('You')) {
                          previousVotes.remove('You');
                        }
                        _localPollOptions![previousSelection] = previousVotes;
                      }
                    });
                  } else {
                    setState(() {
                      _selectedPollOption = option;
                    });
                  }

                  // Find the option ID from postData using the option text or index
                  String? optionId;
                  if (widget.postData!.options != null) {
                    // Try to match by option text first
                    for (final pollOption in widget.postData!.options!) {
                      final optionText = pollOption.option ?? 'Option ${String.fromCharCode(65 + widget.postData!.options!.indexOf(pollOption))}';
                      if (optionText == option) {
                        optionId = pollOption.id;
                        break;
                      }
                    }
                    
                    // If still not found, try to match by position/index as fallback
                    if (optionId == null && _localPollOptions != null) {
                      final optionIndex = _localPollOptions!.keys.toList().indexOf(option);
                      if (optionIndex >= 0 && optionIndex < widget.postData!.options!.length) {
                        optionId = widget.postData!.options![optionIndex].id;
                      }
                    }
                  }

                  if (optionId != null) {
                    // Call the API to vote (in background)
                    _postController.voteOnPoll(widget.postId!, optionId);
                  }
                } else {
                  // Fallback to just updating local state if no post data
                  setState(() {
                    _selectedPollOption = option;
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEEF4FF)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Progress bar for all options showing vote percentage
                    if (voteCount > 0)
                      Positioned.fill(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: votePercentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF4976C2).withOpacity(0.3)
                                  : const Color(0xFF4976C2).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                    // Option content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          // Radio button
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4976C2)
                                    : Colors.grey,
                                width: 2,
                              ),
                              color: isSelected
                                  ? const Color(0xFF4976C2)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),

                          // Option text
                          Expanded(
                            child: Text(
                              option,
                              style: AppTextStyles.semiBold16.copyWith(
                                color: isSelected
                                    ? const Color(0xFF4976C2)
                                    : Colors.black,
                              ),
                            ),
                          ),
                          
                          // Vote count and percentage display
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF4976C2)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$voteCount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontFamily: 'FacebookSans',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${votePercentage.toInt()}%)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected ? Colors.white70 : Colors.black54,
                                    fontFamily: 'FacebookSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          Icon(
                            Icons.how_to_vote,
                            size: 16,
                            color: isSelected 
                                ? const Color(0xFF4976C2) 
                                : Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          Text(
            "$totalVotes votes",
            style: AppTextStyles.regular14.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildVoterAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.grey[300],
        backgroundImage: CachedNetworkImageProvider(widget.profileImage),
      ),
    );
  }

  /// Handle share functionality for post detail view
  void _handleShare(PostPollItem postDetail) async {
    try {
      String shareText = '';
      String shareUrl = '';
      
      // Build share content from post data
      shareText = '${postDetail.description ?? "Check out this post"}\n\nShared from Haappening';
      shareUrl = postDetail.shareUrl ?? '';
      
      if (postDetail.type == 'Polls') {
        // For polls, share poll question and options
        final content = shareUrl.isNotEmpty ? '$shareText\n\n$shareUrl' : shareText;
        await Share.share(
          content,
          subject: 'Check out this poll on Haappening',
        );
      } else if (postDetail.media.isNotEmpty) {
        final hasVideo = postDetail.media.any((media) => media.type == 'video');
        if (hasVideo) {
          // For video posts
          final content = shareUrl.isNotEmpty ? '$shareText\n\n$shareUrl' : shareText;
          await Share.share(
            content,
            subject: 'Check out this video on Haappening',
          );
        } else {
          // For image posts
          await Share.share(
            shareText,
            subject: 'Check out this post on Haappening',
          );
        }
      } else {
        // For text posts
        final content = shareUrl.isNotEmpty ? '$shareText\n\n$shareUrl' : shareText;
        await Share.share(
          content,
          subject: 'Check out this post on Haappening',
        );
      }
    } catch (e) {
      debugPrint('Error sharing content: $e');
    }
  }
}
