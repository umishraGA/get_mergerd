// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_poll_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostPollResponseImpl _$$PostPollResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PostPollResponseImpl(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PostPollItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$$PostPollResponseImplToJson(
        _$PostPollResponseImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'data': instance.data,
      'message': instance.message,
      'success': instance.success,
    };

_$PostPollItemImpl _$$PostPollItemImplFromJson(Map<String, dynamic> json) =>
    _$PostPollItemImpl(
      id: json['_id'] as String,
      description: json['description'] as String?,
      chooseType: json['chooseType'] as String?,
      chooseTypeModel: json['chooseTypeModel'] as String?,
      locution: json['locution'] as String?,
      type: json['type'] as String?,
      locutionkm: json['locutionkm'] as String?,
      locationKm: json['locationKm'] as String?,
      status: json['status'] as String?,
      latCoordinage: json['latCoordinage'] as String?,
      latCoordinate: json['latCoordinate'] as String?,
      langCoordinagee: json['langCoordinagee'] as String?,
      lngCoordinate: json['lngCoordinate'] as String?,
      createdBy: json['createdBy'] as String?,
      likes: (json['likes'] as List<dynamic>?)
              ?.map((e) => LikeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => PostItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      postId: json['postId'] as String?,
      version: (json['__v'] as num?)?.toInt(),
      chooseTypeId: json['chooseTypeId'],
      approveBy: json['approveBy'] as String?,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => ReactionsItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likesCount: (json['likesCount'] as num?)?.toInt() ?? 0,
      isLikedByUser: json['isLikedByUser'] as bool? ?? false,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      reactionCount: (json['reactionCount'] as List<dynamic>?)
              ?.map((e) => ReactionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      userReaction:
          $enumDecodeNullable(_$UserReactionEnumMap, json['userReaction']),
      follow: json['follow'] as bool? ?? false,
      isPostSaved: json['isPostSaved'] as bool? ?? false,
      question: json['question'] as String?,
      shareUrl: json['shareUrl'] as String?,
      pollsId: json['pollsId'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostPollItemImplToJson(_$PostPollItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'description': instance.description,
      'chooseType': instance.chooseType,
      'chooseTypeModel': instance.chooseTypeModel,
      'locution': instance.locution,
      'type': instance.type,
      'locutionkm': instance.locutionkm,
      'locationKm': instance.locationKm,
      'status': instance.status,
      'latCoordinage': instance.latCoordinage,
      'latCoordinate': instance.latCoordinate,
      'langCoordinagee': instance.langCoordinagee,
      'lngCoordinate': instance.lngCoordinate,
      'createdBy': instance.createdBy,
      'likes': instance.likes,
      'media': instance.media,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'postId': instance.postId,
      '__v': instance.version,
      'chooseTypeId': instance.chooseTypeId,
      'approveBy': instance.approveBy,
      'reactions': instance.reactions,
      'likesCount': instance.likesCount,
      'isLikedByUser': instance.isLikedByUser,
      'commentCount': instance.commentCount,
      'reactionCount': instance.reactionCount,
      'userReaction': _$UserReactionEnumMap[instance.userReaction],
      'follow': instance.follow,
      'isPostSaved': instance.isPostSaved,
      'question': instance.question,
      'shareUrl': instance.shareUrl,
      'pollsId': instance.pollsId,
      'options': instance.options,
    };

const _$UserReactionEnumMap = {
  UserReaction.love: 'LOVE',
  UserReaction.haha: 'HAHA',
  UserReaction.sad: 'SAD',
  UserReaction.angry: 'ANGRY',
  UserReaction.surprise: 'SURPRISE',
};

_$LogoImpl _$$LogoImplFromJson(Map<String, dynamic> json) => _$LogoImpl(
      url: json['url'] as String,
    );

Map<String, dynamic> _$$LogoImplToJson(_$LogoImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

_$CompanyInfoImpl _$$CompanyInfoImplFromJson(Map<String, dynamic> json) =>
    _$CompanyInfoImpl(
      companyName: json['companyName'] as String?,
      aboutUs: json['aboutUs'] as String?,
    );

Map<String, dynamic> _$$CompanyInfoImplToJson(_$CompanyInfoImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'aboutUs': instance.aboutUs,
    };

_$ChooseTypeIdImpl _$$ChooseTypeIdImplFromJson(Map<String, dynamic> json) =>
    _$ChooseTypeIdImpl(
      id: json['_id'] as String,
      vendorId: json['vendorId'] as String?,
      logo: json['logo'] == null
          ? null
          : Logo.fromJson(json['logo'] as Map<String, dynamic>),
      companyInfo: json['companyInfo'] == null
          ? null
          : CompanyInfo.fromJson(json['companyInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChooseTypeIdImplToJson(_$ChooseTypeIdImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'vendorId': instance.vendorId,
      'logo': instance.logo,
      'companyInfo': instance.companyInfo,
    };

_$PostItemImpl _$$PostItemImplFromJson(Map<String, dynamic> json) =>
    _$PostItemImpl(
      url: json['url'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$PostItemImplToJson(_$PostItemImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'type': instance.type,
    };

_$ReactionItemImpl _$$ReactionItemImplFromJson(Map<String, dynamic> json) =>
    _$ReactionItemImpl(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$ReactionItemImplToJson(_$ReactionItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'count': instance.count,
    };

_$PollOptionsItemImpl _$$PollOptionsItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PollOptionsItemImpl(
      option: json['option'] as String?,
      votes: (json['votes'] as num?)?.toInt() ?? 0,
      id: json['_id'] as String?,
      selected: json['selected'] as bool?,
    );

Map<String, dynamic> _$$PollOptionsItemImplToJson(
        _$PollOptionsItemImpl instance) =>
    <String, dynamic>{
      'option': instance.option,
      'votes': instance.votes,
      '_id': instance.id,
      'selected': instance.selected,
    };

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
      id: json['_id'] as String,
      description: json['description'] as String,
      chooseType: $enumDecode(_$ChooseTypeEnumMap, json['chooseType']),
      chooseModel: $enumDecode(_$ChooseModelEnumMap, json['chooseModel']),
      type: $enumDecode(_$PostingTypeEnumMap, json['type']),
      createdBy: json['createdBy'] as String,
      isLikedByUser: json['isLikedByUser'] as bool,
      likesCount: (json['likesCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      media: PostItem.fromJson(json['media'] as Map<String, dynamic>),
      postId: json['postId'] as String,
      reactionCount:
          ReactionItem.fromJson(json['reactionCount'] as Map<String, dynamic>),
      follow: json['follow'] as bool,
      isPostSaved: json['isPostSaved'] as bool,
      userReaction:
          $enumDecodeNullable(_$UserReactionEnumMap, json['userReaction']),
      question: json['question'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => PollOptionsItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      chooseTypeId: json['chooseTypeId'] == null
          ? null
          : ChooseTypeId.fromJson(json['chooseTypeId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'description': instance.description,
      'chooseType': _$ChooseTypeEnumMap[instance.chooseType]!,
      'chooseModel': _$ChooseModelEnumMap[instance.chooseModel]!,
      'type': _$PostingTypeEnumMap[instance.type]!,
      'createdBy': instance.createdBy,
      'isLikedByUser': instance.isLikedByUser,
      'likesCount': instance.likesCount,
      'commentCount': instance.commentCount,
      'media': instance.media,
      'postId': instance.postId,
      'reactionCount': instance.reactionCount,
      'follow': instance.follow,
      'isPostSaved': instance.isPostSaved,
      'userReaction': _$UserReactionEnumMap[instance.userReaction],
      'question': instance.question,
      'options': instance.options,
      'chooseTypeId': instance.chooseTypeId,
    };

const _$ChooseTypeEnumMap = {
  ChooseType.business: 'business',
  ChooseType.mandir: 'mandir',
};

const _$ChooseModelEnumMap = {
  ChooseModel.business: 'business',
  ChooseModel.christianTemple: 'christian_temple',
  ChooseModel.temples: 'temples',
};

const _$PostingTypeEnumMap = {
  PostingType.polls: 'Polls',
  PostingType.posts: 'Posts',
};

_$CommentResponseImpl _$$CommentResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CommentResponseImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$CommentResponseImplToJson(
        _$CommentResponseImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'data': instance.data,
      'message': instance.message,
      'success': instance.success,
    };

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['_id'] as String,
      postId: json['postId'] as String?,
      userId: json['userId'],
      message: json['message'] as String?,
      parentCommentId: json['parentCommentId'] as String?,
      updatedAt: json['updatedAt'] as String?,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      replyMessage: json['replyMessage'] as String?,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'message': instance.message,
      'parentCommentId': instance.parentCommentId,
      'updatedAt': instance.updatedAt,
      'replies': instance.replies,
      'replyMessage': instance.replyMessage,
    };

_$UpdateCommentRequestImpl _$$UpdateCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCommentRequestImpl(
      message: json['message'] as String,
    );

Map<String, dynamic> _$$UpdateCommentRequestImplToJson(
        _$UpdateCommentRequestImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

_$AddCommentRequestImpl _$$AddCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AddCommentRequestImpl(
      message: json['message'] as String,
      parentCommentId: json['parentCommentId'] as String?,
    );

Map<String, dynamic> _$$AddCommentRequestImplToJson(
        _$AddCommentRequestImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'parentCommentId': instance.parentCommentId,
    };

_$AddCommentResponseImpl _$$AddCommentResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AddCommentResponseImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      success: json['success'] as bool,
      data: json['data'],
    );

Map<String, dynamic> _$$AddCommentResponseImplToJson(
        _$AddCommentResponseImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

_$AddPostReactionImpl _$$AddPostReactionImplFromJson(
        Map<String, dynamic> json) =>
    _$AddPostReactionImpl(
      IdReactedFor: json['IdReactedFor'] as String,
      reactionType: json['reactionType'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$AddPostReactionImplToJson(
        _$AddPostReactionImpl instance) =>
    <String, dynamic>{
      'IdReactedFor': instance.IdReactedFor,
      'reactionType': instance.reactionType,
      'type': instance.type,
    };

_$PollReactionImpl _$$PollReactionImplFromJson(Map<String, dynamic> json) =>
    _$PollReactionImpl(
      reactionId: json['reactionId'] as String,
    );

Map<String, dynamic> _$$PollReactionImplToJson(_$PollReactionImpl instance) =>
    <String, dynamic>{
      'reactionId': instance.reactionId,
    };

_$PostReportImpl _$$PostReportImplFromJson(Map<String, dynamic> json) =>
    _$PostReportImpl(
      message: json['message'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$$PostReportImplToJson(_$PostReportImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'postId': instance.postId,
    };

_$SavePostImpl _$$SavePostImplFromJson(Map<String, dynamic> json) =>
    _$SavePostImpl(
      postId: json['postId'] as String,
      postModel: json['postModel'] as String,
    );

Map<String, dynamic> _$$SavePostImplToJson(_$SavePostImpl instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'postModel': instance.postModel,
    };

_$LikeItemImpl _$$LikeItemImplFromJson(Map<String, dynamic> json) =>
    _$LikeItemImpl(
      id: json['_id'] as String?,
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
    );

Map<String, dynamic> _$$LikeItemImplToJson(_$LikeItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
    };

_$ReactionsItemImpl _$$ReactionsItemImplFromJson(Map<String, dynamic> json) =>
    _$ReactionsItemImpl(
      userName: json['userName'] as String?,
      userAvatar: json['userAvatar'] as String?,
      reactionName: json['reactionName'] as String?,
    );

Map<String, dynamic> _$$ReactionsItemImplToJson(_$ReactionsItemImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'userAvatar': instance.userAvatar,
      'reactionName': instance.reactionName,
    };

_$StoryReactionImpl _$$StoryReactionImplFromJson(Map<String, dynamic> json) =>
    _$StoryReactionImpl(
      storyId: json['storyId'] as String,
      reactionType: json['reactionType'] as String,
    );

Map<String, dynamic> _$$StoryReactionImplToJson(_$StoryReactionImpl instance) =>
    <String, dynamic>{
      'storyId': instance.storyId,
      'reactionType': instance.reactionType,
    };
