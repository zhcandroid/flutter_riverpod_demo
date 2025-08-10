import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../app/router/router_service.dart';
import '../auth/auth_provider.dart';

//API 通用拦截器
class ApiInterceptor extends Interceptor {
  final Ref _ref;

  ApiInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authProvider).token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 处理HTTP状态码
    if (response.statusCode != 200) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'HTTP错误: ${response.statusCode}',
        ),
      );
      return;
    }

    // 处理业务状态码
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final code = data['errorCode'];
      final message = data['errorMessage'] ?? '未知错误';

      if (code != 0) {
        // 处理特定业务错误码
        switch (code) {
          case 401: // 未授权
            _handleUnauthorizedError();
            break;
          case 403: // 禁止访问
            break;
          case 404: // 资源不存在
            break;
          case 500: // 服务器错误
            break;
          default:
        }
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: message,
            type: DioExceptionType.badResponse,
          ),
        );
        return;
      }

      // 通过路由服务显示错误信息
      final routerService = _ref.read(routerServiceProvider);
      routerService.showSnackBar("请求成功");

    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = '网络请求失败';
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      errorMessage = '网络连接超时';
    } else if (err.type == DioExceptionType.badResponse) {
      if (err.response?.statusCode == 401) {
        errorMessage = '登录已过期，请重新登录';
        _handleUnauthorizedError();
      } else if (err.response?.statusCode == 403) {
        errorMessage = '没有权限访问';
      } else if (err.response?.statusCode == 404) {
        errorMessage = '请求的资源不存在';
      } else if (err.response?.statusCode == 500) {
        errorMessage = '服务器内部错误';
      } else {
        errorMessage = err.response?.data?['message'] ?? '请求失败';
      }
    } else if (err.type == DioExceptionType.cancel) {
      errorMessage = '请求已取消';
    } else {
      errorMessage = '网络连接失败，请检查网络设置';
    }
    // 通过路由服务显示错误信息
    final routerService = _ref.read(routerServiceProvider);
    routerService.showSnackBar(errorMessage);

    super.onError(err, handler);
  }

  //监听到401错误时，处理未授权的情况
  Future<void> _handleUnauthorizedError() async {
    _ref.read(authProvider.notifier).logout();
    //如果使用了go_router，不需要使用全局 navigatorKey 来做路由跳转
    final GoRouter router = _ref.read(routerProvider);
    router.pushReplacement('/login', extra: {'sessionExpired': false});
  }
}
