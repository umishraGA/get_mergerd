import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../utils/dio/auth_helper.dart';

class ListingService {
  final http.Client _client;
  ListingService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> searchListings({
    required String keyword,
    required String userLat,
    required String userLng,
  }) async {

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
    };

    final uri = Uri.parse('https://api.gamsgroup.in/user/position/get-position');
    final requestBody = json.encode({
      'keyword': keyword,
      'userLat': userLat,
      'userLng': userLng,
    });

    final response = await _client.put(
      uri,
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load listings: ${response.statusCode}');
    }

    final decoded = json.decode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response shape');
    }

    List<dynamic> dataDyn = [];

    if (decoded['statusCode'] is Map<String, dynamic> && decoded['statusCode']['data'] is List) {
      dataDyn = decoded['statusCode']['data'] as List<dynamic>;
    } else if (decoded['data'] is List) {
      dataDyn = decoded['data'] as List<dynamic>;
    }

    final List<Map<String, dynamic>> maps = dataDyn
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();

    return maps;
  }
}
