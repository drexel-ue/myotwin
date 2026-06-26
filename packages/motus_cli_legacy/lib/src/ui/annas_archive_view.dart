import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:annas_archive_api/annas_archive_api.dart';
import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:dartatui/dartatui.dart';

import 'terminal_text.dart';
import 'layout_fixes.dart';
import 'terminal_button.dart';

class AnnasArchiveView extends StatefulWidget {
  final VoidCallback onBack;

  const AnnasArchiveView({super.key, required this.onBack});

  @override
  State<AnnasArchiveView> createState() => _AnnasArchiveViewState();
}

enum _ViewState {
  checkEnv,
  enterKey,
  enterQuery,
  searching,
  selectBook,
  downloading,
  done,
  error,
}

class _AnnasArchiveViewState extends State<AnnasArchiveView> {
  _ViewState _state = _ViewState.checkEnv;
  String _errorMessage = '';
  
  String _initialKey = '';
  
  List<Book> _books = [];
  Book? _selectedBook;
  String _downloadPath = '';

  @override
  void initState() {
    super.initState();
    _checkEnv();
  }

  void _checkEnv() {
    final env = DotEnv(includePlatformEnvironment: true)..load(['packages/motus_cli/.env']);
    final apiKey = env['ANNAS_ARCHIVE_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'your_api_key_here') {
      setState(() {
        _state = _ViewState.enterKey;
      });
    } else {
      _initialKey = apiKey;
      setState(() {
        _state = _ViewState.enterQuery;
      });
    }
  }

  void _saveKeyAndProceed(String key) {
    if (key.trim().isEmpty) return;
    
    final envFile = File('packages/motus_cli/.env');
    if (envFile.existsSync()) {
      var content = envFile.readAsStringSync();
      if (content.contains('ANNAS_ARCHIVE_KEY=')) {
        content = content.replaceAll(RegExp(r'ANNAS_ARCHIVE_KEY=.*'), 'ANNAS_ARCHIVE_KEY="$key"');
      } else {
        content += '\nANNAS_ARCHIVE_KEY="$key"\n';
      }
      envFile.writeAsStringSync(content);
    }
    setState(() {
      _state = _ViewState.enterQuery;
    });
  }

  Future<void> _search(String queryText) async {
    final query = queryText.trim();
    if (query.isEmpty) return;

    setState(() {
      _state = _ViewState.searching;
    });

    try {
      final annaApi = AnnaApi();
      final response = await annaApi.find(SearchRequest(query: query));
      _books = response.books;
      if (_books.isEmpty) {
        setState(() {
          _errorMessage = 'No books found for "$query".';
          _state = _ViewState.error;
        });
      } else {
        setState(() {
          _state = _ViewState.selectBook;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching: $e';
        _state = _ViewState.error;
      });
    }
  }

  Future<void> _downloadBook(Book book) async {
    setState(() {
      _selectedBook = book;
      _state = _ViewState.downloading;
    });

    try {
      final downloadApiUrl = Uri.parse('https://annas-archive.gd/dyn/api/fast_download.json?md5=${book.md5}&key=$_initialKey');
      
      final res = await http.get(downloadApiUrl);
      if (res.statusCode != 200 && res.statusCode != 204) {
        throw Exception('Fast download API error (Code: ${res.statusCode})\n${res.body}');
      }
      
      final json = jsonDecode(res.body);
      final downloadUrl = json['download_url'] as String?;
      if (downloadUrl == null) {
        throw Exception('Failed to get download URL: ${json['error']}');
      }

      final booksDir = Directory('packages/motus_cli/data/books');
      if (!booksDir.existsSync()) {
        booksDir.createSync(recursive: true);
      }

      final safeTitle = book.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final filename = '${safeTitle}_${book.md5}.${book.format.name}';
      final savePath = p.join(booksDir.path, filename);

      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await client.send(request);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download file (HTTP ${response.statusCode})');
      }

      final file = File(savePath);
      final sink = file.openWrite();
      await response.stream.pipe(sink);

      setState(() {
        _downloadPath = savePath;
        _state = _ViewState.done;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _state = _ViewState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;
    switch (_state) {
      case _ViewState.checkEnv:
        content = const TerminalText('Checking environment...');
        break;
      case _ViewState.enterKey:
        content = Column(
          children: [
            TerminalText('⚠️ Anna\'s Archive requires a member API key for fast downloads.', style: theme.headingStyle),
            const SizedBox(sHeight: 1),
            TerminalText('Enter your API Key:'),
            TextField(
              initialValue: _initialKey,
              onSubmitted: (val) {
                _initialKey = val; // Save it to use in download URL later
                _saveKeyAndProceed(val);
                return true;
              },
            ),
          ],
        );
        break;
      case _ViewState.enterQuery:
        content = Column(
          children: [
            TerminalText('🔍 Search Anna\'s Archive', style: theme.headingStyle),
            const SizedBox(sHeight: 1),
            TerminalText('Enter book title, author, or ISBN:'),
            TextField(
              onSubmitted: (val) { _search(val); return true; },
            ),
          ],
        );
        break;
      case _ViewState.searching:
        content = const TerminalText('⏳ Searching Anna\'s Archive...');
        break;
      case _ViewState.selectBook:
        // Use ScrollableColumn so we don't overflow the terminal
        content = Column(
          children: [
            TerminalText('📚 Select a book to download:', style: theme.headingStyle),
            const SizedBox(sHeight: 1),
            Expanded(
              child: ScrollableColumn(
                children: [
                  for (final book in _books)
                    TerminalButton(
                      label: '${book.title} by ${book.author} [${book.format.name}, ${book.size}]',
                      onPressed: () => _downloadBook(book),
                    ),
                ],
              ),
            ),
          ],
        );
        break;
      case _ViewState.downloading:
        content = TerminalText('📥 Downloading ${_selectedBook?.title}...\nThis may take a moment depending on the file size.');
        break;
      case _ViewState.done:
        content = Column(
          children: [
            TerminalText('✅ Download complete!', style: theme.headingStyle),
            const SizedBox(sHeight: 1),
            TerminalText('Saved to: $_downloadPath'),
          ],
        );
        break;
      case _ViewState.error:
        content = Column(
          children: [
            TerminalText('❌ Error', style: theme.headingStyle),
            const SizedBox(sHeight: 1),
            TerminalText(_errorMessage),
            const SizedBox(sHeight: 1),
            TerminalButton(
              label: 'Retry Search',
              onPressed: () {
                setState(() {
                  _state = _ViewState.enterQuery;
                });
              },
            ),
          ],
        );
        break;
    }

    return TerminalPadding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Expanded(child: content),
          const SizedBox(sHeight: 2),
          TerminalButton(label: 'Back to Menu', onPressed: widget.onBack),
        ],
      ),
    );
  }
}
