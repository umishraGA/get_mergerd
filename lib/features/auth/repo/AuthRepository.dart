import 'package:dio/dio.dart';
import 'package:myapp/common/constant/endpoints.dart';
import '../../../utils/dio/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient.instance;

  Future<Response> sendSignupOtp(String phone) async {
    final response = await _dioClient.post(
        Endpoints.signupOtp,
        data: {
          'phone': phone,
        },
      );
      return response;
  }

  Future<Response> verifySignupOtp(String phone, String otp) async {
    final response = await _dioClient.post(
        Endpoints.verifySignupOtp,
        data: {
          'phone': phone,
          'otp': otp,
      },
      );
      return response;
  }

  Future<Response> sendLoginOtp(String phone) async {
    final response = await _dioClient.post(
        Endpoints.loginOtp,
        data: {
          'phone': phone,
        },
      );
      return response;
  }

  Future<Response> verifyLoginOtp(String phone, String otp) async {
    final response = await _dioClient.post(
        Endpoints.verifyLoginOtp,
        data: {
          'phone': phone,
          'otp': otp,
        },
      );
      return response;
  }
}