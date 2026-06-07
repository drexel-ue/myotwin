import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_core/shared_core.dart';

/// A service that provides semantic enrichment for anatomical data.
///
/// Loads a pre-compiled mapping of medical mesh IDs to user-friendly layman terms.
class AnatomySemanticService extends ChangeNotifier {
  /// Creates an [AnatomySemanticService].
  AnatomySemanticService({
    required LoggerService logger,
  }) : _logger = logger;

  final LoggerService _logger;

  /// Internal index of translated nodes
  final Map<String, AnatomyNode> _index = {};

  /// Whether the mapping is loaded and ready for search.
  bool _isReady = false;

  /// Whether the mapping is loaded and ready for search.
  bool get isReady => _isReady;

  /// Loads the semantic map from a JSON string.
  ///
  /// Typically called during the boot sequence using a bundled asset.
  void load(String jsonString) {
    _logger.info('SEMANTIC_SERVICE: LOADING_PRECOMPILED_MAP');

    try {
      final data = jsonDecode(jsonString) as List<dynamic>;
      for (final dynamic item in data) {
        if (item is Map<String, dynamic>) {
          final node = AnatomyNode.fromJson(item);
          _index[node.id] = node;
        }
      }
      _isReady = true;
      _logger.success('SEMANTIC_SERVICE: MAP_LOADED_TOTAL_${_index.length}_NODES');
      notifyListeners();
    } catch (e, stack) {
      _logger.error('SEMANTIC_SERVICE: FAILED_TO_LOAD_MAP', error: e, stackTrace: stack);
    }
  }

  /// Searches for nodes matching the query and optional layer filter.
  List<AnatomyNode> search(String query, {AnatomyLayer? layer}) {
    final term = query.toLowerCase();

    return _index.values.where((node) {
      if (layer != null && node.layer != layer) return false;
      if (term.isEmpty) return true;

      return node.laymanName.toLowerCase().contains(term) ||
             node.id.toLowerCase().contains(term) ||
             node.regions.any((r) => r.toLowerCase().contains(term));
    }).toList();
  }

  /// Returns all nodes in the index.
  List<AnatomyNode> getAll() => _index.values.toList();
}
