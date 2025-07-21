import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:myapp/features/common/widgets/CommonDivider.dart';
import 'package:myapp/features/mainPage/widgets/ReactionDisplayWidget.dart';

import '../models/comment_model.dart';
import '../services/comments_service.dart';
import 'comment_item_widget.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final Map<ReactionType, List<String>>? recentReactions;
  final ReactionType? selectedReaction;
  final int likeCount;

  const CommentsBottomSheet({
    super.key,
    required this.postId,
    this.recentReactions,
    this.selectedReaction,
    this.likeCount = 0,
  });

  static Future<void> show(
    BuildContext context,
    String postId, {
    Map<ReactionType, List<String>>? recentReactions,
    ReactionType? selectedReaction,
    int likeCount = 0,
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
  final ScrollController _scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final bool _showReactionsList = false;

  // Reply state
  CommentModel? _replyingTo;
  String? _lastReplyParentId;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _initAudio();

    // Listen for changes in the comments service
    _commentsService.addListener(_onCommentsChanged);
  }

  void _onCommentsChanged() {
    if (mounted) {
      _loadComments();
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

  void _loadComments() {
    setState(() {
      _comments = _commentsService.getCommentsForPost(widget.postId);
    });
  }

  Future<void> _playCommentSound() async {
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing comment sound: $e');
    }
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    // Play comment sound
    await _playCommentSound();

    if (_replyingTo != null) {
      // Adding a reply
      final reply = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: 'You',
        userImage: 'assets/images/username_comment.png',
        text: _commentController.text.trim(),
        timestamp: DateTime.now(),
        parentId: _replyingTo!.id,
        isReply: true,
      );

      _commentsService.addReply(widget.postId, _replyingTo!.id, reply);

      // Store the parent comment ID to auto-expand after rebuild
      final parentId = _replyingTo!.id;

      setState(() {
        _replyingTo = null;
        _lastReplyParentId = parentId;
        _comments = _commentsService.getCommentsForPost(widget.postId);
        _commentController.clear();
      });
    } else {
      // Adding a new comment
      final newComment = CommentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: 'You',
        userImage: 'assets/images/username_comment.png',
        text: _commentController.text.trim(),
        timestamp: DateTime.now(),
      );

      // Add comment to service
      _commentsService.addComment(widget.postId, newComment);

      setState(() {
        _lastReplyParentId = null;
        _comments = _commentsService.getCommentsForPost(widget.postId);
        _commentController.clear();
      });
    }

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

    // Hide keyboard after submitting
    FocusScope.of(context).unfocus();
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
                    if (widget.recentReactions != null && widget.likeCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ReactionDisplayWidget(
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
                child: _comments.isEmpty
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
