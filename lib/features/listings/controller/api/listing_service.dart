import 'dart:convert';
import 'package:http/http.dart' as http;

class ListingService {
  final http.Client _client;
  ListingService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> searchListings({
    required String keyword,
    required String userLat,
    required String userLng,
    required String authToken,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': authToken,
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

    final dynamic statusContainer = decoded['statusCode'];
    List<dynamic> dataDyn = const [];
    if (statusContainer is Map<String, dynamic>) {
      dataDyn = (statusContainer['data'] as List?) ?? const [];
    } else {
      // Fallback if API returns data at root
      dataDyn = (decoded['data'] as List?) ?? const [];
    }

    // Keep only map entries to avoid type errors
    final List<Map<String, dynamic>> maps = dataDyn
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList();
    return maps;
  }
}


