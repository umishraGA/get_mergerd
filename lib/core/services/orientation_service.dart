import 'package:flutter/services.dart';

/// Service to handle device orientation changes throughout the app
class OrientationService {
  /// Singleton instance
  static final OrientationService _instance = OrientationService._internal();

  /// Factory constructor to return the singleton instance
  factory OrientationService() => _instance;

  /// Internal private constructor for singleton
  OrientationService._internal();

  /// Set orientation to portrait mode only
  Future<void> setPortraitMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Set orientation to allow both portrait and landscape
  Future<void> setAllOrientations() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Set orientation to landscape mode only
  Future<void> setLandscapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
