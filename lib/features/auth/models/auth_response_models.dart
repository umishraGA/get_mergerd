class SignupOtpResponse {
  final int statusCode;
  final SignupOtpData data;
  final String message;
  final bool success;

  SignupOtpResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory SignupOtpResponse.fromJson(Map<String, dynamic> json) {
    return SignupOtpResponse(
      statusCode: json['statusCode'] as int,
      data: SignupOtpData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class SignupOtpData {
  final String message;
  final String type;

  SignupOtpData({
    required this.message,
    required this.type,
  });

  factory SignupOtpData.fromJson(Map<String, dynamic> json) {
    return SignupOtpData(
      message: json['message'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type,
    };
  }
}

class VerifySignupResponse {
  final int statusCode;
  final VerifySignupData data;
  final String message;
  final bool success;

  VerifySignupResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory VerifySignupResponse.fromJson(Map<String, dynamic> json) {
    return VerifySignupResponse(
      statusCode: json['statusCode'] as int,
      data: VerifySignupData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.toJson(),
      'message': message,
      'success': success,
    };
  }
}

class VerifySignupData {
  final String token;
  final String refreshToken;

  VerifySignupData({
    required this.token,
    required this.refreshToken,
  });

  factory VerifySignupData.fromJson(Map<String, dynamic> json) {
    return VerifySignupData(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}