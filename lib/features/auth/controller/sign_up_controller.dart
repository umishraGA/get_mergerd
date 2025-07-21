import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupOtpController extends GetxController {
  var isLoading = false.obs;

  final String baseUrl = 'https://roll-mngmnt-backend.vercel.app/user/auth/signup-otp';

  /// ✅ Send OTP
  Future<bool> sendSignupOtp(BuildContext context, String phone) async {
    isLoading.value = true;

    final url = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'phone': phone});

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData["message"].toString()),
            backgroundColor: Colors.green,
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData["message"].toString()),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Verify OTP
  /// ✅ Verify OTP
  Future<bool> verifySignUpOtp({
    required BuildContext context,
    required String phone,
    required String otp,
  }) async
  {isLoading.value = true;

    const String verifyUrl = "https://roll-mngmnt-backend.vercel.app/user/auth/verify-signup";

    try {
      final response = await http.post(
        Uri.parse(verifyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": phone, "otp": otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", responseData["data"]["token"].toString());
        await prefs.setString("refreshToken", responseData["data"]["refreshToken"].toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData["message"].toString()),
            backgroundColor: Colors.green,
          ),
        );

        return true; // ✅ Verification successful
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData["message"].toString()),
            backgroundColor: Colors.red,
          ),
        );
        return false; // ❌ Invalid OTP
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return false; // ❌ Exception occurred
    } finally {
      isLoading.value = false;
    }
  }

}
