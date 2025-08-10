import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/core/network/dio_service.dart';
import 'package:flutter_riverpod_demo/core/utils/logger.dart';
import 'package:flutter_riverpod_demo/shared/models/user_model.dart';

// 用户 Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dioService = ref.read(dioServiceProvider);
  return UserRepository(dioService);
});

// 合理用法如下
// UI层 -> ViewModel/Provider -> Repository -> DioService
class UserRepository {
  final DioService _dioService;

  UserRepository(this._dioService);

  Future getContent() async {
    final response = await _dioService.get(
      '/harmony/index/json',
      // fromJson: (json) => json as String,
    );
    return response.data ?? 'No Content';
  }

  Future<UserModel> login(String email, String password) async {
    final response = await _dioService.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
      fromJson: (json) => json as Map<String, dynamic>,
    );

    final token = response.data!['token'] as String?;
    final userData = response.data!['user'] as Map<String, dynamic>?;

    return UserModel.fromJson(userData!);
  }
}
