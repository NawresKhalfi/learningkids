import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/code_playground/domain/shared_snippet.dart';

void main() {
  test('toMap/fromMap round-trip preserves every field', () {
    final snippet = SharedSnippet(
      id: 'abc123',
      ownerUid: 'kid-1',
      pseudo: 'Léo',
      language: ProgrammingLanguage.python,
      code: "print('hello')",
      createdAt: DateTime.utc(2026, 3, 1, 10),
    );

    final restored = SharedSnippet.fromMap(snippet.id, snippet.toMap());

    expect(restored.id, snippet.id);
    expect(restored.ownerUid, snippet.ownerUid);
    expect(restored.pseudo, snippet.pseudo);
    expect(restored.language, snippet.language);
    expect(restored.code, snippet.code);
    expect(restored.createdAt, snippet.createdAt);
  });

  test('fromMap falls back to python for an unknown language string', () {
    final snippet = SharedSnippet.fromMap('id', {
      'ownerUid': 'kid-1',
      'pseudo': 'Léo',
      'language': 'not-a-language',
      'code': 'x = 1',
      'createdAt': DateTime.utc(2026).toIso8601String(),
    });

    expect(snippet.language, ProgrammingLanguage.python);
  });
}
