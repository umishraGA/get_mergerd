enum StoryMediaType {
  image,
  video,
  multiImage,
  multiVideo,
  mixedMedia,
}

class StoryModel {
  final String id;
  final String username;
  final String profileImage;
  final String mediaUrl;
  final String? videoUrl;
  final List<String>? additionalImages;
  final List<String>? additionalVideos;
  final List<Map<String, dynamic>>? mixedMediaItems;
  final StoryMediaType mediaType;
  final DateTime createdAt;
  final bool isViewed;

  StoryModel({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.mediaUrl,
    this.videoUrl,
    this.additionalImages,
    this.additionalVideos,
    this.mixedMediaItems,
    this.mediaType = StoryMediaType.image,
    required this.createdAt,
    this.isViewed = false,
  }) {
    // Print creation info for debugging
    if (mediaType == StoryMediaType.video) {
      print("Created video story: $id with URL: $videoUrl");
    } else if (mediaType == StoryMediaType.multiImage) {
      print(
          "Created multi-image story: $id with ${additionalImages?.length ?? 0} additional images");
    } else if (mediaType == StoryMediaType.multiVideo) {
      print(
          "Created multi-video story: $id with ${additionalVideos?.length ?? 0} videos");
    } else if (mediaType == StoryMediaType.mixedMedia) {
      print(
          "Created mixed media story: $id with ${mixedMediaItems?.length ?? 0} items");
    }
  }

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      username: json['username'] as String,
      profileImage: json['profileImage'] as String,
      mediaUrl: json['mediaUrl'] as String,
      videoUrl: json['videoUrl'] as String?,
      additionalImages: json['additionalImages'] != null
          ? (json['additionalImages'] as List).cast<String>()
          : null,
      additionalVideos: json['additionalVideos'] != null
          ? (json['additionalVideos'] as List).cast<String>()
          : null,
      mixedMediaItems: json['mixedMediaItems'] != null
          ? (json['mixedMediaItems'] as List).cast<Map<String, dynamic>>()
          : null,
      mediaType: _parseMediaType(json['mediaType'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
    );
  }

  static StoryMediaType _parseMediaType(String? type) {
    switch (type) {
      case 'video':
        return StoryMediaType.video;
      case 'multiImage':
        return StoryMediaType.multiImage;
      case 'multiVideo':
        return StoryMediaType.multiVideo;
      case 'mixedMedia':
        return StoryMediaType.mixedMedia;
      default:
        return StoryMediaType.image;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileImage': profileImage,
      'mediaUrl': mediaUrl,
      'videoUrl': videoUrl,
      'additionalImages': additionalImages,
      'additionalVideos': additionalVideos,
      'mixedMediaItems': mixedMediaItems,
      'mediaType': _mediaTypeToString(mediaType),
      'createdAt': createdAt.toIso8601String(),
      'isViewed': isViewed,
    };
  }

  String _mediaTypeToString(StoryMediaType type) {
    switch (type) {
      case StoryMediaType.video:
        return 'video';
      case StoryMediaType.multiImage:
        return 'multiImage';
      case StoryMediaType.multiVideo:
        return 'multiVideo';
      case StoryMediaType.mixedMedia:
        return 'mixedMedia';
      default:
        return 'image';
    }
  }

  @override
  String toString() {
    return 'StoryModel{id: $id, mediaType: $mediaType, videoUrl: $videoUrl}';
  }

  StoryModel copyWith({
    String? id,
    String? username,
    String? profileImage,
    String? mediaUrl,
    String? videoUrl,
    List<String>? additionalImages,
    List<String>? additionalVideos,
    List<Map<String, dynamic>>? mixedMediaItems,
    StoryMediaType? mediaType,
    DateTime? createdAt,
    bool? isViewed,
  }) {
    return StoryModel(
      id: id ?? this.id,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      additionalVideos: additionalVideos ?? this.additionalVideos,
      mixedMediaItems: mixedMediaItems ?? this.mixedMediaItems,
      mediaType: mediaType ?? this.mediaType,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}
