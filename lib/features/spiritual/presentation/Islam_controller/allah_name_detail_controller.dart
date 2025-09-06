import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class AllahNameDetailController extends GetxController {
  final isLoading = false.obs;
  final nameDetails = <String, dynamic>{}.obs;
  String? errorMessage;

  Future<void> fetchNameDetails(String id) async {
    try {
      isLoading(true);
      errorMessage = null;

      final response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/spiritual/islam/allah-name/$id'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          nameDetails.value = jsonData['data'] as Map<String, dynamic>;
        } else {
          errorMessage = jsonData['message']?.toString() ?? 'Failed to load name details';
        }
      } else {
        errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Exception: ${e.toString()}';
    } finally {
      isLoading(false);
    }
  }

  // Helper getters for clean access to properties
  String get arabicName => nameDetails['name_arabic']?.toString() ?? '';
  String get englishName => nameDetails['name_english'] ?.toString()?? '';
  String get meaning => nameDetails['meaning']?.toString() ?? '';
  String get benefits => nameDetails['benefits']?.toString() ?? '';
  String get sortingNo => nameDetails['sorting_no']?.toString() ?? "0";
}