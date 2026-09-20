import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/badge_catalog.dart';
import '../domain/badge_definition.dart';
import '../domain/gamification_activity.dart';
import '../domain/gamification_profile.dart';
import '../domain/level.dart';
import '../domain/streak.dart';
import '../domain/weekly_summary.dart';

/// What one call to [GamificationRepository.recordActivity] changed, for
/// callers that want to celebrate it (EP11/US58) — [leveledUpTo] is the new
/// level, or null if this activity didn't cross a level boundary.
typedef RecordActivityResult = ({List<BadgeDefinition> unlockedBadges, int? leveledUpTo});

/// Stores gamification state at `users/{uid}/gamification/summary` (EP08)
/// and mirrors it into the public `leaderboard/{uid}` collection (US46)
/// whenever the learner hasn't opted out (US48).
class GamificationRepository {
  GamificationRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid).collection('gamification').doc('summary');

  DocumentReference<Map<String, dynamic>> _leaderboardDoc(String uid) => _firestore.collection('leaderboard').doc(uid);

  Stream<GamificationProfile> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data == null ? const GamificationProfile() : GamificationProfile.fromMap(data);
    });
  }

  Future<GamificationProfile> _fetchProfile(String uid) async {
    final snapshot = await _doc(uid).get();
    final data = snapshot.data();
    return data == null ? const GamificationProfile() : GamificationProfile.fromMap(data);
  }

  /// Awards XP, extends the streak and unlocks any newly-earned badges for
  /// one completed activity (US43/US44/US47). Returns the badges unlocked
  /// by this call, if any, so the UI can celebrate them.
  Future<RecordActivityResult> recordActivity(
    String uid, {
    required GamificationActivity activity,
    required String pseudo,
    required String avatarId,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final current = await _fetchProfile(uid);
    // A rolling 7-day baseline for the weekly summary (US50): reset just
    // before applying this activity, so it always reflects the totals as
    // they stood at the start of the *current* window.
    final resetWeek = shouldResetWeekBaseline(current.weekStartDate, today);
    final withWeekBaseline = resetWeek
        ? current.copyWith(
            weekStartDate: today,
            xpAtWeekStart: current.totalXp,
            lessonsAtWeekStart: current.lessonsCompletedCount,
            projectsAtWeekStart: current.projectsPublishedCount,
          )
        : current;
    final updated = withWeekBaseline.copyWith(
      totalXp: current.totalXp + xpForActivity(activity),
      streak: recordActivityDay(current.streak, today),
      lessonsCompletedCount: activity == GamificationActivity.lessonCompleted
          ? current.lessonsCompletedCount + 1
          : current.lessonsCompletedCount,
      projectsPublishedCount: activity == GamificationActivity.projectPublished
          ? current.projectsPublishedCount + 1
          : current.projectsPublishedCount,
    );

    final newlyUnlocked = [
      for (final badge in badgeCatalog)
        if (!current.unlockedBadgeIds.contains(badge.id) && badge.isUnlocked(updated)) badge,
    ];
    final finalProfile = updated.copyWith(
      unlockedBadgeIds: {...updated.unlockedBadgeIds, for (final badge in newlyUnlocked) badge.id},
    );

    await _doc(uid).set(finalProfile.toMap(), SetOptions(merge: true));
    if (!finalProfile.leaderboardOptOut) {
      await _leaderboardDoc(
        uid,
      ).set({'pseudo': pseudo, 'avatarId': avatarId, 'totalXp': finalProfile.totalXp}, SetOptions(merge: true));
    }

    final oldLevel = levelForXp(current.totalXp);
    final newLevel = levelForXp(finalProfile.totalXp);
    return (unlockedBadges: newlyUnlocked, leveledUpTo: newLevel > oldLevel ? newLevel : null);
  }

  /// US48: a parent switches public-leaderboard visibility off/on. Off
  /// deletes the learner's public entry immediately; on re-publishes it
  /// from their current totals.
  Future<void> setLeaderboardOptOut(String uid, bool optOut, {required String pseudo, required String avatarId}) async {
    await _doc(uid).set({'leaderboardOptOut': optOut}, SetOptions(merge: true));
    if (optOut) {
      await _leaderboardDoc(uid).delete();
      return;
    }
    final profile = await _fetchProfile(uid);
    await _leaderboardDoc(
      uid,
    ).set({'pseudo': pseudo, 'avatarId': avatarId, 'totalXp': profile.totalXp}, SetOptions(merge: true));
  }
}

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) => GamificationRepository());
