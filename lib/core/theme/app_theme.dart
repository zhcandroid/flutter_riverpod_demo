import 'package:flutter/material.dart';

class AppTheme {
  // 亮色主题 - 更柔和的现代风格
  static ThemeData lightTheme = ThemeData(
    // 启用Material 3设计
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      // 主色：更深的科技蓝
      primary: Color(0xFF0066CC),
      //辅助品牌色，次重要元素	浮动按钮、开关滑块
      secondary: Color(0xFF5CC3FF),
      // "表面"元素的背景色（卡片、对话框等）	Card, Dialog, BottomSheet
      surface: Colors.white,
      // 显示在 primary 颜色上的内容色（文字/图标）	主色按钮上的文字
      onPrimary: Colors.white,
      //显示在 surface 颜色上的内容色	卡片内文字
      onSurface: Color(0xFF1E1E1E),

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
        fontSize: 20,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFEEEEEE),
      thickness: 1,
      space: 0,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF0066CC), // 自定义背景色
      contentTextStyle: TextStyle(color: Colors.white), // 文字颜色
    ),
  );

  // 暗色主题 - 深灰蓝降低视觉疲劳
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF5CC3FF),
      secondary: Color(0xFF8ADAFF),
      surface: Color(0xFF1E2A38),
      onPrimary: Color(0xFF121212),
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
        fontSize: 20,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2D3A48),
      thickness: 1,
      space: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF5CC3FF),
      foregroundColor: Colors.black87,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF5CC3FF), // 自定义背景色
      contentTextStyle: TextStyle(color: Colors.white), // 文字颜色
    ),
  );
}
