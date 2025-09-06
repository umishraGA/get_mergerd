import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../../utils/dio/auth_helper.dart'; // Required for ScaffoldMessenger

class IslamController extends GetxController {
  var isLoading = true.obs;
  var fajr = ''.obs;
  var sunrise = ''.obs;
  var zuhur = ''.obs;
  var asr = ''.obs;
  var maghrib = ''.obs;
  var imsak = ''.obs;
  var isha = ''.obs;
  var featuredList = [].obs;

  final String apiUrl = "https://api.gamsgroup.in/user/spiritual/islam";

  // Updated to accept context
  Future<void> fetchIslamData(BuildContext context) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final timing = jsonData['data']['timing'];
        if (timing != null) {
          fajr.value = timing['fajr'].toString();
          sunrise.value = timing['sunrise'].toString();
          zuhur.value = timing['zuhur'].toString();
          asr.value = timing['asr'].toString();
          maghrib.value = timing['maghrib'].toString();
          imsak.value = timing['imsak'].toString();
          isha.value = timing['isha'].toString();
        }

        final featuredRaw = jsonData['data']['featured'];
        if (featuredRaw != null && featuredRaw is List) {
          featuredList.value =
              featuredRaw.map((item) => item as Map<String, dynamic>).toList();
          print("Featured List Loaded: ${featuredList.length} items");
        } else {
          print("Featured list is null or not a list");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
