import 'package:shared_core/core.dart';

/// Repository interface for KnowledgeSource data access.
/// Manages user-ingested data (PDFs, text, URLs).
abstract class KnowledgeSourceRepository {
  /// Fetches all knowledge sources by category.
  Future<List<KnowledgeSourceEntity>> getByCategory(String category);

  /// Fetches all knowledge sources.
  Future<List<KnowledgeSourceEntity>> getAll();

  /// Ingests a new knowledge source.
  Future<int> ingest({
    required String contentType,
    required String content,
    String? title,
    String? category,
  });

  /// Deletes a knowledge source by ID.
  Future<void> delete(int id);
}
