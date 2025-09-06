import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/common/constant/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/dio/auth_helper.dart';

class AddInterestController extends GetxController {
  var isSubmitting = false.obs;

  Future<void> submitInterests(List<String> interestIds) async {
    isSubmitting.value = true;

    try {
      var bodyReq = json.encode({
        "interest": interestIds,
      });
      print("url ========= >>>>>>> ${Endpoints.addIntrest}");
      print("bodyReq =========== >>>>>>>> $bodyReq");
      final response = await http.post(
        Uri.parse(Endpoints.addIntrest),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
        body: bodyReq,
      );
      print("result ========>>>>>>>> ${jsonDecode(response.body)}");
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
