import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

///  author : zhc 2025/7/4 14:56
///  desc   :NotifierProvider：提供一种更灵活的方式来管理状态和业务逻辑，支持任何类型的 "Notifier" 。


///1
// class ClickCount extends Notifier<int> {
//   //重写此方法返回notifier的初始状态
//   @override
//   build() {
//     return 0;
//   }
//
//   void increment() {
//     state++;
//   }
// }
//
// //2
// final clickCountProvider2 = NotifierProvider<ClickCount,int>(()=> ClickCount());

//之前的 ref.read(clickCountProvider.notifier).state++;可以换成下面的写法

//每次使用 NotifierProvider 都得先创建Notifier类，然后创建NotifierProvider来包裹他，
//有点麻烦了啊，其实可以使用 @riverpod 注解来自动生成：


part 'notifier_provider_widget.g.dart';

///生成的provider变量名为：ClickCount（当前classname） + Provider
@riverpod
class ClickCount extends _$ClickCount {
  //重写此方法返回notifier的初始状态
  @override
  int build() {
    ///注意 这里方法的返回值类型必须写
    ///否则生成的类型时Object 和实际的类型不匹配 报错****
    return 0;
  }

  void increment() {
    state++;
  }
}






