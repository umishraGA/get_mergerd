class SavedAddressResponse {
  final int statusCode;
  final List<SavedAddress> data;
  final String message;
  final bool success;

  SavedAddressResponse({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory SavedAddressResponse.fromJson(Map<String, dynamic> json) {
    return SavedAddressResponse(
      statusCode: json['statusCode'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => SavedAddress.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      success: json['success'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((address) => address.toJson()).toList(),
      'message': message,
      'success': success,
    };
  }
}

class SavedAddress {
  final String type;
  final String deliveryTime;
  final String firstName;
  final String country;
  final String addressLine1;
  final String latitude;
  final String longitude;
  final int mobile;
  final String flat;
  final String landmark;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;
  final String id;

  SavedAddress({
    required this.type,
    required this.deliveryTime,
    required this.firstName,
    required this.country,
    required this.addressLine1,
    required this.latitude,
    required this.longitude,
    required this.mobile,
    required this.flat,
    required this.landmark,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.isDefault,
    required this.id,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) {
    return SavedAddress(
      type: json['type'] as String,
      deliveryTime: json['deliveryTime'] as String,
      firstName: json['firstName'] as String,
      country: json['country'] as String,
      addressLine1: json['addressLine1'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      mobile: json['mobile'] as int,
      flat: json['flat'] as String,
      landmark: json['landmark'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      isDefault: json['isDefault'] as bool,
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'deliveryTime': deliveryTime,
      'firstName': firstName,
      'country': country,
      'addressLine1': addressLine1,
      'latitude': latitude,
      'longitude': longitude,
      'mobile': mobile,
      'flat': flat,
      'landmark': landmark,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault,
      '_id': id,
    };
  }

  // Helper method to get formatted address
  String get formattedAddress {
    List<String> addressParts = [];
    
    if (flat.isNotEmpty) addressParts.add(flat);
    if (addressLine1.isNotEmpty) addressParts.add(addressLine1);
    if (landmark.isNotEmpty) addressParts.add(landmark);
    if (city.isNotEmpty) addressParts.add(city);
    if (state.isNotEmpty) addressParts.add(state);
    if (zipCode.isNotEmpty) addressParts.add(zipCode);
    
    return addressParts.join(', ');
  }

  // Helper method to get display title
  String get displayTitle {
    if (firstName.isNotEmpty) {
      return '$firstName - ${type.toUpperCase()}';
    }
    return type.toUpperCase();
  }
}