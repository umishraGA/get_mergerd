import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';

class MosqueController extends GetxController {
  var isLoading = false.obs;
  var mosqueList = <MosqueModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchMosques({required double lat, required double lon}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
  
      final url = Uri.parse("https://api.gamsgroup.in/user/spiritual/islam/mosque?page_no=1&lat=$lat&lon=$lon");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final data = body['data'] as List;
        mosqueList.value = data.map((e) => MosqueModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        errorMessage.value = 'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
class MosqueModel {
  final String id;
  final String name;
  final String area;
  final String city;
  final String state;
  final String country;
  final String latitude;
  final String longitude;
  final String address;
  final String mosqueId;
  final double distance;
  final String duration;

  MosqueModel({
    required this.id,
    required this.name,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.mosqueId,
    required this.distance,
    required this.duration,
  });

  factory MosqueModel.fromJson(Map<String, dynamic> json) {
    return MosqueModel(
      id: json['_id'].toString(),
      name: json['name'].toString(),
      area: json['area'].toString(),
      city: json['city'].toString(),
      state: json['state'].toString(),
      country: json['country'].toString(),
      latitude: json['coordinates']['latitude'].toString(),
      longitude: json['coordinates']['longitude'].toString(),
      address: json['address'].toString(),
      mosqueId: json['mosque_id'].toString(),
      distance: double.parse(
        json['distance'].toString().replaceAll(RegExp(r'[^\d.]'), ''),
      ),
      duration: json['duration'].toString(),
    );
  }
}
