import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_riverpod_demo/core/utils/logger.dart";
import "package:flutter_riverpod_demo/shared/repository/user_repository.dart";

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState()=>_HomePageState();

}
class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          children: [

            Text(""),

            ElevatedButton(onPressed: () {
              ref.read(userRepositoryProvider).getContent();
            }, child: const Text("点击再次请求")),
          ],
        ),
      ),
    );
  }
}