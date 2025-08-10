import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/core/utils/logger.dart';

import 'api_config.dart';
import 'api_response.dart';
import 'interceptors.dart';

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

/// 请求内容类型
enum ContentType {
  json, // application/json
  form, // application/x-www-form-urlencoded
  formData, // multipart/form-data
}

/// 获取内容类型字符串
String _getContentTypeString(ContentType contentType) {
  switch (contentType) {
    case ContentType.json:
      return 'application/json';
    case ContentType.form:
      return 'application/x-www-form-urlencoded';
    case ContentType.formData:
      return 'multipart/form-data';
  }
}

class DioService {
  final Ref _ref;
  late final Dio _dio;

  DioService(this._ref) {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio();
    // 使用ApiConfig的配置初始化Dio
    _dio = Dio(ApiConfig.baseOptions);
    // 添加日志拦截器（如有需要）
    _dio.interceptors.add(ApiConfig.logInterceptor);

    //添加认证拦截器
    _dio.interceptors.add(ApiInterceptor(_ref));
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool useCache = false,
    Duration cacheDuration = const Duration(minutes: 5),
    ContentType contentType = ContentType.json,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      _dio.options.contentType = _getContentTypeString(contentType);
      final response = await _dio.get(path, queryParameters: queryParameters);

      final apiResponse = ApiResponse<T>.fromResponse(
        response,
        fromJson: fromJson,
      );
      return apiResponse;
    } on DioException catch (e) {
      LogUtils.e('GET请求失败: $path', e);
      return ApiResponse.error(
        ApiError.fromDioError(e).message,
        code: e.response?.statusCode,
      );
    } catch (e) {
      LogUtils.e('GET请求失败: $path', e);
      return ApiResponse.error('请求异常');
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    ContentType contentType = ContentType.json,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      _dio.options.contentType = _getContentTypeString(contentType);
      final processedData = _processRequestData(data, contentType);

      final response = await _dio.post(
        path,
        data: processedData,
        queryParameters: queryParameters,
      );

      return ApiResponse<T>.fromResponse(response, fromJson: fromJson);
    } on DioException catch (e) {
      LogUtils.e('POST请求失败: $path', e);
      return ApiResponse.error(
        ApiError.fromDioError(e).message,
        code: e.response?.statusCode,
      );
    } catch (e) {
      LogUtils.e('POST请求异常: $path', e);
      return ApiResponse.error('请求异常');
    }
  }

  /// 处理请求数据
  dynamic _processRequestData(dynamic data, ContentType contentType) {
    if (data == null) return null;

    switch (contentType) {
      case ContentType.json:
        return data;
      case ContentType.form:
        if (data is Map) {
          // 将 Map<dynamic, dynamic> 转换为 Map<String, dynamic>
          final Map<String, dynamic> stringMap = Map<String, dynamic>.from(
            data,
          );
          return FormData.fromMap(stringMap);
        } else if (data is FormData) {
          return data;
        }
        return data;
      case ContentType.formData:
        if (data is Map) {
          final formData = FormData();
          // 将 Map<dynamic, dynamic> 转换为 Map<String, dynamic>
          final Map<String, dynamic> stringMap = Map<String, dynamic>.from(
            data,
          );
          stringMap.forEach((key, value) {
            if (value is File) {
              formData.files.add(
                MapEntry(
                  key,
                  MultipartFile.fromFileSync(
                    value.path,
                    filename: value.path.split('/').last,
                  ),
                ),
              );
            } else {
              formData.fields.add(MapEntry(key, value.toString()));
            }
          });
          return formData;
        } else if (data is FormData) {
          return data;
        }
        return data;
    }
  }
}
