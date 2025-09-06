import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class LiveDarshanController extends GetxController {
  RxList<dynamic> darshanList = <dynamic>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxBool hasMore = true.obs;

  @override
  void onInit() {
    fetchLiveDarshan();
    super.onInit();
  }

  Future<void> fetchLiveDarshan({bool isRefresh = false}) async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    if (isRefresh) {
      currentPage.value = 1;
      darshanList.clear();
      hasMore.value = true;
    }


    try {
      final response = await http.get(
        Uri.parse("https://api.gamsgroup.in/user/spiritual/hinduism/livedarshan?page=${currentPage.value}"),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        List newData = body["data"] as List<dynamic>;

        if (newData.isNotEmpty) {
          darshanList.addAll(newData);
          currentPage.value++;
        } else {
          hasMore.value = false;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
