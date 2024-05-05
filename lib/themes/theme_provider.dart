import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:studenthub/themes/dark_mode.dart';
import 'package:studenthub/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  bool _isDarkMode = false;

  static const _themeModeKey = 'theme_mode';

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _isDarkMode;

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeModeKey) ?? false;
    _themeData = _isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkMode : lightMode;
    await _saveThemeMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> _saveThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDarkMode);
  }
}
