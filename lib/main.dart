import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/count_page.dart';
import 'package:flutter_riverpod_demo/stream_provider_widget.dart';
import 'package:flutter_riverpod_demo/todo/to_do_list_widget.dart';

import 'count_provider.dart';
import 'future_provider_test.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeApp());
  }
}

class HomeApp extends ConsumerWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //通过watch来监听状态
    //watch返回的是定义provider时使用的范型T，类型保持一致
    final int count = ref.watch(clickCountProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("RiverPod Demo")),
      body: Center(
        child: Column(
          children: [
            Text(
              "当前count是:$count",
              style: TextStyle(color: Colors.green, fontSize: 28),
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => CountPage()));
              },
              child: const Text("跳转到增加计数页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => FutureProviderWidget()));
              },
              child: const Text("跳转到FutureProvider页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => StreamProviderWidget()));
              },
              child: const Text("跳转到StreamProvider页面"),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => TodoListPage()));
              },
              child: const Text("跳转到TodoList页面"),
            ),

          ],
        ),
      ),
    );
  }
}
