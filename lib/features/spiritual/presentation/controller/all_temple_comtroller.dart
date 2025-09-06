// File: controllers/temple_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class AllTempleController extends GetxController {
  var temples = [].obs;
  var isLoading = false.obs;
  var pageNo = 1;
  final int pageSize = 10;
  var hasMoreData = true.obs;

  String _search = ''; // private search
  String cityId = '';
  final String baseUrl = 'https://api.gamsgroup.in/user/spiritual/hinduism/temples';

  set search(String value) {
    _search = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchTemples(isInitial: true);
  }

  Future<void> fetchTemples({bool isInitial = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    if (isInitial) {
      pageNo = 1;
      temples.clear();
      hasMoreData.value = true;
    }

    try {
  
      final uri = Uri.parse(
        '$baseUrl?page=$pageNo&limit=$pageSize&city_id=$cityId&search=$_search',
      );
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> fetched = data['data'] as List<dynamic>;

        if (fetched.length < pageSize) {
          hasMoreData.value = false;
        }

        temples.addAll(fetched);
        pageNo++;
      } else {
        Get.snackbar('Error', 'Failed to load data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
