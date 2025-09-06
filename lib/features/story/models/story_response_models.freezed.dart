// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_response_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StoryResponse _$StoryResponseFromJson(Map<String, dynamic> json) {
  return _StoryResponse.fromJson(json);
}

/// @nodoc
mixin _$StoryResponse {
  int? get statusCode => throw _privateConstructorUsedError;
  List<StoryItem>? get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;

  /// Serializes this StoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryResponseCopyWith<StoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryResponseCopyWith<$Res> {
  factory $StoryResponseCopyWith(
          StoryResponse value, $Res Function(StoryResponse) then) =
      _$StoryResponseCopyWithImpl<$Res, StoryResponse>;
  @useResult
  $Res call(
      {int? statusCode, List<StoryItem>? data, String? message, bool? success});
}

/// @nodoc
class _$StoryResponseCopyWithImpl<$Res, $Val extends StoryResponse>
    implements $StoryResponseCopyWith<$Res> {
  _$StoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? data = freezed,
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<StoryItem>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryResponseImplCopyWith<$Res>
    implements $StoryResponseCopyWith<$Res> {
  factory _$$StoryResponseImplCopyWith(
          _$StoryResponseImpl value, $Res Function(_$StoryResponseImpl) then) =
      __$$StoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statusCode, List<StoryItem>? data, String? message, bool? success});
}

/// @nodoc
class __$$StoryResponseImplCopyWithImpl<$Res>
    extends _$StoryResponseCopyWithImpl<$Res, _$StoryResponseImpl>
    implements _$$StoryResponseImplCopyWith<$Res> {
  __$$StoryResponseImplCopyWithImpl(
      _$StoryResponseImpl _value, $Res Function(_$StoryResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? data = freezed,
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_$StoryResponseImpl(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<StoryItem>?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryResponseImpl implements _StoryResponse {
  const _$StoryResponseImpl(
      {this.statusCode,
      final List<StoryItem>? data,
      this.message,
      this.success})
      : _data = data;

  factory _$StoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryResponseImplFromJson(json);

  @override
  final int? statusCode;
  final List<StoryItem>? _data;
  @override
  List<StoryItem>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? message;
  @override
  final bool? success;

  @override
  String toString() {
    return 'StoryResponse(statusCode: $statusCode, data: $data, message: $message, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryResponseImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, statusCode,
      const DeepCollectionEquality().hash(_data), message, success);

  /// Create a copy of StoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryResponseImplCopyWith<_$StoryResponseImpl> get copyWith =>
      __$$StoryResponseImplCopyWithImpl<_$StoryResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryResponseImplToJson(
      this,
    );
  }
}

abstract class _StoryResponse implements StoryResponse {
  const factory _StoryResponse(
      {final int? statusCode,
      final List<StoryItem>? data,
      final String? message,
      final bool? success}) = _$StoryResponseImpl;

  factory _StoryResponse.fromJson(Map<String, dynamic> json) =
      _$StoryResponseImpl.fromJson;

  @override
  int? get statusCode;
  @override
  List<StoryItem>? get data;
  @override
  String? get message;
  @override
  bool? get success;

  /// Create a copy of StoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryResponseImplCopyWith<_$StoryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryItem _$StoryItemFromJson(Map<String, dynamic> json) {
  return _StoryItem.fromJson(json);
}

/// @nodoc
mixin _$StoryItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get chooseType => throw _privateConstructorUsedError;
  String? get chooseTypeModel => throw _privateConstructorUsedError;
  String? get locution => throw _privateConstructorUsedError;
  String? get locutionkm => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get latCoordinate => throw _privateConstructorUsedError;
  String? get langCoordinate => throw _privateConstructorUsedError;
  StoryCreatedBy? get createdBy => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  List<String>? get likes => throw _privateConstructorUsedError;
  List<StoryMediaItem>? get images => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get PostStoryId => throw _privateConstructorUsedError;
  @JsonKey(name: '__v')
  int? get version => throw _privateConstructorUsedError;
  StoryChooseTypeId? get chooseTypeId => throw _privateConstructorUsedError;
  String? get approveBy => throw _privateConstructorUsedError;
  List<StoryMediaItem>? get media => throw _privateConstructorUsedError;
  int? get likesCount => throw _privateConstructorUsedError;
  bool? get isLikedByUser => throw _privateConstructorUsedError;
  StoryReactionCount? get reactionCount => throw _privateConstructorUsedError;
  String? get userReaction => throw _privateConstructorUsedError;

  /// Serializes this StoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryItemCopyWith<StoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryItemCopyWith<$Res> {
  factory $StoryItemCopyWith(StoryItem value, $Res Function(StoryItem) then) =
      _$StoryItemCopyWithImpl<$Res, StoryItem>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
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
      String? userReaction});

  $StoryCreatedByCopyWith<$Res>? get createdBy;
  $StoryChooseTypeIdCopyWith<$Res>? get chooseTypeId;
  $StoryReactionCountCopyWith<$Res>? get reactionCount;
}

/// @nodoc
class _$StoryItemCopyWithImpl<$Res, $Val extends StoryItem>
    implements $StoryItemCopyWith<$Res> {
  _$StoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? chooseType = freezed,
    Object? chooseTypeModel = freezed,
    Object? locution = freezed,
    Object? locutionkm = freezed,
    Object? status = freezed,
    Object? latCoordinate = freezed,
    Object? langCoordinate = freezed,
    Object? createdBy = freezed,
    Object? expiresAt = freezed,
    Object? likes = freezed,
    Object? images = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? PostStoryId = freezed,
    Object? version = freezed,
    Object? chooseTypeId = freezed,
    Object? approveBy = freezed,
    Object? media = freezed,
    Object? likesCount = freezed,
    Object? isLikedByUser = freezed,
    Object? reactionCount = freezed,
    Object? userReaction = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      chooseType: freezed == chooseType
          ? _value.chooseType
          : chooseType // ignore: cast_nullable_to_non_nullable
              as String?,
      chooseTypeModel: freezed == chooseTypeModel
          ? _value.chooseTypeModel
          : chooseTypeModel // ignore: cast_nullable_to_non_nullable
              as String?,
      locution: freezed == locution
          ? _value.locution
          : locution // ignore: cast_nullable_to_non_nullable
              as String?,
      locutionkm: freezed == locutionkm
          ? _value.locutionkm
          : locutionkm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinate: freezed == latCoordinate
          ? _value.latCoordinate
          : latCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      langCoordinate: freezed == langCoordinate
          ? _value.langCoordinate
          : langCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as StoryCreatedBy?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<StoryMediaItem>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      PostStoryId: freezed == PostStoryId
          ? _value.PostStoryId
          : PostStoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as StoryChooseTypeId?,
      approveBy: freezed == approveBy
          ? _value.approveBy
          : approveBy // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<StoryMediaItem>?,
      likesCount: freezed == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isLikedByUser: freezed == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool?,
      reactionCount: freezed == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as StoryReactionCount?,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryCreatedByCopyWith<$Res>? get createdBy {
    if (_value.createdBy == null) {
      return null;
    }

    return $StoryCreatedByCopyWith<$Res>(_value.createdBy!, (value) {
      return _then(_value.copyWith(createdBy: value) as $Val);
    });
  }

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryChooseTypeIdCopyWith<$Res>? get chooseTypeId {
    if (_value.chooseTypeId == null) {
      return null;
    }

    return $StoryChooseTypeIdCopyWith<$Res>(_value.chooseTypeId!, (value) {
      return _then(_value.copyWith(chooseTypeId: value) as $Val);
    });
  }

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryReactionCountCopyWith<$Res>? get reactionCount {
    if (_value.reactionCount == null) {
      return null;
    }

    return $StoryReactionCountCopyWith<$Res>(_value.reactionCount!, (value) {
      return _then(_value.copyWith(reactionCount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryItemImplCopyWith<$Res>
    implements $StoryItemCopyWith<$Res> {
  factory _$$StoryItemImplCopyWith(
          _$StoryItemImpl value, $Res Function(_$StoryItemImpl) then) =
      __$$StoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
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
      String? userReaction});

  @override
  $StoryCreatedByCopyWith<$Res>? get createdBy;
  @override
  $StoryChooseTypeIdCopyWith<$Res>? get chooseTypeId;
  @override
  $StoryReactionCountCopyWith<$Res>? get reactionCount;
}

/// @nodoc
class __$$StoryItemImplCopyWithImpl<$Res>
    extends _$StoryItemCopyWithImpl<$Res, _$StoryItemImpl>
    implements _$$StoryItemImplCopyWith<$Res> {
  __$$StoryItemImplCopyWithImpl(
      _$StoryItemImpl _value, $Res Function(_$StoryItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? description = freezed,
    Object? chooseType = freezed,
    Object? chooseTypeModel = freezed,
    Object? locution = freezed,
    Object? locutionkm = freezed,
    Object? status = freezed,
    Object? latCoordinate = freezed,
    Object? langCoordinate = freezed,
    Object? createdBy = freezed,
    Object? expiresAt = freezed,
    Object? likes = freezed,
    Object? images = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? PostStoryId = freezed,
    Object? version = freezed,
    Object? chooseTypeId = freezed,
    Object? approveBy = freezed,
    Object? media = freezed,
    Object? likesCount = freezed,
    Object? isLikedByUser = freezed,
    Object? reactionCount = freezed,
    Object? userReaction = freezed,
  }) {
    return _then(_$StoryItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      chooseType: freezed == chooseType
          ? _value.chooseType
          : chooseType // ignore: cast_nullable_to_non_nullable
              as String?,
      chooseTypeModel: freezed == chooseTypeModel
          ? _value.chooseTypeModel
          : chooseTypeModel // ignore: cast_nullable_to_non_nullable
              as String?,
      locution: freezed == locution
          ? _value.locution
          : locution // ignore: cast_nullable_to_non_nullable
              as String?,
      locutionkm: freezed == locutionkm
          ? _value.locutionkm
          : locutionkm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinate: freezed == latCoordinate
          ? _value.latCoordinate
          : latCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      langCoordinate: freezed == langCoordinate
          ? _value.langCoordinate
          : langCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as StoryCreatedBy?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      likes: freezed == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<StoryMediaItem>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      PostStoryId: freezed == PostStoryId
          ? _value.PostStoryId
          : PostStoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as StoryChooseTypeId?,
      approveBy: freezed == approveBy
          ? _value.approveBy
          : approveBy // ignore: cast_nullable_to_non_nullable
              as String?,
      media: freezed == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<StoryMediaItem>?,
      likesCount: freezed == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int?,
      isLikedByUser: freezed == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool?,
      reactionCount: freezed == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as StoryReactionCount?,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryItemImpl implements _StoryItem {
  const _$StoryItemImpl(
      {@JsonKey(name: '_id') this.id,
      this.description,
      this.chooseType,
      this.chooseTypeModel,
      this.locution,
      this.locutionkm,
      this.status,
      this.latCoordinate,
      this.langCoordinate,
      this.createdBy,
      this.expiresAt,
      final List<String>? likes,
      final List<StoryMediaItem>? images,
      this.createdAt,
      this.updatedAt,
      this.PostStoryId,
      @JsonKey(name: '__v') this.version,
      this.chooseTypeId,
      this.approveBy,
      final List<StoryMediaItem>? media,
      this.likesCount,
      this.isLikedByUser,
      this.reactionCount,
      this.userReaction})
      : _likes = likes,
        _images = images,
        _media = media;

  factory _$StoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? description;
  @override
  final String? chooseType;
  @override
  final String? chooseTypeModel;
  @override
  final String? locution;
  @override
  final String? locutionkm;
  @override
  final String? status;
  @override
  final String? latCoordinate;
  @override
  final String? langCoordinate;
  @override
  final StoryCreatedBy? createdBy;
  @override
  final DateTime? expiresAt;
  final List<String>? _likes;
  @override
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<StoryMediaItem>? _images;
  @override
  List<StoryMediaItem>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? PostStoryId;
  @override
  @JsonKey(name: '__v')
  final int? version;
  @override
  final StoryChooseTypeId? chooseTypeId;
  @override
  final String? approveBy;
  final List<StoryMediaItem>? _media;
  @override
  List<StoryMediaItem>? get media {
    final value = _media;
    if (value == null) return null;
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? likesCount;
  @override
  final bool? isLikedByUser;
  @override
  final StoryReactionCount? reactionCount;
  @override
  final String? userReaction;

  @override
  String toString() {
    return 'StoryItem(id: $id, description: $description, chooseType: $chooseType, chooseTypeModel: $chooseTypeModel, locution: $locution, locutionkm: $locutionkm, status: $status, latCoordinate: $latCoordinate, langCoordinate: $langCoordinate, createdBy: $createdBy, expiresAt: $expiresAt, likes: $likes, images: $images, createdAt: $createdAt, updatedAt: $updatedAt, PostStoryId: $PostStoryId, version: $version, chooseTypeId: $chooseTypeId, approveBy: $approveBy, media: $media, likesCount: $likesCount, isLikedByUser: $isLikedByUser, reactionCount: $reactionCount, userReaction: $userReaction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.chooseType, chooseType) ||
                other.chooseType == chooseType) &&
            (identical(other.chooseTypeModel, chooseTypeModel) ||
                other.chooseTypeModel == chooseTypeModel) &&
            (identical(other.locution, locution) ||
                other.locution == locution) &&
            (identical(other.locutionkm, locutionkm) ||
                other.locutionkm == locutionkm) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latCoordinate, latCoordinate) ||
                other.latCoordinate == latCoordinate) &&
            (identical(other.langCoordinate, langCoordinate) ||
                other.langCoordinate == langCoordinate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.PostStoryId, PostStoryId) ||
                other.PostStoryId == PostStoryId) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.chooseTypeId, chooseTypeId) ||
                other.chooseTypeId == chooseTypeId) &&
            (identical(other.approveBy, approveBy) ||
                other.approveBy == approveBy) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isLikedByUser, isLikedByUser) ||
                other.isLikedByUser == isLikedByUser) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.userReaction, userReaction) ||
                other.userReaction == userReaction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        description,
        chooseType,
        chooseTypeModel,
        locution,
        locutionkm,
        status,
        latCoordinate,
        langCoordinate,
        createdBy,
        expiresAt,
        const DeepCollectionEquality().hash(_likes),
        const DeepCollectionEquality().hash(_images),
        createdAt,
        updatedAt,
        PostStoryId,
        version,
        chooseTypeId,
        approveBy,
        const DeepCollectionEquality().hash(_media),
        likesCount,
        isLikedByUser,
        reactionCount,
        userReaction
      ]);

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryItemImplCopyWith<_$StoryItemImpl> get copyWith =>
      __$$StoryItemImplCopyWithImpl<_$StoryItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryItemImplToJson(
      this,
    );
  }
}

abstract class _StoryItem implements StoryItem {
  const factory _StoryItem(
      {@JsonKey(name: '_id') final String? id,
      final String? description,
      final String? chooseType,
      final String? chooseTypeModel,
      final String? locution,
      final String? locutionkm,
      final String? status,
      final String? latCoordinate,
      final String? langCoordinate,
      final StoryCreatedBy? createdBy,
      final DateTime? expiresAt,
      final List<String>? likes,
      final List<StoryMediaItem>? images,
      final String? createdAt,
      final String? updatedAt,
      final String? PostStoryId,
      @JsonKey(name: '__v') final int? version,
      final StoryChooseTypeId? chooseTypeId,
      final String? approveBy,
      final List<StoryMediaItem>? media,
      final int? likesCount,
      final bool? isLikedByUser,
      final StoryReactionCount? reactionCount,
      final String? userReaction}) = _$StoryItemImpl;

  factory _StoryItem.fromJson(Map<String, dynamic> json) =
      _$StoryItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get description;
  @override
  String? get chooseType;
  @override
  String? get chooseTypeModel;
  @override
  String? get locution;
  @override
  String? get locutionkm;
  @override
  String? get status;
  @override
  String? get latCoordinate;
  @override
  String? get langCoordinate;
  @override
  StoryCreatedBy? get createdBy;
  @override
  DateTime? get expiresAt;
  @override
  List<String>? get likes;
  @override
  List<StoryMediaItem>? get images;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get PostStoryId;
  @override
  @JsonKey(name: '__v')
  int? get version;
  @override
  StoryChooseTypeId? get chooseTypeId;
  @override
  String? get approveBy;
  @override
  List<StoryMediaItem>? get media;
  @override
  int? get likesCount;
  @override
  bool? get isLikedByUser;
  @override
  StoryReactionCount? get reactionCount;
  @override
  String? get userReaction;

  /// Create a copy of StoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryItemImplCopyWith<_$StoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryCreatedBy _$StoryCreatedByFromJson(Map<String, dynamic> json) {
  return _StoryCreatedBy.fromJson(json);
}

/// @nodoc
mixin _$StoryCreatedBy {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;

  /// Serializes this StoryCreatedBy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryCreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryCreatedByCopyWith<StoryCreatedBy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCreatedByCopyWith<$Res> {
  factory $StoryCreatedByCopyWith(
          StoryCreatedBy value, $Res Function(StoryCreatedBy) then) =
      _$StoryCreatedByCopyWithImpl<$Res, StoryCreatedBy>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id, String? firstName, String? lastName});
}

/// @nodoc
class _$StoryCreatedByCopyWithImpl<$Res, $Val extends StoryCreatedBy>
    implements $StoryCreatedByCopyWith<$Res> {
  _$StoryCreatedByCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryCreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryCreatedByImplCopyWith<$Res>
    implements $StoryCreatedByCopyWith<$Res> {
  factory _$$StoryCreatedByImplCopyWith(_$StoryCreatedByImpl value,
          $Res Function(_$StoryCreatedByImpl) then) =
      __$$StoryCreatedByImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id, String? firstName, String? lastName});
}

/// @nodoc
class __$$StoryCreatedByImplCopyWithImpl<$Res>
    extends _$StoryCreatedByCopyWithImpl<$Res, _$StoryCreatedByImpl>
    implements _$$StoryCreatedByImplCopyWith<$Res> {
  __$$StoryCreatedByImplCopyWithImpl(
      _$StoryCreatedByImpl _value, $Res Function(_$StoryCreatedByImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryCreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
  }) {
    return _then(_$StoryCreatedByImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryCreatedByImpl implements _StoryCreatedBy {
  const _$StoryCreatedByImpl(
      {@JsonKey(name: '_id') this.id, this.firstName, this.lastName});

  factory _$StoryCreatedByImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryCreatedByImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? firstName;
  @override
  final String? lastName;

  @override
  String toString() {
    return 'StoryCreatedBy(id: $id, firstName: $firstName, lastName: $lastName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryCreatedByImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, firstName, lastName);

  /// Create a copy of StoryCreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryCreatedByImplCopyWith<_$StoryCreatedByImpl> get copyWith =>
      __$$StoryCreatedByImplCopyWithImpl<_$StoryCreatedByImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryCreatedByImplToJson(
      this,
    );
  }
}

abstract class _StoryCreatedBy implements StoryCreatedBy {
  const factory _StoryCreatedBy(
      {@JsonKey(name: '_id') final String? id,
      final String? firstName,
      final String? lastName}) = _$StoryCreatedByImpl;

  factory _StoryCreatedBy.fromJson(Map<String, dynamic> json) =
      _$StoryCreatedByImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get firstName;
  @override
  String? get lastName;

  /// Create a copy of StoryCreatedBy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryCreatedByImplCopyWith<_$StoryCreatedByImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryMediaItem _$StoryMediaItemFromJson(Map<String, dynamic> json) {
  return _StoryMediaItem.fromJson(json);
}

/// @nodoc
mixin _$StoryMediaItem {
  String? get url => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this StoryMediaItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryMediaItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryMediaItemCopyWith<StoryMediaItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryMediaItemCopyWith<$Res> {
  factory $StoryMediaItemCopyWith(
          StoryMediaItem value, $Res Function(StoryMediaItem) then) =
      _$StoryMediaItemCopyWithImpl<$Res, StoryMediaItem>;
  @useResult
  $Res call(
      {String? url,
      String? status,
      @JsonKey(name: '_id') String? id,
      String? type});
}

/// @nodoc
class _$StoryMediaItemCopyWithImpl<$Res, $Val extends StoryMediaItem>
    implements $StoryMediaItemCopyWith<$Res> {
  _$StoryMediaItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryMediaItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? status = freezed,
    Object? id = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryMediaItemImplCopyWith<$Res>
    implements $StoryMediaItemCopyWith<$Res> {
  factory _$$StoryMediaItemImplCopyWith(_$StoryMediaItemImpl value,
          $Res Function(_$StoryMediaItemImpl) then) =
      __$$StoryMediaItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? url,
      String? status,
      @JsonKey(name: '_id') String? id,
      String? type});
}

/// @nodoc
class __$$StoryMediaItemImplCopyWithImpl<$Res>
    extends _$StoryMediaItemCopyWithImpl<$Res, _$StoryMediaItemImpl>
    implements _$$StoryMediaItemImplCopyWith<$Res> {
  __$$StoryMediaItemImplCopyWithImpl(
      _$StoryMediaItemImpl _value, $Res Function(_$StoryMediaItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryMediaItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? status = freezed,
    Object? id = freezed,
    Object? type = freezed,
  }) {
    return _then(_$StoryMediaItemImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryMediaItemImpl implements _StoryMediaItem {
  const _$StoryMediaItemImpl(
      {this.url, this.status, @JsonKey(name: '_id') this.id, this.type});

  factory _$StoryMediaItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryMediaItemImplFromJson(json);

  @override
  final String? url;
  @override
  final String? status;
  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? type;

  @override
  String toString() {
    return 'StoryMediaItem(url: $url, status: $status, id: $id, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryMediaItemImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, status, id, type);

  /// Create a copy of StoryMediaItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryMediaItemImplCopyWith<_$StoryMediaItemImpl> get copyWith =>
      __$$StoryMediaItemImplCopyWithImpl<_$StoryMediaItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryMediaItemImplToJson(
      this,
    );
  }
}

abstract class _StoryMediaItem implements StoryMediaItem {
  const factory _StoryMediaItem(
      {final String? url,
      final String? status,
      @JsonKey(name: '_id') final String? id,
      final String? type}) = _$StoryMediaItemImpl;

  factory _StoryMediaItem.fromJson(Map<String, dynamic> json) =
      _$StoryMediaItemImpl.fromJson;

  @override
  String? get url;
  @override
  String? get status;
  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get type;

  /// Create a copy of StoryMediaItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryMediaItemImplCopyWith<_$StoryMediaItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryChooseTypeId _$StoryChooseTypeIdFromJson(Map<String, dynamic> json) {
  return _StoryChooseTypeId.fromJson(json);
}

/// @nodoc
mixin _$StoryChooseTypeId {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get gurudwara_id => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  List<StoryAdditionalInfo>? get additional_info =>
      throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  StoryCompanyInfo? get companyInfo => throw _privateConstructorUsedError;
  StoryLogo? get logo => throw _privateConstructorUsedError;
  String? get vendorId => throw _privateConstructorUsedError;

  /// Serializes this StoryChooseTypeId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryChooseTypeIdCopyWith<StoryChooseTypeId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryChooseTypeIdCopyWith<$Res> {
  factory $StoryChooseTypeIdCopyWith(
          StoryChooseTypeId value, $Res Function(StoryChooseTypeId) then) =
      _$StoryChooseTypeIdCopyWithImpl<$Res, StoryChooseTypeId>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? gurudwara_id,
      String? image,
      List<StoryAdditionalInfo>? additional_info,
      String? updatedAt,
      StoryCompanyInfo? companyInfo,
      StoryLogo? logo,
      String? vendorId});

  $StoryCompanyInfoCopyWith<$Res>? get companyInfo;
  $StoryLogoCopyWith<$Res>? get logo;
}

/// @nodoc
class _$StoryChooseTypeIdCopyWithImpl<$Res, $Val extends StoryChooseTypeId>
    implements $StoryChooseTypeIdCopyWith<$Res> {
  _$StoryChooseTypeIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? gurudwara_id = freezed,
    Object? image = freezed,
    Object? additional_info = freezed,
    Object? updatedAt = freezed,
    Object? companyInfo = freezed,
    Object? logo = freezed,
    Object? vendorId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      gurudwara_id: freezed == gurudwara_id
          ? _value.gurudwara_id
          : gurudwara_id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      additional_info: freezed == additional_info
          ? _value.additional_info
          : additional_info // ignore: cast_nullable_to_non_nullable
              as List<StoryAdditionalInfo>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      companyInfo: freezed == companyInfo
          ? _value.companyInfo
          : companyInfo // ignore: cast_nullable_to_non_nullable
              as StoryCompanyInfo?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as StoryLogo?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryCompanyInfoCopyWith<$Res>? get companyInfo {
    if (_value.companyInfo == null) {
      return null;
    }

    return $StoryCompanyInfoCopyWith<$Res>(_value.companyInfo!, (value) {
      return _then(_value.copyWith(companyInfo: value) as $Val);
    });
  }

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StoryLogoCopyWith<$Res>? get logo {
    if (_value.logo == null) {
      return null;
    }

    return $StoryLogoCopyWith<$Res>(_value.logo!, (value) {
      return _then(_value.copyWith(logo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StoryChooseTypeIdImplCopyWith<$Res>
    implements $StoryChooseTypeIdCopyWith<$Res> {
  factory _$$StoryChooseTypeIdImplCopyWith(_$StoryChooseTypeIdImpl value,
          $Res Function(_$StoryChooseTypeIdImpl) then) =
      __$$StoryChooseTypeIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? gurudwara_id,
      String? image,
      List<StoryAdditionalInfo>? additional_info,
      String? updatedAt,
      StoryCompanyInfo? companyInfo,
      StoryLogo? logo,
      String? vendorId});

  @override
  $StoryCompanyInfoCopyWith<$Res>? get companyInfo;
  @override
  $StoryLogoCopyWith<$Res>? get logo;
}

/// @nodoc
class __$$StoryChooseTypeIdImplCopyWithImpl<$Res>
    extends _$StoryChooseTypeIdCopyWithImpl<$Res, _$StoryChooseTypeIdImpl>
    implements _$$StoryChooseTypeIdImplCopyWith<$Res> {
  __$$StoryChooseTypeIdImplCopyWithImpl(_$StoryChooseTypeIdImpl _value,
      $Res Function(_$StoryChooseTypeIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? gurudwara_id = freezed,
    Object? image = freezed,
    Object? additional_info = freezed,
    Object? updatedAt = freezed,
    Object? companyInfo = freezed,
    Object? logo = freezed,
    Object? vendorId = freezed,
  }) {
    return _then(_$StoryChooseTypeIdImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      gurudwara_id: freezed == gurudwara_id
          ? _value.gurudwara_id
          : gurudwara_id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      additional_info: freezed == additional_info
          ? _value._additional_info
          : additional_info // ignore: cast_nullable_to_non_nullable
              as List<StoryAdditionalInfo>?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      companyInfo: freezed == companyInfo
          ? _value.companyInfo
          : companyInfo // ignore: cast_nullable_to_non_nullable
              as StoryCompanyInfo?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as StoryLogo?,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryChooseTypeIdImpl implements _StoryChooseTypeId {
  const _$StoryChooseTypeIdImpl(
      {@JsonKey(name: '_id') this.id,
      this.gurudwara_id,
      this.image,
      final List<StoryAdditionalInfo>? additional_info,
      this.updatedAt,
      this.companyInfo,
      this.logo,
      this.vendorId})
      : _additional_info = additional_info;

  factory _$StoryChooseTypeIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryChooseTypeIdImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? gurudwara_id;
  @override
  final String? image;
  final List<StoryAdditionalInfo>? _additional_info;
  @override
  List<StoryAdditionalInfo>? get additional_info {
    final value = _additional_info;
    if (value == null) return null;
    if (_additional_info is EqualUnmodifiableListView) return _additional_info;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? updatedAt;
  @override
  final StoryCompanyInfo? companyInfo;
  @override
  final StoryLogo? logo;
  @override
  final String? vendorId;

  @override
  String toString() {
    return 'StoryChooseTypeId(id: $id, gurudwara_id: $gurudwara_id, image: $image, additional_info: $additional_info, updatedAt: $updatedAt, companyInfo: $companyInfo, logo: $logo, vendorId: $vendorId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryChooseTypeIdImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gurudwara_id, gurudwara_id) ||
                other.gurudwara_id == gurudwara_id) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality()
                .equals(other._additional_info, _additional_info) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.companyInfo, companyInfo) ||
                other.companyInfo == companyInfo) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      gurudwara_id,
      image,
      const DeepCollectionEquality().hash(_additional_info),
      updatedAt,
      companyInfo,
      logo,
      vendorId);

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryChooseTypeIdImplCopyWith<_$StoryChooseTypeIdImpl> get copyWith =>
      __$$StoryChooseTypeIdImplCopyWithImpl<_$StoryChooseTypeIdImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryChooseTypeIdImplToJson(
      this,
    );
  }
}

abstract class _StoryChooseTypeId implements StoryChooseTypeId {
  const factory _StoryChooseTypeId(
      {@JsonKey(name: '_id') final String? id,
      final String? gurudwara_id,
      final String? image,
      final List<StoryAdditionalInfo>? additional_info,
      final String? updatedAt,
      final StoryCompanyInfo? companyInfo,
      final StoryLogo? logo,
      final String? vendorId}) = _$StoryChooseTypeIdImpl;

  factory _StoryChooseTypeId.fromJson(Map<String, dynamic> json) =
      _$StoryChooseTypeIdImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get gurudwara_id;
  @override
  String? get image;
  @override
  List<StoryAdditionalInfo>? get additional_info;
  @override
  String? get updatedAt;
  @override
  StoryCompanyInfo? get companyInfo;
  @override
  StoryLogo? get logo;
  @override
  String? get vendorId;

  /// Create a copy of StoryChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryChooseTypeIdImplCopyWith<_$StoryChooseTypeIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryAdditionalInfo _$StoryAdditionalInfoFromJson(Map<String, dynamic> json) {
  return _StoryAdditionalInfo.fromJson(json);
}

/// @nodoc
mixin _$StoryAdditionalInfo {
  String? get title => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this StoryAdditionalInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryAdditionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryAdditionalInfoCopyWith<StoryAdditionalInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryAdditionalInfoCopyWith<$Res> {
  factory $StoryAdditionalInfoCopyWith(
          StoryAdditionalInfo value, $Res Function(StoryAdditionalInfo) then) =
      _$StoryAdditionalInfoCopyWithImpl<$Res, StoryAdditionalInfo>;
  @useResult
  $Res call({String? title, String? content, @JsonKey(name: '_id') String? id});
}

/// @nodoc
class _$StoryAdditionalInfoCopyWithImpl<$Res, $Val extends StoryAdditionalInfo>
    implements $StoryAdditionalInfoCopyWith<$Res> {
  _$StoryAdditionalInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryAdditionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? content = freezed,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryAdditionalInfoImplCopyWith<$Res>
    implements $StoryAdditionalInfoCopyWith<$Res> {
  factory _$$StoryAdditionalInfoImplCopyWith(_$StoryAdditionalInfoImpl value,
          $Res Function(_$StoryAdditionalInfoImpl) then) =
      __$$StoryAdditionalInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? title, String? content, @JsonKey(name: '_id') String? id});
}

/// @nodoc
class __$$StoryAdditionalInfoImplCopyWithImpl<$Res>
    extends _$StoryAdditionalInfoCopyWithImpl<$Res, _$StoryAdditionalInfoImpl>
    implements _$$StoryAdditionalInfoImplCopyWith<$Res> {
  __$$StoryAdditionalInfoImplCopyWithImpl(_$StoryAdditionalInfoImpl _value,
      $Res Function(_$StoryAdditionalInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryAdditionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? content = freezed,
    Object? id = freezed,
  }) {
    return _then(_$StoryAdditionalInfoImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryAdditionalInfoImpl implements _StoryAdditionalInfo {
  const _$StoryAdditionalInfoImpl(
      {this.title, this.content, @JsonKey(name: '_id') this.id});

  factory _$StoryAdditionalInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryAdditionalInfoImplFromJson(json);

  @override
  final String? title;
  @override
  final String? content;
  @override
  @JsonKey(name: '_id')
  final String? id;

  @override
  String toString() {
    return 'StoryAdditionalInfo(title: $title, content: $content, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryAdditionalInfoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, id);

  /// Create a copy of StoryAdditionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryAdditionalInfoImplCopyWith<_$StoryAdditionalInfoImpl> get copyWith =>
      __$$StoryAdditionalInfoImplCopyWithImpl<_$StoryAdditionalInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryAdditionalInfoImplToJson(
      this,
    );
  }
}

abstract class _StoryAdditionalInfo implements StoryAdditionalInfo {
  const factory _StoryAdditionalInfo(
      {final String? title,
      final String? content,
      @JsonKey(name: '_id') final String? id}) = _$StoryAdditionalInfoImpl;

  factory _StoryAdditionalInfo.fromJson(Map<String, dynamic> json) =
      _$StoryAdditionalInfoImpl.fromJson;

  @override
  String? get title;
  @override
  String? get content;
  @override
  @JsonKey(name: '_id')
  String? get id;

  /// Create a copy of StoryAdditionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryAdditionalInfoImplCopyWith<_$StoryAdditionalInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryCompanyInfo _$StoryCompanyInfoFromJson(Map<String, dynamic> json) {
  return _StoryCompanyInfo.fromJson(json);
}

/// @nodoc
mixin _$StoryCompanyInfo {
  String? get companyName => throw _privateConstructorUsedError;
  String? get establishYear => throw _privateConstructorUsedError;
  String? get companyCeo => throw _privateConstructorUsedError;

  /// Serializes this StoryCompanyInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryCompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryCompanyInfoCopyWith<StoryCompanyInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCompanyInfoCopyWith<$Res> {
  factory $StoryCompanyInfoCopyWith(
          StoryCompanyInfo value, $Res Function(StoryCompanyInfo) then) =
      _$StoryCompanyInfoCopyWithImpl<$Res, StoryCompanyInfo>;
  @useResult
  $Res call({String? companyName, String? establishYear, String? companyCeo});
}

/// @nodoc
class _$StoryCompanyInfoCopyWithImpl<$Res, $Val extends StoryCompanyInfo>
    implements $StoryCompanyInfoCopyWith<$Res> {
  _$StoryCompanyInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryCompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = freezed,
    Object? establishYear = freezed,
    Object? companyCeo = freezed,
  }) {
    return _then(_value.copyWith(
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      establishYear: freezed == establishYear
          ? _value.establishYear
          : establishYear // ignore: cast_nullable_to_non_nullable
              as String?,
      companyCeo: freezed == companyCeo
          ? _value.companyCeo
          : companyCeo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryCompanyInfoImplCopyWith<$Res>
    implements $StoryCompanyInfoCopyWith<$Res> {
  factory _$$StoryCompanyInfoImplCopyWith(_$StoryCompanyInfoImpl value,
          $Res Function(_$StoryCompanyInfoImpl) then) =
      __$$StoryCompanyInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? companyName, String? establishYear, String? companyCeo});
}

/// @nodoc
class __$$StoryCompanyInfoImplCopyWithImpl<$Res>
    extends _$StoryCompanyInfoCopyWithImpl<$Res, _$StoryCompanyInfoImpl>
    implements _$$StoryCompanyInfoImplCopyWith<$Res> {
  __$$StoryCompanyInfoImplCopyWithImpl(_$StoryCompanyInfoImpl _value,
      $Res Function(_$StoryCompanyInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryCompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = freezed,
    Object? establishYear = freezed,
    Object? companyCeo = freezed,
  }) {
    return _then(_$StoryCompanyInfoImpl(
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      establishYear: freezed == establishYear
          ? _value.establishYear
          : establishYear // ignore: cast_nullable_to_non_nullable
              as String?,
      companyCeo: freezed == companyCeo
          ? _value.companyCeo
          : companyCeo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryCompanyInfoImpl implements _StoryCompanyInfo {
  const _$StoryCompanyInfoImpl(
      {this.companyName, this.establishYear, this.companyCeo});

  factory _$StoryCompanyInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryCompanyInfoImplFromJson(json);

  @override
  final String? companyName;
  @override
  final String? establishYear;
  @override
  final String? companyCeo;

  @override
  String toString() {
    return 'StoryCompanyInfo(companyName: $companyName, establishYear: $establishYear, companyCeo: $companyCeo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryCompanyInfoImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.establishYear, establishYear) ||
                other.establishYear == establishYear) &&
            (identical(other.companyCeo, companyCeo) ||
                other.companyCeo == companyCeo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, companyName, establishYear, companyCeo);

  /// Create a copy of StoryCompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryCompanyInfoImplCopyWith<_$StoryCompanyInfoImpl> get copyWith =>
      __$$StoryCompanyInfoImplCopyWithImpl<_$StoryCompanyInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryCompanyInfoImplToJson(
      this,
    );
  }
}

abstract class _StoryCompanyInfo implements StoryCompanyInfo {
  const factory _StoryCompanyInfo(
      {final String? companyName,
      final String? establishYear,
      final String? companyCeo}) = _$StoryCompanyInfoImpl;

  factory _StoryCompanyInfo.fromJson(Map<String, dynamic> json) =
      _$StoryCompanyInfoImpl.fromJson;

  @override
  String? get companyName;
  @override
  String? get establishYear;
  @override
  String? get companyCeo;

  /// Create a copy of StoryCompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryCompanyInfoImplCopyWith<_$StoryCompanyInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryLogo _$StoryLogoFromJson(Map<String, dynamic> json) {
  return _StoryLogo.fromJson(json);
}

/// @nodoc
mixin _$StoryLogo {
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this StoryLogo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryLogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryLogoCopyWith<StoryLogo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryLogoCopyWith<$Res> {
  factory $StoryLogoCopyWith(StoryLogo value, $Res Function(StoryLogo) then) =
      _$StoryLogoCopyWithImpl<$Res, StoryLogo>;
  @useResult
  $Res call({String? url});
}

/// @nodoc
class _$StoryLogoCopyWithImpl<$Res, $Val extends StoryLogo>
    implements $StoryLogoCopyWith<$Res> {
  _$StoryLogoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryLogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryLogoImplCopyWith<$Res>
    implements $StoryLogoCopyWith<$Res> {
  factory _$$StoryLogoImplCopyWith(
          _$StoryLogoImpl value, $Res Function(_$StoryLogoImpl) then) =
      __$$StoryLogoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url});
}

/// @nodoc
class __$$StoryLogoImplCopyWithImpl<$Res>
    extends _$StoryLogoCopyWithImpl<$Res, _$StoryLogoImpl>
    implements _$$StoryLogoImplCopyWith<$Res> {
  __$$StoryLogoImplCopyWithImpl(
      _$StoryLogoImpl _value, $Res Function(_$StoryLogoImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryLogo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
  }) {
    return _then(_$StoryLogoImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryLogoImpl implements _StoryLogo {
  const _$StoryLogoImpl({this.url});

  factory _$StoryLogoImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryLogoImplFromJson(json);

  @override
  final String? url;

  @override
  String toString() {
    return 'StoryLogo(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryLogoImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  /// Create a copy of StoryLogo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryLogoImplCopyWith<_$StoryLogoImpl> get copyWith =>
      __$$StoryLogoImplCopyWithImpl<_$StoryLogoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryLogoImplToJson(
      this,
    );
  }
}

abstract class _StoryLogo implements StoryLogo {
  const factory _StoryLogo({final String? url}) = _$StoryLogoImpl;

  factory _StoryLogo.fromJson(Map<String, dynamic> json) =
      _$StoryLogoImpl.fromJson;

  @override
  String? get url;

  /// Create a copy of StoryLogo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryLogoImplCopyWith<_$StoryLogoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryReactionCount _$StoryReactionCountFromJson(Map<String, dynamic> json) {
  return _StoryReactionCount.fromJson(json);
}

/// @nodoc
mixin _$StoryReactionCount {
  int? get LOVE => throw _privateConstructorUsedError;
  int? get HAHA => throw _privateConstructorUsedError;
  int? get SAD => throw _privateConstructorUsedError;
  int? get ANGRY => throw _privateConstructorUsedError;
  int? get SURPRISE => throw _privateConstructorUsedError;

  /// Serializes this StoryReactionCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryReactionCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryReactionCountCopyWith<StoryReactionCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryReactionCountCopyWith<$Res> {
  factory $StoryReactionCountCopyWith(
          StoryReactionCount value, $Res Function(StoryReactionCount) then) =
      _$StoryReactionCountCopyWithImpl<$Res, StoryReactionCount>;
  @useResult
  $Res call({int? LOVE, int? HAHA, int? SAD, int? ANGRY, int? SURPRISE});
}

/// @nodoc
class _$StoryReactionCountCopyWithImpl<$Res, $Val extends StoryReactionCount>
    implements $StoryReactionCountCopyWith<$Res> {
  _$StoryReactionCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryReactionCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? LOVE = freezed,
    Object? HAHA = freezed,
    Object? SAD = freezed,
    Object? ANGRY = freezed,
    Object? SURPRISE = freezed,
  }) {
    return _then(_value.copyWith(
      LOVE: freezed == LOVE
          ? _value.LOVE
          : LOVE // ignore: cast_nullable_to_non_nullable
              as int?,
      HAHA: freezed == HAHA
          ? _value.HAHA
          : HAHA // ignore: cast_nullable_to_non_nullable
              as int?,
      SAD: freezed == SAD
          ? _value.SAD
          : SAD // ignore: cast_nullable_to_non_nullable
              as int?,
      ANGRY: freezed == ANGRY
          ? _value.ANGRY
          : ANGRY // ignore: cast_nullable_to_non_nullable
              as int?,
      SURPRISE: freezed == SURPRISE
          ? _value.SURPRISE
          : SURPRISE // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryReactionCountImplCopyWith<$Res>
    implements $StoryReactionCountCopyWith<$Res> {
  factory _$$StoryReactionCountImplCopyWith(_$StoryReactionCountImpl value,
          $Res Function(_$StoryReactionCountImpl) then) =
      __$$StoryReactionCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? LOVE, int? HAHA, int? SAD, int? ANGRY, int? SURPRISE});
}

/// @nodoc
class __$$StoryReactionCountImplCopyWithImpl<$Res>
    extends _$StoryReactionCountCopyWithImpl<$Res, _$StoryReactionCountImpl>
    implements _$$StoryReactionCountImplCopyWith<$Res> {
  __$$StoryReactionCountImplCopyWithImpl(_$StoryReactionCountImpl _value,
      $Res Function(_$StoryReactionCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryReactionCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? LOVE = freezed,
    Object? HAHA = freezed,
    Object? SAD = freezed,
    Object? ANGRY = freezed,
    Object? SURPRISE = freezed,
  }) {
    return _then(_$StoryReactionCountImpl(
      LOVE: freezed == LOVE
          ? _value.LOVE
          : LOVE // ignore: cast_nullable_to_non_nullable
              as int?,
      HAHA: freezed == HAHA
          ? _value.HAHA
          : HAHA // ignore: cast_nullable_to_non_nullable
              as int?,
      SAD: freezed == SAD
          ? _value.SAD
          : SAD // ignore: cast_nullable_to_non_nullable
              as int?,
      ANGRY: freezed == ANGRY
          ? _value.ANGRY
          : ANGRY // ignore: cast_nullable_to_non_nullable
              as int?,
      SURPRISE: freezed == SURPRISE
          ? _value.SURPRISE
          : SURPRISE // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryReactionCountImpl implements _StoryReactionCount {
  const _$StoryReactionCountImpl(
      {this.LOVE, this.HAHA, this.SAD, this.ANGRY, this.SURPRISE});

  factory _$StoryReactionCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryReactionCountImplFromJson(json);

  @override
  final int? LOVE;
  @override
  final int? HAHA;
  @override
  final int? SAD;
  @override
  final int? ANGRY;
  @override
  final int? SURPRISE;

  @override
  String toString() {
    return 'StoryReactionCount(LOVE: $LOVE, HAHA: $HAHA, SAD: $SAD, ANGRY: $ANGRY, SURPRISE: $SURPRISE)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryReactionCountImpl &&
            (identical(other.LOVE, LOVE) || other.LOVE == LOVE) &&
            (identical(other.HAHA, HAHA) || other.HAHA == HAHA) &&
            (identical(other.SAD, SAD) || other.SAD == SAD) &&
            (identical(other.ANGRY, ANGRY) || other.ANGRY == ANGRY) &&
            (identical(other.SURPRISE, SURPRISE) ||
                other.SURPRISE == SURPRISE));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, LOVE, HAHA, SAD, ANGRY, SURPRISE);

  /// Create a copy of StoryReactionCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryReactionCountImplCopyWith<_$StoryReactionCountImpl> get copyWith =>
      __$$StoryReactionCountImplCopyWithImpl<_$StoryReactionCountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryReactionCountImplToJson(
      this,
    );
  }
}

abstract class _StoryReactionCount implements StoryReactionCount {
  const factory _StoryReactionCount(
      {final int? LOVE,
      final int? HAHA,
      final int? SAD,
      final int? ANGRY,
      final int? SURPRISE}) = _$StoryReactionCountImpl;

  factory _StoryReactionCount.fromJson(Map<String, dynamic> json) =
      _$StoryReactionCountImpl.fromJson;

  @override
  int? get LOVE;
  @override
  int? get HAHA;
  @override
  int? get SAD;
  @override
  int? get ANGRY;
  @override
  int? get SURPRISE;

  /// Create a copy of StoryReactionCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryReactionCountImplCopyWith<_$StoryReactionCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryReactionRequest _$StoryReactionRequestFromJson(Map<String, dynamic> json) {
  return _StoryReactionRequest.fromJson(json);
}

/// @nodoc
mixin _$StoryReactionRequest {
  String get storyId => throw _privateConstructorUsedError;
  String get reactionType => throw _privateConstructorUsedError;

  /// Serializes this StoryReactionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryReactionRequestCopyWith<StoryReactionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryReactionRequestCopyWith<$Res> {
  factory $StoryReactionRequestCopyWith(StoryReactionRequest value,
          $Res Function(StoryReactionRequest) then) =
      _$StoryReactionRequestCopyWithImpl<$Res, StoryReactionRequest>;
  @useResult
  $Res call({String storyId, String reactionType});
}

/// @nodoc
class _$StoryReactionRequestCopyWithImpl<$Res,
        $Val extends StoryReactionRequest>
    implements $StoryReactionRequestCopyWith<$Res> {
  _$StoryReactionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storyId = null,
    Object? reactionType = null,
  }) {
    return _then(_value.copyWith(
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoryReactionRequestImplCopyWith<$Res>
    implements $StoryReactionRequestCopyWith<$Res> {
  factory _$$StoryReactionRequestImplCopyWith(_$StoryReactionRequestImpl value,
          $Res Function(_$StoryReactionRequestImpl) then) =
      __$$StoryReactionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storyId, String reactionType});
}

/// @nodoc
class __$$StoryReactionRequestImplCopyWithImpl<$Res>
    extends _$StoryReactionRequestCopyWithImpl<$Res, _$StoryReactionRequestImpl>
    implements _$$StoryReactionRequestImplCopyWith<$Res> {
  __$$StoryReactionRequestImplCopyWithImpl(_$StoryReactionRequestImpl _value,
      $Res Function(_$StoryReactionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storyId = null,
    Object? reactionType = null,
  }) {
    return _then(_$StoryReactionRequestImpl(
      storyId: null == storyId
          ? _value.storyId
          : storyId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryReactionRequestImpl implements _StoryReactionRequest {
  const _$StoryReactionRequestImpl(
      {required this.storyId, required this.reactionType});

  factory _$StoryReactionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryReactionRequestImplFromJson(json);

  @override
  final String storyId;
  @override
  final String reactionType;

  @override
  String toString() {
    return 'StoryReactionRequest(storyId: $storyId, reactionType: $reactionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryReactionRequestImpl &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storyId, reactionType);

  /// Create a copy of StoryReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryReactionRequestImplCopyWith<_$StoryReactionRequestImpl>
      get copyWith =>
          __$$StoryReactionRequestImplCopyWithImpl<_$StoryReactionRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryReactionRequestImplToJson(
      this,
    );
  }
}

abstract class _StoryReactionRequest implements StoryReactionRequest {
  const factory _StoryReactionRequest(
      {required final String storyId,
      required final String reactionType}) = _$StoryReactionRequestImpl;

  factory _StoryReactionRequest.fromJson(Map<String, dynamic> json) =
      _$StoryReactionRequestImpl.fromJson;

  @override
  String get storyId;
  @override
  String get reactionType;

  /// Create a copy of StoryReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryReactionRequestImplCopyWith<_$StoryReactionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
