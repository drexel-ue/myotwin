import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/shared_core.dart';

/// The state for user theme preferences.
class ThemeState implements Loggable {
  /// Creates [ThemeState].
  const ThemeState({
    required this.settings,
  });

  /// The active theme settings.
  final ThemeSettings settings;

  @override
  String toDiagnosticString() => settings.toDiagnosticString();

  @override
  String toSummaryString() => settings.toSummaryString();

  @override
  String toString() => toDiagnosticString();
}

/// Manages the application's theme state and persistence.
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates [ThemeCubit].
  ThemeCubit({
    required ThemeRepository repository,
  }) : _repository = repository,
       super(ThemeState(settings: ThemeSettings.defaultTactical()));

  final ThemeRepository _repository;

  /// Loads the persisted theme settings.
  Future<void> initialize() async {
    final settings = await _repository.loadSettings();
    emit(ThemeState(settings: settings));
  }

  /// Updates the accent color.
  Future<void> updateAccentColor(Color color) async {
    final newSettings = state.settings.copyWith(accentColor: color);
    emit(ThemeState(settings: newSettings));
    await _repository.saveSettings(newSettings);
  }

  /// Updates the highlight color.
  Future<void> updateHighlightColor(Color color) async {
    final newSettings = state.settings.copyWith(highlightColor: color);
    emit(ThemeState(settings: newSettings));
    await _repository.saveSettings(newSettings);
  }

  /// Updates the model roughness.
  Future<void> updateRoughness(double roughness) async {
    final newSettings = state.settings.copyWith(modelRoughness: roughness);
    emit(ThemeState(settings: newSettings));
    await _repository.saveSettings(newSettings);
  }
}
