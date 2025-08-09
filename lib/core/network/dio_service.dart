import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/core/network/auth_interceptor.dart';

import '../errors/network_err.dart';
import 'api_response.dart';

// ====================== 网络服务架构 ======================
// UI层 -> ViewModel/Provider -> Repository -> DioService

// 1. UI层通过Provider获取ViewModel或Repository
// 2. ViewModel或Repository通过DioService进行网络请求
// 3. DioService处理请求、响应和错误
// 4. 网络请求结果通过ApiResponse封装
// 5. 错误通过NetworkException进行统一处理
// 6. 分页数据通过PaginatedData进行处理
// 7. 所有网络请求都通过DioService进行，确保统一的错误处理和响应解析
// 8. 使用Provider进行依赖注入，方便测试和维护

// ====================== 网络服务实现 ======================
final dioServiceProvider = Provider<DioService>((ref) {
  return DioService(ref);
});

class DioService {
  final Ref _ref;
  late final Dio _dio;

  DioService(this._ref) {
    _dio = Dio();
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://your-api.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    //添加认证拦截器
    _dio.interceptors.add(AuthInterceptor(_ref));
    _dio.interceptors.add(
      LogInterceptor(request: true, responseBody: true, error: true),
    );
  }

  // ====================== 请求方法 ======================
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
    bool forceRefresh = false,
  }) async {
    return _handleApiRequest<T>(
      () => _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(extra: {'forceRefresh': forceRefresh}),
      ),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    return _handleApiRequest<T>(
      () => _dio.post(path, data: data),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    return _handleApiRequest<T>(
      () => _dio.put(path, data: data),
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    T Function(dynamic)? fromJson,
  }) async {
    return _handleApiRequest<T>(
      () => _dio.delete(path, queryParameters: queryParams),
      fromJson: fromJson,
    );
  }

  // ====================== 核心请求处理 ======================
  Future<ApiResponse<T>> _handleApiRequest<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _handleRequest(request);
      return _parseSuccessResponse<T>(response, fromJson);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('数据处理失败: ${e.toString()}');
    }
  }

  Future<Response> _handleRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error!;
      }
      throw _parseDioError(e);
    } catch (e) {
      throw NetworkException('未知网络错误: ${e.toString()}');
    }
  }

  NetworkException _parseDioError(DioException e) {
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

  NetworkException _handleResponseError(Response response) {
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

  // ====================== 成功响应处理 ======================
  ApiResponse<T> _parseSuccessResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    final statusCode = response.statusCode ?? 200;

    if (response.data == null) {
      return ApiResponse<T>(statusCode: statusCode, message: '空响应');
    }

    try {
      dynamic jsonData = response.data;

      if (jsonData is String) {
        jsonData = jsonDecode(jsonData);
      }

      if (jsonData is! Map<String, dynamic>) {
        throw const FormatException('响应格式无效');
      }

      final apiResponse = ApiResponse<T>.fromJson(jsonData, fromJson);

      if (!apiResponse.isSuccess) {
        throw NetworkException(
          apiResponse.message ?? '业务错误 (${apiResponse.statusCode})',
          statusCode: apiResponse.statusCode,
        );
      }

      return apiResponse;
    } on FormatException catch (e) {
      throw NetworkException('响应解析失败: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  // ====================== 分页数据处理 ======================
  PaginatedData<T> parsePaginatedData<T>(
    Map<String, dynamic> json,
    T Function(dynamic) itemFromJson,
  ) {
    try {
      final items =
          (json['items'] as List).map((item) => itemFromJson(item)).toList();

      return PaginatedData<T>(
        items: items,
        currentPage: json['meta']['current_page'] ?? 1,
        totalPages: json['meta']['last_page'] ?? 1,
        totalItems: json['meta']['total'] ?? items.length,
        perPage: json['meta']['per_page'] ?? items.length,
      );
    } catch (e) {
      throw NetworkException('分页数据解析失败: ${e.toString()}');
    }
  }
}
