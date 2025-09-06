import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:myapp/features/posts/widgets/PostCardWidget.dart';
import 'package:myapp/features/posts/data/PostPollViewModel.dart';
import 'package:myapp/features/posts/models/post_poll_models.dart';
import 'package:myapp/features/posts/controllers/social_feed_controller.dart';
import 'package:myapp/features/posts/controller/reaction_controller.dart';
import 'package:myapp/features/posts/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/posts/widgets/shimmer_loading_widgets.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  final PostPollViewModel _viewModel = PostPollViewModel();
  bool _isLoading = false;
  late SocialFeedController _controller;
  late ReactionController _reactionController;

  // List to store saved posts from API
  List<PostPollItem> _savedPosts = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = SocialFeedController();
    _controller.initializeAnimations(this);
    
    // Initialize reaction controller
    _reactionController = context.read<ReactionController>();
    
    _loadSavedPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Load saved posts from API
  Future<void> _loadSavedPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _viewModel.getSavePost();
      debugPrint('Saved Posts API Response: success=${response.success}, data=${response.data}');
      
      if (response.success == true && response.data != null && mounted) {
        setState(() {
          _savedPosts = response.data!;
          _isLoading = false;
        });
      } else {
        debugPrint('API response not successful or no data');
        setState(() {
          _savedPosts = [];
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? 'Failed to load saved posts'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading saved posts: $e');
      if (mounted) {
        setState(() {
          _savedPosts = [];
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading saved posts: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Removed unused follow methods since PostCardWidget handles this internally

  Future<void> _removePost(int index) async {
    if (index >= 0 && index < _savedPosts.length) {
      final post = _savedPosts[index];
      
      try {
        // Call API to unsave the post
        final savePostRequest = SavePost(
          postId: post.id,
          postModel: post.type == 'Polls' ? 'Polls' : 'Post',
        );
        
        final response = await _viewModel.savePost(savePostRequest);
        
        if (response.success == true && mounted) {
          setState(() {
            _savedPosts.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Post removed from saved'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove post: ${response.message ?? "Unknown error"}'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error removing post: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error removing post: ${e.toString()}'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
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
                await controller.hidePostDetail(null);
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  'All Saved Posts',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: Stack(
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
                      child: _buildMainContent(),
                    )
                  else
                    _buildMainContent(),

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
                          controller.hidePostDetail(null),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No saved posts yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save posts to view them later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate back to the feed
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Go to Feed'),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return _isLoading
        ? const PostListShimmerLoading(itemCount: 3)
        : _savedPosts.isEmpty
            ? _buildEmptyState()
            : _buildSavedPostsList();
  }

  Widget _buildSavedPostsList() {
    return RefreshIndicator(
      onRefresh: _loadSavedPosts,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: _savedPosts.length,
        itemBuilder: (context, index) {
          final PostPollItem post = _savedPosts[index];
          
          return _buildPostCard(post, index);
        },
      ),
    );
  }

  Widget _buildPostCard(PostPollItem post, int index) {
    final String username = _getPostUsername(post);
    final String postId = post.id;
    final String userId = _getUserId(post);
    
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
    }

    return Consumer<ReactionController>(
      builder: (context, reactionController, child) {
        // Get current reaction state from controller to display
        final reactionState = reactionController.getPostReactionState(postId);
        final displayLikes = reactionState?.likeCount ?? post.likesCount;
        final displayIsBookmarked = reactionState?.isBookmarked ?? post.isPostSaved;
        
        return PostCardWidget(
          key: ValueKey(postId),
          profileImage: _getPostUserImage(post),
          username: username,
          date: _formatDate(post.updatedAt ?? post.createdAt),
          description: post.description ?? post.question ?? '',
          postImage: _getPostImage(post),
          likes: displayLikes,
          comments: post.commentCount,
          mediaType: _getMediaType(post),
          videoPath: _getVideoPath(post),
          additionalImages: _getAdditionalImages(post),
          pollOptions: _getPollOptions(post),
          totalVotes: _getTotalVotes(post),
          isFollowing: post.follow ?? false,
          onFollowChanged: (isFollowing) {
            // Handle follow state change if needed
          },
          onCommentCountChanged: (newCount) {
            // Handle comment count change if needed
          },
          onTap: () {
            // Skip detail view for poll posts
            if (post.type == 'Polls') {
              return;
            }
            _controller.showPostDetail(post, null);
          },
          onShare: () {
            final String shareUrl = post.shareUrl ?? "";
            final String shareText = post.description != null && post.description!.isNotEmpty
                ? '${post.description!}\n\n$shareUrl'
                : shareUrl;
                
            Share.share(shareText);
          },
          onPostReported: (String postId) {
            final reportedIndex = _savedPosts.indexWhere((p) => p.id == postId);
            if (reportedIndex != -1) {
              setState(() {
                _savedPosts.removeAt(reportedIndex);
              });
            }
          },
          postId: postId,
          postData: post,
          userId: userId,
          chooseTypeModel: post.chooseTypeModel ?? "",
          isBookmarked: displayIsBookmarked,
          // Add callback handlers for like and bookmark changes
          onLikeChanged: (likeCount, isLiked, reaction) =>
              _handlePostLikeChange(_controller, postId, likeCount, isLiked, reaction),
          onBookmarkChanged: (isBookmarked) {
            _handlePostBookmarkChange(_controller, postId, isBookmarked);
            // If unbookmarked, remove from saved list
            if (!isBookmarked) {
              _removePost(index);
            }
          },
        );
      },
    );
  }

  // Helper method to determine media type from post data
  PostMediaType _getMediaType(PostPollItem post) {
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

  // Helper methods to extract data from PostPollItem
  String _getPostUserImage(PostPollItem post) {
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

  String _getPostUsername(PostPollItem post) {
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

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    
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

  String _getPostImage(PostPollItem post) {
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
          imageUrls.add(media.url ?? '');
        }
      }
      
      return imageUrls.isNotEmpty ? imageUrls : null;
    }
    return null;
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

  Map<String, List<String>>? _getPollOptions(PostPollItem post) {
    if (post.options != null && post.options!.isNotEmpty) {
      final Map<String, List<String>> result = {};
      for (int i = 0; i < post.options!.length; i++) {
        final option = post.options![i];
        // Use provided option text or generate placeholder
        final optionText = option.option ?? 'Option ${String.fromCharCode(65 + i)}';
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

  // Handle changes from the post detail view and sync back to main post list
  void _handleDetailLikeChange(SocialFeedController controller, int likeCount, bool isLiked, dynamic reaction) {
    // Update the main post data with the new like information
    if (controller.postDetail != null) {
      // Update both controller and reaction controller
      controller.updatePostLikeState(controller.postDetail!.id, likeCount, isLiked, reaction as ReactionType?);
      _reactionController.updateReactionState(
        controller.postDetail!.id,
        likeCount: likeCount,
        isLiked: isLiked,
        selectedReaction: reaction as ReactionType?,
      );
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
    if (controller.postDetail != null) {
      // Update both controller and reaction controller
      controller.updatePostBookmarkState(controller.postDetail!.id, isBookmarked);
      _reactionController.updateReactionState(
        controller.postDetail!.id,
        isBookmarked: isBookmarked,
      );
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
        shareText = '${controller.postDetail!.description ?? "Check out this post"}\\n\\nShared from Haappening';
        shareUrl = controller.postDetail!.shareUrl ?? '';
        
        if (controller.postDetail!.type == 'Polls') {
          // For polls, share poll question and options
          final content = shareUrl.isNotEmpty ? '$shareText\\n\\n$shareUrl' : shareText;
          await Share.share(
            content,
            subject: 'Check out this poll on Haappening',
          );
        } else if (controller.postDetail!.media.isNotEmpty) {
          final hasVideo = controller.postDetail!.media.any((media) => media.type == 'video');
          if (hasVideo) {
            // For video posts
            final content = shareUrl.isNotEmpty ? '$shareText\\n\\n$shareUrl' : shareText;
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
          final content = shareUrl.isNotEmpty ? '$shareText\\n\\n$shareUrl' : shareText;
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
