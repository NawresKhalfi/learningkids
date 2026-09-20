import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  group('AuthRepository', () {
    test('signUpWithEmail creates a user and emits it on authStateChanges', () async {
      final mockAuth = MockFirebaseAuth();
      final repository = AuthRepository(firebaseAuth: mockAuth);

      final states = <String?>[];
      final subscription = repository.authStateChanges().listen(
            (user) => states.add(user?.email),
          );
      addTearDown(subscription.cancel);

      await repository.signUpWithEmail(email: 'kid@example.com', password: 'password1');
      await Future<void>.delayed(Duration.zero);

      expect(repository.currentUser?.email, 'kid@example.com');
      expect(states, contains('kid@example.com'));
    });

    test('signInWithEmail surfaces FirebaseAuthException as-is', () async {
      final mockAuth = MockFirebaseAuth();
      whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
          .on(mockAuth)
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));
      final repository = AuthRepository(firebaseAuth: mockAuth);

      expect(
        () => repository.signInWithEmail(email: 'kid@example.com', password: 'nope'),
        throwsA(isA<FirebaseAuthException>().having((e) => e.code, 'code', 'wrong-password')),
      );
    });

    test('signOut clears the current user', () async {
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'u1', email: 'kid@example.com'),
      );
      final repository = AuthRepository(firebaseAuth: mockAuth);
      expect(repository.currentUser, isNotNull);

      await repository.signOut();

      expect(repository.currentUser, isNull);
    });

    test('sendPasswordResetEmail delegates to FirebaseAuth', () async {
      final mockAuth = MockFirebaseAuth();
      final repository = AuthRepository(firebaseAuth: mockAuth);

      await expectLater(
        repository.sendPasswordResetEmail('kid@example.com'),
        completes,
      );
    });
  });
}
