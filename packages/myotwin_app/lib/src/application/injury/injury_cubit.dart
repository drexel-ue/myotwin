import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/infrastructure/injury/injury_repository.dart';
import 'package:shared_core/shared_core.dart';
import 'package:uuid/uuid.dart';

/// The state of the user's logged injuries.
class InjuryState {
  /// Creates an [InjuryState].
  const InjuryState({
    this.injuries = const [],
    this.isLoading = false,
  });

  /// The list of currently active injuries.
  final List<Injury> injuries;

  /// Whether the initial load is in progress.
  final bool isLoading;

  /// Creates a copy of this state with the given fields replaced.
  InjuryState copyWith({
    List<Injury>? injuries,
    bool? isLoading,
  }) {
    return InjuryState(
      injuries: injuries ?? this.injuries,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Manages the lifecycle of user injuries and biomechanical constraints.
class InjuryCubit extends Cubit<InjuryState> {
  /// Creates an [InjuryCubit].
  InjuryCubit({
    required InjuryRepository repository,
  }) : _repository = repository,
       super(const InjuryState());

  final InjuryRepository _repository;
  StreamSubscription<List<Injury>>? _injurySubscription;

  /// Initializes the cubit and starts watching the database.
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));
    await _injurySubscription?.cancel();
    _injurySubscription = _repository.watchActiveInjuries().listen((injuries) {
      emit(state.copyWith(injuries: injuries, isLoading: false));
    });
  }

  /// Logs a new injury.
  Future<void> logInjury({
    required List<String> nodeIds,
    required InjurySeverity severity,
    required String description,
  }) async {
    final injury = Injury(
      id: const Uuid().v4(),
      nodeIds: nodeIds,
      severity: severity,
      description: description,
      createdAt: DateTime.now(),
    );
    await _repository.saveInjury(injury);
  }

  /// Resolves an existing injury.
  Future<void> resolveInjury(String id) async {
    await _repository.resolveInjury(id);
  }

  @override
  Future<void> close() async {
    await _injurySubscription?.cancel();
    return super.close();
  }
}
