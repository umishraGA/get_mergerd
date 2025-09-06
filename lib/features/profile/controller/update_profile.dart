import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/features/profile/controller/profile_controller.dart';
import 'package:myapp/utils/dio/auth_helper.dart';

class UpdateProfileController extends GetxController {
  // Observable loading state
  var isLoading = false.obs;
  final UserDetailsController userDetailsController =Get.put(UserDetailsController());
  // Update user profile API
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String image,
    required String maritalStatus,
    required String interest,
    required String gender,
    required String occupation,
    required String dateOfBirth,
    required BuildContext context,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse('https://api.gamsgroup.in/user/basic/update-user-profile');

      final body = {
        "firstName": firstName,
        "lastName": lastName,
        "image": image,
        "maritalStatus": maritalStatus,
        "interest": interest,
        "gender": gender,
        "occupation": occupation,
        "dateOfBirth": dateOfBirth,
      };

  
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // You can process `data` further if needed
        userDetailsController.fetchUserDetails();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
