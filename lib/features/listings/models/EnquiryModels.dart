class SaveEnquiryRequest {
  final String businessId;
  final String serviceName;
  final String details;

  SaveEnquiryRequest({
    required this.businessId,
    required this.serviceName,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessId': businessId,
      'serviceName': serviceName,
      'details': details,
    };
  }
}

class SaveEnquiryResponse {
  final int? statusCode;
  final EnquiryData? data;
  final String? message;
  final bool? success;

  SaveEnquiryResponse({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory SaveEnquiryResponse.fromJson(Map<String, dynamic> json) {
    return SaveEnquiryResponse(
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null 
          ? EnquiryData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class EnquiryData {
  final String? businessId;
  final String? userId;
  final String? serviceName;
  final String? details;
  final String? status;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? leadId;
  final int? v;

  EnquiryData({
    this.businessId,
    this.userId,
    this.serviceName,
    this.details,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.leadId,
    this.v,
  });

  factory EnquiryData.fromJson(Map<String, dynamic> json) {
    return EnquiryData(
      businessId: json['businessId'] as String?,
      userId: json['userId'] as String?,
      serviceName: json['serviceName'] as String?,
      details: json['details'] as String?,
      status: json['status'] as String?,
      id: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      leadId: json['leadId'] as String?,
      v: json['__v'] as int?,
    );
  }
}