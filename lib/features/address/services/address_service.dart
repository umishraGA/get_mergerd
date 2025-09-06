import '../../../common/constant/endpoints.dart';
import '../../../utils/dio/api_service.dart';
import '../../../utils/dio/auth_helper.dart';
import '../models/saved_address_models.dart';

class AddressService {
  static final AddressService _instance = AddressService._internal();
  factory AddressService() => _instance;
  AddressService._internal();

  final ApiService _apiService = ApiService();

  Future<String?> _getBearerToken() async {
    try {
      final token = await AuthHelper.getAuthToken;
      print("Token of Auth: $token");
      // await SharedPreferences.getInstance();
      // return prefs.getString('auth_token');
      // const token =  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZSI6Ijk2NTEzNDI4ODciLCJfaWQiOiI2ODhkZDM5MGM3NDAxMGQ1MzUwYTNhZDUiLCJpYXQiOjE3NTQxMjUyMDAsImV4cCI6MTc1NjcxNzIwMH0.adE1S2WxS_kqaWExyxuSwjnosmLqx7J68NvGUIvjGZU";
      return "Bearer $token";
    } catch (e) {
      return null;
    }
  }


  // Get saved addresses
  Future<SavedAddressResponse> getSavedAddresses() async {
    final token = await _getBearerToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }

    return _apiService.get<SavedAddressResponse>(
      Endpoints.getAddress,
      headers: {
        'Authorization': token,
      },
      parser: (data) => SavedAddressResponse.fromJson(
        data as Map<String, dynamic>,
      ),
    );
  }

  // Alternative method using getList if you only need the address list
  Future<List<SavedAddress>> getSavedAddressList() async {
    final token = await _getBearerToken();
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found');
    }
    return _apiService.getList<SavedAddress>(
      Endpoints.getAddress,
      itemParser: (item) => SavedAddress.fromJson(item),
    );
  }
}