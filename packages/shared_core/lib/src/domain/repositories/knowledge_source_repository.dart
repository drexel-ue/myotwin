import 'package:shared_core/core.dart';

/// Data access interface for KnowledgeSource entities.
/// Manages user-ingested data such as PDFs, text, and URLs.
abstract class KnowledgeSourceRepository {
  /// Fetches knowledge sources whose category matches [category].
  Future<List<KnowledgeSourceEntity>> getByCategory(String category);

  /// Fetches all knowledge sources.
  Future<List<KnowledgeSourceEntity>> getAll();

  /// Ingests a new knowledge source.
  ///
  /// [contentType] describes the type (e.g. PDF, URL, text).
  /// [content] is the raw content to ingest.
  /// [title] and [category] are optional metadata.
  Future<int> ingest({
    required String contentType,
    required String content,
    String? title,
    String? category,
  });

  /// Deletes the knowledge source with the given [id].
  Future<void> delete(int id);
}
