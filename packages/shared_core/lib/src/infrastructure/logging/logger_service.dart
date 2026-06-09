import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Context extension providing shortcut access to the [LoggerService].
extension LoggerServiceBuildContextX on BuildContext {
  /// Retrieves the [LoggerService] from the nearest ancestor [Provider].
  LoggerService get myoLogger => read<LoggerService>();
}

/// A simple log level enum to replace mason_logger's Level.
enum LogLevel {
  /// Detailed logs for troubleshooting.
  verbose,

  /// Debug information.
  debug,

  /// Standard informational messages.
  info,

  /// Warning messages for non-fatal issues.
  warning,

  /// Error messages for fatal issues.
  error,

  /// No logging.
  quiet
}

/// A single-concern service for structured, high-signal logging.
///
/// Wraps dart:developer log to provide consistent formatting
/// across the MyoTwin application, server, and core packages, without
/// requiring FFI/CLI dependencies like mason_logger.
class LoggerService {
  /// Creates a [LoggerService].
  LoggerService({this.level = LogLevel.info});

  /// The current filtering level of this logger.
  final LogLevel level;

  bool _shouldLog(LogLevel messageLevel) {
    return messageLevel.index >= level.index;
  }

  /// Logs a detailed debug message.
  void detail(String message) {
    if (_shouldLog(LogLevel.debug)) {
      developer.log('[DETAIL] $message', name: 'MYOTWIN', level: 500);
    }
  }

  /// Logs a standard informational message.
  void info(String message) {
    if (_shouldLog(LogLevel.info)) {
      developer.log('[INFO] $message', name: 'MYOTWIN', level: 800);
    }
  }

  /// Logs a warning message.
  void warn(String message) {
    if (_shouldLog(LogLevel.warning)) {
      developer.log('[WARN] $message', name: 'MYOTWIN', level: 900);
    }
  }

  /// Logs an error message.
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (_shouldLog(LogLevel.error)) {
      developer.log(
        '[ERROR] $message',
        name: 'MYOTWIN',
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Logs a success message.
  void success(String message) {
    if (_shouldLog(LogLevel.info)) {
      developer.log('[SUCCESS] $message', name: 'MYOTWIN', level: 800);
    }
  }

  /// Starts a progress indicator for long-running tasks.
  SimpleProgress progress(String message) {
    info('Started: $message');
    return SimpleProgress(message, this);
  }
}

/// A simple progress tracker replacing mason_logger's Progress.
class SimpleProgress {
  /// Creates a [SimpleProgress].
  SimpleProgress(this.message, this._logger);

  /// The task message.
  final String message;
  final LoggerService _logger;

  /// Completes the task.
  void complete([String? update]) {
    _logger.success('Completed: ${update ?? message}');
  }

  /// Fails the task.
  void fail([String? update]) {
    _logger.error('Failed: ${update ?? message}');
  }

  /// Updates the progress message.
  void update(String update) {
    _logger.info('Update ($message): $update');
  }

  /// Cancels the task.
  void cancel() {
    _logger.info('Cancelled: $message');
  }
}
