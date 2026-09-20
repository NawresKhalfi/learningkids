import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/javascript_error_parser.dart';

void main() {
  test('uses the provided error name and message directly', () {
    final error = parseJavaScriptError(message: 'x is not defined', errorName: 'ReferenceError');

    expect(error.errorType, 'ReferenceError');
    expect(error.message, 'x is not defined');
  });

  test('extracts a line number from a stack trace when present', () {
    final error = parseJavaScriptError(
      message: 'x is not defined',
      errorName: 'ReferenceError',
      stack: 'ReferenceError: x is not defined\n    at eval (eval at <anonymous>, <anonymous>:3:1)',
    );

    expect(error.line, 3);
  });

  test('leaves the line null when the stack has no recognizable line info', () {
    final error = parseJavaScriptError(
      message: 'Script error.',
      errorName: null,
      stack: 'global code',
    );

    expect(error.line, isNull);
  });

  test('leaves the line null when there is no stack at all', () {
    final error = parseJavaScriptError(message: 'boom');

    expect(error.line, isNull);
    expect(error.errorType, isNull);
  });
}
