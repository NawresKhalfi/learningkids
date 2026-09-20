import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/data/shared_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/code_playground/domain/shared_snippet.dart';

void main() {
  test('shareSnippet stores it and fetchSnippet retrieves it by the generated id', () async {
    final repository = SharedSnippetRepository(firestore: FakeFirebaseFirestore());
    final id = await repository.shareSnippet(
      SharedSnippet(
        id: '',
        ownerUid: 'kid-1',
        pseudo: 'Léo',
        language: ProgrammingLanguage.javascript,
        code: "console.log('hi')",
        createdAt: DateTime.utc(2026, 3, 1),
      ),
    );

    final fetched = await repository.fetchSnippet(id);

    expect(fetched, isNotNull);
    expect(fetched!.ownerUid, 'kid-1');
    expect(fetched.code, "console.log('hi')");
  });

  test('fetchSnippet returns null for an unknown id', () async {
    final repository = SharedSnippetRepository(firestore: FakeFirebaseFirestore());
    expect(await repository.fetchSnippet('does-not-exist'), isNull);
  });
}
