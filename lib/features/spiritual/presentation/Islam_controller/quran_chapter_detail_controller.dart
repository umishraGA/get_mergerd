import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class QuranVerseController extends GetxController {
  RxList<QuranVerseModel> verses = <QuranVerseModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchVersesByChapter(String chapterId) async {
    try {
      isLoading.value = true;

  


      final url = 'https://api.gamsgroup.in/user/spiritual/islam/quran-chapters/$chapterId?page_no=1';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List verseData = jsonData['data'] as List<dynamic>;
        verses.value = verseData.map((e) => QuranVerseModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        Get.snackbar("Error", "Failed to load verses");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}



class QuranVerseModel {
  final String id;
  final int sortingNo;
  final String arabicVerse;
  final String englishVerse;
  final String verseMeaning;
  final String audioUrl;
  final String duration;
  final String chapterId;

  QuranVerseModel({
    required this.id,
    required this.sortingNo,
    required this.arabicVerse,
    required this.englishVerse,
    required this.verseMeaning,
    required this.audioUrl,
    required this.duration,
    required this.chapterId,
  });

  factory QuranVerseModel.fromJson(Map<String, dynamic> json) {
    return QuranVerseModel(
      id: json['_id']?.toString() ?? '',
      sortingNo: int.tryParse(json['sorting_no']?.toString()??"") ?? 0,
      arabicVerse: json['arabic_verse']?.toString() ?? '',
      englishVerse: json['english_verse']?.toString() ?? '',
      verseMeaning: json['verses_meaning']?.toString() ?? '',
      audioUrl: json['audio_url']?.toString() ?? '',
      duration: json['duration'] ?.toString()?? '',
      chapterId: json['chapter_id']?.toString() ?? '',
    );
  }
}
