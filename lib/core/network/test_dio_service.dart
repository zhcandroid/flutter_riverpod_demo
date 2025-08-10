import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../shared/models/user_model.dart";
import "dio_service.dart";

class TestDioService extends ConsumerStatefulWidget {
  const TestDioService({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TestDioServiceState();
}

class _TestDioServiceState extends ConsumerState<TestDioService> {



  Future<void> _fetchData() async {
    final dioService = ref.watch(dioServiceProvider);
// 获取数据
    final response = await dioService.get<Map<String, dynamic>>(
      '/api/data',
      fromJson: (json) => json as Map<String, dynamic>,
    );

// 处理响应
    if (response.isSuccess && response.hasData) {
      // 处理数据
      final data = response.data!;
      // ...
    }

// 分页数据处理
    final paginatedData = dioService.parsePaginatedData<UserModel>(
      response.data!,
          (item) => UserModel.fromJson(item),
    );


  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
