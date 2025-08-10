import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../core/auth/auth_provider.dart";

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //取出参数
    final sessionExpired =
        (GoRouterState.of(context).extra as Map?)?["sessionExpired"] as bool? ??
        false;
    if (sessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 如果会话过期，显示提示
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("会话已过期，请重新登录")));
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 模拟登录操作
            ref.read(authProvider.notifier).login("mock_token");
            // 登录成功后跳转到主页
            context.pushReplacement('/home');
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
