import 'CategoryCouponsModels.dart';

class SearchRequest {
  final String search;
  final String latitude;
  final String longitude;

  SearchRequest({
    required this.search,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'search': search,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

// Reusing CategoryCouponsResponse since the API returns the same structure
typedef SearchResponse = CategoryCouponsResponse;