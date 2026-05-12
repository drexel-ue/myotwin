/// Service for database export and import operations.
/// Exports the entire database as JSON or SQLite file.
abstract class DatabaseExportService {
  /// Exports the database to a JSON file.
  ///
  /// Returns the file path to the exported JSON.
  Future<String> exportToJson();

  /// Exports the database to an SQLite file.
  ///
  /// Returns the file path to the exported SQLite file.
  Future<String> exportToSqlite();

  /// Imports data from a JSON file.
  ///
  /// [filePath] Path to the JSON file.
  ///
  /// Returns true if import was successful.
  Future<bool> importFromJson(String filePath);

  /// Imports data from a SQLite file.
  ///
  /// [filePath] Path to the SQLite file.
  ///
  /// Returns true if import was successful.
  Future<bool> importFromSqlite(String filePath);
}
