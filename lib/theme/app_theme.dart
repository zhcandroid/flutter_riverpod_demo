import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme.g.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    // 你可以继续自定义更多属性
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF181818),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
    // 你可以继续自定义更多属性
  );
}

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
      case ThemeMode.system:
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