class RedeemHistoryResponse {
  final int statusCode;
  final List<RedeemHistoryItem> data;
  final String message;
  final bool success;

  RedeemHistoryResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory RedeemHistoryResponse.fromJson(Map<String, dynamic> json) {
    return RedeemHistoryResponse(
      statusCode: (json['statusCode'] as int?) ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => RedeemHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      message: (json['message'] as String?) ?? '',
      success: (json['success'] as bool?) ?? false,
    );
  }
}

class RedeemHistoryItem {
  final String id;
  final List<CouponCode> couponCodes;
  final String user;
  final String customerId;
  final CouponInfo couponId;
  final bool redeemed;
  final int userAssigned;
  final int totalAvailUser;
  final int balanceCoupon;
  final int usedCoupon;
  final List<DateTime> redeemAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  RedeemHistoryItem({
    required this.id,
    required this.couponCodes,
    required this.user,
    required this.customerId,
    required this.couponId,
    required this.redeemed,
    required this.userAssigned,
    required this.totalAvailUser,
    required this.balanceCoupon,
    required this.usedCoupon,
    required this.redeemAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RedeemHistoryItem.fromJson(Map<String, dynamic> json) {
    return RedeemHistoryItem(
      id: (json['_id'] as String?) ?? '',
      couponCodes: (json['couponcode'] as List<dynamic>?)
          ?.map((item) => CouponCode.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      user: (json['user'] as String?) ?? '',
      customerId: (json['customerId'] as String?) ?? '',
      couponId: CouponInfo.fromJson((json['couponId'] as Map<String, dynamic>?) ?? {}),
      redeemed: (json['redeemed'] as bool?) ?? false,
      userAssigned: (json['user_assigned'] as int?) ?? 0,
      totalAvailUser: (json['totalAvailUser'] as int?) ?? 0,
      balanceCoupon: (json['balanceCoupon'] as int?) ?? 0,
      usedCoupon: (json['usedCoupon'] as int?) ?? 0,
      redeemAt: (json['redeemAt'] as List<dynamic>?)
          ?.map((item) => DateTime.tryParse(item as String? ?? '') ?? DateTime.now())
          .toList() ?? [],
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ?? DateTime.now(),
    );
  }

  // Helper methods
  bool get hasAvailableCoupons => balanceCoupon > 0;
  bool get hasRedeemedCoupons => usedCoupon > 0;
  
  List<CouponCode> get availableCoupons => 
      couponCodes.where((code) => !code.redeemed).toList();
      
  List<CouponCode> get redeemedCoupons => 
      couponCodes.where((code) => code.redeemed).toList();

  String get displayValue {
    if (couponId.discountType == 'fixed') {
      return '₹${couponId.fixedValue}';
    } else if (couponId.discountType == 'percentage' && couponId.percentage != null) {
      return '${couponId.percentage}% OFF';
    }
    return 'Discount';
  }
}

class CouponCode {
  final String code;
  final bool redeemed;
  final String id;

  CouponCode({
    required this.code,
    required this.redeemed,
    required this.id,
  });

  factory CouponCode.fromJson(Map<String, dynamic> json) {
    return CouponCode(
      code: (json['code'] as String?) ?? '',
      redeemed: (json['redeemed'] as bool?) ?? false,
      id: (json['_id'] as String?) ?? '',
    );
  }
}

class CouponInfo {
  final String id;
  final String title;
  final DateTime expiryDate;
  final List<String> redeemDays;
  final String terms;
  final String discountType;
  final int? fixedValue;
  final int? percentage;

  CouponInfo({
    required this.id,
    required this.title,
    required this.expiryDate,
    required this.redeemDays,
    required this.terms,
    required this.discountType,
    this.fixedValue,
    this.percentage,
  });

  factory CouponInfo.fromJson(Map<String, dynamic> json) {
    return CouponInfo(
      id: (json['_id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      expiryDate: DateTime.tryParse((json['expiryDate'] as String?) ?? '') ?? DateTime.now(),
      redeemDays: (json['redeemdays'] as List<dynamic>?)
          ?.map((day) => day as String)
          .toList() ?? [],
      terms: (json['terms'] as String?) ?? '',
      discountType: (json['discountType'] as String?) ?? 'fixed',
      fixedValue: (json['fixedvalue'] as int?),
      percentage: (json['percentage'] as int?),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  
  String get formattedExpiryDate {
    return '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  }
}