import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';

/// Wraps `firebase_auth` plus the Google native sign-in SDK behind a
/// small surface the rest of the app depends on, so features never touch
/// the Firebase SDK types directly (see `domain/app_user.dart`).
class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Emits the current user immediately, then follows Firebase's own
  /// stream. Firebase's `authStateChanges()` already replays the current
  /// state to each new subscriber, but priming it ourselves keeps
  /// `go_router`'s redirect working under `MockFirebaseAuth` (whose
  /// broadcast stream does not replay past events) and removes any doubt
  /// about first-listener timing in production.
  Stream<AppUser?> authStateChanges() async* {
    yield _toAppUser(_firebaseAuth.currentUser);
    yield* _firebaseAuth.authStateChanges().map(_toAppUser);
  }

  AppUser? get currentUser => _toAppUser(_firebaseAuth.currentUser);

  AppUser? _toAppUser(User? user) => user == null
      ? null
      : AppUser(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // US01 requires email verification; sent as a side effect rather than
    // gating onboarding on it, so a new (young) user is never locked out
    // waiting on their inbox.
    await credential.user?.sendEmailVerification();
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) =>
      _firebaseAuth.sendPasswordResetEmail(email: email);

  Future<void> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) {
      throw FirebaseAuthException(code: 'sign_in_canceled');
    }
    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // Best-effort: throws if the user never signed in through Google (or,
    // in tests, if the plugin has no platform binding at all).
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  /// Requires a fresh sign-in; throws [AuthFailure.requiresRecentLogin] via
  /// `mapFirebaseAuthError` if the session is stale, in which case the UI
  /// should send the user back through login before retrying.
  Future<void> deleteAccount() async {
    await _firebaseAuth.currentUser?.delete();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);
