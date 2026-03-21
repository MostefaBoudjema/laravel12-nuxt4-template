import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  ThemeMode _themeMode;
  Locale? _locale;

  SettingsController({ThemeMode defaultThemeMode = ThemeMode.system, Locale? defaultLocale})
      : _themeMode = defaultThemeMode,
        _locale = defaultLocale;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final themeIndex = prefs.getInt('theme_mode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    }
    
    // Load locale
    final localeCode = prefs.getString('language_code');
    if (localeCode != null && localeCode.isNotEmpty) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null || newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', newThemeMode.index);
  }

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == _locale) return;
    _locale = newLocale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    if (newLocale == null) {
      await prefs.remove('language_code');
    } else {
      await prefs.setString('language_code', newLocale.languageCode);
    }
  }
}
