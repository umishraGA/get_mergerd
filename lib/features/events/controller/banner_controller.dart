import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/dio/auth_helper.dart';

// -------- MODEL --------
class EventBanner {
  final String id;
  final String eventId;
  final String webBanner;
  final String mobBanner;
  final String address;

  EventBanner({
    required this.id,
    required this.eventId,
    required this.webBanner,
    required this.mobBanner,
    required this.address,
  });

  factory EventBanner.fromJson(Map<String, dynamic> json) {
    return EventBanner(
      id: json["_id"]?.toString() ?? "",
      eventId: json["event"]?.toString() ?? "",
      webBanner: json["webBanner"]?.toString() ?? "",
      mobBanner: json["mobBanner"]?.toString() ?? "",
      address: json["address"]?.toString() ?? "",
    );
  }
}

// -------- CONTROLLER --------
class EventBannerController extends GetxController {
  var isLoading = false.obs;
  var banners = <EventBanner>[].obs;
  var errorMessage = "".obs;

  final String apiUrl = "https://api.gamsgroup.in/user/event/event-banner";

  @override
  void onInit() {
    super.onInit();
    fetchEventBanners();
  }

  Future<void> fetchEventBanners() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

  

      // Prepare request body with latitude & longitude
      final body = jsonEncode({
        "latitude": "26.8466937",
        "longitude": "80.9462",
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody["success"] == true && jsonBody["data"] != null) {
          var dataList = jsonBody["data"] as List;
          banners.value =
              dataList.map((e) => EventBanner.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          errorMessage.value =
              jsonBody["message"]?.toString() ?? "No banners found.";
        }
      } else {
        errorMessage.value =
        "Error: ${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      errorMessage.value = "Failed to load banners: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
