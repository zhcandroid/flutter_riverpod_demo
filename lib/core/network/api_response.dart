import 'package:dio/dio.dart' as dio;

/// API响应状态码
enum ApiStatus {
  success(0),
  error(-1),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  serverError(500);

  final int code;
  const ApiStatus(this.code);

  static ApiStatus fromCode(int code) {
    return ApiStatus.values.firstWhere(
          (status) => status.code == code,
      orElse: () => ApiStatus.error,
    );
  }
}

/// API响应模型
class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final String? message;
  final int? code;
  final dio.Response<dynamic>? rawResponse;

  ApiResponse({
    required this.status,
    this.data,
    this.message,
    this.code,
    this.rawResponse,
  });

  bool get isSuccess => status == ApiStatus.success;
  bool get isError => status == ApiStatus.error;
  bool get isUnauthorized => status == ApiStatus.unauthorized;
  bool get isForbidden => status == ApiStatus.forbidden;
  bool get isNotFound => status == ApiStatus.notFound;
  bool get isServerError => status == ApiStatus.serverError;

  factory ApiResponse.success(T data, {dio.Response<dynamic>? rawResponse}) {
    return ApiResponse(
      status: ApiStatus.success,
      data: data,
      rawResponse: rawResponse,
    );
  }

  factory ApiResponse.error(
      String message, {
        int? code,
        dio.Response<dynamic>? rawResponse,
      }) {
    return ApiResponse(
      status: ApiStatus.error,
      message: message,
      code: code,
      rawResponse: rawResponse,
    );
  }

  factory ApiResponse.fromResponse(
      dio.Response<dynamic> response, {
        T Function(dynamic json)? fromJson,
      }) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final code = data['code'] as int? ?? -1;
      final status = ApiStatus.fromCode(code);
      final message = data['message'] as String?;
      final responseData = data['data'];

      return ApiResponse(
        status: status,
        data: fromJson != null ? fromJson(responseData) : responseData as T?,
        message: message,
        code: code,
        rawResponse: response,
      );
    }
    return ApiResponse.error('Invalid response format', rawResponse: response);
  }
}

/// API错误模型
class ApiError implements Exception {
  final String message;
  final int? code;
  final ApiStatus status;
  final dynamic data;
  final dio.DioException? dioError;

  ApiError({
    required this.message,
    this.code,
    required this.status,
    this.data,
    this.dioError,
  });

  factory ApiError.fromDioError(dio.DioException error) {
    String message;
    ApiStatus status;
    int? code;

    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        message = '网络连接超时';
        status = ApiStatus.error;
        break;
      case dio.DioExceptionType.badResponse:
        code = error.response?.statusCode;
        message = error.response?.data?['message'] ?? '请求失败';
        status = ApiStatus.fromCode(code ?? -1);
        break;
      case dio.DioExceptionType.cancel:
        message = '请求已取消';
        status = ApiStatus.error;
        break;
      default:
        message = '网络连接异常';
        status = ApiStatus.error;
    }

    return ApiError(
      message: message,
      code: code,
      status: status,
      data: error.response?.data,
      dioError: error,
    );
  }

  @override
  String toString() => 'ApiError: $message (code: $code)';
} 