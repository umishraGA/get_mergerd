class CategoryCouponsResponse {
  final int? statusCode;
  final List<BusinessInfo>? data;
  final String? message;
  final bool? success;

  CategoryCouponsResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory CategoryCouponsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryCouponsResponse(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => BusinessInfo.fromJson(item as Map<String, dynamic>))
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

class BusinessInfo {
  final CompanyInfo? companyInfo;
  final LocationInfo? locationInfo;
  final CoverImage? coverImage;
  final String? id;
  final String? status;
  final int? activeCouponCount;
  final int? highestRating;
  final int? ratingCount;

  BusinessInfo({
    this.companyInfo,
    this.locationInfo,
    this.coverImage,
    this.id,
    this.status,
    this.activeCouponCount,
    this.highestRating,
    this.ratingCount,
  });

  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
      companyInfo: json['companyInfo'] != null ? CompanyInfo.fromJson(json['companyInfo'] as Map<String, dynamic>) : null,
      locationInfo: json['locationInfo'] != null ? LocationInfo.fromJson(json['locationInfo'] as Map<String, dynamic>) : null,
      coverImage: json['coverImage'] != null ? CoverImage.fromJson(json['coverImage'] as Map<String, dynamic>) : null,
      id: json['_id'] as String?,
      status: json['status'] as String?,
      activeCouponCount: json['activeCouponCount'] as int?,
      highestRating: json['highestRating'] as int?,
      ratingCount: json['ratingCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyInfo': companyInfo?.toJson(),
      'locationInfo': locationInfo?.toJson(),
      'coverImage': coverImage?.toJson(),
      '_id': id,
      'status': status,
      'activeCouponCount': activeCouponCount,
      'highestRating': highestRating,
      'ratingCount': ratingCount,
    };
  }
}

class CompanyInfo {
  final String? companyName;

  CompanyInfo({
    this.companyName,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      companyName: json['companyName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
    };
  }
}

class LocationInfo {
  final String? country;
  final String? state;
  final String? city;
  final String? area;
  final int? pincode;
  final String? address;

  LocationInfo({
    this.country,
    this.state,
    this.city,
    this.area,
    this.pincode,
    this.address,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      pincode: json['pincode'] as int?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'state': state,
      'city': city,
      'area': area,
      'pincode': pincode,
      'address': address,
    };
  }
}

class CoverImage {
  final String? reason;
  final String? url;
  final String? status;

  CoverImage({
    this.reason,
    this.url,
    this.status,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      reason: json['reason'] as String?,
      url: json['url'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reason': reason,
      'url': url,
      'status': status,
    };
  }
}

class CategoryCouponsRequest {
  final String categoryid;
  final String latitude;
  final String longitude;

  CategoryCouponsRequest({
    required this.categoryid,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryid': categoryid,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}