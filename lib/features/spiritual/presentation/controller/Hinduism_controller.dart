import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class HinduismController extends GetxController {
  var bannerImage = <String, dynamic>{}.obs;
  var featuredList = <dynamic>[].obs;
  var chants = <String, dynamic>{}.obs;
  var adSliderList = <dynamic>[].obs;

  var isLoading = false.obs;

  Future<void> fetchSpiritualData() async {
    isLoading.value = true;
    try {
  
      final response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/spiritual/hinduism'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final responseData = data['data'] as Map<String, dynamic>;
        print("Full API Response:\n${json.encode(data)}");

        bannerImage.value = (responseData['banner_image'] ?? {}) as Map<String, dynamic>;
        featuredList.value = (responseData['featured'] ?? []) as List<dynamic>;
        chants.value = (responseData['chants'] ?? {}) as Map<String, dynamic>;
        adSliderList.value = (responseData['ad_slider'] ?? []) as List<dynamic>;
        print("Banner Image:\n$bannerImage");
        print("Featured List:\n$featuredList");
        print("Chants:\n$chants");
        print("Ad Slider List:\n$adSliderList");      } else {
        Get.snackbar("Error", "Failed to fetch data. (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchSpiritualData();
    super.onInit();
  }
}
