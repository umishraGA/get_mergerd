import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class AartiController extends GetxController {
  var aartis = [].obs;
  var isLoading = false.obs;
  var pageNo = 1;
  final int pageSize = 10;
  var hasMoreData = true.obs;
  ScrollController scrollController = ScrollController();

  final String baseUrl = 'https://api.gamsgroup.in/user/spiritual/hinduism/aarti';

  @override
  void onInit() {
    super.onInit();
    fetchAartis(isInitial: true);
  }

  Future<void> fetchAartis({bool isInitial = false}) async {
    if (isLoading.value || !hasMoreData.value) return;

    isLoading.value = true;

    if (isInitial) {
      pageNo = 1;
      aartis.clear();
      hasMoreData.value = true;
    }

    try {

      final uri = Uri.parse('$baseUrl?page=$pageNo&limit=$pageSize');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> fetched = data['data'] as List<dynamic>;

        if (fetched.length < pageSize) {
          hasMoreData.value = false;
        }

        aartis.addAll(fetched);
        pageNo++;
      } else {
        Get.snackbar('Error', 'Failed to load aarti');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
