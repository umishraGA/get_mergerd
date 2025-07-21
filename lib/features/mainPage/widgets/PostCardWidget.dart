import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/comments/comments.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/mainPage/data/open_video_from.dart';
import 'package:myapp/features/mainPage/widgets/MultiImagePostWidget.dart';
import 'package:myapp/features/mainPage/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/mainPage/widgets/VideoPostWidget.dart';
import 'package:myapp/features/postDetail/PostDetailPageWithZoom.dart';
import 'package:myapp/features/postDetail/widgets/SimpleReadMoreWidget.dart';

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
  final Map<String, List<String>>? pollOptions;
  final int? totalVotes;

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
    this.pollOptions,
    this.totalVotes,
  });

  /// Builds a post detail view with zoom and animations
  ///
  /// This static method can be used to create a post detail view with animations
  /// when transitioning between feed and detail views.
  static Widget buildPostDetailView({
    required BuildContext context,
    required Map<String, Object> postDetail,
    required bool showingPostDetail,
    required bool isPostDetailExiting,
    required bool Function(String) isFollowingCallback,
    required Function(String, bool) handleFollowChangedCallback,
    required VoidCallback onDetailBackPressed,
    required AnimationController transitionController,
  })
  {
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
                  onBack: onDetailBackPressed,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  bool _isFollowing = false;
  bool _isBookmarked = false;
  int _likeCount = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showBigHeart = false;
  int _commentCount = 0;
  final CommentsService _commentsService = CommentsService();
  ReactionType? _selectedReaction;
  bool _showReactionBar = false;
  final GlobalKey _likeButtonKey = GlobalKey();
  final _player = AudioPlayer();
  bool _showReactionsList = false;
  String? _selectedPollOption;

  // Map to store recent reactions with usernames
  final Map<ReactionType, List<String>> _recentReactions = {
    ReactionType.love: ['John', 'Sarah'],
    ReactionType.haha: ['Mike'],
    ReactionType.wow: ['Emma'],
  };

  @override
  void initState() {
    super.initState();
    _likeCount = widget.likes;
    _commentCount = widget.comments;
    _isFollowing = widget.isFollowing;
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

  void _updateCommentCount() {
    final String postId = widget.postImage.hashCode.toString();
    final newCount = _commentsService.getCommentCount(postId);

    if (newCount != _commentCount) {
      setState(() {
        _commentCount = newCount;
      });
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

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _selectedReaction = ReactionType.heart;
        _likeCount += 1;

        // Update recent reactions
        if (_recentReactions.containsKey(ReactionType.heart)) {
          // Remove 'You' first to avoid duplicates
          _recentReactions[ReactionType.heart]!.remove('You');
          // Add 'You' to the beginning of the list
          _recentReactions[ReactionType.heart]!.insert(0, 'You');
        } else {
          _recentReactions[ReactionType.heart] = ['You'];
        }

        _playLikeSound();
      } else {
        _selectedReaction = null;
        _likeCount = _likeCount > 0 ? _likeCount - 1 : 0;

        // Remove your reaction from recent reactions
        _recentReactions.forEach((key, usernames) {
          usernames.remove('You');
        });
      }
    });
  }

  void _doubleTapLike() {
    // Only animate if not already liked
    if (!_isLiked) {
      setState(() {
        _isLiked = true;
        _likeCount += 1;
        _showBigHeart = true;
        _selectedReaction = ReactionType.heart;

        // Update recent reactions
        if (_recentReactions.containsKey(ReactionType.heart)) {
          // Remove 'You' first to avoid duplicates
          _recentReactions[ReactionType.heart]!.remove('You');
          // Add 'You' to the beginning of the list
          _recentReactions[ReactionType.heart]!.insert(0, 'You');
        } else {
          _recentReactions[ReactionType.heart] = ['You'];
        }
      });

      _playLikeSound();

      // Reset and play animation with smooth transition
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _showComments(BuildContext context, String postId) {
    // Pass reaction data to the comments sheet
    CommentsBottomSheet.show(
      context,
      postId,
      recentReactions: _recentReactions,
      selectedReaction: _selectedReaction,
      likeCount: _likeCount,
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    // Show a short feedback message
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked
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
                            PostMediaType.video => isTablet ? 400 : 250,
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
                  if (!_showReactionBar) _buildActionBar(context, theme),
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
                      backgroundImage: AssetImage(widget.profileImage),
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
            onPressed: () {
              widget.onFollowChanged?.call(!widget.isFollowing);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  widget.isFollowing ? Colors.white : const Color(0xFF4976C2),
              backgroundColor: widget.isFollowing
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
              widget.isFollowing ? 'Following' : 'Follow',
              style: AppTextStyles.semiBold14.copyWith(
                color:
                    widget.isFollowing ? Colors.white : const Color(0xFF4976C2),
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
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post reported for: $option'),
            duration: const Duration(seconds: 2),
          ),
        );
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
  // if mediya is vedio then this screen open
  Widget _buildPostMedia(BuildContext context, bool isTablet) {
    switch (widget.mediaType) {
      case PostMediaType.video:
       // if mediya is vedio then this screen open
        return Container(
          height: isTablet ? 400 : 250,
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
                      // Image with hero animation
                      Hero(
                        tag: 'image-${widget.postImage}',
                        child: Image.asset(
                          widget.postImage,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                          height: isTablet ? 600 : 300,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
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
                            );
                          },
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
  Widget _buildActionBar(BuildContext context, ThemeData theme) {
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
                _showComments(context, widget.postImage.hashCode.toString()),
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

          // Share button - using Icon for consistency
          Icon(
            MdiIcons.shareOutline,
            size: 26,
            color: Colors.grey[600],
          ),
          const Spacer(),

          // Bookmark button
          GestureDetector(
            onTap: _toggleBookmark,
            child: Icon(
              _isBookmarked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
              color: _isBookmarked ? const Color(0xFF4976C2) : Colors.grey[600],
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
                          : Color(0xFFEEEEEE),
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
                  decoration: BoxDecoration(
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
            decoration: BoxDecoration(
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
              decoration: BoxDecoration(
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
  Widget _buildReactionIcon() {
    if (_selectedReaction == null) {

      return Icon(
        _isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
        color: _isLiked ? Colors.red : Colors.grey[600],
        size: 26,
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
          color: _isLiked ? Colors.red : Theme.of(context).colorScheme.primary,
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

  void _toggleReaction(ReactionType reaction) {
    setState(() {
      if (_selectedReaction == reaction) {
        // Tapping the same reaction removes it
        _selectedReaction = null;
        _isLiked = false;
        _likeCount = _likeCount > 0 ? _likeCount - 1 : 0;

        // Remove your reaction from the recent reactions
        _recentReactions.forEach((key, usernames) {
          usernames.remove('You');
        });
      } else {
        // Setting a different reaction
        if (_selectedReaction == null) {
          // If no previous reaction, increment count
          _likeCount += 1;
        } else {
          // Remove previous reaction if there was one
          _recentReactions.forEach((key, usernames) {
            usernames.remove('You');
          });
        }

        // Add new reaction
        _selectedReaction = reaction;
        _isLiked = true;

        // Add this reaction to the recent reactions
        if (_recentReactions.containsKey(reaction)) {
          // Remove 'You' first to avoid duplicates
          _recentReactions[reaction]!.remove('You');
          // Add 'You' to the beginning of the list
          _recentReactions[reaction]!.insert(0, 'You');
        } else {
          _recentReactions[reaction] = ['You'];
        }

        _playLikeSound();
      }
    });
  }

  // Show the reaction selector bar
  void _showReactionSelector() {
    setState(() {
      _showReactionBar = true;
    });
  }

  // Helper method to build recent reactions display
  Widget _buildRecentReactions() {
    return ReactionDisplayWidget(
      reactionCount: _likeCount,
      recentReactions: _recentReactions,
      currentUserReaction: _selectedReaction,
    );
  }

  // Poll widget implementation
  Widget _buildPollWidget(BuildContext context) {
    final theme = Theme.of(context);
    final totalVotes = widget.totalVotes ?? 15;

    if (widget.pollOptions == null || widget.pollOptions!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tire Pressure Monitoring System Design Vote! 📸",
            style: AppTextStyles.semiBold18,
          ),
          const SizedBox(height: 8),
          const Text(
            "Please check the following comment pict... See more",
            style: AppTextStyles.medium15,
          ),
          const SizedBox(height: 16),
          ...widget.pollOptions!.entries.map((entry) {
            final option = entry.key;
            final voters = entry.value;
            final isSelected = _selectedPollOption == option;
            final voteCount = voters.length;
            final votePercentage =
                totalVotes > 0 ? (voteCount / totalVotes) * 100 : 0;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPollOption = option;
                });
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
                    // Progress bar for selected option
                    if (isSelected)
                      Positioned.fill(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: votePercentage / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF4976C2).withOpacity(0.2),
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
                          Text(
                            option,
                            style: AppTextStyles.semiBold16.copyWith(
                              color: isSelected
                                  ? const Color(0xFF4976C2)
                                  : Colors.black,
                            ),
                          ),
                          const Spacer(),

                          // Voter avatars
                          if (voters.isNotEmpty)
                            Row(
                              children: [
                                ...voters
                                    .take(3)
                                    .map((voter) => _buildVoterAvatar()),
                              ],
                            ),

                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[600],
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
        backgroundImage: AssetImage(widget.profileImage),
      ),
    );
  }
}
