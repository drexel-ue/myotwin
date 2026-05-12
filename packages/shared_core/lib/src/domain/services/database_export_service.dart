/// Service contract for local database export and import operations.
///
/// Enables users to back up and restore their entire biomechanical
/// coaching and recovery data on-device, supporting both JSON for
/// human-readable exchange and SQLite for fast bulk operations.
abstract class DatabaseExportService {
  /// Exports the entire database to a JSON file for backup or portable transfer.
  ///
  /// All coaching logs, muscle integrity scores, exercise history, and
  /// recovery state are serialized into a single JSON document.
  ///
  /// Returns the file path to the exported JSON file on local storage.
  Future<String> exportToJson();

  /// Exports the entire database to an SQLite file for backup or fast sync.
  ///
  /// Tables are dumped into a portable SQLite database file suitable for
  /// large-scale data transfer between MyoTwin instances on the same device.
  ///
  /// Returns the file path to the exported SQLite file on local storage.
  Future<String> exportToSqlite();

  /// Imports all data from a previously exported JSON file.
  ///
  /// [filePath] Path to the JSON file on local storage.
  ///
  /// Returns true if the import succeeded and all records were merged into
  /// the current database. Throws on malformed JSON or schema mismatch.
  Future<bool> importFromJson(String filePath);

  /// Imports all data from a previously exported SQLite file.
  ///
  /// [filePath] Path to the SQLite file on local storage.
  ///
  /// Returns true if the import succeeded and all tables were merged into
  /// the current database. Throws on incompatible schema or corrupted file.
  Future<bool> importFromSqlite(String filePath);
}
