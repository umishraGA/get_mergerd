import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/comment_model.dart';
import '../services/comments_service.dart';

class CommentItemWidget extends StatefulWidget {
  final CommentModel comment;
  final String postId;
  final VoidCallback? onReply;
  final String? autoExpandReplyId;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.postId,
    this.onReply,
    this.autoExpandReplyId,
  });

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  final CommentsService _commentsService = CommentsService();
  bool _showReplies = false;
  late List<CommentModel> _replies;
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _loadReplies();
    _editController = TextEditingController(text: widget.comment.text);

    // Auto-expand if this is the parent of a newly added reply
    if (widget.autoExpandReplyId != null &&
        widget.autoExpandReplyId == widget.comment.id) {
      _showReplies = true;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CommentItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Refresh replies when widget updates
    _loadReplies();

    // Auto-expand if this is the parent of a newly added reply
    if (widget.autoExpandReplyId != null &&
        widget.autoExpandReplyId == widget.comment.id &&
        widget.autoExpandReplyId != oldWidget.autoExpandReplyId) {
      _showReplies = true;
    }
  }

  void _loadReplies() {
    _replies =
        _commentsService.getRepliesForComment(widget.postId, widget.comment.id);
  }

  void _toggleReplies() {
    setState(() {
      _showReplies = !_showReplies;
    });
  }

  // Used to force expand replies from parent
  void expandReplies() {
    if (!_showReplies && _replies.isNotEmpty) {
      setState(() {
        _showReplies = true;
      });
    }
  }

  // Refresh replies
  void refreshReplies() {
    setState(() {
      _loadReplies();
    });
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _commentsService.deleteComment(
                    widget.postId, widget.comment.id);
                // Force a rebuild of parent widget
                if (mounted) setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _saveEdit() {
    if (_editController.text.trim().isNotEmpty) {
      _commentsService.editComment(
        widget.postId,
        widget.comment.id,
        _editController.text.trim(),
      );
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile image
              Image.asset(
                widget.comment.userImage,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 12),

              // Comment content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username
                    Text(
                      widget.comment.username,
                      style: AppTextStyles.bold16,
                    ),
                    const SizedBox(height: 4),

                    // Either show editable text field or normal text
                    _isEditing
                        ? Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _editController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  maxLines: null,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: _saveEdit,
                                color: Theme.of(context).primaryColor,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _editController.text = widget.comment.text;
                                  });
                                },
                                color: Colors.grey,
                              ),
                            ],
                          )
                        : Text(
                            widget.comment.text,
                            style: AppTextStyles.medium15,
                          ),
                    const SizedBox(height: 6),
                    // Action row - time, reply, edit and delete buttons
                    Row(
                      children: [
                        Text(
                          timeago.format(widget.comment.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (!widget.comment.isReply && widget.onReply != null)
                          GestureDetector(
                            onTap: widget.onReply,
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),

                        // Only show edit and delete for the user's own comments
                        if (widget.comment.username == 'You')
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              // Edit button
                              GestureDetector(
                                onTap: _startEditing,
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Delete button
                              GestureDetector(
                                onTap: _showDeleteConfirmation,
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Show replies toggle if this comment has replies
                    if (_replies.isNotEmpty && !widget.comment.isReply)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: _toggleReplies,
                          child: Text(
                            _showReplies
                                ? 'Hide ${_replies.length} ${_replies.length == 1 ? 'reply' : 'replies'}'
                                : 'View ${_replies.length} ${_replies.length == 1 ? 'reply' : 'replies'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Replies section
        if (_showReplies && _replies.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(left: 35),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _replies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CommentItemWidget(
                    comment: _replies[index],
                    postId: widget.postId,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
