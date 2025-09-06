import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/dio/auth_helper.dart';

class CategoryFilterController extends GetxController {
  var selectedCategory = 'All Events'.obs;
  var categories = ['All Events'].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

  

      final url = Uri.parse("https://api.gamsgroup.in/user/event/EventCategory");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        final List<dynamic> apiCategories = data['data']as List<dynamic>;

        categories.value = [
          'All Events',
          ...apiCategories.map((cat) => (cat['categoryname'] ?? '').toString())
        ];
      } else {
        throw Exception("Failed to fetch categories");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
