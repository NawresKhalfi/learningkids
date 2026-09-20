import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  test('every language has a title and non-empty starter code', () {
    for (final language in ProgrammingLanguage.values) {
      expect(programmingLanguageTitle(language), isNotEmpty);
      expect(starterCodeFor(language), isNotEmpty);
    }
  });

  test('titles match the three languages named in the backlog (US26)', () {
    expect(programmingLanguageTitle(ProgrammingLanguage.python), 'Python');
    expect(programmingLanguageTitle(ProgrammingLanguage.javascript), 'JavaScript');
    expect(programmingLanguageTitle(ProgrammingLanguage.html), 'HTML');
  });
}
