import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/count_page.dart';
import 'package:flutter_riverpod_demo/stream_provider_widget.dart';
import 'package:flutter_riverpod_demo/todo/to_do_list_widget.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/utils/logger.dart';
import 'count_provider.dart';
import 'future_provider_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeStr = prefs.getString('themeMode');
  ThemeMode initialThemeMode = ThemeModeNotifier.stringToMode(themeStr);
  runApp(
    ProviderScope(
      overrides: [
        /// 使用overrideWith来覆盖themeModeNotifierProvider
        /// 在应用启动时，可以尽快使用主题，优化体验
        themeModeNotifierProvider.overrideWith(
          () => ThemeModeNotifier(initialThemeMode),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeNotifierProvider);
    LogUtils.i('当前主题:${theme.toString()} ');
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      //配置主题
      themeMode: theme,
      //配置路由
      routerConfig: router,
    );
  }
}
