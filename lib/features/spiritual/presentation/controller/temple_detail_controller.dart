import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/dio/auth_helper.dart';


class TempleDetailController extends GetxController {
  var isLoading = false.obs;
  var templeData = <String, dynamic>{}.obs;
  var errorMessage = ''.obs;

  Future<void> fetchTempleDetails(String templeId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('https://api.gamsgroup.in/user/spiritual/hinduism/temple/$templeId'),
        headers: {
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          templeData.value = Map<String, dynamic>.from(data['data'] as Map<dynamic, dynamic> ?? {});
        } else {
          throw Exception(data['message'] ?? 'Failed to load temple details');
        }
      } else {
        throw Exception('Failed to load temple details: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Helper methods with proper null checks
  String get templeName => templeData['name']?.toString() ?? 'Temple';
  String get templeImage => templeData['image']?.toString() ?? '';
  String get about => templeData['about']?.toString() ?? '';
  String get contactNumber => templeData['contact_number']?.toString() ?? '';

  Map<String, dynamic> get location {
    final loc = templeData['location'];
    return loc is Map ? Map<String, dynamic>.from(loc) : {};
  }

  String get city => (location['city'] is Map ? location['city']['name'] : null)?.toString() ?? '';
  String get state => (location['state'] is Map ? location['state']['name'] : null)?.toString() ?? '';
  String get country => (location['country'] is Map ? location['country']['name'] : null)?.toString() ?? '';

  List<dynamic> get darshanTimings {
    final timings = templeData['timings'];
    return (timings is Map && timings['darshan'] is List)
        ? List<dynamic>.from(timings['darshan'] as Iterable<dynamic>)
        : [];
  }

  List<dynamic> get aartiTimings {
    final timings = templeData['timings'];
    return (timings is Map && timings['aarti'] is List)
        ? List<dynamic>.from(timings['aarti']as Iterable<dynamic>)
        : [];
  }

  Map<String, dynamic> get socialLinks {
    final links = templeData['social_links'];
    return links is Map ? Map<String, dynamic>.from(links) : {};
  }

  List<dynamic> get galleryImages {
    final gallery = templeData['gallery_images'];
    return (gallery is Map && gallery['gallery'] is List)
        ? List<dynamic>.from(gallery['gallery'] as Iterable<dynamic>)
        : [];
  }

  List<dynamic> get bannerImages {
    final gallery = templeData['gallery_images'];
    return (gallery is Map && gallery['banner'] is List)
        ? List<dynamic>.from(gallery['banner'] as Iterable<dynamic>)
        : [];
  }

  List<dynamic> get additionalInfo {
    final info = templeData['additional_info'];
    return info is List ? List<dynamic>.from(info) : [];
  }

  List<dynamic> get donations {
    final donation = templeData['donation'];
    return donation is List ? List<dynamic>.from(donation) : [];
  }

  List<dynamic> get liveDarshan {
    final donation = templeData['live_darshan'];
    return donation is List ? List<dynamic>.from(donation) : [];
  }
}