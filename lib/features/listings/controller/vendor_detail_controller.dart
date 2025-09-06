import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/utils/dio/auth_helper.dart';

class VendorDetailController extends GetxController {
  var isLoading = false.obs;
  var vendorData = {}.obs; // Store the response as a Map
  var errorMessage = ''.obs;

  final String baseUrl = 'https://api.gamsgroup.in'; // Replace with your VPS base URL

  // Fetch vendor details by ID
  Future<void> fetchVendorDetails(String vendorId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      var token = await AuthHelper.getAuthToken;
      final url = Uri.parse('$baseUrl/user/vendor/get-vendor-detail/$vendorId');

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
          vendorData.value = data['data'] as Map<dynamic, dynamic>;
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

  // Helper methods to access nested fields easily
  String get companyName => vendorData['companyInfo']?['companyName']?.toString() ?? '';
  String get phone => vendorData['contactInfo']?['phoneNo']?.toString() ?? '';
  String get address => vendorData['locationInfo']?['address']?.toString() ?? '';
  double get latitude =>
      double.tryParse(vendorData['googleLocation']?['latitude']?.toString() ?? '')??0;
  double get longitude =>
      double.tryParse(vendorData['googleLocation']?['longitude']?.toString() ?? '') ?? 0;
  List<dynamic> get businessHours => vendorData['businessHours'] as List<dynamic>?? [];
}
