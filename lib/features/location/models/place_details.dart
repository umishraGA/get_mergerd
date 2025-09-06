class PlaceDetails {
  final String placeId;
  final String name;
  final String formattedAddress;
  final double latitude;
  final double longitude;
  final List<String> types;
  final String? vicinity;
  final String? url;
  final String? website;
  final String? phoneNumber;
  final double? rating;
  final int? userRatingsTotal;

  PlaceDetails({
    required this.placeId,
    required this.name,
    required this.formattedAddress,
    required this.latitude,
    required this.longitude,
    required this.types,
    this.vicinity,
    this.url,
    this.website,
    this.phoneNumber,
    this.rating,
    this.userRatingsTotal,
  });

  factory PlaceDetails.fromGooglePlace(dynamic place) {
    final geometry = place['geometry'] ?? {};
    final location = geometry['location'] ?? {};
    
    return PlaceDetails(
      placeId: (place['place_id'] ?? '') as String,
      name: (place['name'] ?? '') as String,
      formattedAddress: (place['formatted_address'] ?? '') as String,
      latitude: ((location['lat'] ?? 0.0) as num).toDouble(),
      longitude: ((location['lng'] ?? 0.0) as num).toDouble(),
      types: List<String>.from((place['types'] as List<dynamic>?) ?? <dynamic>[]),
      vicinity: place['vicinity'] as String?,
      url: place['url'] as String?,
      website: place['website'] as String?,
      phoneNumber: place['formatted_phone_number'] as String?,
      rating: place['rating'] != null ? (place['rating'] as num).toDouble() : null,
      userRatingsTotal: place['user_ratings_total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'name': name,
      'formattedAddress': formattedAddress,
      'latitude': latitude,
      'longitude': longitude,
      'types': types,
      'vicinity': vicinity,
      'url': url,
      'website': website,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
    };
  }

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      placeId: (json['placeId'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      formattedAddress: (json['formattedAddress'] ?? '') as String,
      latitude: ((json['latitude'] ?? 0.0) as num).toDouble(),
      longitude: ((json['longitude'] ?? 0.0) as num).toDouble(),
      types: List<String>.from((json['types'] as List<dynamic>?) ?? <dynamic>[]),
      vicinity: json['vicinity'] as String?,
      url: json['url'] as String?,
      website: json['website'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      userRatingsTotal: json['userRatingsTotal'] as int?,
    );
  }

  @override
  String toString() {
    return 'PlaceDetails(placeId: $placeId, name: $name, formattedAddress: $formattedAddress, lat: $latitude, lng: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaceDetails &&
        other.placeId == placeId;
  }

  @override
  int get hashCode {
    return placeId.hashCode;
  }
}