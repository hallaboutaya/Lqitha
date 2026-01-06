import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const String _localeKey = 'selected_locale';

  LocaleCubit() : super(const LocaleState(Locale('en'))) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);
      if (languageCode != null) {
        emit(LocaleState(Locale(languageCode)));
      }
    } catch (e) {
      print('Error loading saved locale: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      emit(LocaleState(Locale(languageCode)));
    } catch (e) {
      print('Error saving locale: $e');
    }
  }
}
