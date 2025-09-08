class ReportOption {
  final String id;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportOption({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportOption.fromJson(Map<String, dynamic> json) {
    return ReportOption(
      id: json['_id'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ReportOptionsResponse {
  final int statusCode;
  final List<ReportOption> data;
  final String message;
  final bool success;

  ReportOptionsResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory ReportOptionsResponse.fromJson(Map<String, dynamic> json) {
    return ReportOptionsResponse(
      statusCode: json['statusCode'] as int,
      data: (json['data'] as List)
          .map((item) => ReportOption.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }
}

enum ReportModel {
  post('Post'),
  polls('Polls'),
  story('Story');

  const ReportModel(this.value);
  final String value;
}

class CreateReportRequest {
  final String reportId;
  final String postId;
  final ReportModel reportModel;

  CreateReportRequest({
    required this.reportId,
    required this.postId,
    required this.reportModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'postId': postId,
      'reportModel': reportModel.value,
    };
  }
}