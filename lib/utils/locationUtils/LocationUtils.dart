
import 'package:shared_preferences/shared_preferences.dart';

class LocationUtils {

  static Future<List<double>> getUserCoordinates() async {
    final prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('user_latitude') ?? 0.0;
    double longitude = prefs.getDouble('user_longitude') ?? 0.0;
    return [latitude, longitude];
  }

  static saveUserCoordinates(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('user_latitude', latitude);
    prefs.setDouble('user_longitude', longitude);
  }

}