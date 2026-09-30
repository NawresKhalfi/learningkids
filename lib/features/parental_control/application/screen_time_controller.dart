import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../../auth/data/auth_repository.dart';
import '../data/parental_control_repository.dart';
import '../domain/screen_time_snapshot.dart';

/// Ticks once a minute while the app is in the foreground, crediting the
/// signed-in child's daily usage total (US09) so `app_router.dart` can
/// redirect to the blocking screen once the parent-set limit is reached.
///
/// Kept alive for the app's lifetime (not autoDispose) and instantiated by
/// `ScreenTimeTickerObserver`, which also reports foreground/background
/// transitions so time isn't credited while the app is backgrounded.
class ScreenTimeController extends AsyncNotifier<ScreenTimeSnapshot> {
  Timer? _timer;
  bool _isForeground = true;

  @override
  Future<ScreenTimeSnapshot> build() async {
    ref.onDispose(() => _timer?.cancel());
    _timer ??= Timer.periodic(const Duration(minutes: 1), (_) => _tick());
    return _loadSnapshot();
  }

  Future<ScreenTimeSnapshot> _loadSnapshot() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return const ScreenTimeSnapshot();
    final repo = ref.read(parentalControlRepositoryProvider);
    final settings = await repo.fetchSettings(uid);
    final todayMinutes = await repo.fetchTodayMinutes(uid);
    final extraGranted = await repo.isExtraGrantedToday(uid);
    return ScreenTimeSnapshot(
      todayMinutes: todayMinutes,
      dailyLimitMinutes: settings.dailyLimitMinutes,
      extraGrantedToday: extraGranted,
    );
  }

  void setForeground(bool isForeground) => _isForeground = isForeground;

  Future<void> _tick() async {
    if (!_isForeground) return;
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    final hasOnboarded =
        uid != null &&
        ref.read(localPreferencesProvider).hasCompletedOnboarding(uid);
    if (uid == null || !hasOnboarded) return;

    final newTotal = await ref
        .read(parentalControlRepositoryProvider)
        .incrementTodayMinutes(uid, 1);
    final current = state.valueOrNull ?? const ScreenTimeSnapshot();
    state = AsyncData(current.copyWith(todayMinutes: newTotal));
  }

  /// Lets the rest of today bypass the limit once a parent has confirmed
  /// their PIN on the blocking screen.
  Future<void> grantExtraTimeToday() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    await ref.read(parentalControlRepositoryProvider).grantExtraTimeToday(uid);
    final current = state.valueOrNull ?? const ScreenTimeSnapshot();
    state = AsyncData(current.copyWith(extraGrantedToday: true));
  }

  /// Re-reads settings (e.g. right after the parent changes the daily
  /// limit) without waiting for the next minute's tick.
  Future<void> refreshSettings() async {
    state = AsyncData(await _loadSnapshot());
  }
}

final screenTimeControllerProvider =
    AsyncNotifierProvider<ScreenTimeController, ScreenTimeSnapshot>(
      ScreenTimeController.new,
    );
