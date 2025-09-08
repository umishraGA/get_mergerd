import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/features/posts/widgets/NetworkImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/core/services/orientation_service.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/comments/comments.dart';
import 'package:myapp/features/posts/widgets/MultiImagePostWidget.dart';
import 'package:myapp/features/posts/widgets/PostCardWidget.dart';
import 'package:myapp/features/posts/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/posts/widgets/VideoPostWidget.dart';
import 'package:myapp/features/posts/models/post_poll_models.dart';
import 'package:myapp/features/posts/data/PostPollViewModel.dart';
import 'package:myapp/features/posts/controller/post_controller.dart';
import 'package:myapp/features/posts/controller/reaction_controller.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/SimpleReadMoreWidget.dart';

// Uncomment if not using the enum from PostCardWidget
// enum ReactionType {
//   like,
//   love,
//   haha,
//   wow,
//   sad,
//   angry,
//   heart,
// }

class PostDetailPageWithZoom extends StatefulWidget {
  final String username;
  final String followers;
  final String postImage;
  final String profileImage;
  final String description;
  final String location;
  final VoidCallback onBack;
  final PostMediaType mediaType;
  final List<String>? additionalImages;
  final String? videoPath;
  final bool isFollowing;
  final Function(bool)? onFollowChanged;
  final String? userId;
  // New parameters for API integration
  final PostPollItem? postData;
  final String? postId;
  final int? initialLikeCount;
  final int? initialCommentCount;
  final bool? isLikedByUser;
  final bool? isBookmarked;
  final UserReaction? userReaction;
  
  // Callback functions to notify parent of changes
  final Function(int likeCount, bool isLiked, ReactionType? reaction)? onLikeChanged;
  final Function(int commentCount)? onCommentCountChanged;
  final Function(bool isBookmarked)? onBookmarkChanged;
  final VoidCallback? onShare;

  const PostDetailPageWithZoom({
    super.key,
    required this.username,
    required this.followers,
    required this.postImage,
    required this.profileImage,
    required this.description,
    required this.location,
    required this.onBack,
    this.mediaType = PostMediaType.image,
    this.additionalImages,
    this.videoPath,
    this.isFollowing = false,
    this.onFollowChanged,
    this.userId,
    // New optional parameters
    this.postData,
    this.postId,
    this.initialLikeCount,
    this.initialCommentCount,
    this.isLikedByUser,
    this.isBookmarked,
    this.userReaction,
    // Callback functions
    this.onLikeChanged,
    this.onCommentCountChanged,
    this.onBookmarkChanged,
    this.onShare,
  });

  @override
  State<PostDetailPageWithZoom> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPageWithZoom>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final CommentsService _commentsService = CommentsService();
  final OrientationService _orientationService = OrientationService();
  final PostPollViewModel _viewModel = PostPollViewModel();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Use common reaction controller
  late final ReactionController _reactionController;
  bool _isLiked = false;
  bool _isFollowing = false;
  int _likeCount = 23; // Default like count
  int _commentCount = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBigHeart = false;
  bool _showDetails = true; // Whether to show post details overlay
  bool _showInitialTooltip = true; // Show initial tooltip
  bool _isBookmarked = false; // Track bookmark state
  ReactionType? _selectedReaction; // Track selected reaction
  bool _showReactionBar = false; // Control visibility of reaction selector
  bool _isProcessingLike = false; // Prevent multiple simultaneous like requests
  bool _isProcessingBookmark = false; // Prevent multiple simultaneous bookmark requests
  final GlobalKey _likeButtonKey =
      GlobalKey(); // Reference for positioning reaction bar

  // For dismissing reaction bar when tapping outside
  final GlobalKey _reactionBarKey = GlobalKey();

  // Image viewing controls
  final TransformationController _transformationController =
      TransformationController();
  bool _isZooming = false;

  @override
  void initState() {
    super.initState();
    _loadCommentCount();
    _isFollowing = widget.isFollowing;
    
    // Initialize common reaction controller
    _reactionController = context.read<ReactionController>();
    
    // Initialize state from widget parameters
    _likeCount = widget.initialLikeCount ?? 23;
    _commentCount = widget.initialCommentCount ?? _commentCount;
    _isLiked = widget.isLikedByUser ?? false;
    _isBookmarked = widget.isBookmarked ?? false;
    
    // Initialize reaction from API data
    if (widget.userReaction != null) {
      _selectedReaction = _mapApiReactionToReactionType(widget.userReaction!);
      _isLiked = true;
    }
    
    // Initialize reaction controller with post data
    if (widget.postId != null) {
      // Check if state already exists in controller
      final existingState = _reactionController.getPostReactionState(widget.postId!);
      
      if (existingState != null) {
        // Use existing state from controller
        _likeCount = existingState.likeCount;
        _isLiked = existingState.isLiked;
        _selectedReaction = existingState.selectedReaction;
        _isBookmarked = existingState.isBookmarked;
        if (existingState.commentCount > 0) {
          _commentCount = existingState.commentCount;
        }
        print('PostDetailPageWithZoom: Using existing state from ReactionController - likes: $_likeCount, isLiked: $_isLiked, reaction: $_selectedReaction');
      } else {
        // Initialize with new state
        _reactionController.initializePostReaction(
          widget.postId!,
          initialLikeCount: _likeCount,
          isLikedByUser: _isLiked,
          userReaction: _selectedReaction,
          isBookmarked: _isBookmarked,
        );
        print('PostDetailPageWithZoom: Initialized new state in ReactionController - likes: $_likeCount, isLiked: $_isLiked, reaction: $_selectedReaction');
      }
      
      // Listen to reaction updates
      _reactionController.addListener(_onReactionUpdated);
    }

    // Initialize audio player
    _initAudio();

    // Set orientation based on media type
    _setOrientationBasedOnMediaType();

    // Initialize animation controller for like heart animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Create scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Add status listener to reset big heart animation
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
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

    // Set system UI overlay style for immersive experience with light theme
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    // Hide status bar for truly immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Auto-hide initial tooltip after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showInitialTooltip = false;
        });
      }
    });
  }

  // Set the orientation based on media type
  void _setOrientationBasedOnMediaType() async {
    if (widget.mediaType == PostMediaType.video) {
      // Allow all orientations for videos
      await _orientationService.setAllOrientations();
    } else {
      // Force portrait for other media types
      await _orientationService.setPortraitMode();
    }
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset('assets/audio/like_audio.mp3');
    } catch (e) {
      debugPrint('Error initializing like audio: $e');
    }
  }

  void _loadCommentCount() {
    // Use actual post ID if available, otherwise fallback to hash
    final String postId = widget.postId ?? widget.postImage.hashCode.toString();
    _commentCount = _commentsService.getCommentCount(postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    _commentsService.removeListener(_updateCommentCount);
    _reactionController.removeListener(_onReactionUpdated);
    _transformationController.dispose();
    _audioPlayer.dispose();

    // Reset to portrait mode when leaving the page
    _orientationService.setPortraitMode();

    // Restore system UI overlay style when leaving
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    // ));
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: SystemUiOverlay.values,
    // );

    super.dispose();
  }

  void _onReactionUpdated() {
    if (widget.postId != null) {
      final updates = _reactionController.reactionUpdates;
      if (updates.containsKey(widget.postId!)) {
        final state = updates[widget.postId!]!;
        if (mounted) {
          setState(() {
            _likeCount = state.likeCount;
            _isLiked = state.isLiked;
            _selectedReaction = state.selectedReaction;
            _isBookmarked = state.isBookmarked;
            if (state.commentCount > 0) {
              _commentCount = state.commentCount;
            }
          });
        }
      }
    }
  }

  void _updateCommentCount() {
    // Use actual post ID if available, otherwise fallback to hash
    final String postId = widget.postId ?? widget.postImage.hashCode.toString();
    final newCount = _commentsService.getCommentCount(postId);

    if (newCount != _commentCount) {
      setState(() {
        _commentCount = newCount;
      });
      
      // Update reaction controller
      if (widget.postId != null) {
        _reactionController.updateCommentCount(widget.postId!, newCount);
      }
      
      // Notify parent of comment count change
      widget.onCommentCountChanged?.call(_commentCount);
    }
  }

  void _toggleLike() async {
    if (_isProcessingLike || widget.postId == null) return;
    
    setState(() {
      _isProcessingLike = true;
    });

    try {
      final success = await _reactionController.toggleLike(
        widget.postId!,
        widget.postData,
        widget.mediaType,
      );
      
      // Get current state for comparison
      final currentState = _reactionController.getPostReactionState(widget.postId!);
      if (success && currentState != null && currentState.isLiked && !_isLiked) {
        _playLikeSound();
      }
      
      // Get updated state from controller
      final state = _reactionController.getPostReactionState(widget.postId!);
      if (state != null) {
        // Notify parent of like change
        print('PostDetailPageWithZoom: Calling onLikeChanged with likes: ${state.likeCount}, isLiked: ${state.isLiked}, reaction: ${state.selectedReaction}');
        widget.onLikeChanged?.call(state.likeCount, state.isLiked, state.selectedReaction);
      }


    } catch (e) {
      debugPrint('Error toggling like: $e');

    } finally {
      if (mounted) {
        setState(() {
          _isProcessingLike = false;
        });
      }
    }
  }

  Future<void> _playLikeSound() async {
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing like sound: $e');
    }
  }

  void _toggleFollow() {
    final newFollowState = !_isFollowing;
    setState(() {
      _isFollowing = newFollowState;
    });

    // Notify parent widget about follow state change
    if (widget.onFollowChanged != null) {
      widget.onFollowChanged!(newFollowState);
    }
  }

  void _handleSendComment(String comment) {
    if (comment.trim().isEmpty) return;

    // Use actual post ID if available, otherwise fallback to hash
    final String postId = widget.postId ?? widget.postImage.hashCode.toString();

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: 'You',
      userImage: 'assets/images/username_comment.png',
      text: comment.trim(),
      timestamp: DateTime.now(),
    );

    _commentsService.addComment(postId, newComment);
    _commentController.clear();
  }

  void _showComments(BuildContext context, String postId) {
    // Use actual post ID if available, otherwise fallback to hash
    final String actualPostId = widget.postId ?? postId;
    CommentsBottomSheet.show(context, actualPostId);
  }

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;

      // Hide reaction bar when details are toggled
      if (!_showDetails) {
        _showReactionBar = false;
      }
    });
  }

  // Handle image interaction
  void _onInteractionStart(ScaleStartDetails details) {
    // Detect two-finger gestures specifically
    if (details.pointerCount >= 2) {
      setState(() {
        _isZooming = true;
        _showDetails = false;
      });
    }
  }

  // Called when user ends interactiveViewer interaction
  void _onInteractionEnd(ScaleEndDetails details) {
    if (_transformationController.value.getMaxScaleOnAxis() <= 1.0) {
      setState(() {
        _isZooming = false;
        _showDetails = true;
      });
      // Reset transformation
      _transformationController.value = Matrix4.identity();
    }
  }

  // Handle double tap to zoom in/out
  void _handleDoubleTap(TapDownDetails details) {
    if (_transformationController.value != Matrix4.identity()) {
      // If already zoomed in, zoom out to original size
      _transformationController.value = Matrix4.identity();
      setState(() {
        _isZooming = false;
        _showDetails = true;
      });
    } else {
      // If at original size, zoom in to where user tapped
      // Calculate tap position relative to screen center
      final screenSize = MediaQuery.of(context).size;
      final tapPosition = details.localPosition;

      // Create a matrix that zooms into the tapped point
      final Matrix4 matrix = Matrix4.identity();

      // Scale first around center point
      matrix.scale(2.5);

      // Then translate to focus on tap point
      // We need to adjust for the scaling factor
      const double inverseScale =
          -1.0; // Negative to move in opposite direction
      final double dx =
          (tapPosition.dx - (screenSize.width / 2)) * inverseScale;
      final double dy =
          (tapPosition.dy - (screenSize.height / 2)) * inverseScale;

      matrix.translate(dx, dy);

      _transformationController.value = matrix;
      setState(() {
        _isZooming = true;
        _showDetails = false;
      });
    }
  }

  void _doubleTapLike() {
    // Only animate if not already liked
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _selectedReaction = ReactionType.heart;
        _likeCount += 1;
        _showBigHeart = true;
      });

      // Play animation
      _animationController.reset();
      _animationController.forward();
      
      // Notify parent of like change
      widget.onLikeChanged?.call(_likeCount, _isLiked, _selectedReaction);
    }
  }

  void _toggleBookmark() async {
    if (_isProcessingBookmark || widget.postId == null) return;
    
    setState(() {
      _isProcessingBookmark = true;
    });

    try {
      final success = await _reactionController.toggleBookmark(
        widget.postId!,
        widget.postData,
      );
      
      if (success) {
        _showBookmarkMessage();
        
        // Get updated state from controller
        final state = _reactionController.getPostReactionState(widget.postId!);
        if (state != null) {
          // Notify parent of bookmark change
          print('PostDetailPageWithZoom: Calling onBookmarkChanged with isBookmarked: ${state.isBookmarked}');
          widget.onBookmarkChanged?.call(state.isBookmarked);
        }
      } else {
        // Show error message
        // if (mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Failed to ${_isBookmarked ? "remove" : "save"} post'),
        //       backgroundColor: Colors.red,
        //       duration: const Duration(seconds: 2),
        //     ),
        //   );
        // }
      }
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Failed to ${_isBookmarked ? "remove" : "save"} post: ${e.toString()}'),
      //       backgroundColor: Colors.red,
      //       duration: const Duration(seconds: 2),
      //     ),
      //   );
      // }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingBookmark = false;
        });
      }
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

  /// Handle share functionality
  void _handleShare() async {
    try {
      widget.onShare?.call();
    }catch(e) {}

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

  // Add reaction-related methods
  Widget _buildReactionIcon() {
    if (_selectedReaction == null) {
      return Icon(
        _isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
        color: _isLiked ? Colors.red : Colors.white,
        size: 32,
      );
    }

    // Return the selected reaction
    switch (_selectedReaction) {
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
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? Colors.red : Colors.black,
          size: 32,
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

  void _toggleReaction(ReactionType reaction) async {
    if (_isProcessingLike || widget.postId == null) return;
    
    setState(() {
      _isProcessingLike = true;
      _showReactionBar = false; // Hide reaction bar immediately
    });

    try {
      final success = await _reactionController.toggleReaction(
        widget.postId!,
        reaction,
        widget.postData,
        widget.mediaType,
      );
      
      // Get updated state from controller
      final state = _reactionController.getPostReactionState(widget.postId!);
      if (state != null) {
        // Play sound if newly liked
        if (state.isLiked && state.selectedReaction == reaction && !_isLiked) {
          _playLikeSound();
        }
        
        // Notify parent of reaction change
        print('PostDetailPageWithZoom: Calling onLikeChanged (reaction) with likes: ${state.likeCount}, isLiked: ${state.isLiked}, reaction: ${state.selectedReaction}');
        widget.onLikeChanged?.call(state.likeCount, state.isLiked, state.selectedReaction);
      }
      
      // if (!success && mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Reaction saved locally - will sync when connection improves'),
      //       backgroundColor: Colors.orange,
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // }
    } catch (e) {
      debugPrint('Error toggling reaction: $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Reaction saved locally - will sync when connection improves'),
      //       backgroundColor: Colors.orange,
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingLike = false;
        });
      }
    }
  }

  Widget _buildReactionSelector() {
    return Positioned(
      key: _reactionBarKey,
      bottom: 60, // Position closer to the action bar
      left: -40,
      right: 0,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 250),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            height: 52,
            width: 320,
            decoration: BoxDecoration(
              color: Colors.black,
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
          // We're now handling this in _toggleReaction
          // setState(() {
          //   _showReactionBar = false;
          // });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? _getReactionColor(reaction).withOpacity(0.2)
                : Colors.transparent,
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 26),
          ),
        ),
      ),
    );
  }

  // Add the action bar method
  Widget _buildActionBar(BuildContext context) {
    // Use actual post ID if available, otherwise fallback to hash
    final String postId = widget.postId ?? widget.postImage.hashCode.toString();
    
    // Get current bookmark state from ReactionController
    final PostReactionState? reactionState = widget.postId != null 
        ? _reactionController.getPostReactionState(widget.postId!)
        : null;
    final bool currentIsBookmarked = reactionState?.isBookmarked ?? _isBookmarked;
    
    // Calculate total reaction count (likes + all other reactions)
    final int totalReactionCount = _calculateTotalReactionCount(_likeCount, widget.postData);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button with reactions support
          GestureDetector(
            key: _likeButtonKey,
            onTap: _toggleLike,
            onLongPress: () {
              print("Long press on like button, showing reaction bar");
              setState(() {
                _showReactionBar = true;
              });
            },
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.elasticOut,
                  child: _buildReactionIcon(),
                ),
                const SizedBox(width: 4),
                Text(
                  totalReactionCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'FacebookSans',
                    color: _selectedReaction != null
                        ? _getReactionColor(_selectedReaction!)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Comment button
          GestureDetector(
            onTap: () => _showComments(context, postId),
            child: Row(
              children: [
                Icon(
                  MdiIcons.commentOutline,
                  size: 26,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _commentCount.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'FacebookSans',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Share button
          GestureDetector(
            onTap: _handleShare,
            child: Icon(
              MdiIcons.shareOutline,
              size: 26,
              color: Colors.white,
            ),
          ),

          const Spacer(),

          // Bookmark button
          GestureDetector(
            onTap: _toggleBookmark,
            child: Icon(
              currentIsBookmarked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBarHidden(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Like button with reactions support
          GestureDetector(
            onTap: () {
              print(
                  "Tapped to hide reaction bar, current state: $_showReactionBar");
              if (_showReactionBar) {
                setState(() {
                  _showReactionBar = false;
                });
                print("After setState, _showReactionBar: $_showReactionBar");
              }
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
            onTap: () {
              // Use actual post ID if available, otherwise fallback to hash
              final String postId = widget.postId ?? widget.postImage.hashCode.toString();
              _showComments(context, postId);
            },
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

          // Share button - replaced with dot but still functional
          GestureDetector(
            onTap: _handleShare,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEEEEEE),
              ),
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

  @override
  Widget build(BuildContext context) {
    // Use actual post ID if available, otherwise fallback to hash
    final String postId = widget.postId ?? widget.postImage.hashCode.toString();
    final theme = Theme.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenSize = MediaQuery.of(context).size;
    const Color primaryRed = Color(0xFFEF3340);

    // Debug output for UI rendering
    print(
        "Building UI with _showReactionBar: $_showReactionBar, _showDetails: $_showDetails");

    return Consumer<ReactionController>(
      builder: (context, reactionController, child) {
        // Get reaction state from controller if available, otherwise use local state
        final PostReactionState? reactionState = widget.postId != null 
            ? reactionController.getPostReactionState(widget.postId!)
            : null;
        
        final bool currentIsBookmarked = reactionState?.isBookmarked ?? _isBookmarked;

        return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          // Add this GestureDetector to dismiss reaction bar when tapping outside
          onTap: () {
            if (_showReactionBar) {
              print("Tapped on scaffold, dismissing reaction bar");
              setState(() {
                _showReactionBar = false;
              });
            }
          },
          child: Container(
            child: Stack(
              fit: StackFit.expand, // Make stack fill the entire screen
              children: [
                // Main content - centered and full screen
                Positioned.fill(
                  child: _buildMediaContent(),
                ),

                // Animated heart overlay on double tap
                if (_showBigHeart)
                  Center(
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red.withOpacity(0.8),
                            size: 120,
                          ),
                        );
                      },
                    ),
                  ),

                if (_showDetails) ...[
                  // Top bar with back button and username - with slide-in animation
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutQuart,
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset:
                              Offset(0, -20 * (1 - value)), // Slide down effect
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.97),
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(
                            16, statusBarHeight + 8, 16, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                // Set _showDetails to false for smoother exit animation
                                setState(() {
                                  _showDetails = false;
                                });
                                // Small delay before navigation
                                Future.delayed(
                                    const Duration(milliseconds: 150), () {
                                  widget.onBack();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.white),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Username and followers (expanded section)
                            const Expanded(
                                child: SizedBox(
                              width: 10,
                            )),

                            // More options icon
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.more_vert,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Bottom controls with slide-up animation
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutQuart,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset:
                              Offset(0, 30 * (1 - value)), // Slide up effect
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.97),
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Description with Read more/less button
                            Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: SimpleReadMoreWidget(
                                text: widget.description,
                                trimLines: 3,
                                style: AppTextStyles.medium15.copyWith(
                                  color: Colors.white,
                                ),
                                trimCollapsedButtonStyle: const TextStyle(
                                  color: primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'FacebookSans',
                                ),
                              ),
                            ),

                            // Action bar
                            if (!_showReactionBar) _buildActionBar(context),
                            if (_showReactionBar)
                              _buildActionBarHidden(context, theme),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // Two-finger zoom indicator - only shown when zooming
                if (_isZooming && widget.mediaType == PostMediaType.image)
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.zoom_out_map,
                              size: 18,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pinch to zoom • Tap to show details',
                              style: AppTextStyles.medium14.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Reaction selector overlay
                if (_showReactionBar && _showDetails) _buildReactionSelector(),
              ],
            ),
          ),
        ));
      },
    );
  }

  Widget _buildMediaContent() {
    switch (widget.mediaType) {
      case PostMediaType.image:
        return GestureDetector(
          onTap: _toggleDetails,
          onDoubleTapDown: _handleDoubleTap,
          onDoubleTap: () {}, // Empty callback to prevent default behavior
          onLongPress: _doubleTapLike,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.8,
            maxScale: 6.0,
            onInteractionStart: _onInteractionStart,
            onInteractionEnd: _onInteractionEnd,
            panEnabled: true,
            scaleEnabled: true,
            constrained: true,
            clipBehavior: Clip.none,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Hero(
                tag: 'image-${widget.postImage}',
                createRectTween: (begin, end) {
                  // Create a custom RectTween for smoother animation
                  return RectTween(
                    begin: begin,
                    end: end,
                  );
                },
                child: Center(
                  child: NetworkImageWidget(
                    imageUrl: widget.postImage,
                    fit: BoxFit
                        .contain, // Use contain for proper zooming experience
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      case PostMediaType.video:
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black, // White background for video
          child: Center(
            child: VideoPostWidget(
              videoPath: widget.videoPath ??
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
              thumbnailPath: widget.postImage,
              onDoubleTap: _doubleTapLike,
              onTap: _toggleDetails,
              postId: widget.postId ?? '',
            ),
          ),
        );

      case PostMediaType.multiImage:
        final allImages = [widget.postImage, ...?widget.additionalImages];
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Center(
            child: GestureDetector(
              onTap: _toggleDetails,
              child: MultiImagePostWidget(
                imagePaths: allImages,
                height: double.infinity,
                onTap: (_) => _toggleDetails(),
                borderRadius:
                    BorderRadius.zero, // Remove border radius in detail view
                isDetailView:
                    true, // Flag this as detail view for proper transitions
              ),
            ),
          ),
        );

      case PostMediaType.poll:
        // Display a placeholder for polls in zoom view
        return GestureDetector(
          onTap: _toggleDetails,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.poll,
                    size: 64,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Poll content is displayed in the posts view",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontFamily: 'FacebookSans',
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: widget.onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Return to posts'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
