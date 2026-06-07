import 'dart:convert';
import 'package:shared_core/shared_core.dart';

/// Orchestrates the persistence and retrieval of [ThemeSettings].
///
/// Bridges between [LocalStorageService] and the domain models.
class ThemeRepository {
  /// Creates [ThemeRepository].
  ThemeRepository({
    required LocalStorageService storage,
    required LoggerService logger,
  }) : _storage = storage,
       _logger = logger;

  final LocalStorageService _storage;
  final LoggerService _logger;

  static const String _storageKey = 'myotwin_theme_settings';

  /// Loads the persisted theme settings, or returns defaults if none exist.
  Future<ThemeSettings> loadSettings() async {
    _logger.detail('THEME_REPOSITORY: LOADING_SETTINGS');
    final raw = _storage.readString(_storageKey);
    
    if (raw == null) {
      _logger.info('THEME_REPOSITORY: NO_PERSISTED_SETTINGS_FOUND_USING_DEFAULTS');
      return ThemeSettings.defaultTactical();
    }

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ThemeSettings.fromJson(json);
    } catch (e, stack) {
      _logger.error('THEME_REPOSITORY: FAILED_TO_PARSE_SETTINGS', error: e, stackTrace: stack);
      return ThemeSettings.defaultTactical();
    }
  }

  /// Persists the given theme settings to disk.
  Future<void> saveSettings(ThemeSettings settings) async {
    _logger.detail('THEME_REPOSITORY: SAVING_SETTINGS: $settings');
    final raw = jsonEncode(settings.toJson());
    await _storage.writeString(_storageKey, raw);
  }
}
