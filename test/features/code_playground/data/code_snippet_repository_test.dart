import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/data/code_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  late CodeSnippetRepository repository;

  setUp(() {
    repository = CodeSnippetRepository(firestore: FakeFirebaseFirestore());
  });

  test('fetchCode returns null before anything has been saved', () async {
    final code = await repository.fetchCode('uid-1', ProgrammingLanguage.python);
    expect(code, isNull);
  });

  test('saveCode then fetchCode round-trips the exact text, including empty', () async {
    await repository.saveCode('uid-1', ProgrammingLanguage.python, "print('hi')");
    expect(await repository.fetchCode('uid-1', ProgrammingLanguage.python), "print('hi')");

    await repository.saveCode('uid-1', ProgrammingLanguage.python, '');
    expect(await repository.fetchCode('uid-1', ProgrammingLanguage.python), '');
  });

  test('each language has its own independent snippet', () async {
    await repository.saveCode('uid-1', ProgrammingLanguage.python, 'python code');
    await repository.saveCode('uid-1', ProgrammingLanguage.javascript, 'js code');

    expect(await repository.fetchCode('uid-1', ProgrammingLanguage.python), 'python code');
    expect(await repository.fetchCode('uid-1', ProgrammingLanguage.javascript), 'js code');
    expect(await repository.fetchCode('uid-1', ProgrammingLanguage.html), isNull);
  });
}
