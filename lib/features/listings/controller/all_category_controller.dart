import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/dio/auth_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  RxList<Category> categoryList = <Category>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  final String baseUrl = "https://api.gamsgroup.in/user/common/get-category";

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
   var token =await AuthHelper.getAuthToken;

      if (token == null) {
        errorMessage.value = 'Token not found in shared preferences.';
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        List<dynamic> data = body['data'] as List<dynamic>;

        categoryList.value =
            data.map((item) => Category.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        errorMessage.value =
        'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    }

    isLoading.value = false;
  }
}
class Category {
  final String id;
  final String name;
  final String bannerImageApp;

  Category({
    required this.id,
    required this.name,
    required this.bannerImageApp,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'].toString(),
      name: json['name'].toString(),
      bannerImageApp: json['bannerImageApp'].toString(),
    );
  }
}