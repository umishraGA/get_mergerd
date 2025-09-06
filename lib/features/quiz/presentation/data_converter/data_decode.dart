import 'dart:convert';

class ResponseParser {
  static Map<String, dynamic> parseResponseData(dynamic data) {
    if (data == null) return {};

    if (data is String) {
      // Try decoding JSON
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw Exception("Expected JSON object but got ${decoded.runtimeType}");
      }
    } else if (data is Map) {
      // Already a Map
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception("Unexpected response type: ${data.runtimeType}");
    }
  }
}
