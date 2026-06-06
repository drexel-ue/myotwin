import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/shared_core.dart';

/// A global BLoC observer that uses [LoggerService] for consistent
/// formatted output across the entire application's BLoC/Cubit state changes.
class MyoBlocObserver extends BlocObserver {
  /// Creates a [MyoBlocObserver].
  MyoBlocObserver({required LoggerService logger}) : _logger = logger;

  final LoggerService _logger;

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    _logger.detail('BLOC_CREATE: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    final current = change.currentState;
    final next = change.nextState;

    final currentStr = current is Loggable ? current.toDiagnosticString() : current.toString();
    final nextStr = next is Loggable ? next.toDiagnosticString() : next.toString();

    _logger.detail('BLOC_CHANGE: ${bloc.runtimeType} | $currentStr -> $nextStr');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.error('BLOC_ERROR: ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _logger.detail('BLOC_CLOSE: ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
