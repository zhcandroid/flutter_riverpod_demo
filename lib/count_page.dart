import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod_demo/main.dart";

import "count_provider.dart";
import "notifier_provider_widget.dart";

///  author : zhc 2025/7/4 11:26
///  desc   :

class CountPage extends ConsumerWidget {
  const CountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final int count = ref.watch(clickCountProvider2);

    return Scaffold(
      appBar: AppBar(title: const Text("计数调整")),
      body: Center(
        child: Column(
          children: [
            Text("当前：$count", style: TextStyle(color: Colors.green, fontSize: 28)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                //state 这个字段 同样是返回的T
                //
                // int count = ref.read(clickCountProvider.notifier).state;
                //count++; 这么写无效
                // ref.read(clickCountProvider.notifier).state++;

                //notifier的使用方式
                ref.read(clickCountProvider2.notifier).increment();


              },
              child: const Text(
                "点击增加计数",
                style: TextStyle(color: Colors.blue, fontSize: 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
