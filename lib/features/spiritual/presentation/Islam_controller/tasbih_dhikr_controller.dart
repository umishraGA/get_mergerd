
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../utils/dio/auth_helper.dart';

class TasbihModel {
  final String id;
  final String sortingNo;
  final String dikhrNameArabic;
  final String dikhrNameEnglish;
  final String dikhrMeaning;
  final String audioUrl;

  TasbihModel({
    required this.id,
    required this.sortingNo,
    required this.dikhrNameArabic,
    required this.dikhrNameEnglish,
    required this.dikhrMeaning,
    required this.audioUrl,
  });

  factory TasbihModel.fromJson(Map<String, dynamic> json) {
    return TasbihModel(
      id: json['_id'].toString(),
      sortingNo: json['sorting_no'].toString(),
      dikhrNameArabic: json['dikhr_name_arabic'].toString(),
      dikhrNameEnglish: json['dikhr_name_english'].toString(),
      dikhrMeaning: json['dikhr_meaning'].toString(),
      audioUrl: json['audio_url'].toString(),
    );
  }
}


class TasbihController extends GetxController {
  var isLoading = false.obs;
  var tasbihList = <TasbihModel>[].obs;
  final currentPlayingIndex = (-1).obs;

  Future<void> fetchTasbihList() async {
    try {
      isLoading.value = true;

      var headers = {
        'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
      };

      var response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/spiritual/islam/tasbih?page_no=1'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> data = jsonData['data'] as List<dynamic>;

        tasbihList.value = data.map((e) => TasbihModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load Tasbih list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
