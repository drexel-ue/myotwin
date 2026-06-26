
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

/// Main entrypoint for the Motus Hub server.
///
/// Starts a Dart HTTP server with REST and WebSocket endpoints.
/// Exposes tool calling endpoints for Motus inference orchestration.
Future<void> main([List<String> args = const []]) async {
  final port = int.tryParse(args.firstOrNull ?? '8080') ?? 8080;

  // The path to the local models directory
  final modelsDir = Directory('packages/motus_server/assets/models');
  if (!modelsDir.existsSync()) {
    modelsDir.createSync(recursive: true);
  }

  // Create a static handler to serve raw model files (e.g., .gguf)
  final staticModelsHandler = createStaticHandler(
    modelsDir.path,
  );

  final router = Router()
    // Health check endpoint
    ..get('/health', (_, _) async {
      return shelf.Response.ok('Motus Hub is running');
    })
    // Catalog endpoint to list available models
    ..get('/models/catalog', (_, _) async {
      final files = modelsDir.listSync().whereType<File>();
      final catalog = files
          .map((f) => f.uri.pathSegments.last)
          .where((name) => name.endsWith('.gguf'))
          .toList();
      return shelf.Response.ok(
        jsonEncode({'models': catalog}),
        headers: {'Content-Type': 'application/json'},
      );
    })
    // Tool calling endpoints
    ..post('/tools/calculate_torque_load', (_, _) async {
      return shelf.Response.ok('{"result": 0.0}');
    })
    ..post('/tools/get_progression_step', (_, _) async {
      return shelf.Response.ok('{"result": ""}');
    })
    ..post('/tools/calculate_safety_margin', (_, _) async {
      return shelf.Response.ok('{"result": 0.0}');
    })
    ..post('/tools/get_anatomical_integrity', (_, _) async {
      return shelf.Response.ok('{"result": "{}"}');
    })
    ..post('/tools/fetch_injury_vault', (_, _) async {
      return shelf.Response.ok('{"result": "[]"}');
    })
    ..post('/tools/get_equipment_status', (_, _) async {
      return shelf.Response.ok('{"result": "{}"}');
    })
    // Query research library (RAG)
    ..post('/tools/query_research_library', (_, _) async {
      return shelf.Response.ok('{"result": "[]"}');
    })
    // Create hypothesis
    ..post('/tools/create_hypothesis', (_, _) async {
      return shelf.Response.ok('{"result": ""}');
    })
    // Update hypothesis certainty
    ..post('/tools/update_hypothesis_certainty', (_, _) async {
      return shelf.Response.ok('{"result": true}');
    })
    // Context snapshot
    ..get('/context/snapshot', (_, _) async {
      return shelf.Response.ok('{"injury_vault": {}, "equipment_registry": {}}');
    });

  // Cascade to serve static files if the router doesn't match
  final cascade = shelf.Cascade()
      .add(router.call)
      .add((request) {
        // Intercept requests to /models/* and route to static handler
        if (request.url.path.startsWith('models/')) {
          final newRequest = request.change(path: 'models');
          return staticModelsHandler(newRequest);
        }
        return shelf.Response.notFound('Not found');
      });

  final handler = const shelf.Pipeline().addMiddleware(shelf.logRequests()).addHandler(cascade.handler);

  final server = await shelf_io.serve(handler, 'localhost', port);
  developer.log('Motus Hub listening on http://${server.address}:${server.port}');
}
