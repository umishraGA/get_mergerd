// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_response_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryResponseImpl _$$StoryResponseImplFromJson(Map<String, dynamic> json) =>
    _$StoryResponseImpl(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => StoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$$StoryResponseImplToJson(_$StoryResponseImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'data': instance.data,
      'message': instance.message,
      'success': instance.success,
    };

_$StoryItemImpl _$$StoryItemImplFromJson(Map<String, dynamic> json) =>
    _$StoryItemImpl(
      id: json['_id'] as String?,
      description: json['description'] as String?,
      chooseType: json['chooseType'] as String?,
      chooseTypeModel: json['chooseTypeModel'] as String?,
      locution: json['locution'] as String?,
      locutionkm: json['locutionkm'] as String?,
      status: json['status'] as String?,
      latCoordinate: json['latCoordinate'] as String?,
      langCoordinate: json['langCoordinate'] as String?,
      createdBy: json['createdBy'] == null
          ? null
          : StoryCreatedBy.fromJson(json['createdBy'] as Map<String, dynamic>),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => StoryMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      PostStoryId: json['PostStoryId'] as String?,
      version: (json['__v'] as num?)?.toInt(),
      chooseTypeId: json['chooseTypeId'] == null
          ? null
          : StoryChooseTypeId.fromJson(
              json['chooseTypeId'] as Map<String, dynamic>),
      approveBy: json['approveBy'] as String?,
      media: (json['media'] as List<dynamic>?)
          ?.map((e) => StoryMediaItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      likesCount: (json['likesCount'] as num?)?.toInt(),
      isLikedByUser: json['isLikedByUser'] as bool?,
      reactionCount: json['reactionCount'] == null
          ? null
          : StoryReactionCount.fromJson(
              json['reactionCount'] as Map<String, dynamic>),
      userReaction: json['userReaction'] as String?,
    );

Map<String, dynamic> _$$StoryItemImplToJson(_$StoryItemImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'description': instance.description,
      'chooseType': instance.chooseType,
      'chooseTypeModel': instance.chooseTypeModel,
      'locution': instance.locution,
      'locutionkm': instance.locutionkm,
      'status': instance.status,
      'latCoordinate': instance.latCoordinate,
      'langCoordinate': instance.langCoordinate,
      'createdBy': instance.createdBy,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'likes': instance.likes,
      'images': instance.images,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'PostStoryId': instance.PostStoryId,
      '__v': instance.version,
      'chooseTypeId': instance.chooseTypeId,
      'approveBy': instance.approveBy,
      'media': instance.media,
      'likesCount': instance.likesCount,
      'isLikedByUser': instance.isLikedByUser,
      'reactionCount': instance.reactionCount,
      'userReaction': instance.userReaction,
    };

_$StoryCreatedByImpl _$$StoryCreatedByImplFromJson(Map<String, dynamic> json) =>
    _$StoryCreatedByImpl(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );

Map<String, dynamic> _$$StoryCreatedByImplToJson(
        _$StoryCreatedByImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

_$StoryMediaItemImpl _$$StoryMediaItemImplFromJson(Map<String, dynamic> json) =>
    _$StoryMediaItemImpl(
      url: json['url'] as String?,
      status: json['status'] as String?,
      id: json['_id'] as String?,
      type: json['type'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$$StoryMediaItemImplToJson(
        _$StoryMediaItemImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'status': instance.status,
      '_id': instance.id,
      'type': instance.type,
      'thumbnail': instance.thumbnail,
    };

_$StoryChooseTypeIdImpl _$$StoryChooseTypeIdImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryChooseTypeIdImpl(
      id: json['_id'] as String?,
      gurudwara_id: json['gurudwara_id'] as String?,
      image: json['image'] as String?,
      additional_info: (json['additional_info'] as List<dynamic>?)
          ?.map((e) => StoryAdditionalInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] as String?,
      companyInfo: json['companyInfo'] == null
          ? null
          : StoryCompanyInfo.fromJson(
              json['companyInfo'] as Map<String, dynamic>),
      logo: json['logo'] == null
          ? null
          : StoryLogo.fromJson(json['logo'] as Map<String, dynamic>),
      name: json['name'] as String?,
      vendorId: json['vendorId'] as String?,
    );

Map<String, dynamic> _$$StoryChooseTypeIdImplToJson(
        _$StoryChooseTypeIdImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'gurudwara_id': instance.gurudwara_id,
      'image': instance.image,
      'additional_info': instance.additional_info,
      'updatedAt': instance.updatedAt,
      'companyInfo': instance.companyInfo,
      'logo': instance.logo,
      'name': instance.name,
      'vendorId': instance.vendorId,
    };

_$StoryAdditionalInfoImpl _$$StoryAdditionalInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryAdditionalInfoImpl(
      title: json['title'] as String?,
      content: json['content'] as String?,
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$$StoryAdditionalInfoImplToJson(
        _$StoryAdditionalInfoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      '_id': instance.id,
    };

_$StoryCompanyInfoImpl _$$StoryCompanyInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryCompanyInfoImpl(
      companyName: json['companyName'] as String?,
      establishYear: json['establishYear'] as String?,
      companyCeo: json['companyCeo'] as String?,
    );

Map<String, dynamic> _$$StoryCompanyInfoImplToJson(
        _$StoryCompanyInfoImpl instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'establishYear': instance.establishYear,
      'companyCeo': instance.companyCeo,
    };

_$StoryLogoImpl _$$StoryLogoImplFromJson(Map<String, dynamic> json) =>
    _$StoryLogoImpl(
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$StoryLogoImplToJson(_$StoryLogoImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

_$StoryReactionCountImpl _$$StoryReactionCountImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryReactionCountImpl(
      LOVE: (json['LOVE'] as num?)?.toInt(),
      HAHA: (json['HAHA'] as num?)?.toInt(),
      SAD: (json['SAD'] as num?)?.toInt(),
      ANGRY: (json['ANGRY'] as num?)?.toInt(),
      SURPRISE: (json['SURPRISE'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StoryReactionCountImplToJson(
        _$StoryReactionCountImpl instance) =>
    <String, dynamic>{
      'LOVE': instance.LOVE,
      'HAHA': instance.HAHA,
      'SAD': instance.SAD,
      'ANGRY': instance.ANGRY,
      'SURPRISE': instance.SURPRISE,
    };

_$StoryReactionRequestImpl _$$StoryReactionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StoryReactionRequestImpl(
      storyId: json['storyId'] as String,
      reactionType: json['reactionType'] as String,
    );

Map<String, dynamic> _$$StoryReactionRequestImplToJson(
        _$StoryReactionRequestImpl instance) =>
    <String, dynamic>{
      'storyId': instance.storyId,
      'reactionType': instance.reactionType,
    };
