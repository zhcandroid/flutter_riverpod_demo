import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

///  author : zhc 2025/7/4 12:31
///  desc   :

// 计数器示例
//StateProvider 已经过时
final clickCountProvider = StateProvider<int>((ref) {
  return 0;
});


// 基本使用流程：
// ① 创建一个 全局final 的 Provider实例 来存储 状态/数据，传入一个 初始化状态的方法。
// ② 使用 ProviderScope 包裹 MyApp 实例。
// ③ 需要用到状态的 Widget 继承 ConsumerWidget，它的 build() 会提供一个 WidgetRef 类型的参数。
// ④ 需要 读取状态值，调用 ref.watch(xxxProvider) 来获取，状态值改变，会触发UI更新。
// ⑤ 需要 修改状态值， 调用 ref.read(xxxProvider.notifier).state = xxx。

//各种Provider
// 1、Provider (状态提供者) 是 Riverpod 里 状态管理的核心，负责创建和存储管理状态，
// 通知UI组建状态更新等功能，Riverpod 提供了下述这些不同类型的 Provider，以满足不同的需求：
//
// Provider：只存储 不可变 的值或对象，最简单的状态提供者，只对外提供访问状态值的接口，外部无法对状态值进行修改。

// 2、FutureProvider：处理 异步操作，如：从网络请求数据数据，它会再Future完成时通知其观察者。
// 通常与 autoDispose 修饰符一起使用。

// 3、StreamProvider：处理 基于流的异步数据，监听一个Stream，并在新数据到达前通知其观察者。

//这个 Provider 会在被监听时，自动发起一次网络请求，获取文章列表数据，并通过 Stream 发送出去。
//由于用了 autoDispose，当页面离开或不再监听时，会自动释放资源。
//适合用在需要响应式、自动刷新的场景，比如配合 ConsumerWidget 或 ref.watch(articleStreamValue) 使用。


//❗️ Riverpod 2.0新增：
//
//NotifierProvider：提供一种更灵活的方式来管理状态和业务逻辑，支持任何类型的 "Notifier" 。
//AsyncNotifierProvider：专门用于管理异步操作的状态，如网络请求，
// 它提供了一个结构化的方法来处理异步数据的加载、成功、错误和状态更新。


//❎ 已过时：

// StateProvider：创建和提供一个简单的可变状态，允许监听状态变化并响应这些变化。Riverpod 2.0 中推荐使用 NotifierProvider 来代替它。
// StateNotifierProvider ：将 StateNotifier 类与 Riverpod 集成，管理复杂的状态逻辑，并通知UI更新。Riverpod 2.0 中推荐使用 NotifierProvider 来代替它。
// ChangeNotifierProvider：将 ChangeNotifier 类与 Riverpod 集成，管理可观察的状态对象，ChangeNotifier 中需要自己调用 notifyListeners() 通知变更。













