import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../data/parental_control_repository.dart';
import '../domain/parent_pin.dart';
import '../domain/parental_settings.dart';

/// The signed-in child's parental-control settings, re-subscribed whenever
/// the authenticated uid changes (same pattern as `currentProfileProvider`).
final parentalSettingsProvider = StreamProvider<ParentalSettings>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const ParentalSettings());
  return ref.watch(parentalControlRepositoryProvider).watchSettings(uid);
});

/// Usage minutes for the last 7 days, keyed by day, for the parent
/// dashboard (US08). `autoDispose` since it's only needed while the
/// dashboard is open.
final usageHistoryProvider = FutureProvider.autoDispose<Map<DateTime, int>>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Future.value(const {});
  return ref.watch(parentalControlRepositoryProvider).fetchUsageHistory(uid);
});

/// Drives the Espace Parent gate and settings (US07/US09).
class ParentalControlController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  String? get _uid => ref.read(authRepositoryProvider).currentUser?.uid;

  /// True if [pin] matches the stored PIN. False (never throws) if no PIN
  /// has been set yet — callers should offer PIN creation instead in that
  /// case, checked via `ParentalSettings.hasPin`.
  bool verifyPin(String pin) {
    final settings = ref.read(parentalSettingsProvider).valueOrNull;
    final uid = _uid;
    if (settings?.pinHash == null || uid == null) return false;
    return verifyParentPin(pin: pin, uid: uid, storedHash: settings!.pinHash!);
  }

  Future<void> createOrChangePin(String pin) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncValue.loading();
    try {
      await ref.read(parentalControlRepositoryProvider).setPin(uid, hashParentPin(pin, uid));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setDailyLimitMinutes(int minutes) async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncValue.loading();
    try {
      await ref.read(parentalControlRepositoryProvider).setDailyLimit(uid, minutes);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> clearDailyLimit() async {
    final uid = _uid;
    if (uid == null) return;
    state = const AsyncValue.loading();
    try {
      await ref.read(parentalControlRepositoryProvider).clearDailyLimit(uid);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final parentalControlControllerProvider =
    NotifierProvider<ParentalControlController, AsyncValue<void>>(
  ParentalControlController.new,
);
