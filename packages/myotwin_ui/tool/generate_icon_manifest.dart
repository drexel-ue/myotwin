// ignore_for_file: avoid_print tool file.

import 'dart:convert';
import 'dart:io';

void main() async {
  print('Initializing Mechatronic Icon Registry Generation...');

  final iconsDir = Directory('assets/icons');
  if (!iconsDir.existsSync()) {
    print('Error: Could not find assets/icons directory.');
    exit(1);
  }

  // 1. Load the Healthicons metadata
  final healthMetaFile = File('assets/icons/health/meta-data.json');
  final healthTagsMap = <String, List<String>>{};

  if (healthMetaFile.existsSync()) {
    final jsonString = await healthMetaFile.readAsString();
    final jsonList = (jsonDecode(jsonString) as List).cast<Map<String, dynamic>>();

    for (final item in jsonList) {
      final id = item['id'] as String;
      final tags = (item['tags'] as List).cast<String>();
      final title = item['title'] as String;

      // Combine the title and explicit tags into a single searchable list
      final allTags = tags.map((e) => e.toLowerCase()).toList()..add(title.toLowerCase());
      healthTagsMap[id] = allTags;
    }
    print('Loaded metadata for ${healthTagsMap.length} Healthicons.');
  }

  final unifiedRegistry = <String, List<String>>{};

  // 2. Crawl all SVG files
  final files = iconsDir.listSync(recursive: true);
  var count = 0;

  for (final file in files) {
    if (file is File && file.path.endsWith('.svg')) {
      // Normalize path for Flutter assets
      final assetPath = file.path.replaceAll(r'\', '/');
      final filename = file.uri.pathSegments.last;
      final iconId = filename.replaceAll('.svg', '');

      final searchTags = <String>{};

      // Add the raw filename parts as base tags (e.g., 'shield-check' -> 'shield', 'check')
      final filenameParts = iconId.split(RegExp('[-_]'));
      searchTags.addAll(filenameParts.map((e) => e.toLowerCase()));

      // If it's a Healthicon, inject the rich metadata tags
      if (assetPath.contains('/health/')) {
        if (healthTagsMap.containsKey(iconId)) {
          searchTags.addAll(healthTagsMap[iconId]!);
        }
      }

      // Add the icon family for scoping (e.g., if the AI explicitly wants 'tabler')
      if (assetPath.contains('/phosphor/')) searchTags.add('phosphor');
      if (assetPath.contains('/tabler/')) searchTags.add('tabler');
      if (assetPath.contains('/health/')) searchTags.add('health');

      unifiedRegistry[assetPath] = searchTags.toList();
      count++;
    }
  }

  // 3. Generate the Dart output file
  final outputBuffer = StringBuffer()
    ..writeln('// AUTO-GENERATED FILE. DO NOT MODIFY.')
    ..writeln('// Generated on ${DateTime.now().toIso8601String()}')
    ..writeln()
    // Instructs the Dart formatter to skip this file
    ..writeln('// dart format off')
    // Instructs the Dart linter to ignore line lengths, missing consts, etc.
    ..writeln('// ignore_for_file: type=lint')
    ..writeln()
    ..writeln('class IconRegistryData {')
    ..writeln('  static const Map<String, List<String>> manifest = {');

  unifiedRegistry.forEach((path, tags) {
    // Format tags as a Dart list of strings
    final tagsString = tags.map((t) => "'${t.replaceAll("'", "")}'").join(', ');
    outputBuffer.writeln("    '$path': [$tagsString],");
  });

  outputBuffer
    ..writeln('  };')
    ..writeln('}');

  final outputFile = File('lib/src/theme/icon_registry_data.dart');
  await outputFile.create(recursive: true);
  await outputFile.writeAsString(outputBuffer.toString());

  print('Success! Compiled $count icons into ${outputFile.path}');
}
