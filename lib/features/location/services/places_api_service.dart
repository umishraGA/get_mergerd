import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_suggestion.dart';
import '../models/place_details.dart';

class PlacesApiService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  static const String _apiKey = 'AIzaSyB3WYl5SI0IEo4QvpssbCfNiFz9NlbjhBc'; // TODO: Add your API key here
  
  static const int _defaultRadiusMeters = 50000; // 50km radius
  
  /// Get autocomplete suggestions for a given input
  Future<List<LocationSuggestion>> getAutocompleteSuggestions({
    required String input,
    String? sessionToken,
    double? latitude,
    double? longitude,
    int? radius,
    String? language,
    List<String>? types,
    String? components, // e.g., 'country:in' for India only
  }) async {
    if (input.trim().isEmpty) {
      return [];
    }

    try {
      final queryParams = <String, String>{
        'input': input,
        'key': _apiKey,
      };

      // Add optional parameters
      if (sessionToken != null) {
        queryParams['sessiontoken'] = sessionToken;
      }
      
      if (latitude != null && longitude != null) {
        queryParams['location'] = '$latitude,$longitude';
        queryParams['radius'] = (radius ?? _defaultRadiusMeters).toString();
      }
      
      if (language != null) {
        queryParams['language'] = language;
      }
      
      if (types != null && types.isNotEmpty) {
        queryParams['types'] = types.join('|');
      }
      
      if (components != null) {
        queryParams['components'] = components;
      }

      final uri = Uri.parse('$_baseUrl/place/autocomplete/json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions
              .map((prediction) => LocationSuggestion.fromGooglePlace(prediction))
              .toList();
        } else {
          throw Exception('Places API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get autocomplete suggestions: $e');
    }
  }

  /// Get detailed information about a place using place ID
  Future<PlaceDetails> getPlaceDetails({
    required String placeId,
    String? sessionToken,
    String? language,
    List<String>? fields,
  }) async {
    try {
      final queryParams = <String, String>{
        'place_id': placeId,
        'key': _apiKey,
      };

      // Add optional parameters
      if (sessionToken != null) {
        queryParams['sessiontoken'] = sessionToken;
      }
      
      if (language != null) {
        queryParams['language'] = language;
      }
      
      if (fields != null && fields.isNotEmpty) {
        queryParams['fields'] = fields.join(',');
      } else {
        // Default fields to retrieve
        queryParams['fields'] = [
          'place_id',
          'name',
          'formatted_address',
          'geometry/location',
          'types',
          'vicinity',
          'url',
          'website',
          'formatted_phone_number',
          'rating',
          'user_ratings_total'
        ].join(',');
      }

      final uri = Uri.parse('$_baseUrl/place/details/json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          return PlaceDetails.fromGooglePlace(data['result']);
        } else {
          throw Exception('Places API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get place details: $e');
    }
  }

  /// Get nearby places based on location
  Future<List<PlaceDetails>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = _defaultRadiusMeters,
    String? type,
    String? keyword,
    String? language,
    int? maxResults,
  }) async {
    try {
      final queryParams = <String, String>{
        'location': '$latitude,$longitude',
        'radius': radius.toString(),
        'key': _apiKey,
      };

      // Add optional parameters
      if (type != null) {
        queryParams['type'] = type;
      }
      
      if (keyword != null) {
        queryParams['keyword'] = keyword;
      }
      
      if (language != null) {
        queryParams['language'] = language;
      }

      final uri = Uri.parse('$_baseUrl/place/nearbysearch/json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          var places = results
              .map((result) => PlaceDetails.fromGooglePlace(result))
              .toList();
              
          if (maxResults != null && places.length > maxResults) {
            places = places.take(maxResults).toList();
          }
          
          return places;
        } else {
          throw Exception('Places API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get nearby places: $e');
    }
  }

  /// Reverse geocoding - get place details from coordinates
  Future<List<PlaceDetails>> reverseGeocode({
    required double latitude,
    required double longitude,
    String? language,
    List<String>? resultTypes,
  }) async {
    try {
      final queryParams = <String, String>{
        'latlng': '$latitude,$longitude',
        'key': _apiKey,
      };

      // Add optional parameters
      if (language != null) {
        queryParams['language'] = language;
      }
      
      if (resultTypes != null && resultTypes.isNotEmpty) {
        queryParams['result_type'] = resultTypes.join('|');
      }

      final uri = Uri.parse('$_baseUrl/geocode/json')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          return results
              .map((result) => PlaceDetails.fromGooglePlace(result))
              .toList();
        } else {
          throw Exception('Geocoding API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }
}