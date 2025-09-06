import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_poll_models.freezed.dart';
part 'post_poll_models.g.dart';

@freezed
class PostPollResponse with _$PostPollResponse {
  const factory PostPollResponse({
    int? statusCode,
    List<PostPollItem>? data,
    String? message,
    bool? success,
  }) = _PostPollResponse;

  factory PostPollResponse.fromJson(Map<String, dynamic> json) =>
      _$PostPollResponseFromJson(json);
}

@freezed
class PostPollItem with _$PostPollItem {
  const factory PostPollItem({
    @JsonKey(name: '_id') required String id,
    String? description,
    String? chooseType,
    String? chooseTypeModel,
    String? locution,
    String? type,
    String? locutionkm,
    String? locationKm,
    String? status,
    String? latCoordinage,
    String? latCoordinate,
    String? langCoordinagee,
    String? lngCoordinate,
    String? createdBy,
    @Default([]) List<LikeItem> likes,
    @Default([]) List<PostItem> media,
    String? createdAt,
    String? updatedAt,
    String? postId,
    @JsonKey(name: '__v') int? version,
    dynamic chooseTypeId,
    String? approveBy,
    @Default([]) List<ReactionsItem> reactions,
    @Default(0) int likesCount,
    @Default(false) bool isLikedByUser,
    @Default(0) int commentCount,
    @Default([]) List<ReactionItem> reactionCount,
    UserReaction? userReaction,
    @Default(false) bool follow,
    @Default(false) bool isPostSaved,
    String? question,
    String? shareUrl,
    String? pollsId,
    List<PollOptionsItem>? options,
  }) = _PostPollItem;

  factory PostPollItem.fromJson(Map<String, dynamic> json) =>
      _$PostPollItemFromJson(json);
}

enum ChooseType {
  business,
  mandir,
}

enum ChooseModel {
  business,
  @JsonValue('christian_temple')
  christianTemple,
  temples,
}

enum PostingType {
  @JsonValue('Polls')
  polls,
  @JsonValue('Posts')
  posts,
}

enum PostType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
}

enum UserReaction {
  @JsonValue('LOVE')
  love,
  @JsonValue('HAHA')
  haha,
  @JsonValue('SAD')
  sad,
  @JsonValue('ANGRY')
  angry,
  @JsonValue('SURPRISE')
  surprise,
}

@freezed
class Logo with _$Logo {
  const factory Logo({
    required String url,
  }) = _Logo;

  factory Logo.fromJson(Map<String, dynamic> json) => _$LogoFromJson(json);
}

@freezed
class CompanyInfo with _$CompanyInfo {
  const factory CompanyInfo({
    String? companyName,
    String? aboutUs,
  }) = _CompanyInfo;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoFromJson(json);
}

@freezed
class ChooseTypeId with _$ChooseTypeId {
  const factory ChooseTypeId({
    @JsonKey(name: '_id') required String id,
    String? vendorId,
    Logo? logo,
    CompanyInfo? companyInfo,
  }) = _ChooseTypeId;

  factory ChooseTypeId.fromJson(Map<String, dynamic> json) =>
      _$ChooseTypeIdFromJson(json);
}

@freezed
class PostItem with _$PostItem {
  const factory PostItem({
    String? url,
    String? type,
  }) = _PostItem;

  factory PostItem.fromJson(Map<String, dynamic> json) =>
      _$PostItemFromJson(json);
}

@freezed
class ReactionItem with _$ReactionItem {
  const factory ReactionItem({
    required String name,
    required int count,
  }) = _ReactionItem;

  factory ReactionItem.fromJson(Map<String, dynamic> json) =>
      _$ReactionItemFromJson(json);
}

@freezed
class PollOptionsItem with _$PollOptionsItem {
  const factory PollOptionsItem({
    String? option,
    @Default(0) int votes,
    @JsonKey(name: '_id') String? id,
    bool? selected,
  }) = _PollOptionsItem;

  factory PollOptionsItem.fromJson(Map<String, dynamic> json) =>
      _$PollOptionsItemFromJson(json);
}

@freezed
class Post with _$Post {
  const factory Post({
    @JsonKey(name: '_id') required String id,
    required String description,
    required ChooseType chooseType,
    required ChooseModel chooseModel,
    required PostingType type,
    required String createdBy,
    required bool isLikedByUser,
    required int likesCount,
    required int commentCount,
    required PostItem media,
    required String postId,
    required ReactionItem reactionCount,
    required bool follow,
    required bool isPostSaved,
    UserReaction? userReaction,
    String? question,
    List<PollOptionsItem>? options,
    ChooseTypeId? chooseTypeId,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class CommentResponse with _$CommentResponse {
  const factory CommentResponse({
    required int statusCode,
    required List<Comment> data,
    required String message,
    required bool success,
  }) = _CommentResponse;

  factory CommentResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentResponseFromJson(json);
}

@freezed
class Comment with _$Comment {
  const factory Comment({
    @JsonKey(name: '_id') required String id,
    String? postId, // Made nullable
    dynamic userId, // Changed to dynamic to handle both String and Map
    String? message, // Made nullable to handle null messages
    String? parentCommentId,
    String? updatedAt, // Made nullable to handle null dates
    @Default([]) List<Comment> replies,
    String? replyMessage,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

@freezed
class UpdateCommentRequest with _$UpdateCommentRequest {
  const factory UpdateCommentRequest({
    required String message,
  }) = _UpdateCommentRequest;

  factory UpdateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCommentRequestFromJson(json);
  
  Map<String, dynamic> toJson() => {'message': message};
}

@freezed
class AddCommentRequest with _$AddCommentRequest {
  const factory AddCommentRequest({
    required String message,
    String? parentCommentId,
  }) = _AddCommentRequest;

  factory AddCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCommentRequestFromJson(json);
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'message': message};
    if (parentCommentId != null) {
      data['parentCommentId'] = parentCommentId!;
    }
    return data;
  }
}

@freezed
class AddCommentResponse with _$AddCommentResponse {
  const factory AddCommentResponse({
    required int statusCode,
    required String message,
    required bool success,
    dynamic data,
  }) = _AddCommentResponse;

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$AddCommentResponseFromJson(json);
}

@freezed
class AddPostReaction with _$AddPostReaction {
  const factory AddPostReaction({
    required String IdReactedFor,
    required String reactionType,
    required String type,
  }) = _AddPostReaction;

  factory AddPostReaction.fromJson(Map<String, dynamic> json) =>
      _$AddPostReactionFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'IdReactedFor': IdReactedFor,
    'reactionType': reactionType,
    'type': type,
  };
}

@freezed
class PollReaction with _$PollReaction {
  const factory PollReaction({
    required String reactionId,
  }) = _PollReaction;

  factory PollReaction.fromJson(Map<String, dynamic> json) =>
      _$PollReactionFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'reactionId': reactionId,
  };
}

@freezed
class PostReport with _$PostReport {
  const factory PostReport({
    required String message,
    required String postId,
  }) = _PostReport;

  factory PostReport.fromJson(Map<String, dynamic> json) =>
      _$PostReportFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'message': message,
    'postId': postId,
  };
}

@freezed
class SavePost with _$SavePost {
  const factory SavePost({
    required String postId,
    required String postModel,
  }) = _SavePost;

  factory SavePost.fromJson(Map<String, dynamic> json) =>
      _$SavePostFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'postId': postId,
    'postModel': postModel,
  };
}

@freezed
class LikeItem with _$LikeItem {
  const factory LikeItem({
    @JsonKey(name: '_id') String? id,
    String? userName,
    String? userAvatar,
  }) = _LikeItem;

  factory LikeItem.fromJson(Map<String, dynamic> json) =>
      _$LikeItemFromJson(json);
}

@freezed
class ReactionsItem with _$ReactionsItem {
  const factory ReactionsItem({
    String? userName,
    String? userAvatar,
    String? reactionName,
  }) = _ReactionsItem;

  factory ReactionsItem.fromJson(Map<String, dynamic> json) =>
      _$ReactionsItemFromJson(json);
}

@freezed
class StoryReaction with _$StoryReaction {
  const factory StoryReaction({
    required String storyId,
    required String reactionType,
  }) = _StoryReaction;

  factory StoryReaction.fromJson(Map<String, dynamic> json) =>
      _$StoryReactionFromJson(json);
  
  Map<String, dynamic> toJson() => {
    'storyId': storyId,
    'reactionType': reactionType,
  };
}
