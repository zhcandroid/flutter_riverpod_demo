import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/core/auth/token_manager.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()){
    _init();
  }
  _init() async{
    final token = await TokenManager.getToken(); // 假设从本地存储获取token
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(token: token, isAuthenticated: true);
    }
  }

  void login(String token) {
    state = state.copyWith(token: token, isAuthenticated: true);
  }

  void logout() {
    state = const AuthState();
  }
}

//提供authProvider给调用者
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);