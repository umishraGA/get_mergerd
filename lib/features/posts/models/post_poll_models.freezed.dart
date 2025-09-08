// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_poll_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostPollResponse _$PostPollResponseFromJson(Map<String, dynamic> json) {
  return _PostPollResponse.fromJson(json);
}

/// @nodoc
mixin _$PostPollResponse {
  int? get statusCode => throw _privateConstructorUsedError;
  List<PostPollItem>? get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool? get success => throw _privateConstructorUsedError;

  /// Serializes this PostPollResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostPollResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostPollResponseCopyWith<PostPollResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostPollResponseCopyWith<$Res> {
  factory $PostPollResponseCopyWith(
          PostPollResponse value, $Res Function(PostPollResponse) then) =
      _$PostPollResponseCopyWithImpl<$Res, PostPollResponse>;
  @useResult
  $Res call(
      {int? statusCode,
      List<PostPollItem>? data,
      String? message,
      bool? success});
}

/// @nodoc
class _$PostPollResponseCopyWithImpl<$Res, $Val extends PostPollResponse>
    implements $PostPollResponseCopyWith<$Res> {
  _$PostPollResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostPollResponse
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
              as List<PostPollItem>?,
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
abstract class _$$PostPollResponseImplCopyWith<$Res>
    implements $PostPollResponseCopyWith<$Res> {
  factory _$$PostPollResponseImplCopyWith(_$PostPollResponseImpl value,
          $Res Function(_$PostPollResponseImpl) then) =
      __$$PostPollResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statusCode,
      List<PostPollItem>? data,
      String? message,
      bool? success});
}

/// @nodoc
class __$$PostPollResponseImplCopyWithImpl<$Res>
    extends _$PostPollResponseCopyWithImpl<$Res, _$PostPollResponseImpl>
    implements _$$PostPollResponseImplCopyWith<$Res> {
  __$$PostPollResponseImplCopyWithImpl(_$PostPollResponseImpl _value,
      $Res Function(_$PostPollResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostPollResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = freezed,
    Object? data = freezed,
    Object? message = freezed,
    Object? success = freezed,
  }) {
    return _then(_$PostPollResponseImpl(
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<PostPollItem>?,
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
class _$PostPollResponseImpl implements _PostPollResponse {
  const _$PostPollResponseImpl(
      {this.statusCode,
      final List<PostPollItem>? data,
      this.message,
      this.success})
      : _data = data;

  factory _$PostPollResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostPollResponseImplFromJson(json);

  @override
  final int? statusCode;
  final List<PostPollItem>? _data;
  @override
  List<PostPollItem>? get data {
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
    return 'PostPollResponse(statusCode: $statusCode, data: $data, message: $message, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostPollResponseImpl &&
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

  /// Create a copy of PostPollResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostPollResponseImplCopyWith<_$PostPollResponseImpl> get copyWith =>
      __$$PostPollResponseImplCopyWithImpl<_$PostPollResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostPollResponseImplToJson(
      this,
    );
  }
}

abstract class _PostPollResponse implements PostPollResponse {
  const factory _PostPollResponse(
      {final int? statusCode,
      final List<PostPollItem>? data,
      final String? message,
      final bool? success}) = _$PostPollResponseImpl;

  factory _PostPollResponse.fromJson(Map<String, dynamic> json) =
      _$PostPollResponseImpl.fromJson;

  @override
  int? get statusCode;
  @override
  List<PostPollItem>? get data;
  @override
  String? get message;
  @override
  bool? get success;

  /// Create a copy of PostPollResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostPollResponseImplCopyWith<_$PostPollResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostPollItem _$PostPollItemFromJson(Map<String, dynamic> json) {
  return _PostPollItem.fromJson(json);
}

/// @nodoc
mixin _$PostPollItem {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get chooseType => throw _privateConstructorUsedError;
  String? get chooseTypeModel => throw _privateConstructorUsedError;
  String? get locution => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get locutionkm => throw _privateConstructorUsedError;
  String? get locationKm => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get latCoordinage => throw _privateConstructorUsedError;
  String? get latCoordinate => throw _privateConstructorUsedError;
  String? get langCoordinagee => throw _privateConstructorUsedError;
  String? get lngCoordinate => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  List<LikeItem> get likes => throw _privateConstructorUsedError;
  List<PostItem> get media => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get postId => throw _privateConstructorUsedError;
  @JsonKey(name: '__v')
  int? get version => throw _privateConstructorUsedError;
  dynamic get chooseTypeId => throw _privateConstructorUsedError;
  String? get approveBy => throw _privateConstructorUsedError;
  List<ReactionsItem> get reactions => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  bool get isLikedByUser => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  List<ReactionItem> get reactionCount => throw _privateConstructorUsedError;
  UserReaction? get userReaction => throw _privateConstructorUsedError;
  bool get follow => throw _privateConstructorUsedError;
  bool get isPostSaved => throw _privateConstructorUsedError;
  String? get question => throw _privateConstructorUsedError;
  String? get shareUrl => throw _privateConstructorUsedError;
  String? get pollsId => throw _privateConstructorUsedError;
  List<PollOptionsItem>? get options => throw _privateConstructorUsedError;

  /// Serializes this PostPollItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostPollItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostPollItemCopyWith<PostPollItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostPollItemCopyWith<$Res> {
  factory $PostPollItemCopyWith(
          PostPollItem value, $Res Function(PostPollItem) then) =
      _$PostPollItemCopyWithImpl<$Res, PostPollItem>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
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
      List<LikeItem> likes,
      List<PostItem> media,
      String? createdAt,
      String? updatedAt,
      String? postId,
      @JsonKey(name: '__v') int? version,
      dynamic chooseTypeId,
      String? approveBy,
      List<ReactionsItem> reactions,
      int likesCount,
      bool isLikedByUser,
      int commentCount,
      List<ReactionItem> reactionCount,
      UserReaction? userReaction,
      bool follow,
      bool isPostSaved,
      String? question,
      String? shareUrl,
      String? pollsId,
      List<PollOptionsItem>? options});
}

/// @nodoc
class _$PostPollItemCopyWithImpl<$Res, $Val extends PostPollItem>
    implements $PostPollItemCopyWith<$Res> {
  _$PostPollItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostPollItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = freezed,
    Object? chooseType = freezed,
    Object? chooseTypeModel = freezed,
    Object? locution = freezed,
    Object? type = freezed,
    Object? locutionkm = freezed,
    Object? locationKm = freezed,
    Object? status = freezed,
    Object? latCoordinage = freezed,
    Object? latCoordinate = freezed,
    Object? langCoordinagee = freezed,
    Object? lngCoordinate = freezed,
    Object? createdBy = freezed,
    Object? likes = null,
    Object? media = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? postId = freezed,
    Object? version = freezed,
    Object? chooseTypeId = freezed,
    Object? approveBy = freezed,
    Object? reactions = null,
    Object? likesCount = null,
    Object? isLikedByUser = null,
    Object? commentCount = null,
    Object? reactionCount = null,
    Object? userReaction = freezed,
    Object? follow = null,
    Object? isPostSaved = null,
    Object? question = freezed,
    Object? shareUrl = freezed,
    Object? pollsId = freezed,
    Object? options = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      locutionkm: freezed == locutionkm
          ? _value.locutionkm
          : locutionkm // ignore: cast_nullable_to_non_nullable
              as String?,
      locationKm: freezed == locationKm
          ? _value.locationKm
          : locationKm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinage: freezed == latCoordinage
          ? _value.latCoordinage
          : latCoordinage // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinate: freezed == latCoordinate
          ? _value.latCoordinate
          : latCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      langCoordinagee: freezed == langCoordinagee
          ? _value.langCoordinagee
          : langCoordinagee // ignore: cast_nullable_to_non_nullable
              as String?,
      lngCoordinate: freezed == lngCoordinate
          ? _value.lngCoordinate
          : lngCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<LikeItem>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<PostItem>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      approveBy: freezed == approveBy
          ? _value.approveBy
          : approveBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<ReactionsItem>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as List<ReactionItem>,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as UserReaction?,
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPostSaved: null == isPostSaved
          ? _value.isPostSaved
          : isPostSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      shareUrl: freezed == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pollsId: freezed == pollsId
          ? _value.pollsId
          : pollsId // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionsItem>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostPollItemImplCopyWith<$Res>
    implements $PostPollItemCopyWith<$Res> {
  factory _$$PostPollItemImplCopyWith(
          _$PostPollItemImpl value, $Res Function(_$PostPollItemImpl) then) =
      __$$PostPollItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
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
      List<LikeItem> likes,
      List<PostItem> media,
      String? createdAt,
      String? updatedAt,
      String? postId,
      @JsonKey(name: '__v') int? version,
      dynamic chooseTypeId,
      String? approveBy,
      List<ReactionsItem> reactions,
      int likesCount,
      bool isLikedByUser,
      int commentCount,
      List<ReactionItem> reactionCount,
      UserReaction? userReaction,
      bool follow,
      bool isPostSaved,
      String? question,
      String? shareUrl,
      String? pollsId,
      List<PollOptionsItem>? options});
}

/// @nodoc
class __$$PostPollItemImplCopyWithImpl<$Res>
    extends _$PostPollItemCopyWithImpl<$Res, _$PostPollItemImpl>
    implements _$$PostPollItemImplCopyWith<$Res> {
  __$$PostPollItemImplCopyWithImpl(
      _$PostPollItemImpl _value, $Res Function(_$PostPollItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostPollItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = freezed,
    Object? chooseType = freezed,
    Object? chooseTypeModel = freezed,
    Object? locution = freezed,
    Object? type = freezed,
    Object? locutionkm = freezed,
    Object? locationKm = freezed,
    Object? status = freezed,
    Object? latCoordinage = freezed,
    Object? latCoordinate = freezed,
    Object? langCoordinagee = freezed,
    Object? lngCoordinate = freezed,
    Object? createdBy = freezed,
    Object? likes = null,
    Object? media = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? postId = freezed,
    Object? version = freezed,
    Object? chooseTypeId = freezed,
    Object? approveBy = freezed,
    Object? reactions = null,
    Object? likesCount = null,
    Object? isLikedByUser = null,
    Object? commentCount = null,
    Object? reactionCount = null,
    Object? userReaction = freezed,
    Object? follow = null,
    Object? isPostSaved = null,
    Object? question = freezed,
    Object? shareUrl = freezed,
    Object? pollsId = freezed,
    Object? options = freezed,
  }) {
    return _then(_$PostPollItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      locutionkm: freezed == locutionkm
          ? _value.locutionkm
          : locutionkm // ignore: cast_nullable_to_non_nullable
              as String?,
      locationKm: freezed == locationKm
          ? _value.locationKm
          : locationKm // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinage: freezed == latCoordinage
          ? _value.latCoordinage
          : latCoordinage // ignore: cast_nullable_to_non_nullable
              as String?,
      latCoordinate: freezed == latCoordinate
          ? _value.latCoordinate
          : latCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      langCoordinagee: freezed == langCoordinagee
          ? _value.langCoordinagee
          : langCoordinagee // ignore: cast_nullable_to_non_nullable
              as String?,
      lngCoordinate: freezed == lngCoordinate
          ? _value.lngCoordinate
          : lngCoordinate // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: null == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<LikeItem>,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<PostItem>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      approveBy: freezed == approveBy
          ? _value.approveBy
          : approveBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<ReactionsItem>,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactionCount: null == reactionCount
          ? _value._reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as List<ReactionItem>,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as UserReaction?,
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPostSaved: null == isPostSaved
          ? _value.isPostSaved
          : isPostSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      shareUrl: freezed == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pollsId: freezed == pollsId
          ? _value.pollsId
          : pollsId // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionsItem>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostPollItemImpl extends _PostPollItem {
  const _$PostPollItemImpl(
      {@JsonKey(name: '_id') required this.id,
      this.description,
      this.chooseType,
      this.chooseTypeModel,
      this.locution,
      this.type,
      this.locutionkm,
      this.locationKm,
      this.status,
      this.latCoordinage,
      this.latCoordinate,
      this.langCoordinagee,
      this.lngCoordinate,
      this.createdBy,
      final List<LikeItem> likes = const [],
      final List<PostItem> media = const [],
      this.createdAt,
      this.updatedAt,
      this.postId,
      @JsonKey(name: '__v') this.version,
      this.chooseTypeId,
      this.approveBy,
      final List<ReactionsItem> reactions = const [],
      this.likesCount = 0,
      this.isLikedByUser = false,
      this.commentCount = 0,
      final List<ReactionItem> reactionCount = const [],
      this.userReaction,
      this.follow = false,
      this.isPostSaved = false,
      this.question,
      this.shareUrl,
      this.pollsId,
      final List<PollOptionsItem>? options})
      : _likes = likes,
        _media = media,
        _reactions = reactions,
        _reactionCount = reactionCount,
        _options = options,
        super._();

  factory _$PostPollItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostPollItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String? description;
  @override
  final String? chooseType;
  @override
  final String? chooseTypeModel;
  @override
  final String? locution;
  @override
  final String? type;
  @override
  final String? locutionkm;
  @override
  final String? locationKm;
  @override
  final String? status;
  @override
  final String? latCoordinage;
  @override
  final String? latCoordinate;
  @override
  final String? langCoordinagee;
  @override
  final String? lngCoordinate;
  @override
  final String? createdBy;
  final List<LikeItem> _likes;
  @override
  @JsonKey()
  List<LikeItem> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  final List<PostItem> _media;
  @override
  @JsonKey()
  List<PostItem> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? postId;
  @override
  @JsonKey(name: '__v')
  final int? version;
  @override
  final dynamic chooseTypeId;
  @override
  final String? approveBy;
  final List<ReactionsItem> _reactions;
  @override
  @JsonKey()
  List<ReactionsItem> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  @JsonKey()
  final int likesCount;
  @override
  @JsonKey()
  final bool isLikedByUser;
  @override
  @JsonKey()
  final int commentCount;
  final List<ReactionItem> _reactionCount;
  @override
  @JsonKey()
  List<ReactionItem> get reactionCount {
    if (_reactionCount is EqualUnmodifiableListView) return _reactionCount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactionCount);
  }

  @override
  final UserReaction? userReaction;
  @override
  @JsonKey()
  final bool follow;
  @override
  @JsonKey()
  final bool isPostSaved;
  @override
  final String? question;
  @override
  final String? shareUrl;
  @override
  final String? pollsId;
  final List<PollOptionsItem>? _options;
  @override
  List<PollOptionsItem>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PostPollItem(id: $id, description: $description, chooseType: $chooseType, chooseTypeModel: $chooseTypeModel, locution: $locution, type: $type, locutionkm: $locutionkm, locationKm: $locationKm, status: $status, latCoordinage: $latCoordinage, latCoordinate: $latCoordinate, langCoordinagee: $langCoordinagee, lngCoordinate: $lngCoordinate, createdBy: $createdBy, likes: $likes, media: $media, createdAt: $createdAt, updatedAt: $updatedAt, postId: $postId, version: $version, chooseTypeId: $chooseTypeId, approveBy: $approveBy, reactions: $reactions, likesCount: $likesCount, isLikedByUser: $isLikedByUser, commentCount: $commentCount, reactionCount: $reactionCount, userReaction: $userReaction, follow: $follow, isPostSaved: $isPostSaved, question: $question, shareUrl: $shareUrl, pollsId: $pollsId, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostPollItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.chooseType, chooseType) ||
                other.chooseType == chooseType) &&
            (identical(other.chooseTypeModel, chooseTypeModel) ||
                other.chooseTypeModel == chooseTypeModel) &&
            (identical(other.locution, locution) ||
                other.locution == locution) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.locutionkm, locutionkm) ||
                other.locutionkm == locutionkm) &&
            (identical(other.locationKm, locationKm) ||
                other.locationKm == locationKm) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.latCoordinage, latCoordinage) ||
                other.latCoordinage == latCoordinage) &&
            (identical(other.latCoordinate, latCoordinate) ||
                other.latCoordinate == latCoordinate) &&
            (identical(other.langCoordinagee, langCoordinagee) ||
                other.langCoordinagee == langCoordinagee) &&
            (identical(other.lngCoordinate, lngCoordinate) ||
                other.lngCoordinate == lngCoordinate) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality()
                .equals(other.chooseTypeId, chooseTypeId) &&
            (identical(other.approveBy, approveBy) ||
                other.approveBy == approveBy) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.isLikedByUser, isLikedByUser) ||
                other.isLikedByUser == isLikedByUser) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            const DeepCollectionEquality()
                .equals(other._reactionCount, _reactionCount) &&
            (identical(other.userReaction, userReaction) ||
                other.userReaction == userReaction) &&
            (identical(other.follow, follow) || other.follow == follow) &&
            (identical(other.isPostSaved, isPostSaved) ||
                other.isPostSaved == isPostSaved) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.shareUrl, shareUrl) ||
                other.shareUrl == shareUrl) &&
            (identical(other.pollsId, pollsId) || other.pollsId == pollsId) &&
            const DeepCollectionEquality().equals(other._options, _options));
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
        type,
        locutionkm,
        locationKm,
        status,
        latCoordinage,
        latCoordinate,
        langCoordinagee,
        lngCoordinate,
        createdBy,
        const DeepCollectionEquality().hash(_likes),
        const DeepCollectionEquality().hash(_media),
        createdAt,
        updatedAt,
        postId,
        version,
        const DeepCollectionEquality().hash(chooseTypeId),
        approveBy,
        const DeepCollectionEquality().hash(_reactions),
        likesCount,
        isLikedByUser,
        commentCount,
        const DeepCollectionEquality().hash(_reactionCount),
        userReaction,
        follow,
        isPostSaved,
        question,
        shareUrl,
        pollsId,
        const DeepCollectionEquality().hash(_options)
      ]);

  /// Create a copy of PostPollItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostPollItemImplCopyWith<_$PostPollItemImpl> get copyWith =>
      __$$PostPollItemImplCopyWithImpl<_$PostPollItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostPollItemImplToJson(
      this,
    );
  }
}

abstract class _PostPollItem extends PostPollItem {
  const factory _PostPollItem(
      {@JsonKey(name: '_id') required final String id,
      final String? description,
      final String? chooseType,
      final String? chooseTypeModel,
      final String? locution,
      final String? type,
      final String? locutionkm,
      final String? locationKm,
      final String? status,
      final String? latCoordinage,
      final String? latCoordinate,
      final String? langCoordinagee,
      final String? lngCoordinate,
      final String? createdBy,
      final List<LikeItem> likes,
      final List<PostItem> media,
      final String? createdAt,
      final String? updatedAt,
      final String? postId,
      @JsonKey(name: '__v') final int? version,
      final dynamic chooseTypeId,
      final String? approveBy,
      final List<ReactionsItem> reactions,
      final int likesCount,
      final bool isLikedByUser,
      final int commentCount,
      final List<ReactionItem> reactionCount,
      final UserReaction? userReaction,
      final bool follow,
      final bool isPostSaved,
      final String? question,
      final String? shareUrl,
      final String? pollsId,
      final List<PollOptionsItem>? options}) = _$PostPollItemImpl;
  const _PostPollItem._() : super._();

  factory _PostPollItem.fromJson(Map<String, dynamic> json) =
      _$PostPollItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String? get description;
  @override
  String? get chooseType;
  @override
  String? get chooseTypeModel;
  @override
  String? get locution;
  @override
  String? get type;
  @override
  String? get locutionkm;
  @override
  String? get locationKm;
  @override
  String? get status;
  @override
  String? get latCoordinage;
  @override
  String? get latCoordinate;
  @override
  String? get langCoordinagee;
  @override
  String? get lngCoordinate;
  @override
  String? get createdBy;
  @override
  List<LikeItem> get likes;
  @override
  List<PostItem> get media;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get postId;
  @override
  @JsonKey(name: '__v')
  int? get version;
  @override
  dynamic get chooseTypeId;
  @override
  String? get approveBy;
  @override
  List<ReactionsItem> get reactions;
  @override
  int get likesCount;
  @override
  bool get isLikedByUser;
  @override
  int get commentCount;
  @override
  List<ReactionItem> get reactionCount;
  @override
  UserReaction? get userReaction;
  @override
  bool get follow;
  @override
  bool get isPostSaved;
  @override
  String? get question;
  @override
  String? get shareUrl;
  @override
  String? get pollsId;
  @override
  List<PollOptionsItem>? get options;

  /// Create a copy of PostPollItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostPollItemImplCopyWith<_$PostPollItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Logo _$LogoFromJson(Map<String, dynamic> json) {
  return _Logo.fromJson(json);
}

/// @nodoc
mixin _$Logo {
  String get url => throw _privateConstructorUsedError;

  /// Serializes this Logo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Logo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogoCopyWith<Logo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogoCopyWith<$Res> {
  factory $LogoCopyWith(Logo value, $Res Function(Logo) then) =
      _$LogoCopyWithImpl<$Res, Logo>;
  @useResult
  $Res call({String url});
}

/// @nodoc
class _$LogoCopyWithImpl<$Res, $Val extends Logo>
    implements $LogoCopyWith<$Res> {
  _$LogoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Logo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogoImplCopyWith<$Res> implements $LogoCopyWith<$Res> {
  factory _$$LogoImplCopyWith(
          _$LogoImpl value, $Res Function(_$LogoImpl) then) =
      __$$LogoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url});
}

/// @nodoc
class __$$LogoImplCopyWithImpl<$Res>
    extends _$LogoCopyWithImpl<$Res, _$LogoImpl>
    implements _$$LogoImplCopyWith<$Res> {
  __$$LogoImplCopyWithImpl(_$LogoImpl _value, $Res Function(_$LogoImpl) _then)
      : super(_value, _then);

  /// Create a copy of Logo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
  }) {
    return _then(_$LogoImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoImpl implements _Logo {
  const _$LogoImpl({required this.url});

  factory _$LogoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoImplFromJson(json);

  @override
  final String url;

  @override
  String toString() {
    return 'Logo(url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoImpl &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url);

  /// Create a copy of Logo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoImplCopyWith<_$LogoImpl> get copyWith =>
      __$$LogoImplCopyWithImpl<_$LogoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoImplToJson(
      this,
    );
  }
}

abstract class _Logo implements Logo {
  const factory _Logo({required final String url}) = _$LogoImpl;

  factory _Logo.fromJson(Map<String, dynamic> json) = _$LogoImpl.fromJson;

  @override
  String get url;

  /// Create a copy of Logo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogoImplCopyWith<_$LogoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyInfo _$CompanyInfoFromJson(Map<String, dynamic> json) {
  return _CompanyInfo.fromJson(json);
}

/// @nodoc
mixin _$CompanyInfo {
  String? get companyName => throw _privateConstructorUsedError;
  String? get aboutUs => throw _privateConstructorUsedError;

  /// Serializes this CompanyInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyInfoCopyWith<CompanyInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyInfoCopyWith<$Res> {
  factory $CompanyInfoCopyWith(
          CompanyInfo value, $Res Function(CompanyInfo) then) =
      _$CompanyInfoCopyWithImpl<$Res, CompanyInfo>;
  @useResult
  $Res call({String? companyName, String? aboutUs});
}

/// @nodoc
class _$CompanyInfoCopyWithImpl<$Res, $Val extends CompanyInfo>
    implements $CompanyInfoCopyWith<$Res> {
  _$CompanyInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = freezed,
    Object? aboutUs = freezed,
  }) {
    return _then(_value.copyWith(
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      aboutUs: freezed == aboutUs
          ? _value.aboutUs
          : aboutUs // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyInfoImplCopyWith<$Res>
    implements $CompanyInfoCopyWith<$Res> {
  factory _$$CompanyInfoImplCopyWith(
          _$CompanyInfoImpl value, $Res Function(_$CompanyInfoImpl) then) =
      __$$CompanyInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? companyName, String? aboutUs});
}

/// @nodoc
class __$$CompanyInfoImplCopyWithImpl<$Res>
    extends _$CompanyInfoCopyWithImpl<$Res, _$CompanyInfoImpl>
    implements _$$CompanyInfoImplCopyWith<$Res> {
  __$$CompanyInfoImplCopyWithImpl(
      _$CompanyInfoImpl _value, $Res Function(_$CompanyInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = freezed,
    Object? aboutUs = freezed,
  }) {
    return _then(_$CompanyInfoImpl(
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      aboutUs: freezed == aboutUs
          ? _value.aboutUs
          : aboutUs // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyInfoImpl implements _CompanyInfo {
  const _$CompanyInfoImpl({this.companyName, this.aboutUs});

  factory _$CompanyInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyInfoImplFromJson(json);

  @override
  final String? companyName;
  @override
  final String? aboutUs;

  @override
  String toString() {
    return 'CompanyInfo(companyName: $companyName, aboutUs: $aboutUs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyInfoImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.aboutUs, aboutUs) || other.aboutUs == aboutUs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, companyName, aboutUs);

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyInfoImplCopyWith<_$CompanyInfoImpl> get copyWith =>
      __$$CompanyInfoImplCopyWithImpl<_$CompanyInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyInfoImplToJson(
      this,
    );
  }
}

abstract class _CompanyInfo implements CompanyInfo {
  const factory _CompanyInfo(
      {final String? companyName, final String? aboutUs}) = _$CompanyInfoImpl;

  factory _CompanyInfo.fromJson(Map<String, dynamic> json) =
      _$CompanyInfoImpl.fromJson;

  @override
  String? get companyName;
  @override
  String? get aboutUs;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyInfoImplCopyWith<_$CompanyInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChooseTypeId _$ChooseTypeIdFromJson(Map<String, dynamic> json) {
  return _ChooseTypeId.fromJson(json);
}

/// @nodoc
mixin _$ChooseTypeId {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String? get vendorId => throw _privateConstructorUsedError;
  Logo? get logo => throw _privateConstructorUsedError;
  CompanyInfo? get companyInfo => throw _privateConstructorUsedError;

  /// Serializes this ChooseTypeId to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChooseTypeIdCopyWith<ChooseTypeId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChooseTypeIdCopyWith<$Res> {
  factory $ChooseTypeIdCopyWith(
          ChooseTypeId value, $Res Function(ChooseTypeId) then) =
      _$ChooseTypeIdCopyWithImpl<$Res, ChooseTypeId>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String? vendorId,
      Logo? logo,
      CompanyInfo? companyInfo});

  $LogoCopyWith<$Res>? get logo;
  $CompanyInfoCopyWith<$Res>? get companyInfo;
}

/// @nodoc
class _$ChooseTypeIdCopyWithImpl<$Res, $Val extends ChooseTypeId>
    implements $ChooseTypeIdCopyWith<$Res> {
  _$ChooseTypeIdCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = freezed,
    Object? logo = freezed,
    Object? companyInfo = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as Logo?,
      companyInfo: freezed == companyInfo
          ? _value.companyInfo
          : companyInfo // ignore: cast_nullable_to_non_nullable
              as CompanyInfo?,
    ) as $Val);
  }

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LogoCopyWith<$Res>? get logo {
    if (_value.logo == null) {
      return null;
    }

    return $LogoCopyWith<$Res>(_value.logo!, (value) {
      return _then(_value.copyWith(logo: value) as $Val);
    });
  }

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompanyInfoCopyWith<$Res>? get companyInfo {
    if (_value.companyInfo == null) {
      return null;
    }

    return $CompanyInfoCopyWith<$Res>(_value.companyInfo!, (value) {
      return _then(_value.copyWith(companyInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChooseTypeIdImplCopyWith<$Res>
    implements $ChooseTypeIdCopyWith<$Res> {
  factory _$$ChooseTypeIdImplCopyWith(
          _$ChooseTypeIdImpl value, $Res Function(_$ChooseTypeIdImpl) then) =
      __$$ChooseTypeIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String? vendorId,
      Logo? logo,
      CompanyInfo? companyInfo});

  @override
  $LogoCopyWith<$Res>? get logo;
  @override
  $CompanyInfoCopyWith<$Res>? get companyInfo;
}

/// @nodoc
class __$$ChooseTypeIdImplCopyWithImpl<$Res>
    extends _$ChooseTypeIdCopyWithImpl<$Res, _$ChooseTypeIdImpl>
    implements _$$ChooseTypeIdImplCopyWith<$Res> {
  __$$ChooseTypeIdImplCopyWithImpl(
      _$ChooseTypeIdImpl _value, $Res Function(_$ChooseTypeIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = freezed,
    Object? logo = freezed,
    Object? companyInfo = freezed,
  }) {
    return _then(_$ChooseTypeIdImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: freezed == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as Logo?,
      companyInfo: freezed == companyInfo
          ? _value.companyInfo
          : companyInfo // ignore: cast_nullable_to_non_nullable
              as CompanyInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChooseTypeIdImpl implements _ChooseTypeId {
  const _$ChooseTypeIdImpl(
      {@JsonKey(name: '_id') required this.id,
      this.vendorId,
      this.logo,
      this.companyInfo});

  factory _$ChooseTypeIdImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChooseTypeIdImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String? vendorId;
  @override
  final Logo? logo;
  @override
  final CompanyInfo? companyInfo;

  @override
  String toString() {
    return 'ChooseTypeId(id: $id, vendorId: $vendorId, logo: $logo, companyInfo: $companyInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChooseTypeIdImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.companyInfo, companyInfo) ||
                other.companyInfo == companyInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, vendorId, logo, companyInfo);

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChooseTypeIdImplCopyWith<_$ChooseTypeIdImpl> get copyWith =>
      __$$ChooseTypeIdImplCopyWithImpl<_$ChooseTypeIdImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChooseTypeIdImplToJson(
      this,
    );
  }
}

abstract class _ChooseTypeId implements ChooseTypeId {
  const factory _ChooseTypeId(
      {@JsonKey(name: '_id') required final String id,
      final String? vendorId,
      final Logo? logo,
      final CompanyInfo? companyInfo}) = _$ChooseTypeIdImpl;

  factory _ChooseTypeId.fromJson(Map<String, dynamic> json) =
      _$ChooseTypeIdImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String? get vendorId;
  @override
  Logo? get logo;
  @override
  CompanyInfo? get companyInfo;

  /// Create a copy of ChooseTypeId
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChooseTypeIdImplCopyWith<_$ChooseTypeIdImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostItem _$PostItemFromJson(Map<String, dynamic> json) {
  return _PostItem.fromJson(json);
}

/// @nodoc
mixin _$PostItem {
  String? get url => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;

  /// Serializes this PostItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostItemCopyWith<PostItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostItemCopyWith<$Res> {
  factory $PostItemCopyWith(PostItem value, $Res Function(PostItem) then) =
      _$PostItemCopyWithImpl<$Res, PostItem>;
  @useResult
  $Res call({String? url, String? type});
}

/// @nodoc
class _$PostItemCopyWithImpl<$Res, $Val extends PostItem>
    implements $PostItemCopyWith<$Res> {
  _$PostItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostItemImplCopyWith<$Res>
    implements $PostItemCopyWith<$Res> {
  factory _$$PostItemImplCopyWith(
          _$PostItemImpl value, $Res Function(_$PostItemImpl) then) =
      __$$PostItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? url, String? type});
}

/// @nodoc
class __$$PostItemImplCopyWithImpl<$Res>
    extends _$PostItemCopyWithImpl<$Res, _$PostItemImpl>
    implements _$$PostItemImplCopyWith<$Res> {
  __$$PostItemImplCopyWithImpl(
      _$PostItemImpl _value, $Res Function(_$PostItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = freezed,
    Object? type = freezed,
  }) {
    return _then(_$PostItemImpl(
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
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
class _$PostItemImpl implements _PostItem {
  const _$PostItemImpl({this.url, this.type});

  factory _$PostItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostItemImplFromJson(json);

  @override
  final String? url;
  @override
  final String? type;

  @override
  String toString() {
    return 'PostItem(url: $url, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostItemImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, type);

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostItemImplCopyWith<_$PostItemImpl> get copyWith =>
      __$$PostItemImplCopyWithImpl<_$PostItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostItemImplToJson(
      this,
    );
  }
}

abstract class _PostItem implements PostItem {
  const factory _PostItem({final String? url, final String? type}) =
      _$PostItemImpl;

  factory _PostItem.fromJson(Map<String, dynamic> json) =
      _$PostItemImpl.fromJson;

  @override
  String? get url;
  @override
  String? get type;

  /// Create a copy of PostItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostItemImplCopyWith<_$PostItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReactionItem _$ReactionItemFromJson(Map<String, dynamic> json) {
  return _ReactionItem.fromJson(json);
}

/// @nodoc
mixin _$ReactionItem {
  String get name => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this ReactionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionItemCopyWith<ReactionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionItemCopyWith<$Res> {
  factory $ReactionItemCopyWith(
          ReactionItem value, $Res Function(ReactionItem) then) =
      _$ReactionItemCopyWithImpl<$Res, ReactionItem>;
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class _$ReactionItemCopyWithImpl<$Res, $Val extends ReactionItem>
    implements $ReactionItemCopyWith<$Res> {
  _$ReactionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionItemImplCopyWith<$Res>
    implements $ReactionItemCopyWith<$Res> {
  factory _$$ReactionItemImplCopyWith(
          _$ReactionItemImpl value, $Res Function(_$ReactionItemImpl) then) =
      __$$ReactionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int count});
}

/// @nodoc
class __$$ReactionItemImplCopyWithImpl<$Res>
    extends _$ReactionItemCopyWithImpl<$Res, _$ReactionItemImpl>
    implements _$$ReactionItemImplCopyWith<$Res> {
  __$$ReactionItemImplCopyWithImpl(
      _$ReactionItemImpl _value, $Res Function(_$ReactionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? count = null,
  }) {
    return _then(_$ReactionItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionItemImpl implements _ReactionItem {
  const _$ReactionItemImpl({required this.name, required this.count});

  factory _$ReactionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionItemImplFromJson(json);

  @override
  final String name;
  @override
  final int count;

  @override
  String toString() {
    return 'ReactionItem(name: $name, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, count);

  /// Create a copy of ReactionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionItemImplCopyWith<_$ReactionItemImpl> get copyWith =>
      __$$ReactionItemImplCopyWithImpl<_$ReactionItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionItemImplToJson(
      this,
    );
  }
}

abstract class _ReactionItem implements ReactionItem {
  const factory _ReactionItem(
      {required final String name,
      required final int count}) = _$ReactionItemImpl;

  factory _ReactionItem.fromJson(Map<String, dynamic> json) =
      _$ReactionItemImpl.fromJson;

  @override
  String get name;
  @override
  int get count;

  /// Create a copy of ReactionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionItemImplCopyWith<_$ReactionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollOptionsItem _$PollOptionsItemFromJson(Map<String, dynamic> json) {
  return _PollOptionsItem.fromJson(json);
}

/// @nodoc
mixin _$PollOptionsItem {
  String? get option => throw _privateConstructorUsedError;
  int get votes => throw _privateConstructorUsedError;
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  bool? get selected => throw _privateConstructorUsedError;

  /// Serializes this PollOptionsItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollOptionsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollOptionsItemCopyWith<PollOptionsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollOptionsItemCopyWith<$Res> {
  factory $PollOptionsItemCopyWith(
          PollOptionsItem value, $Res Function(PollOptionsItem) then) =
      _$PollOptionsItemCopyWithImpl<$Res, PollOptionsItem>;
  @useResult
  $Res call(
      {String? option,
      int votes,
      @JsonKey(name: '_id') String? id,
      bool? selected});
}

/// @nodoc
class _$PollOptionsItemCopyWithImpl<$Res, $Val extends PollOptionsItem>
    implements $PollOptionsItemCopyWith<$Res> {
  _$PollOptionsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollOptionsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? option = freezed,
    Object? votes = null,
    Object? id = freezed,
    Object? selected = freezed,
  }) {
    return _then(_value.copyWith(
      option: freezed == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollOptionsItemImplCopyWith<$Res>
    implements $PollOptionsItemCopyWith<$Res> {
  factory _$$PollOptionsItemImplCopyWith(_$PollOptionsItemImpl value,
          $Res Function(_$PollOptionsItemImpl) then) =
      __$$PollOptionsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? option,
      int votes,
      @JsonKey(name: '_id') String? id,
      bool? selected});
}

/// @nodoc
class __$$PollOptionsItemImplCopyWithImpl<$Res>
    extends _$PollOptionsItemCopyWithImpl<$Res, _$PollOptionsItemImpl>
    implements _$$PollOptionsItemImplCopyWith<$Res> {
  __$$PollOptionsItemImplCopyWithImpl(
      _$PollOptionsItemImpl _value, $Res Function(_$PollOptionsItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollOptionsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? option = freezed,
    Object? votes = null,
    Object? id = freezed,
    Object? selected = freezed,
  }) {
    return _then(_$PollOptionsItemImpl(
      option: freezed == option
          ? _value.option
          : option // ignore: cast_nullable_to_non_nullable
              as String?,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as int,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollOptionsItemImpl implements _PollOptionsItem {
  const _$PollOptionsItemImpl(
      {this.option,
      this.votes = 0,
      @JsonKey(name: '_id') this.id,
      this.selected});

  factory _$PollOptionsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollOptionsItemImplFromJson(json);

  @override
  final String? option;
  @override
  @JsonKey()
  final int votes;
  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final bool? selected;

  @override
  String toString() {
    return 'PollOptionsItem(option: $option, votes: $votes, id: $id, selected: $selected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollOptionsItemImpl &&
            (identical(other.option, option) || other.option == option) &&
            (identical(other.votes, votes) || other.votes == votes) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.selected, selected) ||
                other.selected == selected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, option, votes, id, selected);

  /// Create a copy of PollOptionsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollOptionsItemImplCopyWith<_$PollOptionsItemImpl> get copyWith =>
      __$$PollOptionsItemImplCopyWithImpl<_$PollOptionsItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollOptionsItemImplToJson(
      this,
    );
  }
}

abstract class _PollOptionsItem implements PollOptionsItem {
  const factory _PollOptionsItem(
      {final String? option,
      final int votes,
      @JsonKey(name: '_id') final String? id,
      final bool? selected}) = _$PollOptionsItemImpl;

  factory _PollOptionsItem.fromJson(Map<String, dynamic> json) =
      _$PollOptionsItemImpl.fromJson;

  @override
  String? get option;
  @override
  int get votes;
  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  bool? get selected;

  /// Create a copy of PollOptionsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollOptionsItemImplCopyWith<_$PollOptionsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ChooseType get chooseType => throw _privateConstructorUsedError;
  ChooseModel get chooseModel => throw _privateConstructorUsedError;
  PostingType get type => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  bool get isLikedByUser => throw _privateConstructorUsedError;
  int get likesCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  PostItem get media => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  ReactionItem get reactionCount => throw _privateConstructorUsedError;
  bool get follow => throw _privateConstructorUsedError;
  bool get isPostSaved => throw _privateConstructorUsedError;
  UserReaction? get userReaction => throw _privateConstructorUsedError;
  String? get question => throw _privateConstructorUsedError;
  List<PollOptionsItem>? get options => throw _privateConstructorUsedError;
  ChooseTypeId? get chooseTypeId => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String description,
      ChooseType chooseType,
      ChooseModel chooseModel,
      PostingType type,
      String createdBy,
      bool isLikedByUser,
      int likesCount,
      int commentCount,
      PostItem media,
      String postId,
      ReactionItem reactionCount,
      bool follow,
      bool isPostSaved,
      UserReaction? userReaction,
      String? question,
      List<PollOptionsItem>? options,
      ChooseTypeId? chooseTypeId});

  $PostItemCopyWith<$Res> get media;
  $ReactionItemCopyWith<$Res> get reactionCount;
  $ChooseTypeIdCopyWith<$Res>? get chooseTypeId;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? chooseType = null,
    Object? chooseModel = null,
    Object? type = null,
    Object? createdBy = null,
    Object? isLikedByUser = null,
    Object? likesCount = null,
    Object? commentCount = null,
    Object? media = null,
    Object? postId = null,
    Object? reactionCount = null,
    Object? follow = null,
    Object? isPostSaved = null,
    Object? userReaction = freezed,
    Object? question = freezed,
    Object? options = freezed,
    Object? chooseTypeId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      chooseType: null == chooseType
          ? _value.chooseType
          : chooseType // ignore: cast_nullable_to_non_nullable
              as ChooseType,
      chooseModel: null == chooseModel
          ? _value.chooseModel
          : chooseModel // ignore: cast_nullable_to_non_nullable
              as ChooseModel,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostingType,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as PostItem,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionCount: null == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as ReactionItem,
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPostSaved: null == isPostSaved
          ? _value.isPostSaved
          : isPostSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as UserReaction?,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionsItem>?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as ChooseTypeId?,
    ) as $Val);
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostItemCopyWith<$Res> get media {
    return $PostItemCopyWith<$Res>(_value.media, (value) {
      return _then(_value.copyWith(media: value) as $Val);
    });
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReactionItemCopyWith<$Res> get reactionCount {
    return $ReactionItemCopyWith<$Res>(_value.reactionCount, (value) {
      return _then(_value.copyWith(reactionCount: value) as $Val);
    });
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChooseTypeIdCopyWith<$Res>? get chooseTypeId {
    if (_value.chooseTypeId == null) {
      return null;
    }

    return $ChooseTypeIdCopyWith<$Res>(_value.chooseTypeId!, (value) {
      return _then(_value.copyWith(chooseTypeId: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String description,
      ChooseType chooseType,
      ChooseModel chooseModel,
      PostingType type,
      String createdBy,
      bool isLikedByUser,
      int likesCount,
      int commentCount,
      PostItem media,
      String postId,
      ReactionItem reactionCount,
      bool follow,
      bool isPostSaved,
      UserReaction? userReaction,
      String? question,
      List<PollOptionsItem>? options,
      ChooseTypeId? chooseTypeId});

  @override
  $PostItemCopyWith<$Res> get media;
  @override
  $ReactionItemCopyWith<$Res> get reactionCount;
  @override
  $ChooseTypeIdCopyWith<$Res>? get chooseTypeId;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? chooseType = null,
    Object? chooseModel = null,
    Object? type = null,
    Object? createdBy = null,
    Object? isLikedByUser = null,
    Object? likesCount = null,
    Object? commentCount = null,
    Object? media = null,
    Object? postId = null,
    Object? reactionCount = null,
    Object? follow = null,
    Object? isPostSaved = null,
    Object? userReaction = freezed,
    Object? question = freezed,
    Object? options = freezed,
    Object? chooseTypeId = freezed,
  }) {
    return _then(_$PostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      chooseType: null == chooseType
          ? _value.chooseType
          : chooseType // ignore: cast_nullable_to_non_nullable
              as ChooseType,
      chooseModel: null == chooseModel
          ? _value.chooseModel
          : chooseModel // ignore: cast_nullable_to_non_nullable
              as ChooseModel,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PostingType,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      isLikedByUser: null == isLikedByUser
          ? _value.isLikedByUser
          : isLikedByUser // ignore: cast_nullable_to_non_nullable
              as bool,
      likesCount: null == likesCount
          ? _value.likesCount
          : likesCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as PostItem,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionCount: null == reactionCount
          ? _value.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as ReactionItem,
      follow: null == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPostSaved: null == isPostSaved
          ? _value.isPostSaved
          : isPostSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      userReaction: freezed == userReaction
          ? _value.userReaction
          : userReaction // ignore: cast_nullable_to_non_nullable
              as UserReaction?,
      question: freezed == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String?,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOptionsItem>?,
      chooseTypeId: freezed == chooseTypeId
          ? _value.chooseTypeId
          : chooseTypeId // ignore: cast_nullable_to_non_nullable
              as ChooseTypeId?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl implements _Post {
  const _$PostImpl(
      {@JsonKey(name: '_id') required this.id,
      required this.description,
      required this.chooseType,
      required this.chooseModel,
      required this.type,
      required this.createdBy,
      required this.isLikedByUser,
      required this.likesCount,
      required this.commentCount,
      required this.media,
      required this.postId,
      required this.reactionCount,
      required this.follow,
      required this.isPostSaved,
      this.userReaction,
      this.question,
      final List<PollOptionsItem>? options,
      this.chooseTypeId})
      : _options = options;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String description;
  @override
  final ChooseType chooseType;
  @override
  final ChooseModel chooseModel;
  @override
  final PostingType type;
  @override
  final String createdBy;
  @override
  final bool isLikedByUser;
  @override
  final int likesCount;
  @override
  final int commentCount;
  @override
  final PostItem media;
  @override
  final String postId;
  @override
  final ReactionItem reactionCount;
  @override
  final bool follow;
  @override
  final bool isPostSaved;
  @override
  final UserReaction? userReaction;
  @override
  final String? question;
  final List<PollOptionsItem>? _options;
  @override
  List<PollOptionsItem>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ChooseTypeId? chooseTypeId;

  @override
  String toString() {
    return 'Post(id: $id, description: $description, chooseType: $chooseType, chooseModel: $chooseModel, type: $type, createdBy: $createdBy, isLikedByUser: $isLikedByUser, likesCount: $likesCount, commentCount: $commentCount, media: $media, postId: $postId, reactionCount: $reactionCount, follow: $follow, isPostSaved: $isPostSaved, userReaction: $userReaction, question: $question, options: $options, chooseTypeId: $chooseTypeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.chooseType, chooseType) ||
                other.chooseType == chooseType) &&
            (identical(other.chooseModel, chooseModel) ||
                other.chooseModel == chooseModel) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.isLikedByUser, isLikedByUser) ||
                other.isLikedByUser == isLikedByUser) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.follow, follow) || other.follow == follow) &&
            (identical(other.isPostSaved, isPostSaved) ||
                other.isPostSaved == isPostSaved) &&
            (identical(other.userReaction, userReaction) ||
                other.userReaction == userReaction) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.chooseTypeId, chooseTypeId) ||
                other.chooseTypeId == chooseTypeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      chooseType,
      chooseModel,
      type,
      createdBy,
      isLikedByUser,
      likesCount,
      commentCount,
      media,
      postId,
      reactionCount,
      follow,
      isPostSaved,
      userReaction,
      question,
      const DeepCollectionEquality().hash(_options),
      chooseTypeId);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(
      this,
    );
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {@JsonKey(name: '_id') required final String id,
      required final String description,
      required final ChooseType chooseType,
      required final ChooseModel chooseModel,
      required final PostingType type,
      required final String createdBy,
      required final bool isLikedByUser,
      required final int likesCount,
      required final int commentCount,
      required final PostItem media,
      required final String postId,
      required final ReactionItem reactionCount,
      required final bool follow,
      required final bool isPostSaved,
      final UserReaction? userReaction,
      final String? question,
      final List<PollOptionsItem>? options,
      final ChooseTypeId? chooseTypeId}) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get description;
  @override
  ChooseType get chooseType;
  @override
  ChooseModel get chooseModel;
  @override
  PostingType get type;
  @override
  String get createdBy;
  @override
  bool get isLikedByUser;
  @override
  int get likesCount;
  @override
  int get commentCount;
  @override
  PostItem get media;
  @override
  String get postId;
  @override
  ReactionItem get reactionCount;
  @override
  bool get follow;
  @override
  bool get isPostSaved;
  @override
  UserReaction? get userReaction;
  @override
  String? get question;
  @override
  List<PollOptionsItem>? get options;
  @override
  ChooseTypeId? get chooseTypeId;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentResponse _$CommentResponseFromJson(Map<String, dynamic> json) {
  return _CommentResponse.fromJson(json);
}

/// @nodoc
mixin _$CommentResponse {
  int get statusCode => throw _privateConstructorUsedError;
  List<Comment> get data => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;

  /// Serializes this CommentResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentResponseCopyWith<CommentResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentResponseCopyWith<$Res> {
  factory $CommentResponseCopyWith(
          CommentResponse value, $Res Function(CommentResponse) then) =
      _$CommentResponseCopyWithImpl<$Res, CommentResponse>;
  @useResult
  $Res call(
      {int statusCode, List<Comment> data, String? message, bool success});
}

/// @nodoc
class _$CommentResponseCopyWithImpl<$Res, $Val extends CommentResponse>
    implements $CommentResponseCopyWith<$Res> {
  _$CommentResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? data = null,
    Object? message = freezed,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentResponseImplCopyWith<$Res>
    implements $CommentResponseCopyWith<$Res> {
  factory _$$CommentResponseImplCopyWith(_$CommentResponseImpl value,
          $Res Function(_$CommentResponseImpl) then) =
      __$$CommentResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int statusCode, List<Comment> data, String? message, bool success});
}

/// @nodoc
class __$$CommentResponseImplCopyWithImpl<$Res>
    extends _$CommentResponseCopyWithImpl<$Res, _$CommentResponseImpl>
    implements _$$CommentResponseImplCopyWith<$Res> {
  __$$CommentResponseImplCopyWithImpl(
      _$CommentResponseImpl _value, $Res Function(_$CommentResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? data = null,
    Object? message = freezed,
    Object? success = null,
  }) {
    return _then(_$CommentResponseImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentResponseImpl implements _CommentResponse {
  const _$CommentResponseImpl(
      {required this.statusCode,
      required final List<Comment> data,
      this.message,
      required this.success})
      : _data = data;

  factory _$CommentResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentResponseImplFromJson(json);

  @override
  final int statusCode;
  final List<Comment> _data;
  @override
  List<Comment> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? message;
  @override
  final bool success;

  @override
  String toString() {
    return 'CommentResponse(statusCode: $statusCode, data: $data, message: $message, success: $success)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentResponseImpl &&
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

  /// Create a copy of CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentResponseImplCopyWith<_$CommentResponseImpl> get copyWith =>
      __$$CommentResponseImplCopyWithImpl<_$CommentResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentResponseImplToJson(
      this,
    );
  }
}

abstract class _CommentResponse implements CommentResponse {
  const factory _CommentResponse(
      {required final int statusCode,
      required final List<Comment> data,
      final String? message,
      required final bool success}) = _$CommentResponseImpl;

  factory _CommentResponse.fromJson(Map<String, dynamic> json) =
      _$CommentResponseImpl.fromJson;

  @override
  int get statusCode;
  @override
  List<Comment> get data;
  @override
  String? get message;
  @override
  bool get success;

  /// Create a copy of CommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentResponseImplCopyWith<_$CommentResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  dynamic get postId =>
      throw _privateConstructorUsedError; // Changed to dynamic to handle both String and Map
  dynamic get userId =>
      throw _privateConstructorUsedError; // Changed to dynamic to handle both String and Map
  String? get message =>
      throw _privateConstructorUsedError; // Made nullable to handle null messages
  String? get parentCommentId => throw _privateConstructorUsedError;
  String? get updatedAt =>
      throw _privateConstructorUsedError; // Made nullable to handle null dates
  List<Comment> get replies => throw _privateConstructorUsedError;
  String? get replyMessage => throw _privateConstructorUsedError;
  bool get isOwner => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      dynamic postId,
      dynamic userId,
      String? message,
      String? parentCommentId,
      String? updatedAt,
      List<Comment> replies,
      String? replyMessage,
      bool isOwner});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = freezed,
    Object? userId = freezed,
    Object? message = freezed,
    Object? parentCommentId = freezed,
    Object? updatedAt = freezed,
    Object? replies = null,
    Object? replyMessage = freezed,
    Object? isOwner = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      replyMessage: freezed == replyMessage
          ? _value.replyMessage
          : replyMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      dynamic postId,
      dynamic userId,
      String? message,
      String? parentCommentId,
      String? updatedAt,
      List<Comment> replies,
      String? replyMessage,
      bool isOwner});
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = freezed,
    Object? userId = freezed,
    Object? message = freezed,
    Object? parentCommentId = freezed,
    Object? updatedAt = freezed,
    Object? replies = null,
    Object? replyMessage = freezed,
    Object? isOwner = null,
  }) {
    return _then(_$CommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      replies: null == replies
          ? _value._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      replyMessage: freezed == replyMessage
          ? _value.replyMessage
          : replyMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isOwner: null == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {@JsonKey(name: '_id') required this.id,
      this.postId,
      this.userId,
      this.message,
      this.parentCommentId,
      this.updatedAt,
      final List<Comment> replies = const [],
      this.replyMessage,
      this.isOwner = false})
      : _replies = replies;

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final dynamic postId;
// Changed to dynamic to handle both String and Map
  @override
  final dynamic userId;
// Changed to dynamic to handle both String and Map
  @override
  final String? message;
// Made nullable to handle null messages
  @override
  final String? parentCommentId;
  @override
  final String? updatedAt;
// Made nullable to handle null dates
  final List<Comment> _replies;
// Made nullable to handle null dates
  @override
  @JsonKey()
  List<Comment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  @override
  final String? replyMessage;
  @override
  @JsonKey()
  final bool isOwner;

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, message: $message, parentCommentId: $parentCommentId, updatedAt: $updatedAt, replies: $replies, replyMessage: $replyMessage, isOwner: $isOwner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.postId, postId) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            (identical(other.replyMessage, replyMessage) ||
                other.replyMessage == replyMessage) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(postId),
      const DeepCollectionEquality().hash(userId),
      message,
      parentCommentId,
      updatedAt,
      const DeepCollectionEquality().hash(_replies),
      replyMessage,
      isOwner);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {@JsonKey(name: '_id') required final String id,
      final dynamic postId,
      final dynamic userId,
      final String? message,
      final String? parentCommentId,
      final String? updatedAt,
      final List<Comment> replies,
      final String? replyMessage,
      final bool isOwner}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  dynamic get postId; // Changed to dynamic to handle both String and Map
  @override
  dynamic get userId; // Changed to dynamic to handle both String and Map
  @override
  String? get message; // Made nullable to handle null messages
  @override
  String? get parentCommentId;
  @override
  String? get updatedAt; // Made nullable to handle null dates
  @override
  List<Comment> get replies;
  @override
  String? get replyMessage;
  @override
  bool get isOwner;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateCommentRequest _$UpdateCommentRequestFromJson(Map<String, dynamic> json) {
  return _UpdateCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateCommentRequest {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this UpdateCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCommentRequestCopyWith<UpdateCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCommentRequestCopyWith<$Res> {
  factory $UpdateCommentRequestCopyWith(UpdateCommentRequest value,
          $Res Function(UpdateCommentRequest) then) =
      _$UpdateCommentRequestCopyWithImpl<$Res, UpdateCommentRequest>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UpdateCommentRequestCopyWithImpl<$Res,
        $Val extends UpdateCommentRequest>
    implements $UpdateCommentRequestCopyWith<$Res> {
  _$UpdateCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCommentRequestImplCopyWith<$Res>
    implements $UpdateCommentRequestCopyWith<$Res> {
  factory _$$UpdateCommentRequestImplCopyWith(_$UpdateCommentRequestImpl value,
          $Res Function(_$UpdateCommentRequestImpl) then) =
      __$$UpdateCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UpdateCommentRequestImplCopyWithImpl<$Res>
    extends _$UpdateCommentRequestCopyWithImpl<$Res, _$UpdateCommentRequestImpl>
    implements _$$UpdateCommentRequestImplCopyWith<$Res> {
  __$$UpdateCommentRequestImplCopyWithImpl(_$UpdateCommentRequestImpl _value,
      $Res Function(_$UpdateCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UpdateCommentRequestImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCommentRequestImpl implements _UpdateCommentRequest {
  const _$UpdateCommentRequestImpl({required this.message});

  factory _$UpdateCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCommentRequestImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'UpdateCommentRequest(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCommentRequestImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCommentRequestImplCopyWith<_$UpdateCommentRequestImpl>
      get copyWith =>
          __$$UpdateCommentRequestImplCopyWithImpl<_$UpdateCommentRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateCommentRequest implements UpdateCommentRequest {
  const factory _UpdateCommentRequest({required final String message}) =
      _$UpdateCommentRequestImpl;

  factory _UpdateCommentRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateCommentRequestImpl.fromJson;

  @override
  String get message;

  /// Create a copy of UpdateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCommentRequestImplCopyWith<_$UpdateCommentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AddCommentRequest _$AddCommentRequestFromJson(Map<String, dynamic> json) {
  return _AddCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$AddCommentRequest {
  String get message => throw _privateConstructorUsedError;
  String? get parentCommentId => throw _privateConstructorUsedError;

  /// Serializes this AddCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddCommentRequestCopyWith<AddCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCommentRequestCopyWith<$Res> {
  factory $AddCommentRequestCopyWith(
          AddCommentRequest value, $Res Function(AddCommentRequest) then) =
      _$AddCommentRequestCopyWithImpl<$Res, AddCommentRequest>;
  @useResult
  $Res call({String message, String? parentCommentId});
}

/// @nodoc
class _$AddCommentRequestCopyWithImpl<$Res, $Val extends AddCommentRequest>
    implements $AddCommentRequestCopyWith<$Res> {
  _$AddCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddCommentRequestImplCopyWith<$Res>
    implements $AddCommentRequestCopyWith<$Res> {
  factory _$$AddCommentRequestImplCopyWith(_$AddCommentRequestImpl value,
          $Res Function(_$AddCommentRequestImpl) then) =
      __$$AddCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? parentCommentId});
}

/// @nodoc
class __$$AddCommentRequestImplCopyWithImpl<$Res>
    extends _$AddCommentRequestCopyWithImpl<$Res, _$AddCommentRequestImpl>
    implements _$$AddCommentRequestImplCopyWith<$Res> {
  __$$AddCommentRequestImplCopyWithImpl(_$AddCommentRequestImpl _value,
      $Res Function(_$AddCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? parentCommentId = freezed,
  }) {
    return _then(_$AddCommentRequestImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      parentCommentId: freezed == parentCommentId
          ? _value.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddCommentRequestImpl implements _AddCommentRequest {
  const _$AddCommentRequestImpl({required this.message, this.parentCommentId});

  factory _$AddCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddCommentRequestImplFromJson(json);

  @override
  final String message;
  @override
  final String? parentCommentId;

  @override
  String toString() {
    return 'AddCommentRequest(message: $message, parentCommentId: $parentCommentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCommentRequestImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, parentCommentId);

  /// Create a copy of AddCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCommentRequestImplCopyWith<_$AddCommentRequestImpl> get copyWith =>
      __$$AddCommentRequestImplCopyWithImpl<_$AddCommentRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _AddCommentRequest implements AddCommentRequest {
  const factory _AddCommentRequest(
      {required final String message,
      final String? parentCommentId}) = _$AddCommentRequestImpl;

  factory _AddCommentRequest.fromJson(Map<String, dynamic> json) =
      _$AddCommentRequestImpl.fromJson;

  @override
  String get message;
  @override
  String? get parentCommentId;

  /// Create a copy of AddCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCommentRequestImplCopyWith<_$AddCommentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddCommentResponse _$AddCommentResponseFromJson(Map<String, dynamic> json) {
  return _AddCommentResponse.fromJson(json);
}

/// @nodoc
mixin _$AddCommentResponse {
  int get statusCode => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;

  /// Serializes this AddCommentResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddCommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddCommentResponseCopyWith<AddCommentResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCommentResponseCopyWith<$Res> {
  factory $AddCommentResponseCopyWith(
          AddCommentResponse value, $Res Function(AddCommentResponse) then) =
      _$AddCommentResponseCopyWithImpl<$Res, AddCommentResponse>;
  @useResult
  $Res call({int statusCode, String? message, bool success, dynamic data});
}

/// @nodoc
class _$AddCommentResponseCopyWithImpl<$Res, $Val extends AddCommentResponse>
    implements $AddCommentResponseCopyWith<$Res> {
  _$AddCommentResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddCommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = freezed,
    Object? success = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddCommentResponseImplCopyWith<$Res>
    implements $AddCommentResponseCopyWith<$Res> {
  factory _$$AddCommentResponseImplCopyWith(_$AddCommentResponseImpl value,
          $Res Function(_$AddCommentResponseImpl) then) =
      __$$AddCommentResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int statusCode, String? message, bool success, dynamic data});
}

/// @nodoc
class __$$AddCommentResponseImplCopyWithImpl<$Res>
    extends _$AddCommentResponseCopyWithImpl<$Res, _$AddCommentResponseImpl>
    implements _$$AddCommentResponseImplCopyWith<$Res> {
  __$$AddCommentResponseImplCopyWithImpl(_$AddCommentResponseImpl _value,
      $Res Function(_$AddCommentResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddCommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = freezed,
    Object? success = null,
    Object? data = freezed,
  }) {
    return _then(_$AddCommentResponseImpl(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddCommentResponseImpl implements _AddCommentResponse {
  const _$AddCommentResponseImpl(
      {required this.statusCode,
      this.message,
      required this.success,
      this.data});

  factory _$AddCommentResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddCommentResponseImplFromJson(json);

  @override
  final int statusCode;
  @override
  final String? message;
  @override
  final bool success;
  @override
  final dynamic data;

  @override
  String toString() {
    return 'AddCommentResponse(statusCode: $statusCode, message: $message, success: $success, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCommentResponseImpl &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, success,
      const DeepCollectionEquality().hash(data));

  /// Create a copy of AddCommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCommentResponseImplCopyWith<_$AddCommentResponseImpl> get copyWith =>
      __$$AddCommentResponseImplCopyWithImpl<_$AddCommentResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddCommentResponseImplToJson(
      this,
    );
  }
}

abstract class _AddCommentResponse implements AddCommentResponse {
  const factory _AddCommentResponse(
      {required final int statusCode,
      final String? message,
      required final bool success,
      final dynamic data}) = _$AddCommentResponseImpl;

  factory _AddCommentResponse.fromJson(Map<String, dynamic> json) =
      _$AddCommentResponseImpl.fromJson;

  @override
  int get statusCode;
  @override
  String? get message;
  @override
  bool get success;
  @override
  dynamic get data;

  /// Create a copy of AddCommentResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCommentResponseImplCopyWith<_$AddCommentResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddPostReaction _$AddPostReactionFromJson(Map<String, dynamic> json) {
  return _AddPostReaction.fromJson(json);
}

/// @nodoc
mixin _$AddPostReaction {
  String get IdReactedFor => throw _privateConstructorUsedError;
  String get reactionType => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Serializes this AddPostReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddPostReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddPostReactionCopyWith<AddPostReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddPostReactionCopyWith<$Res> {
  factory $AddPostReactionCopyWith(
          AddPostReaction value, $Res Function(AddPostReaction) then) =
      _$AddPostReactionCopyWithImpl<$Res, AddPostReaction>;
  @useResult
  $Res call({String IdReactedFor, String reactionType, String type});
}

/// @nodoc
class _$AddPostReactionCopyWithImpl<$Res, $Val extends AddPostReaction>
    implements $AddPostReactionCopyWith<$Res> {
  _$AddPostReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddPostReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? IdReactedFor = null,
    Object? reactionType = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      IdReactedFor: null == IdReactedFor
          ? _value.IdReactedFor
          : IdReactedFor // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddPostReactionImplCopyWith<$Res>
    implements $AddPostReactionCopyWith<$Res> {
  factory _$$AddPostReactionImplCopyWith(_$AddPostReactionImpl value,
          $Res Function(_$AddPostReactionImpl) then) =
      __$$AddPostReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String IdReactedFor, String reactionType, String type});
}

/// @nodoc
class __$$AddPostReactionImplCopyWithImpl<$Res>
    extends _$AddPostReactionCopyWithImpl<$Res, _$AddPostReactionImpl>
    implements _$$AddPostReactionImplCopyWith<$Res> {
  __$$AddPostReactionImplCopyWithImpl(
      _$AddPostReactionImpl _value, $Res Function(_$AddPostReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddPostReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? IdReactedFor = null,
    Object? reactionType = null,
    Object? type = null,
  }) {
    return _then(_$AddPostReactionImpl(
      IdReactedFor: null == IdReactedFor
          ? _value.IdReactedFor
          : IdReactedFor // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddPostReactionImpl implements _AddPostReaction {
  const _$AddPostReactionImpl(
      {required this.IdReactedFor,
      required this.reactionType,
      required this.type});

  factory _$AddPostReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddPostReactionImplFromJson(json);

  @override
  final String IdReactedFor;
  @override
  final String reactionType;
  @override
  final String type;

  @override
  String toString() {
    return 'AddPostReaction(IdReactedFor: $IdReactedFor, reactionType: $reactionType, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPostReactionImpl &&
            (identical(other.IdReactedFor, IdReactedFor) ||
                other.IdReactedFor == IdReactedFor) &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, IdReactedFor, reactionType, type);

  /// Create a copy of AddPostReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPostReactionImplCopyWith<_$AddPostReactionImpl> get copyWith =>
      __$$AddPostReactionImplCopyWithImpl<_$AddPostReactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddPostReactionImplToJson(
      this,
    );
  }
}

abstract class _AddPostReaction implements AddPostReaction {
  const factory _AddPostReaction(
      {required final String IdReactedFor,
      required final String reactionType,
      required final String type}) = _$AddPostReactionImpl;

  factory _AddPostReaction.fromJson(Map<String, dynamic> json) =
      _$AddPostReactionImpl.fromJson;

  @override
  String get IdReactedFor;
  @override
  String get reactionType;
  @override
  String get type;

  /// Create a copy of AddPostReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddPostReactionImplCopyWith<_$AddPostReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollReaction _$PollReactionFromJson(Map<String, dynamic> json) {
  return _PollReaction.fromJson(json);
}

/// @nodoc
mixin _$PollReaction {
  String get reactionId => throw _privateConstructorUsedError;

  /// Serializes this PollReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollReactionCopyWith<PollReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollReactionCopyWith<$Res> {
  factory $PollReactionCopyWith(
          PollReaction value, $Res Function(PollReaction) then) =
      _$PollReactionCopyWithImpl<$Res, PollReaction>;
  @useResult
  $Res call({String reactionId});
}

/// @nodoc
class _$PollReactionCopyWithImpl<$Res, $Val extends PollReaction>
    implements $PollReactionCopyWith<$Res> {
  _$PollReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionId = null,
  }) {
    return _then(_value.copyWith(
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PollReactionImplCopyWith<$Res>
    implements $PollReactionCopyWith<$Res> {
  factory _$$PollReactionImplCopyWith(
          _$PollReactionImpl value, $Res Function(_$PollReactionImpl) then) =
      __$$PollReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reactionId});
}

/// @nodoc
class __$$PollReactionImplCopyWithImpl<$Res>
    extends _$PollReactionCopyWithImpl<$Res, _$PollReactionImpl>
    implements _$$PollReactionImplCopyWith<$Res> {
  __$$PollReactionImplCopyWithImpl(
      _$PollReactionImpl _value, $Res Function(_$PollReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionId = null,
  }) {
    return _then(_$PollReactionImpl(
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PollReactionImpl implements _PollReaction {
  const _$PollReactionImpl({required this.reactionId});

  factory _$PollReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollReactionImplFromJson(json);

  @override
  final String reactionId;

  @override
  String toString() {
    return 'PollReaction(reactionId: $reactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollReactionImpl &&
            (identical(other.reactionId, reactionId) ||
                other.reactionId == reactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reactionId);

  /// Create a copy of PollReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollReactionImplCopyWith<_$PollReactionImpl> get copyWith =>
      __$$PollReactionImplCopyWithImpl<_$PollReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollReactionImplToJson(
      this,
    );
  }
}

abstract class _PollReaction implements PollReaction {
  const factory _PollReaction({required final String reactionId}) =
      _$PollReactionImpl;

  factory _PollReaction.fromJson(Map<String, dynamic> json) =
      _$PollReactionImpl.fromJson;

  @override
  String get reactionId;

  /// Create a copy of PollReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollReactionImplCopyWith<_$PollReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostReport _$PostReportFromJson(Map<String, dynamic> json) {
  return _PostReport.fromJson(json);
}

/// @nodoc
mixin _$PostReport {
  String get message => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;

  /// Serializes this PostReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostReportCopyWith<PostReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostReportCopyWith<$Res> {
  factory $PostReportCopyWith(
          PostReport value, $Res Function(PostReport) then) =
      _$PostReportCopyWithImpl<$Res, PostReport>;
  @useResult
  $Res call({String message, String postId});
}

/// @nodoc
class _$PostReportCopyWithImpl<$Res, $Val extends PostReport>
    implements $PostReportCopyWith<$Res> {
  _$PostReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? postId = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostReportImplCopyWith<$Res>
    implements $PostReportCopyWith<$Res> {
  factory _$$PostReportImplCopyWith(
          _$PostReportImpl value, $Res Function(_$PostReportImpl) then) =
      __$$PostReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String postId});
}

/// @nodoc
class __$$PostReportImplCopyWithImpl<$Res>
    extends _$PostReportCopyWithImpl<$Res, _$PostReportImpl>
    implements _$$PostReportImplCopyWith<$Res> {
  __$$PostReportImplCopyWithImpl(
      _$PostReportImpl _value, $Res Function(_$PostReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? postId = null,
  }) {
    return _then(_$PostReportImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostReportImpl implements _PostReport {
  const _$PostReportImpl({required this.message, required this.postId});

  factory _$PostReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostReportImplFromJson(json);

  @override
  final String message;
  @override
  final String postId;

  @override
  String toString() {
    return 'PostReport(message: $message, postId: $postId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostReportImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, postId);

  /// Create a copy of PostReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostReportImplCopyWith<_$PostReportImpl> get copyWith =>
      __$$PostReportImplCopyWithImpl<_$PostReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostReportImplToJson(
      this,
    );
  }
}

abstract class _PostReport implements PostReport {
  const factory _PostReport(
      {required final String message,
      required final String postId}) = _$PostReportImpl;

  factory _PostReport.fromJson(Map<String, dynamic> json) =
      _$PostReportImpl.fromJson;

  @override
  String get message;
  @override
  String get postId;

  /// Create a copy of PostReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostReportImplCopyWith<_$PostReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SavePost _$SavePostFromJson(Map<String, dynamic> json) {
  return _SavePost.fromJson(json);
}

/// @nodoc
mixin _$SavePost {
  String get postId => throw _privateConstructorUsedError;
  String get postModel => throw _privateConstructorUsedError;

  /// Serializes this SavePost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavePost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavePostCopyWith<SavePost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavePostCopyWith<$Res> {
  factory $SavePostCopyWith(SavePost value, $Res Function(SavePost) then) =
      _$SavePostCopyWithImpl<$Res, SavePost>;
  @useResult
  $Res call({String postId, String postModel});
}

/// @nodoc
class _$SavePostCopyWithImpl<$Res, $Val extends SavePost>
    implements $SavePostCopyWith<$Res> {
  _$SavePostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavePost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? postModel = null,
  }) {
    return _then(_value.copyWith(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postModel: null == postModel
          ? _value.postModel
          : postModel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavePostImplCopyWith<$Res>
    implements $SavePostCopyWith<$Res> {
  factory _$$SavePostImplCopyWith(
          _$SavePostImpl value, $Res Function(_$SavePostImpl) then) =
      __$$SavePostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String postId, String postModel});
}

/// @nodoc
class __$$SavePostImplCopyWithImpl<$Res>
    extends _$SavePostCopyWithImpl<$Res, _$SavePostImpl>
    implements _$$SavePostImplCopyWith<$Res> {
  __$$SavePostImplCopyWithImpl(
      _$SavePostImpl _value, $Res Function(_$SavePostImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavePost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
    Object? postModel = null,
  }) {
    return _then(_$SavePostImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      postModel: null == postModel
          ? _value.postModel
          : postModel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavePostImpl implements _SavePost {
  const _$SavePostImpl({required this.postId, required this.postModel});

  factory _$SavePostImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavePostImplFromJson(json);

  @override
  final String postId;
  @override
  final String postModel;

  @override
  String toString() {
    return 'SavePost(postId: $postId, postModel: $postModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavePostImpl &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.postModel, postModel) ||
                other.postModel == postModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, postId, postModel);

  /// Create a copy of SavePost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavePostImplCopyWith<_$SavePostImpl> get copyWith =>
      __$$SavePostImplCopyWithImpl<_$SavePostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavePostImplToJson(
      this,
    );
  }
}

abstract class _SavePost implements SavePost {
  const factory _SavePost(
      {required final String postId,
      required final String postModel}) = _$SavePostImpl;

  factory _SavePost.fromJson(Map<String, dynamic> json) =
      _$SavePostImpl.fromJson;

  @override
  String get postId;
  @override
  String get postModel;

  /// Create a copy of SavePost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavePostImplCopyWith<_$SavePostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LikeItem _$LikeItemFromJson(Map<String, dynamic> json) {
  return _LikeItem.fromJson(json);
}

/// @nodoc
mixin _$LikeItem {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;

  /// Serializes this LikeItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LikeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LikeItemCopyWith<LikeItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeItemCopyWith<$Res> {
  factory $LikeItemCopyWith(LikeItem value, $Res Function(LikeItem) then) =
      _$LikeItemCopyWithImpl<$Res, LikeItem>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id, String? userName, String? userAvatar});
}

/// @nodoc
class _$LikeItemCopyWithImpl<$Res, $Val extends LikeItem>
    implements $LikeItemCopyWith<$Res> {
  _$LikeItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LikeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LikeItemImplCopyWith<$Res>
    implements $LikeItemCopyWith<$Res> {
  factory _$$LikeItemImplCopyWith(
          _$LikeItemImpl value, $Res Function(_$LikeItemImpl) then) =
      __$$LikeItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id, String? userName, String? userAvatar});
}

/// @nodoc
class __$$LikeItemImplCopyWithImpl<$Res>
    extends _$LikeItemCopyWithImpl<$Res, _$LikeItemImpl>
    implements _$$LikeItemImplCopyWith<$Res> {
  __$$LikeItemImplCopyWithImpl(
      _$LikeItemImpl _value, $Res Function(_$LikeItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of LikeItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userName = freezed,
    Object? userAvatar = freezed,
  }) {
    return _then(_$LikeItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LikeItemImpl implements _LikeItem {
  const _$LikeItemImpl(
      {@JsonKey(name: '_id') this.id, this.userName, this.userAvatar});

  factory _$LikeItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LikeItemImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
  @override
  final String? userName;
  @override
  final String? userAvatar;

  @override
  String toString() {
    return 'LikeItem(id: $id, userName: $userName, userAvatar: $userAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikeItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userName, userAvatar);

  /// Create a copy of LikeItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikeItemImplCopyWith<_$LikeItemImpl> get copyWith =>
      __$$LikeItemImplCopyWithImpl<_$LikeItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LikeItemImplToJson(
      this,
    );
  }
}

abstract class _LikeItem implements LikeItem {
  const factory _LikeItem(
      {@JsonKey(name: '_id') final String? id,
      final String? userName,
      final String? userAvatar}) = _$LikeItemImpl;

  factory _LikeItem.fromJson(Map<String, dynamic> json) =
      _$LikeItemImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id;
  @override
  String? get userName;
  @override
  String? get userAvatar;

  /// Create a copy of LikeItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikeItemImplCopyWith<_$LikeItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReactionsItem _$ReactionsItemFromJson(Map<String, dynamic> json) {
  return _ReactionsItem.fromJson(json);
}

/// @nodoc
mixin _$ReactionsItem {
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatar => throw _privateConstructorUsedError;
  String? get reactionName => throw _privateConstructorUsedError;

  /// Serializes this ReactionsItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionsItemCopyWith<ReactionsItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionsItemCopyWith<$Res> {
  factory $ReactionsItemCopyWith(
          ReactionsItem value, $Res Function(ReactionsItem) then) =
      _$ReactionsItemCopyWithImpl<$Res, ReactionsItem>;
  @useResult
  $Res call({String? userName, String? userAvatar, String? reactionName});
}

/// @nodoc
class _$ReactionsItemCopyWithImpl<$Res, $Val extends ReactionsItem>
    implements $ReactionsItemCopyWith<$Res> {
  _$ReactionsItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? reactionName = freezed,
  }) {
    return _then(_value.copyWith(
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionName: freezed == reactionName
          ? _value.reactionName
          : reactionName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionsItemImplCopyWith<$Res>
    implements $ReactionsItemCopyWith<$Res> {
  factory _$$ReactionsItemImplCopyWith(
          _$ReactionsItemImpl value, $Res Function(_$ReactionsItemImpl) then) =
      __$$ReactionsItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? userName, String? userAvatar, String? reactionName});
}

/// @nodoc
class __$$ReactionsItemImplCopyWithImpl<$Res>
    extends _$ReactionsItemCopyWithImpl<$Res, _$ReactionsItemImpl>
    implements _$$ReactionsItemImplCopyWith<$Res> {
  __$$ReactionsItemImplCopyWithImpl(
      _$ReactionsItemImpl _value, $Res Function(_$ReactionsItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionsItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = freezed,
    Object? userAvatar = freezed,
    Object? reactionName = freezed,
  }) {
    return _then(_$ReactionsItemImpl(
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatar: freezed == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionName: freezed == reactionName
          ? _value.reactionName
          : reactionName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionsItemImpl implements _ReactionsItem {
  const _$ReactionsItemImpl(
      {this.userName, this.userAvatar, this.reactionName});

  factory _$ReactionsItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionsItemImplFromJson(json);

  @override
  final String? userName;
  @override
  final String? userAvatar;
  @override
  final String? reactionName;

  @override
  String toString() {
    return 'ReactionsItem(userName: $userName, userAvatar: $userAvatar, reactionName: $reactionName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionsItemImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.reactionName, reactionName) ||
                other.reactionName == reactionName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userName, userAvatar, reactionName);

  /// Create a copy of ReactionsItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionsItemImplCopyWith<_$ReactionsItemImpl> get copyWith =>
      __$$ReactionsItemImplCopyWithImpl<_$ReactionsItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionsItemImplToJson(
      this,
    );
  }
}

abstract class _ReactionsItem implements ReactionsItem {
  const factory _ReactionsItem(
      {final String? userName,
      final String? userAvatar,
      final String? reactionName}) = _$ReactionsItemImpl;

  factory _ReactionsItem.fromJson(Map<String, dynamic> json) =
      _$ReactionsItemImpl.fromJson;

  @override
  String? get userName;
  @override
  String? get userAvatar;
  @override
  String? get reactionName;

  /// Create a copy of ReactionsItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionsItemImplCopyWith<_$ReactionsItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryReaction _$StoryReactionFromJson(Map<String, dynamic> json) {
  return _StoryReaction.fromJson(json);
}

/// @nodoc
mixin _$StoryReaction {
  String get storyId => throw _privateConstructorUsedError;
  String get reactionType => throw _privateConstructorUsedError;

  /// Serializes this StoryReaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryReactionCopyWith<StoryReaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryReactionCopyWith<$Res> {
  factory $StoryReactionCopyWith(
          StoryReaction value, $Res Function(StoryReaction) then) =
      _$StoryReactionCopyWithImpl<$Res, StoryReaction>;
  @useResult
  $Res call({String storyId, String reactionType});
}

/// @nodoc
class _$StoryReactionCopyWithImpl<$Res, $Val extends StoryReaction>
    implements $StoryReactionCopyWith<$Res> {
  _$StoryReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryReaction
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
abstract class _$$StoryReactionImplCopyWith<$Res>
    implements $StoryReactionCopyWith<$Res> {
  factory _$$StoryReactionImplCopyWith(
          _$StoryReactionImpl value, $Res Function(_$StoryReactionImpl) then) =
      __$$StoryReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String storyId, String reactionType});
}

/// @nodoc
class __$$StoryReactionImplCopyWithImpl<$Res>
    extends _$StoryReactionCopyWithImpl<$Res, _$StoryReactionImpl>
    implements _$$StoryReactionImplCopyWith<$Res> {
  __$$StoryReactionImplCopyWithImpl(
      _$StoryReactionImpl _value, $Res Function(_$StoryReactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storyId = null,
    Object? reactionType = null,
  }) {
    return _then(_$StoryReactionImpl(
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
class _$StoryReactionImpl implements _StoryReaction {
  const _$StoryReactionImpl(
      {required this.storyId, required this.reactionType});

  factory _$StoryReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryReactionImplFromJson(json);

  @override
  final String storyId;
  @override
  final String reactionType;

  @override
  String toString() {
    return 'StoryReaction(storyId: $storyId, reactionType: $reactionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryReactionImpl &&
            (identical(other.storyId, storyId) || other.storyId == storyId) &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, storyId, reactionType);

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryReactionImplCopyWith<_$StoryReactionImpl> get copyWith =>
      __$$StoryReactionImplCopyWithImpl<_$StoryReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryReactionImplToJson(
      this,
    );
  }
}

abstract class _StoryReaction implements StoryReaction {
  const factory _StoryReaction(
      {required final String storyId,
      required final String reactionType}) = _$StoryReactionImpl;

  factory _StoryReaction.fromJson(Map<String, dynamic> json) =
      _$StoryReactionImpl.fromJson;

  @override
  String get storyId;
  @override
  String get reactionType;

  /// Create a copy of StoryReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryReactionImplCopyWith<_$StoryReactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
