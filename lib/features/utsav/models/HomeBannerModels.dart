class HomeBannerResponse {
  final int statusCode;
  final List<HomeBanner> data;
  final String message;
  final bool success;

  HomeBannerResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory HomeBannerResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerResponse(
      statusCode: (json['statusCode'] as int?) ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => HomeBanner.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      message: (json['message'] as String?) ?? '',
      success: (json['success'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((banner) => banner.toJson()).toList(),
      'message': message,
      'success': success,
    };
  }
}

class HomeBanner {
  final String id;
  final int bannerId;
  final String businessId;
  final String webBanner;
  final String mobBanner;
  final String country;
  final String state;
  final String city;
  final String area;
  final String status;
  final String user;
  final String address;
  final String longitude;
  final String latitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  HomeBanner({
    required this.id,
    required this.bannerId,
    required this.businessId,
    required this.webBanner,
    required this.mobBanner,
    required this.country,
    required this.state,
    required this.city,
    required this.area,
    required this.status,
    required this.user,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: (json['_id'] as String?) ?? '',
      bannerId: (json['bannerId'] as int?) ?? 0,
      businessId: (json['BusinessId'] as String?) ?? '',
      webBanner: (json['webBanner'] as String?) ?? '',
      mobBanner: (json['mobBanner'] as String?) ?? '',
      country: (json['country'] as String?) ?? '',
      state: (json['state'] as String?) ?? '',
      city: (json['city'] as String?) ?? '',
      area: (json['area'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      user: (json['user'] as String?) ?? '',
      address: (json['address'] as String?) ?? '',
      longitude: (json['longitude'] as String?) ?? '',
      latitude: (json['latitude'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ?? 
          DateTime.now(),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ?? 
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bannerId': bannerId,
      'BusinessId': businessId,
      'webBanner': webBanner,
      'mobBanner': mobBanner,
      'country': country,
      'state': state,
      'city': city,
      'area': area,
      'status': status,
      'user': user,
      'address': address,
      'longitude': longitude,
      'latitude': latitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convenience getter to get appropriate banner based on device
  String getBannerUrl({bool isMobile = true}) {
    return isMobile ? mobBanner : webBanner;
  }
}