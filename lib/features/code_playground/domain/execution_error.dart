/// A parsed, learner-facing error (US28): which line it happened on (when
/// known), the raw error type (`NameError`, `SyntaxError`...), and a
/// message. [friendlyExplanation] adds the "why", looked up separately so
/// the parsers stay pure and testable without string catalogs.
class ExecutionError {
  const ExecutionError({required this.line, required this.errorType, required this.message});

  final int? line;
  final String? errorType;
  final String message;
}
