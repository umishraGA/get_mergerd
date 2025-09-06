import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class QuranChapterController extends GetxController {
  RxList<QuranChapterModel> chapterList = <QuranChapterModel>[].obs;
  RxBool isLoading = false.obs;

  final String baseUrl = 'https://api.gamsgroup.in/user/spiritual/islam/quran-chapters?page_no=1';

  @override
  void onInit() {
    fetchQuranChapters();
    super.onInit();
  }

  Future<void> fetchQuranChapters() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List data = decoded['data'] as List<dynamic>;
        chapterList.value = data.map((item) => QuranChapterModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        Get.snackbar("Error", "Failed to load data");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}


class QuranChapterModel {
  final String id;
  final int sortingNo;
  final String englishName;
  final String arabicName;
  final List<String> versesList;
  final int totalVerses;
  final String meaning;

  QuranChapterModel({
    required this.id,
    required this.sortingNo,
    required this.englishName,
    required this.arabicName,
    required this.versesList,
    required this.totalVerses,
    required this.meaning,
  });

  factory QuranChapterModel.fromJson(Map<String, dynamic> json) {
    return QuranChapterModel(
      id: json['_id']?.toString() ?? '',
      sortingNo: int.tryParse(json['sorting_no']?.toString()??"") ?? 0,
      englishName: json['english_chapter_name'] ?.toString()?? '',
      arabicName: json['arabic_chapter_name']?.toString() ?? '',
      versesList: List<String>.from(json['verses_list'] as Iterable<dynamic>),
      totalVerses: int.tryParse(json['total_verses']?.toString()??"") ?? 0,
      meaning: json['chapter_name_meaning']?.toString() ?? '',
    );
  }
}
