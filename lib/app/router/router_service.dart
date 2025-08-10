import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';

final routerServiceProvider = Provider<RouterService>((ref) {
  return RouterService(ref);
});

class RouterService {
  final Ref ref;

  RouterService(this.ref);

  // 获取当前上下文
  BuildContext? get currentContext {
    final router = ref.read(routerProvider);
    return router.routerDelegate.navigatorKey.currentContext;
  }

  // 显示全局 SnackBar
  void showSnackBar(String message) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
      );
    }
  }

  // 路由跳转
  void go(String location, {Object? extra}) {
    ref.read(routerProvider).go(location, extra: extra);
  }

  // 认证跳转
  void redirectToLogin() {
    go('/login', extra: '请先登录');
  }
}