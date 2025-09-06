import 'package:dio/dio.dart';
import '../repo/AuthRepository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  Future<Response> sendSignupOtp(String phone) async {
    return await _authRepository.sendSignupOtp(phone);
  }

  Future<Response<dynamic>> verifySignupOtp(String phone, String otp) async {
    return await _authRepository.verifySignupOtp(phone, otp);
  }

  Future<Response> sendLoginOtp(String phone) async {
    return await _authRepository.sendLoginOtp(phone);
  }

  Future<Response<dynamic>> verifyLoginOtp(String phone, String otp) async {
    return await _authRepository.verifyLoginOtp(phone, otp);
  }
}