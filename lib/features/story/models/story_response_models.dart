import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_response_models.freezed.dart';
part 'story_response_models.g.dart';

@freezed
class StoryResponse with _$StoryResponse {
  const factory StoryResponse({
    int? statusCode,
    List<StoryItem>? data,
    String? message,
    bool? success,
  }) = _StoryResponse;

  factory StoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryResponseFromJson(json);
}

@freezed
class StoryItem with _$StoryItem {
  const StoryItem._();
  
  const factory StoryItem({
    @JsonKey(name: '_id') String? id,
    String? description,
    String? chooseType,
    String? chooseTypeModel,
    String? locution,
    String? locutionkm,
    String? status,
    String? latCoordinate,
    String? langCoordinate,
    StoryCreatedBy? createdBy,
    DateTime? expiresAt,
    List<String>? likes,
    List<StoryMediaItem>? images,
    String? createdAt,
    String? updatedAt,
    String? PostStoryId,
    @JsonKey(name: '__v') int? version,
    StoryChooseTypeId? chooseTypeId,
    String? approveBy,
    List<StoryMediaItem>? media,
    int? likesCount,
    bool? isLikedByUser,
    StoryReactionCount? reactionCount,
    String? userReaction,
  }) = _StoryItem;

  factory StoryItem.fromJson(Map<String, dynamic> json) =>
      _$StoryItemFromJson(json);

  /// Get the display name based on chooseType
  /// If chooseType is "mandir", use name from chooseTypeId
  /// Otherwise, use companyName from chooseTypeId.companyInfo
  String get displayName {
    if (chooseType?.toLowerCase() == 'mandir') {
      return chooseTypeId?.name ?? 'Unknown';
    } else {
      return chooseTypeId?.companyInfo?.companyName ?? 'Unknown';
    }
  }
}

@freezed
class StoryCreatedBy with _$StoryCreatedBy {
  const factory StoryCreatedBy({
    @JsonKey(name: '_id') String? id,
    String? firstName,
    String? lastName,
  }) = _StoryCreatedBy;

  factory StoryCreatedBy.fromJson(Map<String, dynamic> json) =>
      _$StoryCreatedByFromJson(json);
}

@freezed
class StoryMediaItem with _$StoryMediaItem {
  const factory StoryMediaItem({
    String? url,
    String? status,
    @JsonKey(name: '_id') String? id,
    String? type,
    String? thumbnail,
  }) = _StoryMediaItem;

  factory StoryMediaItem.fromJson(Map<String, dynamic> json) =>
      _$StoryMediaItemFromJson(json);
}

@freezed
class StoryChooseTypeId with _$StoryChooseTypeId {
  const factory StoryChooseTypeId({
    @JsonKey(name: '_id') String? id,
    String? gurudwara_id,
    String? image,
    List<StoryAdditionalInfo>? additional_info,
    String? updatedAt,
    StoryCompanyInfo? companyInfo,
    StoryLogo? logo,
    String? name,
    String? vendorId,
  }) = _StoryChooseTypeId;

  factory StoryChooseTypeId.fromJson(Map<String, dynamic> json) =>
      _$StoryChooseTypeIdFromJson(json);
}

@freezed
class StoryAdditionalInfo with _$StoryAdditionalInfo {
  const factory StoryAdditionalInfo({
    String? title,
    String? content,
    @JsonKey(name: '_id') String? id,
  }) = _StoryAdditionalInfo;

  factory StoryAdditionalInfo.fromJson(Map<String, dynamic> json) =>
      _$StoryAdditionalInfoFromJson(json);
}

@freezed
class StoryCompanyInfo with _$StoryCompanyInfo {
  const factory StoryCompanyInfo({
    String? companyName,
    String? establishYear,
    String? companyCeo,
  }) = _StoryCompanyInfo;

  factory StoryCompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$StoryCompanyInfoFromJson(json);
}

@freezed
class StoryLogo with _$StoryLogo {
  const factory StoryLogo({
    String? url,
  }) = _StoryLogo;

  factory StoryLogo.fromJson(Map<String, dynamic> json) =>
      _$StoryLogoFromJson(json);
}

@freezed
class StoryReactionCount with _$StoryReactionCount {
  const factory StoryReactionCount({
    int? LOVE,
    int? HAHA,
    int? SAD,
    int? ANGRY,
    int? SURPRISE,
  }) = _StoryReactionCount;

  factory StoryReactionCount.fromJson(Map<String, dynamic> json) =>
      _$StoryReactionCountFromJson(json);
}

@freezed
class StoryReactionRequest with _$StoryReactionRequest {
  const factory StoryReactionRequest({
    required String storyId,
    required String reactionType,
  }) = _StoryReactionRequest;

  factory StoryReactionRequest.fromJson(Map<String, dynamic> json) =>
      _$StoryReactionRequestFromJson(json);
}