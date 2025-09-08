import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/constant/endpoints.dart';

/// Generic model for dropdown-like data
class LocationModel {
  final String id;
  final String name;

  LocationModel({required this.id, required this.name});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'].toString(),
      name: json['name'].toString(),
    );
  }
}

class LocationController extends GetxController {
  var isLoading = false.obs;

  // Lists for each type
  var countries = <LocationModel>[].obs;
  var states = <LocationModel>[].obs;
  var cities = <LocationModel>[].obs;
  var areas = <LocationModel>[].obs;

  var occupations = <LocationModel>[].obs;
  var maritalStatuses = <LocationModel>[].obs;
  var genders = <LocationModel>[].obs;

  // Fetch Country
  Future<void> fetchCountries(BuildContext context) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-country",
      targetList: countries,
    );
  }

  // Fetch State by Country ID
  Future<void> fetchStates(BuildContext context, String countryId) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-state/$countryId",
      targetList: states,
    );
  }

  // Fetch City by State ID
  Future<void> fetchCities(BuildContext context, String stateId) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-city/$stateId",
      targetList: cities,
    );
  }

  // Fetch Area by City ID
  Future<void> fetchAreas(BuildContext context, String cityId) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-area/$cityId",
      targetList: areas,
    );
  }

  // Fetch Occupation
  Future<void> fetchOccupations(BuildContext context) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-occupation",
      targetList: occupations,
    );
  }

  // Fetch Marital Status
  Future<void> fetchMaritalStatus(BuildContext context) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-marital-status",
      targetList: maritalStatuses,
    );
  }

  // Fetch Gender
  Future<void> fetchGenders(BuildContext context) async {
    await _fetchData(
      context: context,
      endpoint: "/user/common/get-gender",
      targetList: genders,
    );
  }

  // Reusable method
  Future<void> _fetchData({
    required BuildContext context,
    required String endpoint,
    required RxList<LocationModel> targetList,
  }) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Token not found. Please login."),
            backgroundColor: Colors.red,
          ),
        );
        isLoading.value = false;
        return;
      }

      final url = Uri.parse('${Endpoints.baseUrl}$endpoint');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> dataList = (jsonData['data'] ?? []) as List<dynamic>;

        if (jsonData['success'] == true) {
          targetList.value = dataList
              .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonData['message']?.toString() ?? "Failed to fetch")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: ${e.toString()}")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
