import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../settings/SettingsComponents.dart';

class PreferencesProvider extends ChangeNotifier {
  static final PreferencesProvider _instance = PreferencesProvider._internal();
  factory PreferencesProvider() => _instance;
  PreferencesProvider._internal();

  String _currency = 'INR';
  String _weightUnit = 'kg';

  String get currency => _currency;
  String get weightUnit => _weightUnit;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString(SettingsComponents.currencyKey) ?? 'INR';
    _weightUnit = prefs.getString(SettingsComponents.weightUnitKey) ?? 'kg';
    notifyListeners();
  }

  Future<void> updateCurrency(String newCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsComponents.currencyKey, newCurrency);
    _currency = newCurrency;
    notifyListeners();
  }

  Future<void> updateWeightUnit(String newUnit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SettingsComponents.weightUnitKey, newUnit);
    _weightUnit = newUnit;
    notifyListeners();
  }
}
