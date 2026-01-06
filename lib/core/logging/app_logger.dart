/// Centralized logging system for the application
/// 
/// Replaces all print statements with proper logging that supports:
/// - Different log levels (debug, info, warning, error)
/// - Stack traces for errors
/// - Conditional logging based on build mode
/// - Pretty formatting in development
library;

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Application-wide logger instance
class AppLogger {
  static Logger? _logger;
  
  /// Get the logger instance (singleton)
  static Logger get logger {
    _logger ??= Logger(
      printer: PrettyPrinter(
        methodCount: kDebugMode ? 2 : 0,
        errorMethodCount: kDebugMode ? 8 : 0,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: kDebugMode ? Level.debug : Level.info,
      output: ConsoleOutput(),
    );
    return _logger!;
  }
  
  /// Log a debug message
  /// Use for detailed information that is only useful during development
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      logger.d(message, error: error, stackTrace: stackTrace);
    }
  }
  
  /// Log an info message
  /// Use for general informational messages
  static void i(String message) {
    logger.i(message);
  }
  
  /// Log a warning message
  /// Use for potentially harmful situations
  static void w(String message, [dynamic error]) {
    logger.w(message, error: error);
  }
  
  /// Log an error message
  /// Use for error events that might still allow the app to continue
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log a fatal error
  /// Use for very severe error events that might cause the app to abort
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    logger.f(message, error: error, stackTrace: stackTrace);
  }
  
  /// Log a verbose message
  /// Use for very detailed tracing information
  static void v(String message) {
    if (kDebugMode) {
      logger.t(message);
    }
  }
}

