// ignore_for_file: avoid_print test file.

import 'package:myotwin_ui/src/theme/icon_registry.dart';

void main() {
  print('=== ICON REGISTRY TEST ===\n');

  // 1. Standard Testing Batch
  final testQueries = [
    'heart', // Expected: A heart icon
    'settings', // Expected: A gear/slider icon
    'wifi error', // Expected: A disconnected network icon
    'biometric scan', // Expected: Fingerprint or eye scan
    'tank', // Expected: The healthicons tank (from your manifest)
    'virus', // Expected: The healthicons virus
    'quantum flux', // Expected: Placeholder (likely no matches)
    '', // Expected: Placeholder (empty query)
  ];

  print('--- Default Confidence (0) ---');
  for (final query in testQueries) {
    final result = IconRegistry.findBestMatch(query);

    // Formatting the output so it's easy to scan in the terminal
    final queryPadded = '"$query"'.padRight(20);
    print('Query: $queryPadded -> $result');
  }

  print('\n--- Minimum Confidence Thresholds ---');
  // 2. Testing the minimumConfidence threshold
  // 'net' might get a low score of 1 or 2 by partially matching 'network'
  const weakQuery = 'net';

  final weakResultDefault = IconRegistry.findBestMatch(weakQuery);
  final weakResultStrict = IconRegistry.findBestMatch(weakQuery, minimumConfidence: 4);

  print('Query: "$weakQuery" (Confidence 0)  -> $weakResultDefault');
  print('Query: "$weakQuery" (Confidence 4)  -> $weakResultStrict');

  print('\n======================================');
}
