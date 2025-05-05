import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  static const String _languageKey = 'app_language';
  late SharedPreferences _prefs;
  final _languageController = ValueNotifier<String>(_getInitialLanguage());

  ValueNotifier<String> get languageNotifier => _languageController;
  String get currentLanguage => _languageController.value;

  static String _getInitialLanguage() {
    final deviceLocale = ui.window.locale.languageCode;
    return deviceLocale == 'es' || deviceLocale == 'en' ? deviceLocale : 'en';
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final String? languageCode = _prefs.getString(_languageKey);
    if (languageCode != null) {
      _languageController.value = languageCode;
    } else {
      // Save the initial language to SharedPreferences
      await _prefs.setString(_languageKey, _languageController.value);
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = _languageController.value == 'es' ? 'en' : 'es';
    await _prefs.setString(_languageKey, newLanguage);
    _languageController.value = newLanguage;
  }
}
