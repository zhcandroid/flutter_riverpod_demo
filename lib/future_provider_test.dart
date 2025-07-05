import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

//只有在watch当前provider时 才会执行ref的回调方法
final articleFutureProvider = FutureProvider.autoDispose(
  (ref) async {
    print("articleFutureProvider执行了");
    return await Dio()
        .get('https://www.wanandroid.com/article/list/0/json')
        .then((res) => res.data);
  }
);

//使用@riverpod 实现articleFutureProvider
// @riverpod
// Future<String> getArticleData() async {
//   print("articleFutureProvider执行了");
//   return await Dio()
//       .get('https://www.wanandroid.com/article/list/0/json')
//       .then((res) => res.data.toString());
// }


class FutureProviderWidget extends ConsumerWidget {
  const FutureProviderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //使用watch监听
    final responseAsyncValue = ref.watch(articleFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("FutureProvider")),
      body: Center(
        child: responseAsyncValue.when(
          data: (data) {
            return Text("$data");
          },
          error: (Object error, StackTrace stackTrace) => Text("Error:$error"),
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
