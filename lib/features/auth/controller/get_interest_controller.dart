import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/constant/base_url.dart';
import '../screens/interest_selection_screen.dart'; // Import Interest model

class GetInterestController extends GetxController {
  var interestList = <Interest>[].obs;
  var isLoading = false.obs;

  final String apiUrl = '$baseUrl/user/basic/interest-count';

  @override
  void onInit() {
    super.onInit();
    fetchInterests();
  }

  void fetchInterests() async {
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] as List;

        interestList.value = data.map((item) {
          final id = item['_id'] as Map<String, dynamic>;
          return Interest(
              id: id['_id']?.toString() ?? '',
            name: id['name']?.toString() ?? '',
            imageUrl: id['image']?.toString() ?? '',
            followerCount: "${item['count']?.toString() ?? '0'} Followers",
          );
        }).toList();
      } else {
        Get.snackbar("Error", "Failed to load interests");
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
