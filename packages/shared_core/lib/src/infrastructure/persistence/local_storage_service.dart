import 'package:shared_preferences/shared_preferences.dart';

/// A single-concern service for persistent key-value storage on disk.
///
/// Wraps [SharedPreferences] to provide a clean async interface for
/// application settings and small data payloads.
class LocalStorageService {
  /// Creates [LocalStorageService] with a pre-initialized instance.
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  /// Writes a string to local storage.
  Future<bool> writeString(String key, String value) => _prefs.setString(key, value);

  /// Reads a string from local storage.
  String? readString(String key) => _prefs.getString(key);

  /// Writes an integer to local storage.
  Future<bool> writeInt(String key, int value) => _prefs.setInt(key, value);

  /// Reads an integer from local storage.
  int? readInt(String key) => _prefs.getInt(key);

  /// Writes a double to local storage.
  Future<bool> writeDouble(String key, double value) => _prefs.setDouble(key, value);

  /// Reads a double from local storage.
  double? readDouble(String key) => _prefs.getDouble(key);

  /// Writes a boolean to local storage.
  Future<bool> writeBool(String key, {required bool value}) => _prefs.setBool(key, value);

  /// Reads a boolean from local storage.
  bool? readBool(String key) => _prefs.getBool(key);

  /// Removes a key from storage.
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Clears all stored data.
  Future<bool> clear() => _prefs.clear();
}
