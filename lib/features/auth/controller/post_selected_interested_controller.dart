import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddInterestController extends GetxController {
  final String apiUrl = 'https://gamsgroup.in/api/user/basic/add-interest';
  var isSubmitting = false.obs;

  Future<void> submitInterests(List<String> interestIds) async {
    isSubmitting.value = true;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        Get.snackbar("Error", "Token not found");
        isSubmitting.value = false;
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "interest": interestIds,
        }),
      );

      final result = json.decode(response.body);
      if (response.statusCode == 200 && result['success'] == true) {
        Get.snackbar("Success", result['message']?.toString() ?? "Interest added successfully");
      } else {
        Get.snackbar("Error", result['message']?.toString() ?? "Failed to add interest");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
