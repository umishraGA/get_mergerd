import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/core/services/orientation_service.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/comments/comments.dart';
import 'package:myapp/features/mainPage/widgets/MultiImagePostWidget.dart';
import 'package:myapp/features/mainPage/widgets/PostCardWidget.dart';
import 'package:myapp/features/mainPage/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/mainPage/widgets/VideoPostWidget.dart';

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
  });

  @override
  State<PostDetailPageWithZoom> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPageWithZoom>
    with SingleTickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  final CommentsService _commentsService = CommentsService();
  final OrientationService _orientationService = OrientationService();
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

  void _loadCommentCount() {
    final String postId = widget.postImage.hashCode.toString();
    _commentCount = _commentsService.getCommentCount(postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _animationController.dispose();
    _commentsService.removeListener(_updateCommentCount);
    _transformationController.dispose();

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

  void _updateCommentCount() {
    final String postId = widget.postImage.hashCode.toString();
    final newCount = _commentsService.getCommentCount(postId);

    if (newCount != _commentCount) {
      setState(() {
        _commentCount = newCount;
      });
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _selectedReaction = ReactionType.heart;
        _likeCount += 1;
      } else {
        _selectedReaction = null;
        _likeCount = _likeCount > 0 ? _likeCount - 1 : 0;
      }
    });
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

    // Generate a unique post ID based on the post image
    final String postId = widget.postImage.hashCode.toString();

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
    CommentsBottomSheet.show(context, postId);
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
    }
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
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

  void _toggleReaction(ReactionType reaction) {
    setState(() {
      if (_selectedReaction == reaction) {
        // Tapping the same reaction removes it
        _selectedReaction = null;
        _isLiked = false;
        _likeCount = _likeCount > 0 ? _likeCount - 1 : 0;
      } else {
        // Setting a different reaction
        if (_selectedReaction == null) {
          // If no previous reaction, increment count
          _likeCount += 1;
        }
        _selectedReaction = reaction;
        _isLiked = true;
      }

      // Always hide the reaction bar after a selection
      _showReactionBar = false;
      print("Reaction selected, setting _showReactionBar to false");
    });
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
    final String postId = widget.postImage.hashCode.toString();

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
                  _likeCount.toString(),
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
          Icon(
            MdiIcons.shareOutline,
            size: 26,
            color: Colors.white,
          ),

          const Spacer(),

          // Bookmark button
          GestureDetector(
            onTap: _toggleBookmark,
            child: Icon(
              _isBookmarked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
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
            onTap: () =>
                _showComments(context, widget.postImage.hashCode.toString()),
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

  @override
  Widget build(BuildContext context) {
    // Generate a unique post ID based on the post image
    final String postId = widget.postImage.hashCode.toString();
    final theme = Theme.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenSize = MediaQuery.of(context).size;
    const Color primaryRed = Color(0xFFEF3340);

    // Debug output for UI rendering
    print(
        "Building UI with _showReactionBar: $_showReactionBar, _showDetails: $_showDetails");

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
                  child: Image.asset(
                    widget.postImage,
                    fit: BoxFit
                        .contain, // Use contain for proper zooming experience
                    alignment: Alignment.center,
                    gaplessPlayback: true, // Prevent image flicker
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      // This creates a smoother transition by matching the initial layout
                      if (frame == null) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black,
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
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
                      );
                    },
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
                    "Poll content is displayed in the feed view",
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
                    child: const Text('Return to feed'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
