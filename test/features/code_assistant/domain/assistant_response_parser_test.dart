import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_assistant/domain/assistant_response_parser.dart';

void main() {
  test('extracts the code block and the surrounding explanation', () {
    final parsed = parseSuggestionResponse(
      "Utilise des noms plus clairs pour tes variables.\n\n```python\nprint('hi')\n```",
    );

    expect(parsed.suggestedCode, "print('hi')");
    expect(parsed.explanation, 'Utilise des noms plus clairs pour tes variables.');
  });

  test('returns the whole text as the explanation when there is no code block', () {
    final parsed = parseSuggestionResponse('Ton code est déjà très clair !');

    expect(parsed.suggestedCode, isNull);
    expect(parsed.explanation, 'Ton code est déjà très clair !');
  });

  test('only extracts the first code block when several are present', () {
    final parsed = parseSuggestionResponse('```python\nfirst\n```\ntexte\n```python\nsecond\n```');

    expect(parsed.suggestedCode, 'first');
  });
}
