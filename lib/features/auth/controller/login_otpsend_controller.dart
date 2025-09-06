import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        // Handle case where response.data might be a String or Map
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
              print("snhsdjhs ${authData['token']}");
              await AuthHelper.saveAuthToken(authData['token'].toString());
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
}
