import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../mainPage/widgets/TabBarWidget.dart';
import '../controllers/social_feed_controller.dart';
import '../controller/reaction_controller.dart';
import '../controllers/global_video_manager.dart';
import '../models/post_poll_models.dart';
import '../widgets/PostCardWidget.dart';
import '../widgets/ReactionDisplayWidget.dart';
import '../widgets/shimmer_loading_widgets.dart';
import '../widgets/social_feed_stories_row.dart';
import '../widgets/social_feed_top_bar.dart';

/// Main social feed widget displaying posts and polls from API
class SocialFeedWidget extends StatefulWidget {
  /// Scroll controller for the feed
  final ScrollController scrollController;

  /// Callback when detail view visibility changes
  final Function(bool)? onDetailViewVisible;

  /// Creates a [SocialFeedWidget]
  const SocialFeedWidget({
    super.key,
    required this.scrollController,
    this.onDetailViewVisible,
  });

  @override
  State<SocialFeedWidget> createState() => _SocialFeedWidgetState();
}

class _SocialFeedWidgetState extends State<SocialFeedWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _tabBarKey = GlobalKey();
  late SocialFeedController _controller;
  late ReactionController _reactionController;
  final GlobalVideoManager _globalVideoManager = GlobalVideoManager();

  @override
  void initState() {
    super.initState();
    _controller = SocialFeedController();
    _controller.initializeAnimations(this);

    // Initialize reaction controller
    _reactionController = context.read<ReactionController>();

    // Add listener to detect when tab bar should become sticky
    widget.scrollController.addListener(_updateTabBarPosition);

    // Add listener for pagination
    widget.scrollController.addListener(_handleScrollForPagination);

    // Fetch posts from API
    _controller.fetchPosts();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateTabBarPosition);
    widget.scrollController.removeListener(_handleScrollForPagination);
    _controller.dispose();
    super.dispose();
  }

  void _updateTabBarPosition() {
    _controller.updateTabBarPosition(_tabBarKey, context);
  }

  void _handleScrollForPagination() {
    // Check if we've scrolled near the bottom of the list
    if (widget.scrollController.hasClients) {
      final maxScroll = widget.scrollController.position.maxScrollExtent;
      final currentScroll = widget.scrollController.position.pixels;
      final scrollPercentage = maxScroll > 0 ? (currentScroll / maxScroll) : 0;

      print('Scroll Debug: currentScroll: $currentScroll, maxScroll: $maxScroll, percentage: ${(scrollPercentage * 100).toInt()}%');
      print('Pagination State: hasMoreData: ${_controller.hasMoreData}, isLoadingMore: ${_controller.isLoadingMore}, isLoading: ${_controller.isLoading}');

      // Trigger pagination when user is 70% down the list (reduced threshold for testing)
      if (currentScroll >= maxScroll * 0.7) {
        print('Scroll threshold reached (70%) - calling loadMorePosts');
        _controller.loadMorePosts();
      }

      // Also trigger if user is near the very bottom (within 200 pixels)
      if (maxScroll - currentScroll <= 200) {
        print('Near bottom threshold reached - calling loadMorePosts');
        _controller.loadMorePosts();
      }
    }
  }

  void _pauseAllVideosInFeed() {
    // Pause any playing videos in the post feed using global video manager
    _globalVideoManager.setGlobalPause(true);
    debugPrint('SocialFeedWidget: Pausing all videos in feed');
  }

  void _resumeAllVideosInFeed() {
    // Resume videos in the post feed using global video manager
    _globalVideoManager.setGlobalPause(false);
    debugPrint('SocialFeedWidget: Resuming videos in feed');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<SocialFeedController>(
        builder: (context, controller, child) {
          return PopScope(
            canPop: !controller.showingPostDetail,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop && controller.showingPostDetail) {
                await controller.hidePostDetail(widget.onDetailViewVisible);
              }
            },
            child: SafeArea(
              top: false,
              bottom: false,
              left: false,
              right: false,
              child: Stack(
                children: [
                  // Main content - always rendered but with adjustable opacity
                  if (controller.fadeAnimation != null)
                    AnimatedBuilder(
                      animation: controller.fadeAnimation!,
                      builder: (context, child) {
                        return Opacity(
                          opacity: controller.fadeAnimation!.value,
                          child: IgnorePointer(
                            ignoring: controller.showingPostDetail,
                            child: child,
                          ),
                        );
                      },
                      child: _buildMainContent(controller),
                    )
                  else
                    _buildMainContent(controller),

                  // Post detail view with animation
                  if (controller.showingPostDetail &&
                      controller.postDetail != null &&
                      controller.transitionController != null)
                    PostCardWidget.buildPostDetailView(
                      context: context,
                      postDetail: controller.postDetail!,
                      showingPostDetail: controller.showingPostDetail,
                      isPostDetailExiting: controller.isPostDetailExiting,
                      isFollowingCallback: controller.isFollowing,
                      handleFollowChangedCallback: controller.handleFollowChanged,
                      onDetailBackPressed: () =>
                          controller.hidePostDetail(widget.onDetailViewVisible),
                      transitionController: controller.transitionController!,
                      // Add callback handlers for state changes
                      onLikeChanged: (likeCount, isLiked, reaction) =>
                          _handleDetailLikeChange(controller, likeCount, isLiked, reaction),
                      onCommentCountChanged: (commentCount) =>
                          _handleDetailCommentCountChange(controller, commentCount),
                      onBookmarkChanged: (isBookmarked) =>
                          _handleDetailBookmarkChange(controller, isBookmarked),
                      onShare: () => _handleDetailShare(controller),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(SocialFeedController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshPosts,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.zero,
        itemCount: _getItemCount(controller),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SocialFeedTopBar(
              onLocationChanged: () {
                // Refresh posts when location changes
                controller.refreshPosts();
              },
            );
          } else if (index == 1) {
            return SocialFeedStoriesRow(
              onStoryOpened: () {
                // Pause any playing videos in the feed when a story is opened
                _pauseAllVideosInFeed();
              },
              onStoryClosed: () {
                // Resume videos when story is closed (if needed)
                _resumeAllVideosInFeed();
              },
            );
          } else if (index == 2) {
            return Visibility(
              visible: !controller.isTabBarSticky,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                key: _tabBarKey,
                child: TabBarWidget(
                  onTabChanged: _controller.switchTab,
                ),
              ),
            );
          } else if (controller.isLoading && controller.posts.isEmpty && index == 3) {
            return const PostListShimmerLoading(itemCount: 3);
          } else if (controller.errorMessage != null && index == 3) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load posts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchPosts,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (controller.posts.isEmpty && !controller.isLoading && controller.errorMessage == null && index == 3) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Posts Available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'There are no posts to show right now. Pull to refresh or check back later.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.fetchPosts,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            final postIndex = index - 3;
            if (postIndex < controller.posts.length) {
              return _buildPostCard(controller, controller.posts[postIndex]);
            } else if (postIndex == controller.posts.length && controller.isLoadingMore) {
              // Show loading indicator at the bottom when loading more posts
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Loading more posts...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: 'FacebookSans',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildPostCard(SocialFeedController controller, PostPollItem post) {
    final String username = _getUsername(post);
    final String postId = post.id;
    final String userId = _getUserId(post);
    print("Post Usernae: $username , Post Detail: ${post.follow}");

    // Initialize reaction state for this post only if it doesn't exist
    final existingState = _reactionController.getPostReactionState(postId);
    if (existingState == null) {
      _reactionController.initializePostReaction(
        postId,
        initialLikeCount: post.likesCount,
        isLikedByUser: post.isLikedByUser,
        userReaction: post.userReaction != null ? _mapApiReactionToReactionType(post.userReaction!) : null,
        isBookmarked: post.isPostSaved,
      );
      print('SocialFeedWidget: Initialized reaction state for post $postId - likes: ${post.likesCount}, isLiked: ${post.isLikedByUser}');
    } else {
      print('SocialFeedWidget: Using existing reaction state for post $postId - likes: ${existingState.likeCount}, isLiked: ${existingState.isLiked}');
    }

    return Consumer<ReactionController>(
      builder: (context, reactionController, child) {
        // Get current reaction state from controller to display
        final reactionState = reactionController.getPostReactionState(postId);
        final displayLikes = reactionState?.likeCount ?? post.likesCount;
        // final displayIsLiked = reactionState?.isLiked ?? post.isLikedByUser;
        final displayIsBookmarked = reactionState?.isBookmarked ?? post.isPostSaved;

        return PostCardWidget(
          key: ValueKey(postId),
          profileImage: _getProfileImage(post),
          username: username,
          date: _formatDate(post.updatedAt ?? post.createdAt ?? ''),
          description: post.description ?? post.question ?? '',
          postImage: _getMainPostImage(post),
          likes: displayLikes,
          comments: post.commentCount,
          mediaType: _getPostMediaType(post),
          videoPath: _getVideoPath(post),
          additionalImages: _getAdditionalImages(post),
          pollOptions: _getPollOptions(post),
          totalVotes: _getTotalVotes(post),
          isFollowing: post.follow,//controller.isFollowing(username),
          onFollowChanged: (isFollowing) =>
              controller.handleNewFollowFollowing(post, isFollowing,controller),
          onCommentCountChanged: (newCount) => {
            controller.updatePostCommentCount(post.id, newCount),
            _reactionController.updateCommentCount(postId, newCount),
          },
          onTap: () {
            // Skip detail view for poll posts
            if (post.type == 'Polls') {
              return;
            }
            controller.showPostDetail(post, widget.onDetailViewVisible);
          },
          onShare: () {
            final String shareUrl = post.shareUrl ?? "";
            final String shareText = post.description != null && post.description!.isNotEmpty
                ? '${post.description!}\n\n$shareUrl'
                : shareUrl;

            Share.share(shareText);
          },
          onPostReported: (String postId) {
            _controller.removeReportedPost(postId);
          },
          postId: postId,
          postData: post,
          userId: userId,
          chooseTypeModel: post.chooseTypeModel??"",
          isBookmarked: displayIsBookmarked,
          // Add callback handlers for like and bookmark changes
          onLikeChanged: (likeCount, isLiked, reaction) =>
              _handlePostLikeChange(controller, postId, likeCount, isLiked, reaction),
          onBookmarkChanged: (isBookmarked) =>
              _handlePostBookmarkChange(controller, postId, isBookmarked),
        );
      },
    );
  }

  int _getItemCount(SocialFeedController controller) {
    int baseItems = 3; // Top bar, stories, tab bar
    print('SocialFeedWidget: _getItemCount - isLoading: ${controller.isLoading}, errorMessage: ${controller.errorMessage}, posts.length: ${controller.posts.length}');

    if (controller.isLoading && controller.posts.isEmpty || controller.errorMessage != null) {
      return baseItems + 1; // Add loading or error item
    }

    // Add empty state handling
    if (controller.posts.isEmpty && !controller.isLoading && controller.errorMessage == null) {
      return baseItems + 1; // Add empty state item
    }

    // Add pagination loading indicator if loading more posts
    int itemCount = baseItems + controller.posts.length;
    if (controller.isLoadingMore) {
      itemCount += 1; // Add loading more indicator
    }

    return itemCount;
  }

  String _getUserId(PostPollItem post) {
    if (post.chooseTypeId != null) {
      if (post.chooseTypeId is Map<String, dynamic>) {
        final chooseType = post.chooseTypeId as Map<String, dynamic>;
        final id = chooseType['_id'] as String?;
        if (id != null) {
          return id;
        }
      }
    }
    return 'unknown';
  }

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

  PostMediaType _getPostMediaType(PostPollItem post) {
    if (post.type == 'Polls') return PostMediaType.poll;
    if (post.media.isNotEmpty) {
      // Check if there's any video in media array - prioritize video
      bool hasVideo = post.media.any((media) =>
      media.type == 'video');
      if (hasVideo) return PostMediaType.video;

      // Check for multiple images/media items
      if (post.media.length > 1) return PostMediaType.multiImage;

      // Single image/media item
      return PostMediaType.image;
    }
    return PostMediaType.image;
  }

  String? _getVideoPath(PostPollItem post) {
    // Find the first video in the media array
    for (final media in post.media) {
      if (media.type == 'video') {
        return media.url;
      }
    }
    return null;
  }

  List<String>? _getAdditionalImages(PostPollItem post) {
    if (post.media.length > 1) {
      // Filter out videos and get only images, excluding the first image
      List<String> imageUrls = [];
      bool skipFirst = true;

      for (final media in post.media) {
        if (media.type == 'image') {
          if (skipFirst) {
            skipFirst = false;
            continue; // Skip the first image as it's the main image
          }
          print("Images List: ${media.url}");
          imageUrls.add(media.url ?? '');
        }
      }

      return imageUrls.isNotEmpty ? imageUrls : null;
    }
    return null;
  }

  Map<String, List<String>>? _getPollOptions(PostPollItem post) {
    if (post.options != null && post.options!.isNotEmpty) {
      final Map<String, List<String>> result = {};
      for (int i = 0; i < post.options!.length; i++) {
        final option = post.options![i];
        // Use provided option text or generate placeholder
        final optionText = option.option ?? 'Option ${String.fromCharCode(65 + i)}';
        // Use actual vote count from the API
        result[optionText] = List.generate(option.votes, (index) => 'User${index + 1}');
      }
      return result;
    }
    return null;
  }

  int? _getTotalVotes(PostPollItem post) {
    if (post.options != null) {
      return post.options!.fold<int>(0, (sum, option) => sum + option.votes);
    }
    return null;
  }

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

  // Handle changes from the post detail view and sync back to main post list
  void _handleDetailLikeChange(SocialFeedController controller, int likeCount, bool isLiked, dynamic reaction) {
    // Update the main post data with the new like information
    print('SocialFeedWidget: _handleDetailLikeChange called - likes: $likeCount, isLiked: $isLiked, reaction: $reaction');
    if (controller.postDetail != null) {
      print('SocialFeedWidget: Updating post ${controller.postDetail!.id} in main feed');

      // Update both controller and reaction controller
      controller.updatePostLikeState(controller.postDetail!.id, likeCount, isLiked, reaction as ReactionType?);
      _reactionController.updateReactionState(
        controller.postDetail!.id,
        likeCount: likeCount,
        isLiked: isLiked,
        selectedReaction: reaction as ReactionType?,
      );

      print('SocialFeedWidget: Post update completed');
    } else {
      print('SocialFeedWidget: No postDetail found');
    }
  }

  void _handleDetailCommentCountChange(SocialFeedController controller, int commentCount) {
    // Update the main post data with the new comment count
    if (controller.postDetail != null) {
      controller.updatePostCommentCount(controller.postDetail!.id, commentCount);
    }
  }

  void _handleDetailBookmarkChange(SocialFeedController controller, bool isBookmarked) {
    // Update the main post data with the new bookmark state
    print('SocialFeedWidget: _handleDetailBookmarkChange called - isBookmarked: $isBookmarked');
    if (controller.postDetail != null) {
      print('SocialFeedWidget: Updating bookmark for post ${controller.postDetail!.id} in main feed');

      // Update both controller and reaction controller
      controller.updatePostBookmarkState(controller.postDetail!.id, isBookmarked);
      _reactionController.updateReactionState(
        controller.postDetail!.id,
        isBookmarked: isBookmarked,
      );

      print('SocialFeedWidget: Bookmark update completed');
    } else {
      print('SocialFeedWidget: No postDetail found for bookmark update');
    }
  }

  // Handle like/reaction changes from PostCard in main feed
  void _handlePostLikeChange(SocialFeedController controller, String postId, int likeCount, bool isLiked, dynamic reaction) {
    // Update both controller and reaction controller
    controller.updatePostLikeState(postId, likeCount, isLiked, reaction as ReactionType?);
    _reactionController.updateReactionState(
      postId,
      likeCount: likeCount,
      isLiked: isLiked,
      selectedReaction: reaction as ReactionType?,
    );
  }

  // Handle bookmark changes from PostCard in main feed
  void _handlePostBookmarkChange(SocialFeedController controller, String postId, bool isBookmarked) {
    // Update both controller and reaction controller
    controller.updatePostBookmarkState(postId, isBookmarked);
    _reactionController.updateReactionState(
      postId,
      isBookmarked: isBookmarked,
    );
  }

  // Handle share action from post detail view
  void _handleDetailShare(SocialFeedController controller) async {
    if (controller.postDetail != null) {
      try {
        String shareText = '';
        String shareUrl = '';

        // Build share content from post data
        shareText = '${controller.postDetail!.description ?? "Check out this post"}\n\nShared from Haappening';
        shareUrl = controller.postDetail!.shareUrl ?? '';

        if (controller.postDetail!.type == 'Polls') {
          // For polls, share poll question and options
          final content = shareUrl.isNotEmpty ? '$shareText\n\n$shareUrl' : shareText;
          await Share.share(
            content,
            subject: 'Check out this poll on Haappening',
          );
        } else if (controller.postDetail!.media.isNotEmpty) {
          final hasVideo = controller.postDetail!.media.any((media) => media.type == 'video');
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

  /// Map API UserReaction to UI ReactionType
  ReactionType? _mapApiReactionToReactionType(UserReaction? apiReaction) {
    if (apiReaction == null) return null;

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
}