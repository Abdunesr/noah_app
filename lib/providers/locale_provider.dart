import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final _prefs;
  static const String _key = 'selected_locale';

  LocaleNotifier(this._prefs) : super(const Locale('en')) {
    final code = _prefs.getString(_key);
    if (code != null) {
      state = Locale(code);
    }
  }

  void setLocale(Locale locale) {
    if (state == locale) return;
    state = locale;
    _prefs.setString(_key, locale.languageCode);
  }
}
