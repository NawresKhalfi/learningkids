import 'execution_error.dart';

final _lineNumberPattern = RegExp(r'line (\d+)');
final _exceptionPattern = RegExp(r'^(\w+(?:Error|Exception|Warning)):?\s*(.*)$');

/// Turns a raw Python/Pyodide traceback into a learner-facing
/// [ExecutionError] (US28): the innermost `line N` (closest to what the
/// learner actually wrote) and the exception type + message from the
/// traceback's last line.
ExecutionError parsePythonTraceback(String traceback) {
  final lineMatches = _lineNumberPattern.allMatches(traceback).toList();
  final line = lineMatches.isEmpty ? null : int.parse(lineMatches.last.group(1)!);

  final lines = traceback.trim().split('\n');
  final lastLine = lines.isEmpty ? '' : lines.last.trim();
  final match = _exceptionPattern.firstMatch(lastLine);

  if (match == null) {
    return ExecutionError(line: line, errorType: null, message: lastLine);
  }
  return ExecutionError(line: line, errorType: match.group(1), message: match.group(2) ?? '');
}
