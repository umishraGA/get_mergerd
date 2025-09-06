import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/dio/auth_helper.dart';

class SubCategoryController extends GetxController {
  var isLoading = false.obs;
  var subCategories = [].obs;

  Future<void> fetchSubCategories(String categoryId) async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Error", "User token not found");
        return;
      }

      final url = 'https://api.gamsgroup.in/user/common/get-categorybyid/$categoryId';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          subCategories.value = data['data'] as List<dynamic>;
        } else {
          Get.snackbar("Failed", data['message'].toString() );
        }
      } else {
        Get.snackbar("Error", "Something went wrong: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
