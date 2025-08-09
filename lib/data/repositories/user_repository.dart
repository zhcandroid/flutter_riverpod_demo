
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/core/network/dio_service.dart';
import 'package:flutter_riverpod_demo/data/models/user_model.dart';

import '../../core/errors/network_err.dart';
import '../../core/network/api_response.dart';

// 用户 Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dioService = ref.watch(dioServiceProvider);
  return UserRepository(dioService);
});

// 合理用法如下
// UI层 -> ViewModel/Provider -> Repository -> DioService
class UserRepository {
  final DioService _dioService;

  UserRepository(this._dioService);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (!response.isSuccess || !response.hasData) {
        throw NetworkException('登录失败: ${response.message}');
      }

      final token = response.data!['token'] as String?;
      final userData = response.data!['user'] as Map<String, dynamic>?;

      if (token == null || userData == null) {
        throw NetworkException('无效的响应格式');
      }
      return UserModel.fromJson(userData);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('登录处理失败: ${e.toString()}');
    }
  }

  Future<UserModel> getUserProfile(int userId) async {
    try {
      final response = await _dioService.get<Map<String, dynamic>>(
        '/users/$userId',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (!response.isSuccess || !response.hasData) {
        throw NetworkException('获取用户信息失败: ${response.message}');
      }

      return UserModel.fromJson(response.data!);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('用户信息解析失败: ${e.toString()}');
    }
  }

  Future<PaginatedData<UserModel>> getUsers({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dioService.get<Map<String, dynamic>>(
        '/users',
        queryParams: {'page': page, 'per_page': perPage},
        fromJson: (json) => json as Map<String, dynamic>,
      );

      if (!response.isSuccess || !response.hasData) {
        throw NetworkException('获取用户列表失败: ${response.message}');
      }

      return _dioService.parsePaginatedData<UserModel>(
        response.data!,
        (item) => UserModel.fromJson(item),
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('用户列表解析失败: ${e.toString()}');
    }
  }
}
