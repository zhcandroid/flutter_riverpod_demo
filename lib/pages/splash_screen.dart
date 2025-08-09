import "package:flutter/material.dart";
import "package:flutter_riverpod_demo/app/router/route_paths.dart";
import "package:go_router/go_router.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('欢迎页面'),
            ElevatedButton(
              onPressed: () {
                context.go(RoutePaths.home);
              },
              child: Text('进入首页'),
            ),
          ],
        ),
      ),
    );
  }
}
