import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';

  ThemeMode appTheme = ThemeMode.light;

  bool get isDark => appTheme == ThemeMode.dark;

  AppThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      appTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  Future<void> changeTheme(ThemeMode newTheme) async {
    if (appTheme == newTheme) {
      return;
    }
    appTheme = newTheme;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      newTheme == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
