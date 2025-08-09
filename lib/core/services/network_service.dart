import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 网络状态模型
class NetworkState {
  final bool isConnected;
  final ConnectivityResult connectionType;

  const NetworkState({
    required this.isConnected,
    required this.connectionType,
  });

  // 命名构造器 - 从连接结果创建
  factory NetworkState.fromConnectivityResult(ConnectivityResult result) {
    return NetworkState(
      isConnected: result != ConnectivityResult.none,
      connectionType: result,
    );
  }

  // 便捷访问器
  bool get isWifi => connectionType == ConnectivityResult.wifi;
  bool get isMobile => connectionType == ConnectivityResult.mobile;
  bool get isNone => connectionType == ConnectivityResult.none;

  String get connectionTypeDescription {
    switch (connectionType) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return '移动数据';
      case ConnectivityResult.none:
        return '无网络';
      default:
        return '未知';
    }
  }

  @override
  String toString() => 'NetworkState($connectionType, connected:$isConnected)';
}

// 网络服务提供者
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(ref);
});

class NetworkService {
  final Ref _ref;
  late StreamSubscription<ConnectivityResult> _subscription;

  NetworkService(this._ref) {
    // 初始化时自动启动监听
    _init();
  }

  void _init() async {
    // 获取初始状态
    final initialResult = await Connectivity().checkConnectivity();
    _updateState(initialResult);

    // 监听网络变化
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen(_updateState);
  }

  void _updateState(ConnectivityResult result) {
    _ref.read(networkStateProvider.notifier).state =
        NetworkState.fromConnectivityResult(result);
  }

  // 销毁时取消订阅
  void dispose() {
    _subscription.cancel();
  }
}

// 网络状态提供者
final networkStateProvider = StateProvider<NetworkState>((ref) {
  // 初始状态设为无网络
  return const NetworkState(
    isConnected: false,
    connectionType: ConnectivityResult.none,
  );
});

// 便捷访问器提供者
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(networkStateProvider).isConnected;
});

final isWifiProvider = Provider<bool>((ref) {
  return ref.watch(networkStateProvider).isWifi;
});

final isMobileProvider = Provider<bool>((ref) {
  return ref.watch(networkStateProvider).isMobile;
});

final connectionTypeDescriptionProvider = Provider<String>((ref) {
  return ref.watch(networkStateProvider).connectionTypeDescription;
});



//使用示例
//在组件中访问网络状态：
// class NetworkStatusIndicator extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isConnected = ref.watch(isConnectedProvider);
//
//     return Icon(
//       isConnected ? Icons.wifi : Icons.wifi_off,
//       color: isConnected ? Colors.green : Colors.red,
//     );
//   }
// }

// 在需要的地方监听变化：
// ref.listen<NetworkState>(networkStateProvider, (previous, next) {
// if (next.isNone) {
// showNetworkDisconnectedToast();
// } else if (previous?.isNone == true && next.isConnected) {
// showNetworkRestoredToast();
// }
// });