import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/posts/widgets/ReactionDisplayWidget.dart';
import 'package:myapp/features/posts/widgets/DynamicReactionDisplayWidget.dart';
import 'package:myapp/features/posts/data/PostPollViewModel.dart';
import 'package:myapp/features/posts/models/post_poll_models.dart';
import '../../../utils/dio/auth_helper.dart';

import '../models/comment_model.dart';
import '../services/comments_service.dart';
import 'comment_item_widget.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final Map<ReactionType, List<LikeItem>>? recentReactions;
  final ReactionType? selectedReaction;
  final int likeCount;
  // New dynamic API data parameters
  final List<ReactionsItem>? reactions;
  final List<ReactionItem>? reactionCountBreakdown;
  final String? currentUserReaction;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    this.recentReactions,
    this.selectedReaction,
    this.likeCount = 0,
    // New parameters for dynamic API data
    this.reactions,
    this.reactionCountBreakdown,
    this.currentUserReaction,
  });

  static Future<void> show(
    BuildContext context,
    String postId, {
    Map<ReactionType, List<LikeItem>>? recentReactions,
    ReactionType? selectedReaction,
    int likeCount = 0,
    // New parameters for dynamic API data
    List<ReactionsItem>? reactions,
    List<ReactionItem>? reactionCountBreakdown,
    String? currentUserReaction,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return CommentsBottomSheet(
            postId: postId,
            recentReactions: recentReactions,
            selectedReaction: selectedReaction,
            likeCount: likeCount,
            reactions: reactions,
            reactionCountBreakdown: reactionCountBreakdown,
            currentUserReaction: currentUserReaction,
          );
        },
      ),
    );
  }

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  late List<CommentModel> _comments;
  final FocusNode _focusNode = FocusNode();
  final CommentsService _commentsService = CommentsService();
  final PostPollViewModel _viewModel = PostPollViewModel();
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  // final bool _showReactionsList = false; // Removed unused field
  bool _isLoading = false;
  String? _currentUserId;
  
  // Keep track of recently added comment IDs by current user
  final Set<String> _recentlyAddedComments = {};
  
  // Track when we last added a comment (for fallback identification)
  DateTime? _lastCommentAddTime;

  // Reply state
  CommentModel? _replyingTo;
  String? _lastReplyParentId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
    _loadComments();
    _initAudio();

    // Listen for changes in the comments service
    _commentsService.addListener(_onCommentsChanged);
  }

  Future<void> _loadCurrentUserId() async {
    try {
      _currentUserId = await AuthHelper.getUserId;
      debugPrint('Current user ID loaded from AuthHelper: $_currentUserId');
      
      // If no user ID found in AuthHelper, try to extract from token
      if (_currentUserId == null || _currentUserId!.isEmpty) {
        _currentUserId = await _extractUserIdFromToken();
        debugPrint('Current user ID extracted from token: $_currentUserId');
      }
    } catch (e) {
      debugPrint('Error loading current user ID: $e');
    }
  }

  Future<String?> _extractUserIdFromToken() async {
    try {
      final token = await AuthHelper.getAuthToken;
      if (token == null || token.isEmpty) return null;
      
      // Basic JWT parsing (split by dots and decode payload)
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed for proper base64 decoding
      String normalizedPayload = payload;
      while (normalizedPayload.length % 4 != 0) {
        normalizedPayload += '=';
      }
      
      // Decode base64 and parse JSON
      final payloadBytes = base64Url.decode(normalizedPayload);
      final payloadString = utf8.decode(payloadBytes);
      final Map<String, dynamic> payloadJson = json.decode(payloadString) as Map<String, dynamic>;
      
      debugPrint('JWT payload: $payloadJson');
      
      // Extract user ID (could be '_id' or 'userId' or 'id')
      return payloadJson['_id']?.toString() ?? 
             payloadJson['userId']?.toString() ?? 
             payloadJson['id']?.toString();
    } catch (e) {
      debugPrint('Error extracting user ID from token: $e');
      return null;
    }
  }

  void _onCommentsChanged() {
    if (mounted) {
      // _loadComments();
    }
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset('assets/audio/comment_audio.mp3');
    } catch (e) {
      debugPrint('Error initializing comment audio: $e');
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    _commentsService.removeListener(_onCommentsChanged);
    super.dispose();
  }

  void _loadComments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure current user ID is loaded first
      if (_currentUserId == null) {
        await _loadCurrentUserId();
      }

      final response = await _viewModel.fetchPostComments(widget.postId);
      debugPrint('Comments API Response: success=${response.success}, data=${response.data}');
      
      if (response.success && mounted) {
        final comments = _convertApiCommentsToCommentModels(response.data);
        debugPrint('Converted comments count: ${comments.length}');
        
        setState(() {
          _comments = comments;
          _isLoading = false;
        });
      } else {
        debugPrint('API response not successful or widget not mounted');
        setState(() {
          _comments = [];
          _isLoading = false;
        });
        
        // Show error for unsuccessful API response
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Comments could not be loaded from server'),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _loadComments(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _comments = [];
          _isLoading = false;
        });
        
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load comments: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadComments(),
            ),
          ),
        );
      }
      debugPrint('Error loading comments: $e');
    }
  }

  Future<void> _playCommentSound() async {
    try {
      // Stop any current playback first
      await _audioPlayer.stop();
      // Seek to beginning
      await _audioPlayer.seek(Duration.zero);
      // Play the sound
      await _audioPlayer.play();
      debugPrint('Comment sound played successfully');
    } catch (e) {
      debugPrint('Error playing comment sound: $e');
      // Try to reinitialize audio if there was an error
      try {
        await _audioPlayer.setAsset('assets/audio/comment_audio.mp3');
        await _audioPlayer.play();
        debugPrint('Comment sound played after reinitializing');
      } catch (retryError) {
        debugPrint('Failed to play comment sound after retry: $retryError');
      }
    }
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    // Play comment sound
    await _playCommentSound();

    try {
      final commentRequest = AddCommentRequest(
        message: _commentController.text.trim(),
        parentCommentId: _replyingTo?.id,
      );

      // Call API to add comment
      final response = await _viewModel.addComment(widget.postId, commentRequest);

      if (response.success && mounted) {
        // Track when we added this comment
        _lastCommentAddTime = DateTime.now();
        
        // If the response contains the new comment ID, track it
        if (response.data != null) {
          final newCommentId = response.data['commentId']?.toString() ?? 
                              response.data['_id']?.toString() ?? 
                              response.data['id']?.toString();
          if (newCommentId != null) {
            _recentlyAddedComments.add(newCommentId);
            debugPrint('Added comment ID to recently added: $newCommentId');
          }
        }
        
        // Clear input and reply state
        setState(() {
          _replyingTo = null;
          _commentController.clear();
        });

        // Reload comments to get the updated list
        _loadComments();

        // Scroll to show new content
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add comment: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    // Hide keyboard after submitting
    FocusScope.of(context).unfocus();
  }

  List<CommentModel> _convertApiCommentsToCommentModels(List<Comment> apiComments) {
    debugPrint('Converting ${apiComments.length} API comments to CommentModels');
    List<CommentModel> commentModels = [];
    
    // First, clear and populate the comments service with fresh data
    _commentsService.clearCommentsForPost(widget.postId);
    
    for (Comment apiComment in apiComments) {
      debugPrint('Processing comment: id=${apiComment.id}, message=${apiComment.message}');
      debugPrint('Comment userId structure: ${apiComment.userId}');
      debugPrint('Comment userId type: ${apiComment.userId.runtimeType}');
      
      // Skip comments with null or empty messages
      if (apiComment.message == null || apiComment.message!.trim().isEmpty) {
        debugPrint('Skipping comment with null/empty message');
        continue;
      }
      
      // Extract username and profile image from userId
      String username = _extractUsername(apiComment.userId, commentId: apiComment.id);
      String userImage = _extractUserImage(apiComment.userId);
      debugPrint('Extracted username for comment ${apiComment.id}: $username');
      debugPrint('Extracted userImage for comment ${apiComment.id}: $userImage');
      debugPrint('Current user ID: $_currentUserId');
      
      // Create main comment
      final mainComment = CommentModel(
        id: apiComment.id,
        username: apiComment.isOwner ? 'You' : username,
        userImage: userImage,
        text: apiComment.message!,
        timestamp: DateTime.tryParse(apiComment.updatedAt ?? '') ?? DateTime.now(),
        isReply: false,
      );
      
      // Add main comment to both the list and the service
      commentModels.add(mainComment);
      _commentsService.addComment(widget.postId, mainComment);
      
      // Process replies and add them to the service
      debugPrint('Comment has ${apiComment.replies.length} replies');
      for (Comment reply in apiComment.replies) {
        // Skip replies with null or empty messages
        if (reply.replyMessage == null || reply.replyMessage!.trim().isEmpty) {
          debugPrint('Skipping reply with null/empty message');
          continue;
        }
        
        String replyUsername = _extractUsername(reply.userId, commentId: reply.id);
        String replyUserImage = _extractUserImage(reply.userId);
        
        final replyComment = CommentModel(
          id: reply.id,
          username: reply.isOwner ? 'You' : replyUsername,
          userImage: replyUserImage,
          text: reply.replyMessage!,
          timestamp: DateTime.tryParse(reply.updatedAt ?? '') ?? DateTime.now(),
          parentId: apiComment.id,
          isReply: true,
        );
        
        // Add reply to the service (not to the main list)
        _commentsService.addReply(widget.postId, apiComment.id, replyComment);
      }
    }
    
    debugPrint('Total main comments: ${commentModels.length}');
    return commentModels;
  }

  String _extractUsername(dynamic userId, {String? commentId}) {
    debugPrint('_extractUsername called with userId: $userId, commentId: $commentId');
    
    // First check if this is the current user
    if (_isCurrentUser(userId, commentId: commentId)) {
      debugPrint('Identified as current user, returning "You"');
      return 'You';
    }
    
    if (userId is String) {
      debugPrint('userId is String: $userId');
      return userId.isNotEmpty ? userId : 'Anonymous';
    } else if (userId is Map<String, dynamic>) {
      debugPrint('userId is Map: $userId');
      // Try to extract full name from firstName and lastName
      final firstName = userId['firstName']?.toString();
      final lastName = userId['lastName']?.toString();
      final name = userId['name']?.toString();
      final username = userId['username']?.toString();
      final phone = userId['phone']?.toString();
      
      // Construct full name from firstName and lastName
      String fullName = '';
      if (firstName != null && firstName.isNotEmpty) {
        fullName = firstName;
        if (lastName != null && lastName.isNotEmpty) {
          fullName += ' $lastName';
        }
      }
      
      debugPrint('Extracted from Map - firstName: $firstName, lastName: $lastName, fullName: $fullName');
      return fullName.isNotEmpty ? fullName : (name ?? username ?? phone ?? 'Anonymous');
    }
    debugPrint('userId is neither String nor Map, returning Anonymous');
    return 'Anonymous';
  }

  String _extractUserImage(dynamic userId) {
    debugPrint('Extracting user image for userId: $userId (type: ${userId.runtimeType})');
    
    if (userId is Map<String, dynamic>) {
      final image = userId['image']?.toString();
      debugPrint('Extracted image from Map: $image');
      return image ?? 'assets/images/username_comment.png';
    }
    
    debugPrint('userId is not Map, returning default image');
    return 'assets/images/username_comment.png';
  }

  bool _isCurrentUser(dynamic userId, {String? commentId}) {
    return _checkIsCurrentUser(userId, commentId: commentId);
  }

  bool _checkIsCurrentUser(dynamic userId, {String? commentId}) {
    debugPrint('_checkIsCurrentUser called with userId: $userId, commentId: $commentId');
    debugPrint('Current user ID: $_currentUserId');
    debugPrint('Recently added comments: $_recentlyAddedComments');
    
    // Check if this is a recently added comment by current user
    if (commentId != null && _recentlyAddedComments.contains(commentId)) {
      debugPrint('Comment found in recently added, returning true');
      return true;
    }
    
    if (_currentUserId == null) {
      debugPrint('Current user ID is null, returning false');
      return false;
    }
    
    List<String?> possibleUserIds = [];
    
    if (userId is String) {
      possibleUserIds.add(userId);
      debugPrint('userId is String, added to possible IDs: $userId');
    } else if (userId is Map<String, dynamic>) {
      // Check if this comment has indicators that it's from current user
      final isCurrentUser = userId['isCurrentUser'] as bool?;
      if (isCurrentUser != null) {
        debugPrint('Found isCurrentUser flag: $isCurrentUser');
        return isCurrentUser;
      }
      
      // Try all possible user ID field names
      possibleUserIds.addAll([
        userId['_id']?.toString(),
        userId['id']?.toString(),
        userId['userId']?.toString(),
        userId['user_id']?.toString(),
      ]);
      
      // If the user object has nested user info
      if (userId['user'] is Map<String, dynamic>) {
        final userObj = userId['user'] as Map<String, dynamic>;
        possibleUserIds.addAll([
          userObj['_id']?.toString(),
          userObj['id']?.toString(),
          userObj['userId']?.toString(),
        ]);
      }
      
      debugPrint('Extracted possible user IDs from Map: $possibleUserIds');
    }
    
    // Remove null values
    possibleUserIds.removeWhere((id) => id == null || id.isEmpty);
    
    // Check if any of the possible user IDs match the current user ID
    for (final possibleId in possibleUserIds) {
      if (_currentUserId == possibleId) {
        debugPrint('Match found! currentUserId ($_currentUserId) == possibleId ($possibleId)');
        return true;
      }
    }
    
    debugPrint('No matches found. Checked IDs: $possibleUserIds against current: $_currentUserId');
    
    // Final fallback: check if this is a very recent comment (within 10 seconds of our last add)
    if (_lastCommentAddTime != null && commentId != null) {
      final commentAge = DateTime.now().difference(_lastCommentAddTime!);
      if (commentAge.inSeconds <= 10) {
        debugPrint('Comment is very recent (${commentAge.inSeconds}s), considering as current user');
        return true;
      }
    }
    
    return false;
  }

  void _startReply(CommentModel comment) {
    setState(() {
      _replyingTo = comment;
      _commentController.clear();
    });

    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  void _onCommentUpdated() {
    // Reload comments when a comment is updated or deleted
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // Drag handle at the top
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFBB9F9F)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Color(0xFFBB9F9F),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Title
                        const Text(
                          'Comments',
                          style: AppTextStyles.bold16,
                        ),
                      ],
                    ),

                    // Show reactions if available
                    if ((widget.reactions != null && widget.reactions!.isNotEmpty) || 
                        (widget.recentReactions != null && widget.likeCount > 0))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: widget.reactions != null || widget.reactionCountBreakdown != null
                            ? DynamicReactionDisplayWidget(
                                reactionCount: widget.likeCount,
                                reactions: widget.reactions,
                                reactionCountBreakdown: widget.reactionCountBreakdown,
                                currentUserReaction: widget.currentUserReaction,
                              )
                            : ReactionDisplayWidget(
                                reactionCount: widget.likeCount,
                                recentReactions: widget.recentReactions!,
                                currentUserReaction: widget.selectedReaction,
                              ),
                      ),
                  ],
                ),
              ),

              // Comments list
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF426DB3),
                        ),
                      )
                    : _comments.isEmpty
                        ? const Center(
                            child: Text(
                              'No comments yet',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'FacebookSans',
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _comments.length,
                            separatorBuilder: (context, index) =>
                                const CommonDivider(),
                            itemBuilder: (context, index) {
                              return CommentItemWidget(
                                comment: _comments[index],
                                postId: widget.postId,
                                onReply: () => _startReply(_comments[index]),
                                autoExpandReplyId: _lastReplyParentId,
                                onCommentUpdated: () => _onCommentUpdated(),
                              );
                            },
                          ),
              ),

              const Divider(
                color: Color(0xFF909090),
                height: 10,
              ),

              // Reply indicator (only shown when replying)
              if (_replyingTo != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.blue.withOpacity(0.05),
                  child: Row(
                    children: [
                      Text(
                        'Replying to ${_replyingTo!.username}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: _cancelReply,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Comment input
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Profile image
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          AssetImage('assets/images/username_comment.png'),
                    ),
                    const SizedBox(width: 8),

                    // Input field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 100, // Reduced max height
                        ),
                        child: TextField(
                          controller: _commentController,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: _replyingTo != null
                                ? 'Write a reply...'
                                : 'Write your comments.....',
                            hintStyle: AppTextStyles.medium15,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 8),
                            isDense: true, // Important to reduce height
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.3, // Reduce line height
                          ),
                          onChanged: (text) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Send button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF426DB3),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        onPressed: _addComment,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
