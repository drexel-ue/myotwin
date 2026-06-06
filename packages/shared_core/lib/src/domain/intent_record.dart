import 'package:shared_core/src/domain/enums.dart';
import 'package:shared_core/src/domain/extension_types.dart';
import 'package:shared_core/src/domain/goal.dart';
import 'package:shared_core/src/infrastructure/logging/loggable.dart';

/// The bridge between Motus's intelligence and the Generative UI.
///
/// An [IntentRecord] is a database object created when Motus makes a decision.
/// it carries the "why" and the payload required to assemble a GenUI surface.
class IntentRecord implements Loggable {
  /// Creates an [IntentRecord].
  const IntentRecord({
    required this.id,
    required this.goalId,
    required this.type,
    this.payload = const IntentPayload({}),
    required this.scheduledTime,
    this.deliveredAt,
    this.userEngagementScore,
    this.reason = '',
    this.hypothesisIds = const [],
    this.researchNoteIds = const [],
  });

  /// Unique identifier for this intent decision.
  final String id;

  /// The parent [Goal] this decision serves.
  final String goalId;

  /// The type of surface interaction this intent describes.
  final IntentType type;

  /// The GenUI CatalogItem configuration payload.
  final IntentPayload payload;

  /// When this intent is eligible for delivery (determined by heuristic engine).
  final DateTime scheduledTime;

  /// When the intent was actually presented to the user.
  final DateTime? deliveredAt;

  /// Observed engagement (0.0 to 1.0), updated after user interaction.
  final double? userEngagementScore;

  /// Human-readable heuristic summary (the "why").
  final String reason;

  /// Scientific method records backing this decision.
  final List<String> hypothesisIds;

  /// Server-side research notes informing this decision.
  final List<String> researchNoteIds;

  /// Helper to mark the intent as delivered.
  IntentRecord markDelivered(DateTime time) {
    return copyWith(deliveredAt: time);
  }

  /// Helper to create a copy with updated fields.
  IntentRecord copyWith({
    DateTime? deliveredAt,
    double? userEngagementScore,
    IntentPayload? payload,
  }) {
    return IntentRecord(
      id: id,
      goalId: goalId,
      type: type,
      payload: payload ?? this.payload,
      scheduledTime: scheduledTime,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      userEngagementScore: userEngagementScore ?? this.userEngagementScore,
      reason: reason,
      hypothesisIds: hypothesisIds,
      researchNoteIds: researchNoteIds,
    );
  }

  @override
  String toDiagnosticString() => 'IntentRecord(id: $id, type: ${type.name}, reason: $reason)';

  @override
  String toSummaryString() => '[${type.name.toUpperCase()}] : $reason';

  @override
  String toString() => toDiagnosticString();
}
