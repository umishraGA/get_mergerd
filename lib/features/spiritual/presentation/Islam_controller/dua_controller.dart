import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class DuaController extends GetxController {
  var duaList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isMoreDataAvailable = true.obs;
  var pageNo = 1;

  final String baseUrl = 'https://api.gamsgroup.in/user/spiritual/islam/dua';

  @override
  void onInit() {
    super.onInit();
    fetchDuas(); // initial fetch
  }

  Future<void> fetchDuas({bool isLoadMore = false}) async {
    if (isLoading.value || !isMoreDataAvailable.value) return;

    isLoading.value = true;

    try {
  
      final response = await http.get(
        Uri.parse('$baseUrl?page_no=$pageNo'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final List<dynamic> newItems = jsonData['data'] as List<dynamic>;

        if (newItems.isNotEmpty) {
          // append new items to existing list
          duaList.addAll(newItems.cast<Map<String, dynamic>>());
          pageNo++; // move to next page
        } else {
          // no more data available
          isMoreDataAvailable.value = false;
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

   refreshDuas() {
    // reset pagination and list
    pageNo = 1;
    isMoreDataAvailable.value = true;
    duaList.clear();
    fetchDuas();
  }
}
