import 'package:myotwin_ui/src/theme/icon_registry_data.dart';

/// A fast, synchronous search engine for resolving semantic intent into physical SVG paths.
class IconRegistry {
  /// Default asset.
  static const placeholderPath = 'assets/icons/phosphor/thin/placeholder-thin.svg';

  /// Fuzzy-matches a semantic query (e.g., "heart rate monitor") against the
  /// compiled icon manifest. Returns the asset path with the highest relevance score,
  /// or null if no match is found.
  static String? findBestMatch(String query, {int minimumConfidence = 0}) {
    if (query.trim().isEmpty) return null;

    // Normalize the query and split it into discrete, searchable terms
    final queryWords = query.toLowerCase().split(RegExp(r'\W+')).where((w) => w.isNotEmpty).toList();

    String? bestMatch;
    var highestScore = 0;

    for (final entry in IconRegistryData.manifest.entries) {
      final path = entry.key;
      final tags = entry.value;
      var score = 0;

      for (final word in queryWords) {
        for (final tag in tags) {
          if (tag == word) {
            score += 5; // Heavily weight exact concept matches
          } else if (tag.startsWith(word)) {
            score += 2; // Medium weight for root words (e.g., "medi" matching "medical")
          } else if (tag.contains(word) || word.contains(tag)) {
            score += 1; // Low weight for generic substring overlap
          }
        }
      }

      if (score > highestScore) {
        highestScore = score;
        bestMatch = path;
      }
    }

    // Require a minimum confidence threshold to avoid completely irrelevant matches
    return highestScore > minimumConfidence ? bestMatch : null;
  }
}
