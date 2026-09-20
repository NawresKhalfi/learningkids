import 'package:firebase_auth/firebase_auth.dart';

/// The auth error kinds the UI knows how to show a friendly message for.
///
/// Keeping this as an enum (instead of surfacing raw `FirebaseAuthException`
/// codes) lets `mapFirebaseAuthError` be unit tested and keeps the
/// presentation layer decoupled from Firebase's error taxonomy.
enum AuthFailure {
  invalidEmail,
  emailAlreadyInUse,
  weakPassword,
  invalidCredentials,
  tooManyRequests,
  requiresRecentLogin,
  cancelled,
  network,
  unknown,
}

AuthFailure mapFirebaseAuthError(Object error) {
  if (error is! FirebaseAuthException) {
    return AuthFailure.unknown;
  }
  switch (error.code) {
    case 'invalid-email':
      return AuthFailure.invalidEmail;
    case 'email-already-in-use':
      return AuthFailure.emailAlreadyInUse;
    case 'weak-password':
      return AuthFailure.weakPassword;
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return AuthFailure.invalidCredentials;
    case 'too-many-requests':
      return AuthFailure.tooManyRequests;
    case 'requires-recent-login':
      return AuthFailure.requiresRecentLogin;
    case 'network-request-failed':
      return AuthFailure.network;
    case 'sign_in_canceled':
    case 'canceled':
      return AuthFailure.cancelled;
    default:
      return AuthFailure.unknown;
  }
}
