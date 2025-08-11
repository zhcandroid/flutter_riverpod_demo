import 'package:flutter/material.dart';
import 'package:flutter_riverpod_demo/app/router/route_paths.dart';
import 'package:flutter_riverpod_demo/core/utils/logger.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_provider.dart';

class RouteGuards {
  static String? authGuard(
      BuildContext context,
      GoRouterState state,
      Ref ref
      ) {

    // 获取当前路由名称（优先使用）
    final currentRouteName = state.name;

    // 获取当前路径
    final currentPath = state.uri.path;

    // 获取匹配的路由模式（解决动态参数问题）
    final matchedPathPattern = state.matchedLocation ?? '';

    LogUtils.d('''
    RouteGuard State:
    - Name: $currentRouteName
    - Path: $currentPath
    - Pattern: $matchedPathPattern
    ''');

    // 特殊处理 splash 路由
    if (currentRouteName == 'splash' || matchedPathPattern == RoutePaths.splash) {
      return null; // 允许访问
    }


    //监听认证状态
    final authState = ref.watch(authProvider);

    final isLoggingIn = state.name == RoutePaths.login; // 使用路由名称判断
    final isAuthenticated = authState.isAuthenticated;


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