import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddressController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var addresses = <AddressModel>[].obs;
  var errorMessage = ''.obs;
  var defaultAddress = Rxn<AddressModel>();

  // API Configuration
  static const String baseUrl = 'https://api.gamsgroup.in'; // Replace with actual VPS URL
  static const String getAddressEndpoint = '/user/basic/get-address';

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  /// Fetch all addresses from API
  Future<void> fetchAddresses() async {
    try {
      isLoading(true);
      errorMessage('');



      final response = await http.get(
        Uri.parse('$baseUrl$getAddressEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AuthHelper.getAuthToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['statusCode'] == 200) {
          final List<dynamic> addressData = jsonData['data']  as List<dynamic>?? [];

          // Convert to AddressModel objects
          addresses.value = addressData
              .map((address) => AddressModel.fromJson(address as Map<String, dynamic>))
              .toList();

          // Find and set default address
          final defaultAddr = addresses.firstWhereOrNull(
                (address) => address.isDefault,
          );
          defaultAddress.value = defaultAddr;

          Get.snackbar(
            'Success',
            'Addresses loaded successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to fetch addresses');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized access. Please login again.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar(
        'Error',
        'Failed to load addresses: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading(false);
    }
  }


  /// Refresh addresses (pull to refresh)
  Future<void> refreshAddresses() async {
    await fetchAddresses();
  }

  /// Set default address
  void setDefaultAddress(String addressId) {
    try {
      // Update local state
      for (var address in addresses) {
        address.isDefault = (address.id == addressId);
      }

      defaultAddress.value = addresses.firstWhereOrNull(
            (address) => address.id == addressId,
      );

      addresses.refresh(); // Trigger UI update

      // TODO: Make API call to update default address on server
      // _updateDefaultAddressOnServer(addressId);

    } catch (e) {
      Get.snackbar('Error', 'Failed to set default address');
    }
  }

  /// Get address by ID
  AddressModel? getAddressById(String id) {
    return addresses.firstWhereOrNull((address) => address.id == id);
  }

  /// Get addresses by type
  List<AddressModel> getAddressesByType(String type) {
    return addresses.where((address) => address.types == type).toList();
  }

  /// Check if user has any addresses
  bool get hasAddresses => addresses.isNotEmpty;

  /// Get total address count
  int get addressCount => addresses.length;

  /// Clear all data (for logout)
  void clearData() {
    addresses.clear();
    defaultAddress.value = null;
    errorMessage('');
  }

  /// Validate if address data is complete
  bool isAddressValid(AddressModel address) {
    return address.firstName.isNotEmpty &&
        address.addressLine1.isNotEmpty &&
        address.city.isNotEmpty &&
        address.state.isNotEmpty &&
        address.zipCode.isNotEmpty &&
        address.mobile.isNotEmpty;
  }

  /// Format address for display
  String formatAddressForDisplay(AddressModel address) {
    final parts = <String>[];

    if (address.flat.isNotEmpty) parts.add(address.flat);
    parts.add(address.addressLine1);
    if (address.landmark.isNotEmpty) parts.add('Near ${address.landmark}');
    parts.add('${address.city}, ${address.state}');
    parts.add(address.zipCode);

    return parts.join(', ');
  }
}

/// Address Model Class
class AddressModel {
  final String id;
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
  bool isDefault;

  AddressModel({
    required this.id,
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
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id']?.toString() ?? '',
      types: json['types']?.toString() ?? '',
      deliveryTime: json['deliveryTime']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      addressLine1: json['addressLine1']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      flat: json['flat']?.toString() ?? '',
      landmark: json['landmark']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      zipCode: json['zipCode']?.toString() ?? '',
      isDefault: json['isDefault'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id':id,
      'types': types,
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
    };
  }

  @override
  String toString() {
    return 'AddressModel(id: $id, firstName: $firstName, city: $city, isDefault: $isDefault)';
  }
}