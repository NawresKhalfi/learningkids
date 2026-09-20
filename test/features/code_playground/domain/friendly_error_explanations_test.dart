import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/friendly_error_explanations.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  test('known Python error types have a French explanation', () {
    for (final type in ['NameError', 'SyntaxError', 'IndentationError', 'TypeError']) {
      expect(
        friendlyErrorExplanation(ProgrammingLanguage.python, type),
        isNotNull,
        reason: type,
      );
    }
  });

  test('known JavaScript error types have a French explanation', () {
    for (final type in ['ReferenceError', 'SyntaxError', 'TypeError']) {
      expect(
        friendlyErrorExplanation(ProgrammingLanguage.javascript, type),
        isNotNull,
        reason: type,
      );
    }
  });

  test('an unknown error type has no explanation rather than a wrong one', () {
    expect(friendlyErrorExplanation(ProgrammingLanguage.python, 'SomeMadeUpError'), isNull);
    expect(friendlyErrorExplanation(ProgrammingLanguage.python, null), isNull);
  });

  test('HTML never has an explanation (no JS-style exceptions surfaced there)', () {
    expect(friendlyErrorExplanation(ProgrammingLanguage.html, 'TypeError'), isNull);
  });
}
