import 'package:flutter/material.dart';
import 'package:flutter_riverpod_demo/app/router/route_guards.dart';
import 'package:flutter_riverpod_demo/app/router/route_paths.dart';
import 'package:flutter_riverpod_demo/scaffold_main.dart';
import 'package:flutter_riverpod_demo/features/home/chat_page.dart';
import 'package:flutter_riverpod_demo/features/home/home_page.dart';
import 'package:flutter_riverpod_demo/features/login/login_page.dart';
import 'package:flutter_riverpod_demo/features/mine/mine_page.dart';
import 'package:flutter_riverpod_demo/features/news/news_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/error_screen.dart';
import '../../features/splash_screen.dart';


//route是和业务强相关的，不适合放在core中
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    //初始化路由
    initialLocation: RoutePaths.splash,
    //
    redirect: (context, state) => RouteGuards.authGuard(context, state, ref),
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder:
            (_, state) => CustomTransitionPage(
              child: const LoginPage(),
              transitionsBuilder: fadeTransition,
            ),
      ),


      //主页对应table页面
      StatefulShellRoute.indexedStack(
        builder: (
            context, state, navigationShell
        ) {
          //返回共享页面widget
          return MainPage( navigationShell);
        },
        branches: [
          //4 个 table
          // 首页分支
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.news,
                builder: (context, state) => const NewsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.chat,
                builder: (context, state) => const ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.mine,
                builder: (context, state) => const MinePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder:
        (context, state) => ErrorScreen(
          // error: state.error.toString(),
          // onRetry: () => context.go(RoutePaths.home),
        ),
  );
});

Widget fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}
