import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//全局key
//使用go_router就不在需要这个了
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
      (ref) => GlobalKey<NavigatorState>(),
);