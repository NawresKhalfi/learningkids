import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/projects/domain/project_feedback_prompt.dart';

void main() {
  test('includes the project code and never asks for a full rewrite (US42)', () {
    const code = "print('hi')";
    final prompt = buildProjectFeedbackPrompt(language: ProgrammingLanguage.python, code: code);

    expect(prompt, contains(code));
    expect(prompt.toLowerCase(), contains('ne fournis pas de code corrigé complet'));
  });
}
