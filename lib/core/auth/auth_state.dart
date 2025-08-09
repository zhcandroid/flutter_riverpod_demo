///认证状态 这里指登录状态
class AuthState {
  final String? token;
  final bool isAuthenticated;

  const AuthState({this.token, this.isAuthenticated = false});

  AuthState copyWith({String? token, bool? isAuthenticated}) {
    return AuthState(
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}