import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
<<<<<<< HEAD
  static late SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';
  static const String _isProfileCompleted = 'profile_complete';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _numberKey = 'number';
  static const String _locationPermissionGranted = 'location_permission_granted';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }


  // Save authentication token
  static Future<void> saveAuthToken(String value) async =>
      await _prefs.setString(_tokenKey, value);

  // Save authentication number
  static Future<void> saveNumber(String value) async =>
      await _prefs.setString(_numberKey, value);

  // Save authentication profile status
  static Future<void> saveProfileCompleted(bool value) async =>
      await _prefs.setBool(_isProfileCompleted, value);

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
  static String? get getUserNumber => _prefs.getString(_numberKey);
  static bool get getProfileCompleted => _prefs.getBool(_isProfileCompleted) ?? false;

  // Check user login
  static bool get isAuthenticated => _prefs.containsKey(_tokenKey);

  static bool get isFullyCompleted => _prefs.containsKey(_isProfileCompleted);

  // Check if mandatory permissions are granted
  static bool get hasRequiredPermissions => _prefs.containsKey(_locationPermissionGranted);

  // Clear all authentication data
  static Future<void> clearAuthData() async {
    _prefs.remove(_tokenKey);
    _prefs.remove(_refreshTokenKey);
    _prefs.remove(_userIdKey);
    _prefs.remove(_isProfileCompleted);
    _prefs.remove(_numberKey);
=======
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // Save authentication token
  static Future<void> saveAuthToken(String token) async {
    print("Saving token: $token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get authentication token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Save refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  // Get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Clear all authentication data
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
  }

  // Save complete auth response
  static Future<void> saveAuthResponse({
    required String token,
<<<<<<< HEAD
    required bool isProfileCompleted,
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    String? refreshToken,
    String? userId,
  }) async {
    await saveAuthToken(token);
<<<<<<< HEAD
    await saveProfileCompleted(isProfileCompleted);
=======
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    if (userId != null) {
      await saveUserId(userId);
    }
  }

<<<<<<< HEAD

  // Check if user is fully onboarded (authenticated + permissions)
  // static Future<bool> isFullyOnboarded() async {
  //   return isAuthenticated && hasRequiredPermissions;
  // }

  // Check if user is fully onboarded (authenticated + permissions)
  static bool get isFullyOnboarded => isAuthenticated && hasRequiredPermissions;

}

=======
  // Check if mandatory permissions are granted
  static Future<bool> hasRequiredPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('location_permission_granted') ?? false;
  }

  // Save permission status
  static Future<void> savePermissionStatus(bool granted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_granted', granted);
  }

  // Check if user is fully onboarded (authenticated + permissions)
  static Future<bool> isFullyOnboarded() async {
    final isAuth = await isAuthenticated();
    final hasPerms = await hasRequiredPermissions();
    return isAuth && hasPerms;
  }
}
>>>>>>> a12b8cdc96c71b22503145f01065de5b4cacf34b
