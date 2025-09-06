import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/dio/auth_helper.dart';

class ChantCountController extends GetxController {
  var isLoading = false.obs;
  var responseMessage = ''.obs;

  final String baseUrl = "https://api.gamsgroup.in";

  Future<void> updateChantCount({required String chantTab}) async {
    isLoading.value = true;

    try {
      final token = await AuthHelper.getAuthToken; // Use method to get saved token
      final url = Uri.parse('$baseUrl/user/spiritual/chantCount');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
      };
      final body = jsonEncode({
        'religion': "hinduism",
        'chant_tab': chantTab,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        responseMessage.value = data['message']?.toString() ?? 'Chant count updated successfully';
        print('Success: $data');
      } else {
        final data = jsonDecode(response.body);
        responseMessage.value = data['message']?.toString() ?? 'Failed to update chant count';
        print('Error ${response.statusCode}: $data');
      }
    } catch (e) {
      responseMessage.value = 'Error: $e';
      print('Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
