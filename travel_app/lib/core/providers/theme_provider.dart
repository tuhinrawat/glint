import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference {
  system,
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';
  late SharedPreferences _prefs;
  late ThemePreference _themePreference;
  
  ThemePreference get themePreference => _themePreference;
  ThemeMode get themeMode {
    return switch (_themePreference) {
      ThemePreference.system => ThemeMode.system,
      ThemePreference.light => ThemeMode.light,
      ThemePreference.dark => ThemeMode.dark,
    };
  }

  ThemeProvider() {
    _themePreference = ThemePreference.system;
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    _prefs = await SharedPreferences.getInstance();
    final savedPreference = _prefs.getString(_themePreferenceKey);
    if (savedPreference != null) {
      _themePreference = ThemePreference.values.firstWhere(
        (e) => e.toString() == savedPreference,
        orElse: () => ThemePreference.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemePreference(ThemePreference preference) async {
    _themePreference = preference;
    await _prefs.setString(_themePreferenceKey, preference.toString());
    notifyListeners();
  }
} 