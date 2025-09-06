class Address {
  final String types;
  final String deliveryTime;
  final String firstName;
  final String country;
  final String addressLine1;
  final String latitude;
  final String longitude;
  final String mobile;
  final String flat;
  final String landmark;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;
  final String id;

  Address({
    required this.types,
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      types: json['types'].toString() ?? '',
      deliveryTime: json['deliveryTime'].toString() ?? '',
      firstName: json['firstName'].toString() ?? '',
      country: json['country'].toString() ?? '',
      addressLine1: json['addressLine1'].toString() ?? '',
      latitude: json['latitude'].toString() ?? '',
      longitude: json['longitude'].toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      flat: json['flat'].toString() ?? '',
      landmark: json['landmark'].toString() ?? '',
      city: json['city'].toString() ?? '',
      state: json['state'].toString() ?? '',
      zipCode: json['zipCode'].toString() ?? '',
      isDefault: json['isDefault'] as bool,
      id: json['_id'] .toString()?? '',
    );
  }
}
