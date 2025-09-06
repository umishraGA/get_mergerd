import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class HinduismCitiesController extends GetxController {
  // Reactive state
  var isLoading = false.obs;
  var cities = <Map<String, dynamic>>[].obs;
  var bannerImage = <String, dynamic>{}.obs;
  var errorMessage = ''.obs;
  var selectedCityId = ''.obs;


  // Fetch data from API
  Future<void> fetchCities() async {
    try {
  
      isLoading(true);
      errorMessage('');

      final response = await http.get(
        Uri.parse("https://api.gamsgroup.in/user/spiritual/hinduism/cities"),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        if (data['success'] == true) {
          // Explicitly cast the cities list
          final List<dynamic> citiesData = data['data']['cities'] as List;
          cities.assignAll(citiesData.map<Map<String, dynamic>>(
                  (city) => city as Map<String, dynamic>
          ).toList());

          // Explicitly cast the banner image
          bannerImage(data['data']['banner_image'] as Map<String, dynamic>);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch data');
        }
      } else {
        throw Exception('HTTP ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get banner image URL based on platform
  // String getBannerImage() {
  //   return GetPlatform.isWeb
  //       ? bannerImage['web_image']?.toString() ?? ''
  //       : bannerImage['mobile_image']?.toString() ?? '';
  // }
}