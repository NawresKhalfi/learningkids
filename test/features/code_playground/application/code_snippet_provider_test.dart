import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/application/code_snippet_controller.dart';
import 'package:learningkids/features/code_playground/data/code_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        codeSnippetRepositoryProvider.overrideWithValue(
          CodeSnippetRepository(firestore: FakeFirebaseFirestore()),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authStateChangesProvider.future);
  });

  test('falls back to the starter code before anything is saved', () async {
    final code = await container.read(codeSnippetProvider(ProgrammingLanguage.python).future);
    expect(code, starterCodeFor(ProgrammingLanguage.python));
  });

  test('reflects a saved snippet once written', () async {
    final uid = container.read(authRepositoryProvider).currentUser!.uid;
    await container
        .read(codeSnippetRepositoryProvider)
        .saveCode(uid, ProgrammingLanguage.javascript, "console.log('hi')");

    final code = await container.read(codeSnippetProvider(ProgrammingLanguage.javascript).future);
    expect(code, "console.log('hi')");
  });
}
