import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../domain/auth_failure.dart';

/// Drives the auth forms/buttons: exposes a loading/error [AsyncValue] and
/// returns the mapped [AuthFailure] (or null on success) from each action so
/// screens can show an inline message without a separate listener.
class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<AuthFailure?> _run(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    try {
      await action();
      state = const AsyncValue.data(null);
      return null;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return mapFirebaseAuthError(error);
    }
  }

  Future<AuthFailure?> signUp({required String email, required String password}) =>
      _run(() => ref
          .read(authRepositoryProvider)
          .signUpWithEmail(email: email, password: password));

  Future<AuthFailure?> signIn({required String email, required String password}) =>
      _run(() => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: email, password: password));

  Future<AuthFailure?> signInWithGoogle() =>
      _run(() => ref.read(authRepositoryProvider).signInWithGoogle());

  Future<AuthFailure?> signInWithApple() =>
      _run(() => ref.read(authRepositoryProvider).signInWithApple());

  Future<AuthFailure?> sendPasswordResetEmail(String email) =>
      _run(() => ref.read(authRepositoryProvider).sendPasswordResetEmail(email));

  Future<AuthFailure?> signOut() =>
      _run(() => ref.read(authRepositoryProvider).signOut());

  Future<AuthFailure?> deleteAccount() =>
      _run(() => ref.read(authRepositoryProvider).deleteAccount());
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<void>>(AuthController.new);
