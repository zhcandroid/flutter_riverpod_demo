import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

///  author : zhc 2025/7/4 14:08
///  desc   :

final articleStreamValue = StreamProvider.autoDispose((ref) async* {
  final response = await Dio().get(
    "https://www.wanandroid.com/article/list/0/json",
  );
  yield response.data;
});

class StreamProviderWidget extends ConsumerWidget {
  const StreamProviderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseAsyncValue = ref.watch(articleStreamValue);
    return Scaffold(
      appBar: AppBar(title: const Text("StreamProvider")),
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
