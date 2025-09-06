// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class CategoryModel {
//   final String id;
//   final String name;
//   final String? bannerImage;
//   final List<CategoryModel> children;
//
//   CategoryModel({
//     required this.id,
//     required this.name,
//     this.bannerImage,
//     required this.children,
//   });
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     return CategoryModel(
//       id: json['_id'].toString(),
//       name: json['name'].toString(),
//       bannerImage: json['bannerImage'].toString(),
//       children: (json['children'] as List)
//           .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
//
// class CategoryController extends GetxController {
//   var categories = <CategoryModel>[].obs;
//   var isLoading = false.obs;
//
//   // API base url
//   final String baseUrl = "{{vps}}/user/common/get-category";
//
//   @override
//   void onInit() {
//     fetchCategories();
//     super.onInit();
//   }
//
//   Future<void> fetchCategories() async {
//     try {
//       isLoading.value = true;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");
//
//       final response = await http.get(
//         Uri.parse(baseUrl),
//         headers: {
//           "Authorization": "Bearer ${AuthHelper.getAuthToken}",
//           "Content-Type": "application/json",
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//         List data = body['data'] as List<dynamic>;
//         categories.value = data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
//       }
//     } catch (e) {
//       print("Error fetching categories: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
//
