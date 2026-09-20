import 'package:fake_async/fake_async.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/application/code_snippet_controller.dart';
import 'package:learningkids/features/code_playground/data/code_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  test('onCodeChanged only saves once typing pauses for ~800ms (US30)', () {
    final firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );

    fakeAsync((async) {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
          codeSnippetRepositoryProvider.overrideWithValue(
            CodeSnippetRepository(firestore: firestore),
          ),
        ],
      );
      addTearDown(container.dispose);
      final notifier = container.read(codeSnippetControllerProvider.notifier);

      notifier.onCodeChanged(ProgrammingLanguage.python, 'p');
      async.elapse(const Duration(milliseconds: 400));
      notifier.onCodeChanged(ProgrammingLanguage.python, 'pr');
      async.elapse(const Duration(milliseconds: 400));
      // Still within the debounce window of the second call: nothing saved yet.
      firestore
          .collection('users')
          .doc('kid-1')
          .collection('codePlayground')
          .doc('python')
          .get()
          .then((doc) => expect(doc.data(), isNull));
      async.flushMicrotasks();

      async.elapse(const Duration(milliseconds: 800));
      firestore
          .collection('users')
          .doc('kid-1')
          .collection('codePlayground')
          .doc('python')
          .get()
          .then((doc) => expect(doc.data()!['code'], 'pr'));
      async.flushMicrotasks();
    });
  });
}
