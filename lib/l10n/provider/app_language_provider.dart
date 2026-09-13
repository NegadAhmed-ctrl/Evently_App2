import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  String applanguage = "en";

  AppLanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      applanguage = savedLanguage;
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String newLanguage) async {
    if (newLanguage == applanguage) {
      return;
    }
    applanguage = newLanguage;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, newLanguage);
  }
}
