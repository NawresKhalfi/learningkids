import 'execution_error.dart';

final _stackLinePattern = RegExp(r':(\d+):\d+\)?\s*$', multiLine: true);

/// Builds an [ExecutionError] from a JS engine's error name/message/stack
/// (US28). Unlike Python's traceback, WebKit's `Error.stack` for a
/// dynamically built function is often sparse, so the line number is a
/// best-effort regex match — `null` when it can't be found, rather than a
/// guess.
ExecutionError parseJavaScriptError({
  required String message,
  String? errorName,
  String? stack,
}) {
  final match = stack == null ? null : _stackLinePattern.firstMatch(stack);
  final line = match == null ? null : int.parse(match.group(1)!);
  return ExecutionError(line: line, errorType: errorName, message: message);
}
