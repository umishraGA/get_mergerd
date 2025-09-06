class BusinessCouponsResponse {
  final int? statusCode;
  final BusinessCouponsData? data;
  final String? message;
  final bool? success;

  BusinessCouponsResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  // Helper getter to access coupons directly
  List<BusinessCoupon> get coupons => data?.coupons ?? [];

  factory BusinessCouponsResponse.fromJson(Map<String, dynamic> json) {
    return BusinessCouponsResponse(
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null 
          ? BusinessCouponsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data?.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class BusinessCouponsData {
  final List<BusinessCoupon> coupons;
  final String? deeplinkurl;
  final BusinessId? businessId;

  BusinessCouponsData({
    required this.coupons,
    this.deeplinkurl,
    this.businessId,
  });

  factory BusinessCouponsData.fromJson(Map<String, dynamic> json) {
    // Handle the nested structure where coupons is an object containing BusinessId and coupons array
    List<BusinessCoupon> couponsList = [];
    BusinessId? businessIdObj;
    
    if (json['coupons'] is Map<String, dynamic>) {
      final couponsMap = json['coupons'] as Map<String, dynamic>;
      
      // Extract BusinessId if present
      if (couponsMap['BusinessId'] != null) {
        businessIdObj = BusinessId.fromJson(couponsMap['BusinessId'] as Map<String, dynamic>);
      }
      
      // Extract coupons array
      if (couponsMap['coupons'] is List) {
        couponsList = (couponsMap['coupons'] as List<dynamic>)
            .map((item) => BusinessCoupon.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } else if (json['coupons'] is List) {
      // Handle direct array format (for backward compatibility)
      couponsList = (json['coupons'] as List<dynamic>)
          .map((item) => BusinessCoupon.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    
    return BusinessCouponsData(
      coupons: couponsList,
      deeplinkurl: json['deeplinkurl'] as String?,
      businessId: businessIdObj,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupons': coupons.map((coupon) => coupon.toJson()).toList(),
      'deeplinkurl': deeplinkurl,
      'businessId': businessId?.toJson(),
    };
  }
}

class BusinessCoupon {
  final BusinessId? businessId;
  final String? id;
  final String? businessName;
  final String? couponId;
  final String? vouchertype;
  final String? category;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? expiryDate;
  final List<String>? redeemdays;
  final int? totaluserAvail;
  final int? userAssigned;
  final String? redeemOnSingleBill;
  final String? terms;
  final List<String>? howToRedeem;
  final String? discountType;
  final int? fixedvalue;
  final int? percentage;
  final int? originalPrice;
  final List<CouponImage>? images;
  final String? status;
  final String? user;
  final int? usedCoupon;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final int? daysToExpire;

  BusinessCoupon({
    this.businessId,
    this.id,
    this.businessName,
    this.couponId,
    this.vouchertype,
    this.category,
    this.title,
    this.subtitle,
    this.description,
    this.expiryDate,
    this.redeemdays,
    this.totaluserAvail,
    this.userAssigned,
    this.redeemOnSingleBill,
    this.terms,
    this.howToRedeem,
    this.discountType,
    this.fixedvalue,
    this.percentage,
    this.originalPrice,
    this.images,
    this.status,
    this.user,
    this.usedCoupon,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.daysToExpire,
  });

  factory BusinessCoupon.fromJson(Map<String, dynamic> json) {
    return BusinessCoupon(
      businessId: json['BusinessId'] != null ? BusinessId.fromJson(json['BusinessId'] as Map<String, dynamic>) : null,
      id: json['_id'] as String?,
      businessName: json['BusinessName'] as String?,
      couponId: json['couponId'] as String?,
      vouchertype: json['vouchertype'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      expiryDate: json['expiryDate'] as String?,
      redeemdays: (json['redeemdays'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      totaluserAvail: json['totaluserAvail'] as int?,
      userAssigned: json['user_assigned'] as int?,
      redeemOnSingleBill: json['redeem_on_single_bill'] as String?,
      terms: json['terms'] as String?,
      howToRedeem: (json['how_to_redeem'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      discountType: json['discountType'] as String?,
      fixedvalue: json['fixedvalue'] as int?,
      percentage: json['percentage'] as int?,
      originalPrice: json['original_price'] as int?,
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => CouponImage.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      user: json['user'] as String?,
      usedCoupon: json['usedCoupon'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      daysToExpire: json['daysToExpire'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BusinessId': businessId?.toJson(),
      '_id': id,
      'BusinessName': businessName,
      'couponId': couponId,
      'vouchertype': vouchertype,
      'category': category,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'expiryDate': expiryDate,
      'redeemdays': redeemdays,
      'totaluserAvail': totaluserAvail,
      'user_assigned': userAssigned,
      'redeem_on_single_bill': redeemOnSingleBill,
      'terms': terms,
      'how_to_redeem': howToRedeem,
      'discountType': discountType,
      'fixedvalue': fixedvalue,
      'percentage': percentage,
      'original_price': originalPrice,
      'images': images?.map((image) => image.toJson()).toList(),
      'status': status,
      'user': user,
      'usedCoupon': usedCoupon,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'daysToExpire': daysToExpire,
    };
  }
}

class BusinessId {
  final ContactInfo? contactInfo;
  final BusinessLocationInfo? locationInfo;
  final GoogleLocation? googleLocation;
  final BusinessCoverImage? coverImage;
  final String? id;
  final String? status;

  BusinessId({
    this.contactInfo,
    this.locationInfo,
    this.googleLocation,
    this.coverImage,
    this.id,
    this.status,
  });

  factory BusinessId.fromJson(Map<String, dynamic> json) {
    return BusinessId(
      contactInfo: json['contactInfo'] != null ? ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>) : null,
      locationInfo: json['locationInfo'] != null ? BusinessLocationInfo.fromJson(json['locationInfo'] as Map<String, dynamic>) : null,
      googleLocation: json['googleLocation'] != null ? GoogleLocation.fromJson(json['googleLocation'] as Map<String, dynamic>) : null,
      coverImage: json['coverImage'] != null ? BusinessCoverImage.fromJson(json['coverImage'] as Map<String, dynamic>) : null,
      id: json['_id'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactInfo': contactInfo?.toJson(),
      'locationInfo': locationInfo?.toJson(),
      'googleLocation': googleLocation?.toJson(),
      'coverImage': coverImage?.toJson(),
      '_id': id,
      'status': status,
    };
  }
}

class ContactInfo {
  final String? officeLandline;
  final String? phoneNo;
  final String? alternateNo;

  ContactInfo({
    this.officeLandline,
    this.phoneNo,
    this.alternateNo,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      officeLandline: json['officeLandline'] as String?,
      phoneNo: json['phoneNo'] as String?,
      alternateNo: json['alternateNo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'officeLandline': officeLandline,
      'phoneNo': phoneNo,
      'alternateNo': alternateNo,
    };
  }
}

class BusinessLocationInfo {
  final String? address;

  BusinessLocationInfo({
    this.address,
  });

  factory BusinessLocationInfo.fromJson(Map<String, dynamic> json) {
    return BusinessLocationInfo(
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
    };
  }
}

class GoogleLocation {
  final String? latitude;
  final String? longitude;

  GoogleLocation({
    this.latitude,
    this.longitude,
  });

  factory GoogleLocation.fromJson(Map<String, dynamic> json) {
    return GoogleLocation(
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class BusinessCoverImage {
  final String? reason;
  final String? url;
  final String? status;

  BusinessCoverImage({
    this.reason,
    this.url,
    this.status,
  });

  factory BusinessCoverImage.fromJson(Map<String, dynamic> json) {
    return BusinessCoverImage(
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

class CouponImage {
  final String? webimage;
  final String? mobimage;
  final String? thumbnailimage;
  final String? id;

  CouponImage({
    this.webimage,
    this.mobimage,
    this.thumbnailimage,
    this.id,
  });

  factory CouponImage.fromJson(Map<String, dynamic> json) {
    return CouponImage(
      webimage: json['webimage'] as String?,
      mobimage: json['mobimage'] as String?,
      thumbnailimage: json['thumbnailimage'] as String?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'webimage': webimage,
      'mobimage': mobimage,
      'thumbnailimage': thumbnailimage,
      '_id': id,
    };
  }
}

class BusinessCouponsRequest {
  final String businessid;
  final String categoryid;

  BusinessCouponsRequest({
    required this.businessid,
    required this.categoryid,
  });

  Map<String, dynamic> toJson() {
    return {
      'Businessid': businessid,
      'categoryid': categoryid,
    };
  }
}