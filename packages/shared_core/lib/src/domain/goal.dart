import 'package:shared_core/src/domain/enums.dart';
import 'package:shared_core/src/domain/extension_types.dart';
import 'package:shared_core/src/domain/intent_record.dart';

/// Represents a long-term biological or performance objective.
///
/// Goals are the parent containers for all [IntentRecord]s, hypotheses,
/// and progress records tracked by Motus.
class Goal {
  /// Creates a [Goal].
  const Goal({
    required this.id,
    required this.label,
    this.status = GoalStatus.active,
    this.metadata = const GoalMetadata({}),
    required this.createdAt,
    this.updatedAt,
  });

  /// Unique identifier for this goal.
  final String id;

  /// Human-readable label (e.g., "Left Shoulder Recovery").
  final String label;

  /// Current lifecycle state.
  final GoalStatus status;

  /// Flexible, Motus-shaped data (JSONB) — evolves without migrations.
  final GoalMetadata metadata;

  /// When the goal was first established.
  final DateTime createdAt;

  /// When the goal was last updated by Motus or the user.
  final DateTime? updatedAt;

  /// Helper to create a copy of the goal with updated fields.
  Goal copyWith({
    String? label,
    GoalStatus? status,
    GoalMetadata? metadata,
    DateTime? updatedAt,
  }) {
    return Goal(
      id: id,
      label: label ?? this.label,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
