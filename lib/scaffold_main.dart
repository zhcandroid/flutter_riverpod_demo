import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod_demo/core/utils/logger.dart";
import "package:go_router/go_router.dart";

// Main Page Scaffold with Bottom Navigation Bar
class MainPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainPage(this.navigationShell, {super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}
class _MainPageState extends ConsumerState<MainPage> {

  @override
  void initState() {
    super.initState();
    // 初始化时打印当前索引
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: widget.navigationShell.currentIndex,
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
    widget.navigationShell.goBranch(
      index,
      // 保留各分支状态
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

}

