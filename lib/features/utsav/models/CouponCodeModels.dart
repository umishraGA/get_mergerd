class CouponCodeResponse {
  final int? statusCode;
  final CouponCodeData? data;
  final String? message;
  final bool? success;

  CouponCodeResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory CouponCodeResponse.fromJson(Map<String, dynamic> json) {
    return CouponCodeResponse(
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null 
          ? CouponCodeData.fromJson(json['data'] as Map<String, dynamic>)
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

class CouponCodeData {
  final String? id;
  final List<CouponCode>? couponcode;
  final String? user;
  final String? customerId;
  final String? couponId;
  final bool? redeemed;
  final int? userAssigned;
  final int? totalAvailUser;
  final int? balanceCoupon;
  final int? usedCoupon;
  final List<String>? redeemAt;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CouponCodeData({
    this.id,
    this.couponcode,
    this.user,
    this.customerId,
    this.couponId,
    this.redeemed,
    this.userAssigned,
    this.totalAvailUser,
    this.balanceCoupon,
    this.usedCoupon,
    this.redeemAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CouponCodeData.fromJson(Map<String, dynamic> json) {
    return CouponCodeData(
      id: json['_id'] as String?,
      couponcode: (json['couponcode'] as List<dynamic>?)
          ?.map((item) => CouponCode.fromJson(item as Map<String, dynamic>))
          .toList(),
      user: json['user'] as String?,
      customerId: json['customerId'] as String?,
      couponId: json['couponId'] as String?,
      redeemed: json['redeemed'] as bool?,
      userAssigned: json['user_assigned'] as int?,
      totalAvailUser: json['totalAvailUser'] as int?,
      balanceCoupon: json['balanceCoupon'] as int?,
      usedCoupon: json['usedCoupon'] as int?,
      redeemAt: (json['redeemAt'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'couponcode': couponcode?.map((item) => item.toJson()).toList(),
      'user': user,
      'customerId': customerId,
      'couponId': couponId,
      'redeemed': redeemed,
      'user_assigned': userAssigned,
      'totalAvailUser': totalAvailUser,
      'balanceCoupon': balanceCoupon,
      'usedCoupon': usedCoupon,
      'redeemAt': redeemAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class CouponCode {
  final String? code;
  final bool? redeemed;
  final String? id;

  CouponCode({
    this.code,
    this.redeemed,
    this.id,
  });

  factory CouponCode.fromJson(Map<String, dynamic> json) {
    return CouponCode(
      code: json['code'] as String?,
      redeemed: json['redeemed'] as bool?,
      id: json['_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'redeemed': redeemed,
      '_id': id,
    };
  }
}

class GenerateCouponCodeRequest {
  final String couponId;
  final String customerId;

  GenerateCouponCodeRequest({
    required this.couponId,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'customerId': customerId,
    };
  }
}

class RedeemCouponRequest {
  final String couponId;
  final String customerId;

  RedeemCouponRequest({
    required this.couponId,
    required this.customerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'customerId': customerId,
    };
  }
}