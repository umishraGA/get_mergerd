import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/utils/dio/auth_helper.dart';

class VendorImagesController extends GetxController {
  var isLoading = false.obs;
  var businessImages = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;

  final String baseUrl = 'https://api.gamsgroup.in'; // Replace with your VPS base URL

  // Fetch vendor images by ID
  Future<void> fetchVendorImages(String vendorId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      var token = await AuthHelper.getAuthToken;
      final url = Uri.parse('$baseUrl/user/vendor/get-vendor-images/$vendorId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['statusCode'] == 200) {
          // Extract business images from response
          if (data['data'] is List) {
            final list = data['data'] as List;
            if (list.isNotEmpty) {
              final vendorData = list[0];
              if (vendorData['businessImages'] is List) {
                businessImages.value =
                List<Map<String, dynamic>>.from(vendorData['businessImages'] as Iterable<dynamic>);
              }
            }
          }
        } else {
          errorMessage.value = data['message']?.toString() ?? 'Something went wrong';
        }
      } else {
        errorMessage.value =
        'Server Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Clear images data
  void clearImages() {
    businessImages.clear();
  }
}