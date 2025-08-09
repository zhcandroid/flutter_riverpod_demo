import 'package:flutter/material.dart';

class AppTheme {
  // 亮色主题 - 更柔和的现代风格
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // 启用Material 3设计
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0066CC),    // 主色：更深的科技蓝
      secondary: Color(0xFF5CC3FF),   // 强调色：清新的亮蓝
      surface: Colors.white,          // 表面色
      background: Color(0xFFF8FAFD),  // 背景：极浅灰蓝
      onPrimary: Colors.white,        // 主色上的文字
      onBackground: Color(0xFF1E1E1E),// 背景上的文字
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFD),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1E1E1E),
      elevation: 1,
      surfaceTintColor: Colors.white,
      shadowColor: Color(0x22000000),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1E1E1E), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFF454545), fontSize: 14),
      titleLarge: TextStyle(
          color: Color(0xFF1A1A1A),
          fontWeight: FontWeight.w600,
          fontSize: 20
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF0066CC),
      unselectedItemColor: Color(0xFF8E8E93),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 6,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1.5,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
    ),
    dividerTheme: const DividerThemeData(
        color: Color(0xFFEEEEEE),
        thickness: 1,
        space: 0
    ),
  );

  // 暗色主题 - 深灰蓝降低视觉疲劳
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF5CC3FF),      // 主色：柔和的亮蓝
      secondary: Color(0xFF8ADAFF),    // 强调色：更亮的蓝
      surface: Color(0xFF1E2A38),      // 表面色：深蓝灰
      background: Color(0xFF121A24),   // 背景：深蓝黑
      onPrimary: Color(0xFF121212),    // 主色上的文字
      onBackground: Color(0xFFEDEDED), // 背景上的文字
    ),
    scaffoldBackgroundColor: const Color(0xFF121A24),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E2A38),
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Color(0xFF1E2A38),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFEDEDED), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
      titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1A2230),
      selectedItemColor: Color(0xFF5CC3FF),
      unselectedItemColor: Color(0xFF8A8D94),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 8,
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF1E2A38),
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
    ),
    dividerTheme: const DividerThemeData(
        color: Color(0xFF2D3A48),
        thickness: 1,
        space: 0
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF5CC3FF),
        foregroundColor: Colors.black87
    ),
  );
}