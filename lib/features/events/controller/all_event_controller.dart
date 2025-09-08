import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

<<<<<<< HEAD
import '../../../utils/dio/auth_helper.dart';

=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
class AllEventsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList events = [].obs;

  Future<void> fetchAllEvents() async {
    try {
      isLoading.value = true;

<<<<<<< HEAD
  

=======
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      print("📌 Saved Token: $token");

      if (token == null) {
        throw Exception("Token not found in SharedPreferences");
      }
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b

      const String url = "https://api.gamsgroup.in/user/event/All-events";

      var headers = {
<<<<<<< HEAD
        "Authorization": "Bearer ${AuthHelper.getAuthToken}",
=======
        "Authorization": "Bearer $token",
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
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
