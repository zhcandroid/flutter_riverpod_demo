import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

///  author : zhc 2025/7/4 14:56
///  desc   :NotifierProvider：提供一种更灵活的方式来管理状态和业务逻辑，支持任何类型的 "Notifier" 。


class ClickCount extends Notifier<int> {
  //重写此方法返回notifier的初始状态
  @override
  build() {
    return 0;
  }

  void increment() {
    state++;
  }
}

final clickCountProvider2 = NotifierProvider<ClickCount,int>(()=> ClickCount());

//之前的 ref.read(clickCountProvider.notifier).state++;可以换成下面的写法






