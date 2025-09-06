// SOLUTION 1: Rename one of the controllers
// File: common_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/utils/dio/auth_helper.dart';

// File: test.dart (or your view file)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common_controller.dart'; // Import the renamed controller

class CommonDropdownController extends GetxController { // Renamed from DropdownController
  final String baseUrl = "https://api.gamsgroup.in";

  // Dropdown data
  var interests = <dynamic>[].obs;
  var occupations = <dynamic>[].obs;
  var genders = <dynamic>[].obs;
  var maritalStatuses = <dynamic>[].obs;

  // Selected IDs
  var selectedInterestId = "".obs;
  var selectedOccupationId = "".obs;
  var selectedGenderId = "".obs;
  var selectedMaritalStatusId = "".obs;

  // Loading states
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  // Generic GET call
  Future<List<dynamic>> _fetchData(String endpoint) async {

    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Authorization": "Bearer ${AuthHelper.getAuthToken}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] as List<dynamic>;
    } else {
      throw Exception("Failed to fetch $endpoint: ${response.statusCode}");
    }
  }

  // Fetch all dropdown data
  Future<void> fetchDropdowns() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = "";

      interests.value = await _fetchData("/user/common/get-interest");
      occupations.value = await _fetchData("/user/common/get-occupation");
      genders.value = await _fetchData("/user/common/get-gender");
      maritalStatuses.value = await _fetchData("/user/common/get-marital-status");

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print("Error fetching dropdowns: $e");

      Get.snackbar(
        "Error",
        "Failed to fetch dropdown data: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchDropdowns();
  }
}

class DropdownViewScreen extends StatelessWidget {
  // Use unique tag to avoid conflicts
  final CommonDropdownController controller = Get.put(
    CommonDropdownController(),
    // tag: 'dropdown_view'
  );

  DropdownViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile Dropdowns")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${controller.errorMessage.value}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchDropdowns(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildDropdown(
                label: "Select Interest",
                items: controller.interests,
                value: controller.selectedInterestId.value,
                onChanged: (val) => controller.selectedInterestId.value = val ?? "",
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: "Select Occupation",
                items: controller.occupations,
                value: controller.selectedOccupationId.value,
                onChanged: (val) => controller.selectedOccupationId.value = val ?? "",
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: "Select Gender",
                items: controller.genders,
                value: controller.selectedGenderId.value,
                onChanged: (val) => controller.selectedGenderId.value = val ?? "",
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: "Select Marital Status",
                items: controller.maritalStatuses,
                value: controller.selectedMaritalStatusId.value,
                onChanged: (val) => controller.selectedMaritalStatusId.value = val ?? "",
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  print("Interest ID: ${controller.selectedInterestId.value}");
                  print("Occupation ID: ${controller.selectedOccupationId.value}");
                  print("Gender ID: ${controller.selectedGenderId.value}");
                  print("Marital Status ID: ${controller.selectedMaritalStatusId.value}");

                  Get.snackbar(
                    "Selected Values",
                    "Interest: ${controller.selectedInterestId.value}\n"
                        "Occupation: ${controller.selectedOccupationId.value}\n"
                        "Gender: ${controller.selectedGenderId.value}\n"
                        "Marital: ${controller.selectedMaritalStatusId.value}",
                    duration: const Duration(seconds: 3),
                  );
                },
                child: const Text("Update"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<dynamic> items,
    required String value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item["_id"].toString(),
          child: Text(item["name"].toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

