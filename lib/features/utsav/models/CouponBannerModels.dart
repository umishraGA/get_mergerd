class CouponBannerResponse {
  final int? statusCode;
  final List<CouponBanner>? data;
  final String? message;
  final bool? success;

  CouponBannerResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory CouponBannerResponse.fromJson(Map<String, dynamic> json) {
    return CouponBannerResponse(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CouponBanner.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data?.map((item) => item.toJson()).toList(),
      'message': message,
      'success': success,
    };
  }
}

class CouponBanner {
  final String? id;
  final int? bannerId;
  final BusinessInfo? businessId;
  final String? category;
  final int? validity;
  final String? webBanner;
  final String? latitude;
  final String? longitude;
  final String? mobBanner;
  final String? address;
  final String? status;
  final String? user;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CouponBanner({
    this.id,
    this.bannerId,
    this.businessId,
    this.category,
    this.validity,
    this.webBanner,
    this.latitude,
    this.longitude,
    this.mobBanner,
    this.address,
    this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CouponBanner.fromJson(Map<String, dynamic> json) {
    return CouponBanner(
      id: json['_id'] as String?,
      bannerId: json['bannerId'] as int?,
      businessId: json['BusinessId'] != null 
          ? BusinessInfo.fromJson(json['BusinessId'] as Map<String, dynamic>)
          : null,
      category: json['category'] as String?,
      validity: json['validity'] as int?,
      webBanner: json['webBanner'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      mobBanner: json['mobBanner'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String?,
      user: json['user'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bannerId': bannerId,
      'BusinessId': businessId?.toJson(),
      'category': category,
      'validity': validity,
      'webBanner': webBanner,
      'latitude': latitude,
      'longitude': longitude,
      'mobBanner': mobBanner,
      'address': address,
      'status': status,
      'user': user,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class BusinessInfo {
  final LocationInfo? locationInfo;
  final String? id;

  BusinessInfo({
    this.locationInfo,
    this.id,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      locationInfo: json['locationInfo'] != null
          ? LocationInfo.fromJson(json['locationInfo'] as Map<String, dynamic>)
          : null,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationInfo': locationInfo?.toJson(),
      '_id': id,
    };
  }
}

class LocationInfo {
  final String? address;

  LocationInfo({
    this.address,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}

class CouponBannerRequest {
  final String categoryId;
  final double latitude;
  final double longitude;

  CouponBannerRequest({
    required this.categoryId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryid': categoryId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}