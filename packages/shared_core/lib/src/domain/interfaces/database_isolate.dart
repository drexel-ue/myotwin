import 'package:drift/drift.dart';
import 'package:shared_core/src/data/database.dart';

/// Interface for managing the MyoTwin database on a background isolate.
///
/// This ensures that all database operations (reads, writes, complex queries)
/// occur off the main UI thread, satisfying the 16ms performance rule.
abstract class DatabaseIsolate {
  /// Returns a handle to the database connection.
  ///
  /// This allows the caller to execute queries against the [MyoTwinDatabase]
  /// without worrying about the underlying isolate management.
  DatabaseConnection get connection;

  /// Closes the database connection and terminates the background isolate.
  Future<void> dispose();
}
