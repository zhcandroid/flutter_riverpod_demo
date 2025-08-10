import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeMode initTheme = await ThemeModeNotifier.getNavThemeModel();
  runApp(
    ProviderScope(
      overrides: [
        /// 在应用启动时，可以尽快使用主题，优化体验
        themeModeNotifierProvider.overrideWith(
          () => ThemeModeNotifier(initTheme),
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

    return ScreenUtilInit(
      designSize: const Size(375, 812), // 设置设计稿尺寸
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        //配置主题
        themeMode: theme,
        //配置路由
        routerConfig: router,

      ),
    );
  }
}
