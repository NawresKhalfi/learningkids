import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/code_runtime_service.dart';
import '../domain/javascript_error_parser.dart';
import '../domain/python_traceback_parser.dart';

/// One hidden WebView-backed runtime per engine, scoped to how long the
/// Code Playground screen (the only place that watches these) stays open —
/// `autoDispose` so leaving the screen tears down the WebView rather than
/// keeping an idle Pyodide instance around for the rest of the session.
final pythonRuntimeServiceProvider = Provider.autoDispose<CodeRuntimeService>((ref) {
  final service = CodeRuntimeService(
    assetPath: 'assets/pyodide/index.html',
    jsFunctionName: 'runPython',
    parseError: (data) => parsePythonTraceback(data['error'] as String),
  );
  ref.onDispose(service.dispose);
  return service;
});

final javascriptRuntimeServiceProvider = Provider.autoDispose<CodeRuntimeService>((ref) {
  final service = CodeRuntimeService(
    assetPath: 'assets/code_playground/js_runtime.html',
    jsFunctionName: 'runJavaScript',
    parseError: (data) => parseJavaScriptError(
      message: data['error'] as String,
      errorName: data['errorName'] as String?,
      stack: data['stack'] as String?,
    ),
  );
  ref.onDispose(service.dispose);
  return service;
});
