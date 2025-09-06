// controllers/dua_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class DuaDetailController extends GetxController {
  var duaList = <DuaModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchDuasByCategory(String categoryId) async {
    isLoading.value = true;
    final url = Uri.parse("https://api.gamsgroup.in/user/spiritual/islam/dua/$categoryId?page_no=1");


    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${AuthHelper.getAuthToken}'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<DuaModel> loadedDuas = (jsonData['data'] as List)
            .map((e) => DuaModel.fromJson(e  as Map<String, dynamic>))
            .toList();

        duaList.assignAll(loadedDuas);
      } else {
        Get.snackbar("Error", "Failed to load Duas (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
// models/dua_model.dart

class DuaModel {
  final String id;
  final String sortingNo;
  final String titleArabic;
  final String titleEnglish;
  final String arabicDua;
  final String englishDua;
  final String referenceBook;

  DuaModel({
    required this.id,
    required this.sortingNo,
    required this.titleArabic,
    required this.titleEnglish,
    required this.arabicDua,
    required this.englishDua,
    required this.referenceBook,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['_id']?.toString() ?? '',
      sortingNo: json['sorting_no']?.toString()??"",
      titleArabic: json['dua_title_arabic']?.toString()??"",
      titleEnglish: json['dua_title_english']?.toString()??"",
      arabicDua: json['arabic_dua']?.toString()??"",
      englishDua: json['english_dua']?.toString()??"",
      referenceBook: json['reference_book']?.toString()??"",
    );
  }
}
