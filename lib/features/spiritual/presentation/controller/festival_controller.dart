import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../utils/dio/auth_helper.dart';

class SpiritualFestivalsController extends GetxController {
  final String apiUrl = "https://api.gamsgroup.in/user/spiritual/hinduism/festivals";
  var isLoading = false.obs;
  var festivalsList = <Festival>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFestivals();
  }

  Future<void> fetchFestivals() async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          festivalsList.assignAll(
            (responseData['data'] as List)
                .map((festival) => Festival.fromJson(festival as Map<String, dynamic>))
                .toList(),
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load festivals');
        }
      } else {
        throw Exception('Failed to load festivals: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshFestivals() async {
    await fetchFestivals();
  }
}

class Festival {
  final String id;
  final String name;
  final String image;
  final DateTime date;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Festival({
    required this.id,
    required this.name,
    required this.image,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      id: json['_id']?.toString()??"",
      name: json['name']?.toString()??"",
      image: json['image']?.toString()??"",
      date: DateTime.parse(json['date']?.toString()??""),
      status: json['status']?.toString()??"",
      createdAt: DateTime.parse(json['createdAt']?.toString()??""),
      updatedAt: DateTime.parse(json['updatedAt']?.toString()??""),
    );
  }
}