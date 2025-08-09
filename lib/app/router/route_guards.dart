import 'package:flutter/material.dart';
import 'package:flutter_riverpod_demo/app/router/route_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteGuards {
  static String? authGuard(
      BuildContext context,
      GoRouterState state,
      Ref ref
      ) {
    // final isAuthenticated = ref.read(authProvider).isAuthenticated;
    final isAuthenticated =  true;

    final isLoggingIn = state.matchedLocation == RoutePaths.login;

    // 未认证且不在登录页 → 重定向到登录
    if (!isAuthenticated && !isLoggingIn) {
      return RoutePaths.login;
    }

    // 已认证但在登录页 → 重定向到首页
    if (isAuthenticated && isLoggingIn) {
      return RoutePaths.home;
    }

    return null;
  }
}