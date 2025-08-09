import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';


@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  ThemeModeNotifier([this._initialMode]);
  final ThemeMode? _initialMode;

  static const _key = 'themeMode';
  static const _modeMap = {
    'light': ThemeMode.light,
    'dark': ThemeMode.dark,
    'system': ThemeMode.system,
  };
  static String modeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
  static ThemeMode stringToMode(String? str) {
    return _modeMap[str] ?? ThemeMode.system;
  }

  @override
  ThemeMode build() => _initialMode ?? ThemeMode.system;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, modeToString(mode));
  }

  Future<void> nextMode() async {
    ThemeMode next;
    if (state == ThemeMode.light) {
      next = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      next = ThemeMode.system;
    } else {
      next = ThemeMode.light;
    }
    await setThemeMode(next);
  }
}