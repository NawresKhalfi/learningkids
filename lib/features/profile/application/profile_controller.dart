import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../auth/domain/auth_failure.dart';
import '../data/profile_repository.dart';
import '../domain/avatar.dart';
import '../domain/user_profile.dart';

/// The signed-in user's profile document, kept in sync with Firestore and
/// re-subscribed whenever the authenticated uid changes (including on
/// sign-out, where it resolves to `null`).
final currentProfileProvider = StreamProvider<UserProfile?>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(profileRepositoryProvider).watchProfile(uid);
});

/// Drives the profile edit/delete actions (US04/US06).
class ProfileController extends Notifier<AsyncValue<void>> {
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

  Future<AuthFailure?> updateProfile({
    required String pseudo,
    required Avatar avatar,
  }) {
    return _run(() async {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      await ref.read(profileRepositoryProvider).updatePseudoAndAvatar(
            uid: uid,
            pseudo: pseudo,
            avatar: avatar,
          );
    });
  }

  /// Deletes the Firestore profile first (while still authenticated, since
  /// security rules key on the caller's uid), then the auth account itself.
  Future<AuthFailure?> deleteAccount() {
    return _run(() async {
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      await ref.read(profileRepositoryProvider).deleteProfile(uid);
      await ref.read(authRepositoryProvider).deleteAccount();
    });
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, AsyncValue<void>>(ProfileController.new);
