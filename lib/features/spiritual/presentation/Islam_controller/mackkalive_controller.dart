import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class MakkaLiveController extends GetxController {
  var isLoading = false.obs;
  var videoUrl = ''.obs;

  Future<void> fetchMakkaLiveUrl() async {
    try {
      isLoading.value = true;
  


      var headers = {
        'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
      };

      var response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/spiritual/islam/makkah-live'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        videoUrl.value = jsonData['data'].toString();
      } else {
        Get.snackbar('Error', 'Failed to fetch video URL');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }
}
