import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

/// Serves a directory of bundled Flutter assets over `http://127.0.0.1` so
/// WebViews load them with a real HTTP origin instead of `loadFlutterAsset`'s
/// custom URL scheme. Needed because Pyodide's dynamic script/worker loading
/// is rejected by WKWebView's same-origin checks under that custom scheme
/// ("Cross-origin script load denied by Cross-Origin Resource Sharing
/// policy") — iOS exempts loopback addresses from App Transport Security,
/// so no Info.plist changes are required.
class LocalAssetServer {
  LocalAssetServer._(this._server, this._assetDir);

  final HttpServer _server;
  final String _assetDir;

  static Future<LocalAssetServer> start({required String assetDir}) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final instance = LocalAssetServer._(server, assetDir);
    server.listen(instance._handle);
    return instance;
  }

  int get port => _server.port;

  Uri uriFor(String entryFile) => Uri(scheme: 'http', host: '127.0.0.1', port: port, path: '/$entryFile');

  Future<void> _handle(HttpRequest request) async {
    final requestedPath = request.uri.path == '/' ? '/index.html' : request.uri.path;
    try {
      final data = await rootBundle.load('$_assetDir$requestedPath');
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = _contentTypeFor(requestedPath)
        ..add(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    } on Object {
      request.response.statusCode = HttpStatus.notFound;
    }
    await request.response.close();
  }

  ContentType _contentTypeFor(String path) {
    if (path.endsWith('.js')) return ContentType('application', 'javascript');
    if (path.endsWith('.wasm')) return ContentType('application', 'wasm');
    if (path.endsWith('.json')) return ContentType('application', 'json');
    if (path.endsWith('.zip')) return ContentType('application', 'zip');
    if (path.endsWith('.html')) return ContentType('text', 'html');
    return ContentType.binary;
  }

  Future<void> close() => _server.close(force: true);
}
