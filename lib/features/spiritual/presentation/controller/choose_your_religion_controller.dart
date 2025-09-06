
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class SpiritualController extends GetxController {
  var religionList = <dynamic>[].obs;
  var isLoading = false.obs;

  final String apiUrl = "https://api.gamsgroup.in/user/spiritual";

  @override
  void onInit() {
    fetchSpiritualData();
    super.onInit();
  }

  Future<void> fetchSpiritualData() async {
    isLoading.value = true;

    try {


      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded['success'] == true) {
          final religions = decoded['data']['religions'];
          if (religions is List) {
            religionList.value = religions;
          } else {
            print("❌ religions is not a List");
          }
        } else {
          print("❌ API response success=false");
        }
      } else {
        print("❌ Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
