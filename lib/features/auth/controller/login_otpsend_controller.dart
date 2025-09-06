import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../service/AuthService.dart';
import '../../../utils/dio/auth_helper.dart';

class LoginOtpController extends GetxController {
  var isLoading = false.obs;
  final AuthService _authService = AuthService();

  /// Send OTP for login
  Future<bool> sendLoginOtp(BuildContext context, String phone) async {
    isLoading.value = true;
    
    try {
      final response = await _authService.sendLoginOtp(phone);
      
      if (response.statusCode == 200) {
        final responseData = response.data;
        bool success = false;
        String message = "";
        
        if (responseData is Map<String, dynamic>) {
          success = responseData['success'] == true;
          message = responseData['message']?.toString() ?? "";
        } else if (responseData is String) {
          try {
            final parsed = json.decode(responseData);
            if (parsed is Map<String, dynamic>) {
              success = parsed['success'] == true;
              message = parsed['message']?.toString() ?? "";
            }
          } catch (e) {
            success = response.statusCode == 200;
            message = responseData;
          }
        }
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("OTP sent successfully to $phone"),
              backgroundColor: Colors.green,
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message.isNotEmpty ? message : "Failed to send OTP."),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send OTP. Status: ${response.statusCode}"),
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

  /// Verify OTP for login
  Future<bool> verifyLoginOtp(BuildContext context, String phone, String otp) async {
    isLoading.value = true;
    
    try {
      final response = await _authService.verifyLoginOtp(phone, otp);
      
      if (response.statusCode == 200) {
        // Handle case where response.data might be a String or Map
        final responseData = response.data;
        bool success = false;
        String message = "";
        Map<String, dynamic>? authData;
        
        if (responseData is Map<String, dynamic>) {
          success = responseData['success'] == true;
          message = responseData['message']?.toString() ?? "";
          authData = responseData['data'] is Map<String, dynamic> 
              ? responseData['data'] as Map<String, dynamic> 
              : null;
        } else if (responseData is String) {
          try {
            final parsed = json.decode(responseData);
            if (parsed is Map<String, dynamic>) {
              success = parsed['success'] == true;
              message = parsed['message']?.toString() ?? "";
              authData = parsed['data'] is Map<String, dynamic> 
                  ? parsed['data'] as Map<String, dynamic> 
                  : null;
            }
          } catch (e) {
            success = response.statusCode == 200;
            message = responseData;
          }
        }
        
        if (success) {
          // Use AuthHelper to save authentication data
          if (authData != null) {
            if (authData['token'] != null) {
              await AuthHelper.saveAuthToken(authData['token'].toString());
            }
            if (authData['isComplete'] != null) {
              await AuthHelper.saveProfileCompleted(authData['isComplete'] as bool? ?? false);
            }
            if (authData['refreshToken'] != null) {
              await AuthHelper.saveRefreshToken(authData['refreshToken'].toString());
            }
            if (authData['userId'] != null) {
              await AuthHelper.saveUserId(authData['userId'].toString());
            }
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login successful!"),
              backgroundColor: Colors.green,
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message.isNotEmpty ? message : "OTP verification failed."),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP verification failed. Status: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
//   ===========================






  final SmsAutoFill _smsAutoFill = SmsAutoFill();
  var otpCode = "".obs; // For autofill OTP field
  var message = "".obs; // For UI message

  @override
  void onInit() {
    super.onInit();
    _listenForSms();
  }

  void _listenForSms() {
    try {
      _smsAutoFill.code.listen((String? code) {
        if (code != null && code.isNotEmpty) {
          otpCode.value = code; // Auto-fill OTP field
          message.value = "Received OTP: $code"; // Show in UI
        }
      });
    } catch (e) {
      message.value = "Error listening for SMS: $e";
    }
  }

  Future<String> getAppSignature() async {
    try {
      final sig = await _smsAutoFill.getAppSignature;
      return sig;
    } catch (e) {
      return "Error getting signature: $e";
    }
  }

  Future<void> unregister() async {
    await _smsAutoFill.unregisterListener();
  }

  @override
  void onClose() {
    unregister();
    super.onClose();
  }





}
