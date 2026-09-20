import 'execution_error.dart';

/// What running a snippet produced (US27): whatever it printed, plus a
/// parsed error when it failed.
class CodeExecutionResult {
  const CodeExecutionResult({required this.stdout, this.error});

  const CodeExecutionResult.output(String stdout) : this(stdout: stdout);

  final String stdout;
  final ExecutionError? error;

  bool get hasError => error != null;
}
