import 'package:flutter/widgets.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:provider/provider.dart';

/// Context extension providing shortcut access to the [LoggerService].
extension LoggerServiceBuildContextX on BuildContext {
  /// Retrieves the [LoggerService] from the nearest ancestor [Provider].
  LoggerService get myoLogger => read<LoggerService>();
}

/// A single-concern service for structured, high-signal logging.
///
/// Wraps [Logger] from package:mason_logger to provide consistent formatting
/// across the MyoTwin application, server, and core packages.
class LoggerService {
  /// Creates a [LoggerService].
  LoggerService({Level level = Level.info}) : _logger = Logger(level: level);

  final Logger _logger;

  /// Logs a detailed debug message.
  void detail(String message) => _logger.detail(message);

  /// Logs a standard informational message.
  void info(String message) => _logger.info(message);

  /// Logs a warning message.
  void warn(String message) => _logger.warn(message);

  /// Logs an error message.
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.err(message);
    if (error != null) _logger.err('Error details: $error');
    if (stackTrace != null) _logger.err('Stack trace: $stackTrace');
  }

  /// Logs a success message.
  void success(String message) => _logger.success(message);

  /// Starts a progress indicator for long-running tasks.
  Progress progress(String message) => _logger.progress(message);
}
