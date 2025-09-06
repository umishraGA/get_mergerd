import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/dio/auth_helper.dart';

class TicketController extends GetxController {
  var isLoading = false.obs;
  var tickets = <dynamic>[].obs;
  var event = {}.obs; // Store event details separately

  Future<void> fetchTickets(String eventId) async {
    try {
      isLoading.value = true;

  


      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
      };

      var body = json.encode({"eventid": eventId});

      print("🔹 Request Headers: $headers");
      print("🔹 Request Body: $body");

      var response = await http.post(
        Uri.parse('https://api.gamsgroup.in/user/event/ticket'),
        headers: headers,
        body: body,
      );

      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data["success"] == true && data["data"] != null) {
          var eventData = data["data"]["event"];
          var ticketList = data["data"]["tickets"];

          event.value = eventData as Map<dynamic, dynamic>;
          tickets.value = ticketList != null ? List<dynamic>.from(ticketList as Iterable<dynamic>) : [];

          print("✅ Event: $eventData");
          print("✅ Tickets count: ${tickets.length}");
        } else {
          print("⚠ No tickets in API response");
          tickets.clear();
        }
      } else {
        print("❌ Request failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
