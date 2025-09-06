class ListingItemModel {
  final String id;
  final String companyName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final String? phoneNo;
  final String? logoUrl;
  final List<BusinessHourModel> businessHours;
  final List<String> keywords;
  final String type; // free, paid, fixed
  final String vendorId; // 👈 Added vendor ID field

  ListingItemModel({
    required this.id,
    required this.companyName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.phoneNo,
    required this.logoUrl,
    required this.businessHours,
    required this.keywords,
    required this.type,
    required this.vendorId, // 👈 Added vendor ID parameter
  });

  factory ListingItemModel.fromJson(Map<String, dynamic> json) {
    // Support both free and paid/fixed shapes
    final Map<String, dynamic> basicDetails = _asMap(json['basicDetails']);
    // Some payloads use 'vender' instead of 'vendor'
    final Map<String, dynamic> vendor =
    _asMap(basicDetails['vendor']).isNotEmpty
        ? _asMap(basicDetails['vendor'])
        : _asMap(basicDetails['vender']);

    final Map<String, dynamic> companyInfo =
    _asMap(json['companyInfo']).isNotEmpty
        ? _asMap(json['companyInfo'])
        : _asMap(vendor['companyInfo']);
    final Map<String, dynamic> locationInfo =
    _asMap(json['locationInfo']).isNotEmpty
        ? _asMap(json['locationInfo'])
        : _asMap(vendor['locationInfo']);
    final Map<String, dynamic> contactInfo =
    _asMap(json['contactInfo']).isNotEmpty
        ? _asMap(json['contactInfo'])
        : _asMap(vendor['contactInfo']);
    final Map<String, dynamic> logo =
    _asMap(json['coverImage']).isNotEmpty
        ? _asMap(json['coverImage'])
        : _asMap(vendor['coverImage']);

    final List<dynamic> hours = _asList(json['businessHours']).isNotEmpty
        ? _asList(json['businessHours'])
        : _asList(vendor['businessHours']);

    final List<dynamic> kws = _asList(json['keywords']).isNotEmpty
        ? _asList(json['keywords'])
        : _asList(vendor['keywords']);

    // Extract vendor ID
    final String? vendorId = vendor['_id']?.toString();

    return ListingItemModel(
      id: (json['_id'] ?? '').toString(),
      companyName: (companyInfo['companyName'] ?? '').toString(),
      address: (locationInfo['address'] ?? '').toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distanceKm: (json['distance'] as num?)?.toDouble(),
      phoneNo: (contactInfo['phoneNo'] ?? '').toString(),
      logoUrl: (logo['url'] ?? '').toString(),
      businessHours:
      hours.whereType<Map>().map((e) => BusinessHourModel.fromJson(e.cast<String, dynamic>())).toList(),
      keywords: kws.map((e) => e.toString()).toList(),
      type: (json['type'] ?? '').toString().toLowerCase(),
      vendorId: vendorId.toString(), // 👈 Added vendor ID
    );
  }

  static Map<String, dynamic> _asMap(Object? value) {
    if (value is Map) {
      try {
        return value.cast<String, dynamic>();
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  static List<dynamic> _asList(Object? value) {
    if (value is List) return value;
    return const [];
  }
}

class BusinessHourModel {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClosed;
  final bool isOpen24Hours;

  BusinessHourModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
    required this.isOpen24Hours,
  });

  factory BusinessHourModel.fromJson(Map<String, dynamic> json) {
    return BusinessHourModel(
      day: (json['day'] ?? '').toString(),
      openTime: (json['openTime'] ?? '').toString(),
      closeTime: (json['closeTime'] ?? '').toString(),
      isClosed: (json['isClosed'] as bool?) ?? false,
      isOpen24Hours: (json['isOpen24Hours'] as bool?) ?? false,
    );
  }
}