import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/AuthService.dart';

class SignupOtpController extends GetxController {
  var isLoading = false.obs;
  final AuthService _authService = AuthService();
  final AuthHelper _authHelper =  AuthHelper();

  /// ✅ Send OTP
  Future<bool> sendSignupOtp(BuildContext context, String phone) async {
    isLoading.value = true;

    try {
      final response = await _authService.sendSignupOtp(phone);
      final responseData = response.data;

      if (response.statusCode == 200 && responseData['success'] == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData["message"].toString()),
              backgroundColor: Colors.green,
            ),
          );
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData["message"].toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Verify OTP
  Future<bool> verifySignUpOtp({
    required BuildContext context,
    required String phone,
    required String otp,
  }) async {
    isLoading.value = true;

    try {
      final response = await _authService.verifySignupOtp(phone, otp);
      final responseData = response.data;

      if (response.statusCode == 200 && responseData["success"] == true) {
        AuthHelper.saveAuthToken(responseData["data"]["token"] as String? ?? "");
        AuthHelper.saveRefreshToken(responseData["data"]["refreshToken"] as String? ?? "");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData["message"].toString()),
              backgroundColor: Colors.green,
            ),
          );
        }

        return true; // ✅ Verification successful
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData["message"].toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false; // ❌ Invalid OTP
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false; // ❌ Exception occurred
    } finally {
      isLoading.value = false;
    }
  }

}
