import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//全局key
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
      (ref) => GlobalKey<NavigatorState>(),
);