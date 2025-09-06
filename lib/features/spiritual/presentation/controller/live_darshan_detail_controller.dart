import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class DetailLiveDarshanController extends GetxController {
  var isLoading = true.obs;
  var data = {}.obs;
  var relatedDarshans = [].obs;



  Future<void> fetchLiveDarshan(String darshanId) async {
    try {
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        Get.snackbar("Error", "No token found");
        return;
      }

      final url = Uri.parse('https://api.gamsgroup.in/user/spiritual/hinduism/livedarshan/$darshanId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        data.value = jsonResponse['data'] as Map<dynamic, dynamic>;
        relatedDarshans.value = jsonResponse['data']['related_live_darshan']as List<dynamic>;
      } else {
        Get.snackbar("Error", "Failed to load data (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
