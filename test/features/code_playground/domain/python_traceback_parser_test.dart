import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/python_traceback_parser.dart';

void main() {
  test('extracts the exception type, message and line from a simple traceback', () {
    const traceback = 'Traceback (most recent call last):\n'
        '  File "<exec>", line 1, in <module>\n'
        "NameError: name 'x' is not defined";

    final error = parsePythonTraceback(traceback);

    expect(error.line, 1);
    expect(error.errorType, 'NameError');
    expect(error.message, "name 'x' is not defined");
  });

  test('uses the innermost (last) line number for a multi-frame traceback', () {
    const traceback = 'Traceback (most recent call last):\n'
        '  File "<exec>", line 3, in <module>\n'
        '  File "<exec>", line 2, in foo\n'
        'ZeroDivisionError: division by zero';

    final error = parsePythonTraceback(traceback);

    expect(error.line, 2);
    expect(error.errorType, 'ZeroDivisionError');
  });

  test('handles a SyntaxError traceback that has no "Traceback" header', () {
    const traceback = '  File "<exec>", line 2\n'
        '    print(\n'
        '         ^\n'
        'SyntaxError: unexpected EOF while parsing';

    final error = parsePythonTraceback(traceback);

    expect(error.line, 2);
    expect(error.errorType, 'SyntaxError');
    expect(error.message, 'unexpected EOF while parsing');
  });

  test('falls back gracefully when the text does not look like a traceback', () {
    final error = parsePythonTraceback('something unexpected');

    expect(error.line, isNull);
    expect(error.errorType, isNull);
    expect(error.message, 'something unexpected');
  });
}
