class CouponCategoryResponse {
  final int? statusCode;
  final List<CouponCategory>? data;
  final String? message;
  final bool? success;

  CouponCategoryResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory CouponCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CouponCategoryResponse(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CouponCategory.fromJson(item as Map<String, dynamic>))
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

class CouponCategory {
  final String? id;
  final String? categoryname;
  final String? webthumbnail;
  final String? mobthumbnail;
  final String? status;
  final String? user;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CouponCategory({
    this.id,
    this.categoryname,
    this.webthumbnail,
    this.mobthumbnail,
    this.status,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CouponCategory.fromJson(Map<String, dynamic> json) {
    return CouponCategory(
      id: json['_id'] as String?,
      categoryname: json['categoryname'] as String?,
      webthumbnail: json['webthumbnail'] as String?,
      mobthumbnail: json['mobthumbnail'] as String?,
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
      'categoryname': categoryname,
      'webthumbnail': webthumbnail,
      'mobthumbnail': mobthumbnail,
      'status': status,
      'user': user,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}