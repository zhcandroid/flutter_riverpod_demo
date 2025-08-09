import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

// 带有底部导航的脚手架
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          //点击时去除移动效果
          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'News'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Mine'),
          ],
          onTap: (index) => _onTap(context, index),
        ),
      ),
    );
  }

  // 切换标签页
  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      // 保留各分支状态
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
