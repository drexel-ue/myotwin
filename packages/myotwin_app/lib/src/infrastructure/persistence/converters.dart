import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:shared_core/shared_core.dart';

/// Maps the [GoalMetadata] extension type to a JSON string for SQLite storage.
class GoalMetadataConverter extends TypeConverter<GoalMetadata, String> {
  /// Creates a [GoalMetadataConverter].
  const GoalMetadataConverter();

  @override
  GoalMetadata fromSql(String fromDb) {
    return GoalMetadata(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(GoalMetadata value) {
    return json.encode(value.data);
  }
}

/// Maps the [IntentPayload] extension type to a JSON string for SQLite storage.
class IntentPayloadConverter extends TypeConverter<IntentPayload, String> {
  /// Creates an [IntentPayloadConverter].
  const IntentPayloadConverter();

  @override
  IntentPayload fromSql(String fromDb) {
    return IntentPayload(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(IntentPayload value) {
    return json.encode(value.data);
  }
}
