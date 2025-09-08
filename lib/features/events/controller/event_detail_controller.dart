import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

<<<<<<< HEAD
import '../../../utils/dio/auth_helper.dart';

=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
class EventByIdController extends GetxController {
  var isLoading = false.obs;
  var eventData = Rxn<Map<String, dynamic>>();
  var errorMessage = ''.obs;

  Future<void> fetchEventById(String eventId) async {
    isLoading.value = true;
    errorMessage.value = '';
    eventData.value = null;

    try {
<<<<<<< HEAD
  
=======
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
      final url = Uri.parse('https://api.gamsgroup.in/user/event/EventByid'); // Replace with your actual API URL

      final response = await http.post(
        url,
        headers: {
<<<<<<< HEAD
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
=======
          'Authorization': 'Bearer $token',
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'eventid': eventId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          eventData.value = data['data'] as Map<String, dynamic>;
        } else {
          errorMessage.value = data['message']?.toString() ?? 'Failed to load event data';
        }
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
