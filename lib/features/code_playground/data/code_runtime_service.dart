import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../domain/code_execution_result.dart';
import '../domain/execution_error.dart';
import 'local_asset_server.dart';

/// Runs code inside a hidden [WebViewController] and reports the result
/// back over a `FlutterChannel` JS→Dart bridge (US27). Shared by the Python
/// (Pyodide) and plain-JavaScript runtimes, which differ only in which
/// host page they load, which JS function they call, and how they turn a
/// raw error string into an [ExecutionError] (US28).
///
/// The host page is served from a [LocalAssetServer] rather than via
/// `loadFlutterAsset` directly: Pyodide's script loading is rejected by
/// WKWebView's same-origin checks under that plugin's custom URL scheme
/// ("Cross-origin script load denied by Cross-Origin Resource Sharing
/// policy"), so it needs a real `http://127.0.0.1` origin instead.
///
/// A widget must keep a [WebViewWidget] built with [controller] in the
/// tree for the underlying platform WebView — and therefore this service —
/// to actually run anything; see `hidden_runtime_webview.dart`.
class CodeRuntimeService {
  CodeRuntimeService({
    required String assetPath,
    required this.jsFunctionName,
    required ExecutionError Function(Map<String, dynamic> resultData) parseError,
  }) : _parseError = parseError {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('FlutterChannel', onMessageReceived: _onMessage)
      ..setOnConsoleMessage(
        (message) => debugPrint('[$jsFunctionName console] ${message.level.name}: ${message.message}'),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) => debugPrint('[$jsFunctionName webResourceError] $error'),
        ),
      );
    final lastSlash = assetPath.lastIndexOf('/');
    _serve(assetDir: assetPath.substring(0, lastSlash), entryFile: assetPath.substring(lastSlash + 1));
  }

  final String jsFunctionName;
  final ExecutionError Function(Map<String, dynamic> resultData) _parseError;
  late final WebViewController controller;
  LocalAssetServer? _server;

  Future<void> _serve({required String assetDir, required String entryFile}) async {
    final server = await LocalAssetServer.start(assetDir: assetDir);
    _server = server;
    await controller.loadRequest(server.uriFor(entryFile));
  }

  final _readyCompleter = Completer<void>();
  final _pending = <String, Completer<CodeExecutionResult>>{};
  int _nextRequestId = 0;

  void _onMessage(JavaScriptMessage message) {
    final data = jsonDecode(message.message) as Map<String, dynamic>;
    switch (data['event']) {
      case 'ready':
        if (!_readyCompleter.isCompleted) _readyCompleter.complete();
      case 'loadError':
        debugPrint('[$jsFunctionName loadError] ${data['error']}');
      case 'result':
        final completer = _pending.remove(data['requestId'] as String);
        if (completer == null || completer.isCompleted) return;
        final stdout = data['stdout'] as String? ?? '';
        final rawError = data['error'] as String?;
        completer.complete(
          CodeExecutionResult(
            stdout: stdout,
            error: rawError == null ? null : _parseError(data),
          ),
        );
    }
  }

  /// Resolves once the runtime (interpreter/engine) has finished loading —
  /// exposed so the UI can show "chargement..." only for as long as that
  /// genuinely takes, instead of a fixed delay.
  Future<void> get ready => _readyCompleter.future;

  Future<CodeExecutionResult> run(String code) async {
    await ready;
    final requestId = (_nextRequestId++).toString();
    final completer = Completer<CodeExecutionResult>();
    _pending[requestId] = completer;
    await controller.runJavaScript('$jsFunctionName(${jsonEncode(requestId)}, ${jsonEncode(code)})');
    return completer.future;
  }

  void dispose() {
    for (final completer in _pending.values) {
      if (!completer.isCompleted) {
        completer.complete(const CodeExecutionResult(stdout: ''));
      }
    }
    _pending.clear();
    _server?.close();
  }
}
