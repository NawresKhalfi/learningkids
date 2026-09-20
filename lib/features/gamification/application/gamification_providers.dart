import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../notifications/application/reward_notifier.dart';
import '../../profile/application/profile_controller.dart';
import '../data/gamification_repository.dart';
import '../data/leaderboard_repository.dart';
import '../domain/badge_definition.dart';
import '../domain/gamification_activity.dart';
import '../domain/gamification_profile.dart';
import '../domain/leaderboard_entry.dart';

/// The signed-in learner's XP/streak/badges (US43/US44/US47); an empty
/// profile while signed out or before any activity has been recorded.
final gamificationProfileProvider = StreamProvider<GamificationProfile>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const GamificationProfile());
  return ref.watch(gamificationRepositoryProvider).watchProfile(uid);
});

/// The top of the public leaderboard (US46).
final leaderboardProvider = StreamProvider<List<LeaderboardEntry>>((ref) {
  return ref.watch(leaderboardRepositoryProvider).watchTop();
});

class GamificationController extends Notifier<void> {
  @override
  void build() {}

  Future<RecordActivityResult> _record(GamificationActivity activity) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return (unlockedBadges: <BadgeDefinition>[], leveledUpTo: null);
    // Awaits the first snapshot rather than reading `.valueOrNull`, which
    // could still be null/loading the first time this runs in a fresh
    // container and would silently write an empty pseudo/avatar.
    final profile = await ref.read(currentProfileProvider.future);
    final result = await ref
        .read(gamificationRepositoryProvider)
        .recordActivity(uid, activity: activity, pseudo: profile?.pseudo ?? '', avatarId: profile?.avatar.name ?? '');

    // EP11/US58: celebrate what just happened, gated on the learner's own
    // preference (checked inside `RewardNotifier`).
    final rewardNotifier = ref.read(rewardNotifierProvider);
    for (final badge in result.unlockedBadges) {
      await rewardNotifier.notifyBadgeUnlocked(badge);
    }
    if (result.leveledUpTo != null) {
      await rewardNotifier.notifyLevelUp(result.leveledUpTo!);
    }
    return result;
  }

  /// Called once a module is *newly* completed (the caller must have
  /// already checked it wasn't completed before — see
  /// `LearningProgressController.markModuleCompleted`).
  Future<RecordActivityResult> recordLessonCompleted() => _record(GamificationActivity.lessonCompleted);

  /// Called once a project is *newly* published (the caller must have
  /// already checked `!project.isPublished` — see
  /// `ProjectsController.publish`).
  Future<RecordActivityResult> recordProjectPublished() => _record(GamificationActivity.projectPublished);

  /// US48: applied immediately from the parent space.
  Future<void> setLeaderboardOptOut(bool optOut) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    final profile = await ref.read(currentProfileProvider.future);
    await ref
        .read(gamificationRepositoryProvider)
        .setLeaderboardOptOut(uid, optOut, pseudo: profile?.pseudo ?? '', avatarId: profile?.avatar.name ?? '');
  }
}

final gamificationControllerProvider = NotifierProvider<GamificationController, void>(GamificationController.new);
