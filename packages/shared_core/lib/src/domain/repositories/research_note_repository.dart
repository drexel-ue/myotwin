import 'package:shared_core/core.dart';

/// Data access interface for ResearchNote entities.
/// Manages background auditor findings.
abstract class ResearchNoteRepository {
  /// Fetches all research notes.
  Future<List<ResearchNoteEntity>> getAll();

  /// Fetches notes related to the hypothesis identified by [hypothesisId].
  Future<List<ResearchNoteEntity>> getByHypothesisId(String hypothesisId);

  /// Persists a new [note].
  ///
  /// Returns the note ID.
  Future<int> save(ResearchNoteEntity note);

  /// Deletes the research note with the given [id].
  Future<void> deleteNote(int id);
}
