import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/dio/auth_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllEventsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList events = [].obs;

  Future<void> fetchAllEvents() async {
    try {
      isLoading.value = true;
      const String url = "https://api.gamsgroup.in/user/event/All-events";

      var headers = {
        "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        "Content-Type": "application/json"
      };

      // ✅ Required body parameters
      var body = json.encode({
        "latitude": "26.8466937",
        "longitude": "80.9462"
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print("📌 API Status Code: ${response.statusCode}");
      print("📌 API Response: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData["success"] == true) {
          events.value = jsonData["data"] as List<dynamic>;
        } else {
          events.clear();
        }
      } else {
        throw Exception("Failed to fetch events: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    fetchAllEvents();
    super.onInit();
  }
}
