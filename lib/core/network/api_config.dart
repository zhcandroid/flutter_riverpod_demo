import 'package:dio/dio.dart' as dio;

/// API配置管理类
class ApiConfig {
  static const String baseUrl = 'https://www.wanandroid.com';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
  static const int sendTimeout = 15000;
  static const int maxRetries = 3;
  static const int retryDelay = 1000;

  static dio.BaseOptions get baseOptions => dio.BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: Duration(milliseconds: connectTimeout),
    receiveTimeout: Duration(milliseconds: receiveTimeout),
    sendTimeout: Duration(milliseconds: sendTimeout),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  static dio.InterceptorsWrapper get defaultInterceptors => dio.InterceptorsWrapper(
    onRequest: (options, handler) {
      // 添加时间戳
      options.queryParameters ??= {};
      options.queryParameters['timestamp'] = DateTime.now().millisecondsSinceEpoch;
      return handler.next(options);
    },
    onResponse: (response, handler) {
      return handler.next(response);
    },
    onError: (error, handler) {
      return handler.next(error);
    },
  );

  static dio.LogInterceptor get logInterceptor => dio.LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  );
}