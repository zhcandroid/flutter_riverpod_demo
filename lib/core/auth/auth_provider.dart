import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

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