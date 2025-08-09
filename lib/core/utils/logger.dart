import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  Logger? _logger;
  Level _currentLevel = kReleaseMode ? Level.warning : Level.verbose;

  factory AppLogger() => _instance;

  AppLogger._internal() {
    _recreateLogger();
  }

  /// 重新创建Logger实例
  void _recreateLogger() {
    _logger = Logger(
      filter: _createFilter(),
      printer: PrettyPrinter(
        methodCount: _shouldPrintCallStack ? 2 : 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: _shouldUseColors,
        printEmojis: true,
        printTime: true,
      ),
      level: _currentLevel,
    );
  }

  /// 动态更新日志级别
  static void setLevel(Level level) {
    _instance._currentLevel = level;
    _instance._recreateLogger();
  }

  bool get _shouldUseColors => !kReleaseMode;

  bool get _shouldPrintCallStack => !kReleaseMode;

  LogFilter _createFilter() {
    return kReleaseMode
        ? _ProductionFilter(_currentLevel)
        : DevelopmentFilter(_currentLevel);
  }

  /// 检查某个级别是否会被记录
  bool isLoggable(Level level) {
    return level.index >= _currentLevel.index;
  }

  /// 详细日志
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.v(message, error: error, stackTrace: stackTrace);
  }

  /// 调试日志
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.d(message, error: error, stackTrace: stackTrace);
  }

  /// 信息日志
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.i(message, error: error, stackTrace: stackTrace);
  }

  /// 警告日志
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.w(message, error: error, stackTrace: stackTrace);
  }

  /// 错误日志（自动上报）
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.e(message, error: error, stackTrace: stackTrace);
    _reportError(message, error, stackTrace);
  }

  /// 致命错误（立即上报）
  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _instance._logger?.wtf(message, error: error, stackTrace: stackTrace);
    _reportError(message, error, stackTrace, isCritical: true);
  }

  /// 业务关键日志
  static void business(String action, {Map<String, dynamic>? params}) {
    final message =
        'BIZ::$action${params != null ? ' | ${_sanitize(params)}' : ''}';
    i(message);
  }

  /// 性能优化：惰性日志
  static void lazyV(dynamic Function() callback) {
    if (_instance.isLoggable(Level.verbose)) {
      v(callback());
    }
  }

  static void lazyD(dynamic Function() callback) {
    if (_instance.isLoggable(Level.debug)) {
      d(callback());
    }
  }

  static void lazyI(dynamic Function() callback) {
    if (_instance.isLoggable(Level.info)) {
      i(callback());
    }
  }

  // 错误上报实现
  static void _reportError(
    dynamic message,
    dynamic error,
    StackTrace? stackTrace, {
    bool isCritical = false,
  }) {
    if (kReleaseMode) {
      // 实际项目中接入Sentry/Firebase
      debugPrint('⛔️ [ERROR REPORTED] $message');
      if (error != null) debugPrint('➡️ $error');
      if (stackTrace != null) {
        debugPrint(
          '🔍 ${stackTrace.toString().split("\n").take(5).join("\n")}',
        );
      }
    }
  }

  // 敏感信息过滤
  static dynamic _sanitize(dynamic input) {
    if (input is Map) {
      final safeMap = Map<String, dynamic>.from(input);
      const sensitiveKeys = {
        'password',
        'token',
        'creditCard',
        'secret',
        'auth',
      };

      for (final key in sensitiveKeys) {
        if (safeMap.containsKey(key)) {
          safeMap[key] = '***';
        }
        // 处理嵌套key (如 'user.password')
        final nestedKeys = safeMap.keys.where(
          (k) => k.toString().contains(key),
        );
        for (final nestedKey in nestedKeys) {
          safeMap[nestedKey] = '***';
        }
      }
      return safeMap;
    }

    final str = input.toString();
    const patterns = [
      'password":".+?"',
      'token":".+?"',
      'card_number":".+?"',
      'pw=.+?&',
      'apikey=.+?[&"]',
    ];

    var result = str;
    for (final pattern in patterns) {
      result = result.replaceAllMapped(RegExp(pattern), (match) {
        final prefix = match.group(0)!.split('=')[0];
        return '$prefix=***';
      });
    }
    return result;
  }
}

/// 生产环境过滤器
class _ProductionFilter extends LogFilter {
  final Level currentLevel;

  _ProductionFilter(this.currentLevel);

  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= currentLevel.index;
  }
}

/// 开发环境过滤器
class DevelopmentFilter extends LogFilter {
  final Level currentLevel;

  DevelopmentFilter(this.currentLevel);

  @override
  bool shouldLog(LogEvent event) {
    return event.level.index >= currentLevel.index;
  }
}

// 简化调用接口
class LogUtils {
  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.v(message, error, stackTrace);

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.d(message, error, stackTrace);

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.i(message, error, stackTrace);

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.w(message, error, stackTrace);

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.e(message, error, stackTrace);

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      AppLogger.wtf(message, error, stackTrace);

  static void business(String action, {Map<String, dynamic>? params}) =>
      AppLogger.business(action, params: params);

  static void lazyV(dynamic Function() callback) => AppLogger.lazyV(callback);

  static void lazyD(dynamic Function() callback) => AppLogger.lazyD(callback);

  static void lazyI(dynamic Function() callback) => AppLogger.lazyI(callback);

  /// 动态更新日志级别
  static void setLevel(Level level) => AppLogger.setLevel(level);

  /// 检查某个级别是否会被记录
  static bool isLoggable(Level level) => AppLogger().isLoggable(level);
}
