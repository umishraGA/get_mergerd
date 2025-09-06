import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class AllahNamesController extends GetxController {
  final allahNames = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  int currentPage = 1;
  bool hasMoreData = true;

  Future<void> fetchAllahNames({bool isInitial = false}) async {
    if (isLoading.value || isLoadingMore.value || !hasMoreData) return;

    try {
      if (isInitial) {
        currentPage = 1;
        hasMoreData = true;
        allahNames.clear();
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }


      final response = await http.get(
        Uri.parse("https://api.gamsgroup.in/user/spiritual/islam/allah-name?page_no=$currentPage"),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true && decoded["data"] is List) {
          final List<Map<String, dynamic>> newItems =
          List<Map<String, dynamic>>.from(decoded["data"] as Iterable<dynamic>);

          if (newItems.isEmpty) {
            hasMoreData = false;
          } else {
            currentPage++;
            allahNames.addAll(newItems);
          }
        } else {
          Get.snackbar("Error", "Invalid data format");
        }
      } else {
        Get.snackbar("Error", "Failed to load: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
