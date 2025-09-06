import 'package:flutter/foundation.dart';

import '../models/comment_model.dart';

class CommentsService extends ChangeNotifier {
  // Singleton pattern
  static final CommentsService _instance = CommentsService._internal();
  factory CommentsService() => _instance;
  CommentsService._internal();

  // In-memory storage for comments (in a real app, this would be a database)
  final Map<String, List<CommentModel>> _commentsMap = {};

  // Get comments for a post (only top-level comments)
  List<CommentModel> getCommentsForPost(String postId) {
    if (!_commentsMap.containsKey(postId)) {
      return [];
    }
    return List.unmodifiable(
        _commentsMap[postId]!.where((comment) => !comment.isReply).toList());
  }

  // Get all replies for a specific comment
  List<CommentModel> getRepliesForComment(String postId, String commentId) {
    if (!_commentsMap.containsKey(postId)) {
      return [];
    }
    return List.unmodifiable(_commentsMap[postId]!
        .where((comment) => comment.isReply && comment.parentId == commentId)
        .toList());
  }

  // Add a comment to a post
  void addComment(String postId, CommentModel comment) {
    if (!_commentsMap.containsKey(postId)) {
      _commentsMap[postId] = [];
    }
    _commentsMap[postId]!.add(comment);
    notifyListeners();
  }

  // Add a reply to a comment
  void addReply(String postId, String commentId, CommentModel reply) {
    if (!_commentsMap.containsKey(postId)) {
      _commentsMap[postId] = [];
    }

    // Ensure the reply has the parent comment ID and is marked as a reply
    final CommentModel finalReply = CommentModel(
      id: reply.id,
      username: reply.username,
      userImage: reply.userImage,
      text: reply.text,
      timestamp: reply.timestamp,
      parentId: commentId,
      isReply: true,
    );

    _commentsMap[postId]!.add(finalReply);
    notifyListeners();
  }

  // Edit a comment
  void editComment(String postId, String commentId, String newText) {
    if (!_commentsMap.containsKey(postId)) return;

    final commentIndex =
        _commentsMap[postId]!.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return;

    final comment = _commentsMap[postId]![commentIndex];
    final updatedComment = CommentModel(
      id: comment.id,
      username: comment.username,
      userImage: comment.userImage,
      text: newText,
      timestamp: comment.timestamp,
      parentId: comment.parentId,
      isReply: comment.isReply,
    );

    _commentsMap[postId]![commentIndex] = updatedComment;
    notifyListeners();
  }

  // Delete a comment
  void deleteComment(String postId, String commentId) {
    if (!_commentsMap.containsKey(postId)) return;

    // If it's a parent comment, also delete all replies
    if (_commentsMap[postId]!.any((c) => c.parentId == commentId)) {
      _commentsMap[postId]!.removeWhere((c) => c.parentId == commentId);
    }

    // Remove the comment itself
    _commentsMap[postId]!.removeWhere((c) => c.id == commentId);
    notifyListeners();
  }

  // Get comment count for a post (including replies)
  int getCommentCount(String postId) {
    if (!_commentsMap.containsKey(postId)) {
      return 0;
    }
    return _commentsMap[postId]!.length;
  }

  // Check if a post has new comments since last viewed
  bool hasNewComments(String postId) {
    return _commentsMap.containsKey(postId) && _commentsMap[postId]!.isNotEmpty;
  }

  // Clear all comments for a specific post
  void clearCommentsForPost(String postId) {
    if (_commentsMap.containsKey(postId)) {
      _commentsMap[postId]!.clear();
    }
  }
}
