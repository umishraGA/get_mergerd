
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class ArticleController extends GetxController {
  RxBool isLoading = false.obs;
  RxList articles = [].obs;
  RxInt pageNo = 1.obs;


  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    isLoading.value = true;
    final String baseUrl = "https://api.gamsgroup.in/user/spiritual/hinduism/articles";

    final url = Uri.parse("$baseUrl?page=${pageNo.value}");
    try {

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (pageNo.value == 1) {
          articles.value = data['data'] as List<dynamic>;
        } else {
          articles.addAll(data['data']as List<dynamic>);
        }
      } else {
        print("Failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    pageNo.value++;
    fetchArticles();
  }

  void refreshArticles() {
    pageNo.value = 1;
    fetchArticles();
  }
}
