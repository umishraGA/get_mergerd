import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class ChantCountController extends GetxController {
  var isLoading = false.obs;



  Future<void> updateChantCount({required String religion, required String chant_tab}) async {
    isLoading.value = true;

    final url = Uri.parse("https://api.gamsgroup.in/user/spiritual/chantCount");

    try {

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "religion": religion,
          "chant_tab": chant_tab,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {

        } else {
          Get.snackbar("Error", "Something went wrong");
        }
      } else {
        Get.snackbar("Failed", "Error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
