import 'package:dio/dio.dart';

import '../errors/network_err.dart';

class DioErrorHandler {
  static NetworkException parseDioError(DioException e) {
    if (e.response != null) {
      return _handleResponseError(e.response!);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException('请求超时，请检查网络');
      case DioExceptionType.cancel:
        return NetworkException('请求已取消');
      default:
        return NetworkException('网络连接失败');
    }
  }

  static NetworkException _handleResponseError(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String? serverMessage;
    try {
      if (data is Map) {
        serverMessage = data['message'] ?? data['error'];
      } else if (data is String) {
        serverMessage = data;
      }
    } catch (_) {}

    switch (statusCode) {
      case 400:
        return NetworkException(serverMessage ?? '请求参数错误', statusCode: 400);
      case 401:
        return NetworkException(serverMessage ?? '未授权访问', statusCode: 401);
      case 403:
        return NetworkException(serverMessage ?? '没有访问权限', statusCode: 403);
      case 404:
        return NetworkException(serverMessage ?? '资源不存在', statusCode: 404);
      case 422:
        return NetworkException(serverMessage ?? '数据验证失败', statusCode: 422);
      case 429:
        return NetworkException(
          serverMessage ?? '请求过于频繁，请稍后再试',
          statusCode: 429,
        );
      case 500:
      case 502:
      case 503:
        return NetworkException(
          serverMessage ?? '服务器错误 ($statusCode)',
          statusCode: statusCode,
        );
      default:
        return NetworkException(
          serverMessage ?? '未知错误 ($statusCode)',
          statusCode: statusCode,
        );
    }
  }
}
