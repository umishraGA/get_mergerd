import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constant/base_url.dart';

class CreateAccountController extends GetxController {
  var isLoading = false.obs;

  Future<bool> createUser({
    required BuildContext context,

    required String email,
    required String firstName,
    required String password,
  }) async
  {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User token not found"),
          backgroundColor: Colors.red,
        ),
      );
      isLoading.value = false;
      return false;
    }

    final url = Uri.parse('$baseUrl/user/basic/update-user');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "step": 1,
          "email": email,
          "firstName": firstName,
          "password": password,
        }),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);

          if (responseData['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    responseData['message']?.toString() ?? "User updated successfully."),
                backgroundColor: Colors.green,
              ),
            );
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    responseData['message']?.toString() ?? "Failed to update user."),
                backgroundColor: Colors.red,
              ),
            );
            return false;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Empty response from server."),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("HTTP Error: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Exception: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> completeProfile({
    required BuildContext context,
    required String firstName,
    required String dateOfBirth,
    required String gender,
    required String country,
    required String state,
    required String city,
    required String area,
    required String occupation,
    required String maritalStatus,
  }) async
  {
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User token not found"),
          backgroundColor: Colors.red,
        ),
      );
      isLoading.value = false;
      return false;
    }

    final url = Uri.parse('$baseUrl/user/basic/update-user');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "step": 2,
          "firstName": firstName,
          "dathOfBirth": dateOfBirth,
          "gender": gender,
          "country": country,
          "state": state,
          "city": city,
          "area": area,
          "occupation": occupation,
          "maritalStatus": maritalStatus,
        }),
      );

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final responseData = jsonDecode(response.body);

          if (responseData['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    responseData['message']?.toString() ?? "User updated successfully."),
                backgroundColor: Colors.green,
              ),
            );
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    responseData['message']?.toString() ?? "Failed to update user."),
                backgroundColor: Colors.red,
              ),
            );
            return false;
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Empty response from server."),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("HTTP Error: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Exception: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
