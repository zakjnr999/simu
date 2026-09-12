import 'package:flutter/foundation.dart';
import 'package:simu/core/logging/app_logger.dart';

/// Console implementation of [AppLogger] with structured tags and level gating.
class AppLoggerImpl implements AppLogger {
  const AppLoggerImpl({
    this.minLevel = kDebugMode ? LogLevel.debug : LogLevel.info,
  });

  final LogLevel minLevel;

  bool _shouldLog(LogLevel level) => level.index >= minLevel.index;

  String _format(LogLevel level, String message, String? tag) {
    final prefix = switch (level) {
      LogLevel.debug => '🔍 [DEBUG]',
      LogLevel.info => 'ℹ️ [INFO]',
      LogLevel.warning => '⚠️ [WARN]',
      LogLevel.error => '🚨 [ERROR]',
    };
    final tagSection = tag != null ? ' [$tag]' : '';
    return '$prefix$tagSection $message';
  }

  @override
  void debug(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(LogLevel.debug)) return;
    debugPrint(_format(LogLevel.debug, message, tag));
    if (error != null) debugPrint('  Error: $error');
  }

  @override
  void info(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(LogLevel.info)) return;
    debugPrint(_format(LogLevel.info, message, tag));
    if (error != null) debugPrint('  Error: $error');
  }

  @override
  void warning(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(LogLevel.warning)) return;
    debugPrint(_format(LogLevel.warning, message, tag));
    if (error != null) debugPrint('  Error: $error');
    if (stackTrace != null) debugPrint('  StackTrace: $stackTrace');
  }

  @override
  void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(LogLevel.error)) return;
    debugPrint(_format(LogLevel.error, message, tag));
    if (error != null) debugPrint('  Error: $error');
    if (stackTrace != null) debugPrint('  StackTrace: $stackTrace');
  }
}
