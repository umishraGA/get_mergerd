import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static late SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _locationPermissionGranted = 'location_permission_granted';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // Save authentication token
  static Future<void> saveAuthToken(String value) async =>
      await _prefs.setString(_tokenKey, value);

  // Save refresh token
  static Future<void> saveRefreshToken(String value) async =>
      await _prefs.setString(_refreshTokenKey, value);

  // Save user id
  static Future<void> saveUserId(String value) async =>
      await _prefs.setString(_userIdKey, value);

  // Save permission status
  static Future<void> savePermissionStatus(bool granted) async =>
      await _prefs.setBool(_locationPermissionGranted, granted);

  // Check if mandatory permissions are granted
  // Get authentication token
  static String? get getAuthToken => _prefs.getString(_tokenKey);
  static String? get getRefreshToken => _prefs.getString(_refreshTokenKey);
  static String? get getUserId => _prefs.getString(_userIdKey);

  // Check user login
  static bool get isAuthenticated => _prefs.containsKey(_tokenKey);

  // Check if mandatory permissions are granted
  static bool get hasRequiredPermissions => _prefs.containsKey(_locationPermissionGranted);

  // Clear all authentication data
  static Future<void> clearAuthData() async {
    _prefs.remove(_tokenKey);
    _prefs.remove(_refreshTokenKey);
    _prefs.remove(_userIdKey);
  }

  // Check if user is authenticated
  // static Future<bool> isAuthenticated() async {
  //   final token = await getAuthToken;
  //   return token != null && token.isNotEmpty;
  // }

  // Save complete auth response
  static Future<void> saveAuthResponse({
    required String token,
    String? refreshToken,
    String? userId,
  }) async {
    await saveAuthToken(token);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    if (userId != null) {
      await saveUserId(userId);
    }
  }


  // Check if user is fully onboarded (authenticated + permissions)
  // static Future<bool> isFullyOnboarded() async {
  //   return isAuthenticated && hasRequiredPermissions;
  // }

  // Check if user is fully onboarded (authenticated + permissions)
  static bool get isFullyOnboarded => isAuthenticated && hasRequiredPermissions;

}

