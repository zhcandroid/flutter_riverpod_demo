
// 创建 FutureProvider 管理异步状态
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_demo/shared/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/repository/user_repository.dart';

// final userDataProvider = FutureProvider<UserModel>((ref) async {
// // 从 repository 获取数据
// return ref.watch(userRepositoryProvider).getContent();
// });




