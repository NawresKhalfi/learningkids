import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_assistant/domain/assistant_action.dart';
import 'package:learningkids/features/code_assistant/domain/assistant_prompt_builder.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';

void main() {
  group('buildSystemInstruction', () {
    test('adapts wording to the coding level', () {
      final beginner = buildSystemInstruction(codingLevel: CodingLevel.beginner);
      final comfortable = buildSystemInstruction(codingLevel: CodingLevel.comfortable);

      expect(beginner, isNot(equals(comfortable)));
      expect(beginner.toLowerCase(), contains('débute'));
      expect(comfortable.toLowerCase(), contains('aise'));
    });

    test('falls back to a beginner-friendly default when the level is unknown', () {
      final instruction = buildSystemInstruction();
      expect(instruction, isNotEmpty);
    });

    test('always states the on-topic, child-safe rules (US37)', () {
      final instruction = buildSystemInstruction(codingLevel: CodingLevel.someBasics);
      expect(instruction.toLowerCase(), contains('programmation'));
      expect(instruction.toLowerCase(), contains('bienveillant'));
    });
  });

  group('buildActionPrompt', () {
    const code = "print('hello')";

    test('every action includes the learner\'s code', () {
      for (final action in AssistantAction.values) {
        final prompt = buildActionPrompt(action: action, language: ProgrammingLanguage.python, code: code);
        expect(prompt, contains(code));
      }
    });

    test('each action produces a distinct prompt', () {
      final prompts = {
        for (final action in AssistantAction.values)
          action: buildActionPrompt(action: action, language: ProgrammingLanguage.python, code: code),
      };
      expect(prompts.values.toSet(), hasLength(AssistantAction.values.length));
    });

    test('findBug explicitly refuses to hand over the complete fix (US33)', () {
      final prompt = buildActionPrompt(action: AssistantAction.findBug, language: ProgrammingLanguage.python, code: code);
      expect(prompt.toLowerCase(), contains('ne donne surtout pas le code corrigé'));
    });

    test('suggestImprovement asks for a code block to propose a rewrite (US34)', () {
      final prompt = buildActionPrompt(
        action: AssistantAction.suggestImprovement,
        language: ProgrammingLanguage.python,
        code: code,
      );
      expect(prompt.toLowerCase(), contains('bloc de code'));
    });
  });
}
