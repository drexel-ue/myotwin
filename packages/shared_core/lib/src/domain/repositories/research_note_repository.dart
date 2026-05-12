import 'package:shared_core/core.dart';

/// Repository interface for ResearchNote data access.
/// Manages background auditor findings.
abstract class ResearchNoteRepository {
  /// Fetches all research notes.
  Future<List<ResearchNoteEntity>> getAll();

  /// Fetches notes related to a specific hypothesis.
  Future<List<ResearchNoteEntity>> getByHypothesisId(String hypothesisId);

  /// Saves a research note.
  Future<int> save(ResearchNoteEntity note);

  /// Deletes a research note by ID.
  Future<void> deleteNote(int id);
}
