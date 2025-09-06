import 'package:flutter/material.dart';
import 'package:myapp/core/theme/AppTextStyles.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../posts/data/PostPollViewModel.dart';
import '../models/comment_model.dart';
import '../services/comments_service.dart';

class CommentItemWidget extends StatefulWidget {
  final CommentModel comment;
  final String postId;
  final VoidCallback? onReply;
  final String? autoExpandReplyId;
  final Function? onCommentUpdated;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.postId,
    this.onReply,
    this.autoExpandReplyId,
    this.onCommentUpdated,
  });

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  final CommentsService _commentsService = CommentsService();
  final PostPollViewModel _viewModel = PostPollViewModel();
  bool _showReplies = false;
  late List<CommentModel> _replies;
  bool _isEditing = false;
  bool _isLoading = false;
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
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteComment();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteComment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _viewModel.deleteComment(widget.comment.id);
      
      if (response.success == true && mounted) {
        // Remove from local service
        _commentsService.deleteComment(widget.postId, widget.comment.id);
        
        // Notify parent to refresh comments
        widget.onCommentUpdated?.call();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment deleted successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to delete comment: '
                '${response.message ?? "Unknown error"}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error deleting comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete comment: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveEdit() async {
    if (_editController.text.trim().isEmpty) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _viewModel.updateComment(
        widget.comment.id,
        _editController.text.trim(),
      );
      
      if (response.success == true && mounted) {
        // Update local service
        _commentsService.editComment(
          widget.postId,
          widget.comment.id,
          _editController.text.trim(),
        );
        
        setState(() {
          _isEditing = false;
        });
        
        // Notify parent to refresh comments
        widget.onCommentUpdated?.call();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update comment: '
                '${response.message ?? "Unknown error"}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error updating comment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update comment: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                                icon: _isLoading 
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                      )
                                    : const Icon(Icons.check),
                                onPressed: _isLoading ? null : _saveEdit,
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
                                ? 'Hide ${_replies.length} '
                                  '${_replies.length == 1 ? 'reply' : 'replies'}'
                                : 'View ${_replies.length} '
                                  '${_replies.length == 1 ? 'reply' : 'replies'}',
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
                    onCommentUpdated: widget.onCommentUpdated,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
