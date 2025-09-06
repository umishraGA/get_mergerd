import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Always use light mode
  int _colorTheme = 3; // Default to Red theme (index 3)
  static const String _themeModeKey = 'theme_mode';
  static const String _colorThemeKey = 'color_theme';

  ThemeProvider() {
    _loadSavedTheme();
  }

  ThemeMode get themeMode => ThemeMode.light; // Always return light mode
  int get colorTheme => _colorTheme;
  String get currentThemeName => AppThemes.themeNames[_colorTheme];
  Color get currentThemeColor => AppThemes.themeColors[_colorTheme];

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Always set theme mode to light
    _themeMode = ThemeMode.light;
    await prefs.setString(_themeModeKey, _themeMode.toString());

    final savedColorTheme = prefs.getInt(_colorThemeKey);

    if (savedColorTheme != null &&
        savedColorTheme < AppThemes.themeColors.length) {
      _colorTheme = savedColorTheme;
    } else {
      // If no saved theme, default to Red theme
      _colorTheme = 3;
      await prefs.setInt(_colorThemeKey, _colorTheme);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    // Always set to light mode regardless of the requested mode
    if (_themeMode == ThemeMode.light) return;
    _themeMode = ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeMode.toString());
    notifyListeners();
  }

  Future<void> setColorTheme(int index) async {
    if (_colorTheme == index || index >= AppThemes.themeColors.length) return;
    _colorTheme = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorThemeKey, index);
    notifyListeners();
  }
}
