import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/domain/auth_failure.dart';

void main() {
  group('mapFirebaseAuthError', () {
    test('maps known Firebase error codes', () {
      const cases = {
        'invalid-email': AuthFailure.invalidEmail,
        'email-already-in-use': AuthFailure.emailAlreadyInUse,
        'weak-password': AuthFailure.weakPassword,
        'user-not-found': AuthFailure.invalidCredentials,
        'wrong-password': AuthFailure.invalidCredentials,
        'invalid-credential': AuthFailure.invalidCredentials,
        'too-many-requests': AuthFailure.tooManyRequests,
        'requires-recent-login': AuthFailure.requiresRecentLogin,
        'network-request-failed': AuthFailure.network,
        'sign_in_canceled': AuthFailure.cancelled,
      };

      for (final entry in cases.entries) {
        expect(
          mapFirebaseAuthError(FirebaseAuthException(code: entry.key)),
          entry.value,
          reason: 'code ${entry.key}',
        );
      }
    });

    test('maps an unknown Firebase error code to unknown', () {
      expect(
        mapFirebaseAuthError(FirebaseAuthException(code: 'some-new-code')),
        AuthFailure.unknown,
      );
    });

    test('maps a non-Firebase error to unknown', () {
      expect(mapFirebaseAuthError(Exception('boom')), AuthFailure.unknown);
    });
  });
}
