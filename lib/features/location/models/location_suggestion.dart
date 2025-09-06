class LocationSuggestion {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  final List<String> types;
  final double? latitude;
  final double? longitude;

  LocationSuggestion({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    required this.types,
    this.latitude,
    this.longitude,
  });

  factory LocationSuggestion.fromGooglePlace(dynamic prediction) {
    final structuredFormatting = prediction['structured_formatting'] ?? {};
    
    return LocationSuggestion(
      placeId: (prediction['place_id'] ?? '') as String,
      description: (prediction['description'] ?? '') as String,
      mainText: (structuredFormatting['main_text'] ?? '') as String,
      secondaryText: (structuredFormatting['secondary_text'] ?? '') as String,
      types: List<String>.from((prediction['types'] as List<dynamic>?) ?? <dynamic>[]),
    );
  }

  LocationSuggestion copyWith({
    String? placeId,
    String? description,
    String? mainText,
    String? secondaryText,
    List<String>? types,
    double? latitude,
    double? longitude,
  }) {
    return LocationSuggestion(
      placeId: placeId ?? this.placeId,
      description: description ?? this.description,
      mainText: mainText ?? this.mainText,
      secondaryText: secondaryText ?? this.secondaryText,
      types: types ?? this.types,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeId': placeId,
      'description': description,
      'mainText': mainText,
      'secondaryText': secondaryText,
      'types': types,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    return LocationSuggestion(
      placeId: (json['placeId'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      mainText: (json['mainText'] ?? '') as String,
      secondaryText: (json['secondaryText'] ?? '') as String,
      types: List<String>.from((json['types'] as List<dynamic>?) ?? <dynamic>[]),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  @override
  String toString() {
    return 'LocationSuggestion(placeId: $placeId, description: $description, mainText: $mainText, secondaryText: $secondaryText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationSuggestion &&
        other.placeId == placeId &&
        other.description == description;
  }

  @override
  int get hashCode {
    return placeId.hashCode ^ description.hashCode;
  }
}