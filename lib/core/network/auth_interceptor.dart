import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod_demo/app/router/app_router.dart";
import "package:flutter_riverpod_demo/core/network/handler_dio_err.dart";
import "package:go_router/go_router.dart";

import "../auth/auth_provider.dart";
import "../errors/network_err.dart";
import "../provider/navigator_provider.dart";
///  desc   : 认证拦截器

class AuthInterceptor extends InterceptorsWrapper {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      await _handleUnauthorizedError();

      final exception = NetworkException('会话已过期，请重新登录', statusCode: 401);

      return handler.reject(
        DioException(
          requestOptions: error.requestOptions,
          error: exception,
          response: error.response,
        ),
      );
    }

    final exception = DioErrorHandler.parseDioError(error);
    return handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        error: exception,
        response: error.response,
      ),
    );
  }

  Future<void> _handleUnauthorizedError() async {
    _ref.read(authProvider.notifier).logout();
    _navigateToLogin(sessionExpired: true);
  }

  void _navigateToLogin({bool sessionExpired = false}) {
    //如果使用了go_router，不需要使用全局 navigatorKey 来做路由跳转
    final GoRouter router = _ref.read(routerProvider);
    router.pushReplacement('/login', extra: {'sessionExpired': sessionExpired});

  }
}
