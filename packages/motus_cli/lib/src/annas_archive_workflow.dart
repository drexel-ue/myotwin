import 'dart:io';
import 'package:interact/interact.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:annas_archive_api/annas_archive_api.dart';
import 'package:path/path.dart' as p;
import 'package:dotenv/dotenv.dart';
import 'menu_utils.dart';

Future<void> runAnnasArchiveWorkflow() async {
  print('\n--- Search & Download Book (Anna\'s Archive) ---');
  
  final env = DotEnv(includePlatformEnvironment: true)..load(['packages/motus_cli/.env']);
  // Prompt for API key if missing
  String? apiKey = env['ANNAS_ARCHIVE_KEY'];
  if (apiKey == null || apiKey.isEmpty || apiKey == 'your_api_key_here') {
    print('⚠️  Anna\'s Archive requires a member API key for fast downloads.');
    apiKey = Input(prompt: 'Enter your Anna\'s Archive API key:').interact();
    
    // Save to .env
    final envFile = File('packages/motus_cli/.env');
    if (envFile.existsSync()) {
      var content = envFile.readAsStringSync();
      if (content.contains('ANNAS_ARCHIVE_KEY=')) {
        content = content.replaceAll(RegExp(r'ANNAS_ARCHIVE_KEY=.*'), 'ANNAS_ARCHIVE_KEY="$apiKey"');
      } else {
        content += '\nANNAS_ARCHIVE_KEY="$apiKey"\n';
      }
      envFile.writeAsStringSync(content);
    }
  }

  final query = Input(prompt: 'Enter book title or author:').interact();
  if (query.trim().isEmpty) return;

  print('⏳ Searching Anna\'s Archive...');
  final annaApi = AnnaApi();
  List<Book> books = [];
  try {
    final response = await annaApi.find(SearchRequest(
      query: query,
    ));
    books = response.books;
  } catch (e) {
    print('❌ Error searching: $e');
    return;
  }

  if (books.isEmpty) {
    print('No books found for "$query".');
    return;
  }

  final options = books.map((b) => '${b.title} by ${b.author} [${b.format.name}, ${b.size}]').toList();
  options.add('Cancel');

  final selection = promptSelect(
    'Select a book to download:',
    options,
  );

  if (selection == options.length - 1) return;

  final selectedBook = books[selection];
  print('\n🚀 Preparing download for: ${selectedBook.title}');
  
  // Hit fast_download API
  final downloadApiUrl = Uri.parse('https://annas-archive.gd/dyn/api/fast_download.json?md5=${selectedBook.md5}&key=$apiKey');
  
  final res = await http.get(downloadApiUrl);
  if (res.statusCode != 200 && res.statusCode != 204) {
    print('❌ Fast download API error (Code: ${res.statusCode})');
    print(res.body);
    return;
  }
  
  final json = jsonDecode(res.body);
  final downloadUrl = json['download_url'] as String?;
  
  if (downloadUrl == null) {
    print('❌ Failed to get download URL: ${json['error']}');
    return;
  }

  print('📥 Downloading...');
  
  final booksDir = Directory('packages/motus_cli/data/books');
  if (!booksDir.existsSync()) {
    booksDir.createSync(recursive: true);
  }

  final safeTitle = selectedBook.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  final filename = '${safeTitle}_${selectedBook.md5}.${selectedBook.format.name}';
  final savePath = p.join(booksDir.path, filename);

  final client = http.Client();
  final request = http.Request('GET', Uri.parse(downloadUrl));
  final response = await client.send(request);
  
  if (response.statusCode != 200) {
    print('❌ Failed to download file (HTTP ${response.statusCode})');
    return;
  }

  final file = File(savePath);
  final sink = file.openWrite();
  
  print('📦 Saving to disk... This may take a moment depending on the file size.');
  await response.stream.pipe(sink);

  print('\n✅ Download complete! Saved to: $savePath');
}
