import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/count_page.dart';
import 'package:flutter_riverpod_demo/stream_provider_widget.dart';
import 'package:flutter_riverpod_demo/todo/to_do_list_widget.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
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
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeNotifierProvider),
      home: HomeApp(),
    );
  }
}

class HomeApp extends ConsumerWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //通过watch来监听状态
    //watch返回的是定义provider时使用的范型T，类型保持一致
    final int count = ref.watch(clickCountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("RiverPod Demo")),
      body: Center(
        child: Column(
          children: [
            Text(
              "当前count是:$count",
              style: TextStyle(color: Colors.green, fontSize: 28),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => CountPage()));
              },
              child: const Text("跳转到增加计数页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FutureProviderWidget()),
                );
              },
              child: const Text("跳转到FutureProvider页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => StreamProviderWidget()),
                );
              },
              child: const Text("跳转到StreamProvider页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => TodoListPage()));
              },
              child: const Text("跳转到TodoList页面"),
            ),

            const SizedBox(height: 50),

            // 主题切换按钮
            ElevatedButton(
              onPressed: () {
                ref.read(themeModeNotifierProvider.notifier).nextMode();
              },
              child: Text(
                "切换主题（当前： ${{ThemeMode.light: '明亮', ThemeMode.dark: '深色', ThemeMode.system: '跟随系统'}[ref.watch(themeModeNotifierProvider)]}）",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
