import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/gamification/domain/streak.dart';

void main() {
  test('a fresh profile starts at zero for everything', () {
    const profile = GamificationProfile();
    expect(profile.totalXp, 0);
    expect(profile.streak.current, 0);
    expect(profile.lessonsCompletedCount, 0);
    expect(profile.projectsPublishedCount, 0);
    expect(profile.unlockedBadgeIds, isEmpty);
    expect(profile.leaderboardOptOut, isFalse);
  });

  test('toMap/fromMap round-trips every field, including the streak and weekly baseline', () {
    final profile = GamificationProfile(
      totalXp: 140,
      streak: Streak(current: 3, longest: 5, lastActiveDate: DateTime.utc(2026, 1, 5)),
      lessonsCompletedCount: 4,
      projectsPublishedCount: 2,
      unlockedBadgeIds: const {'first-lesson', 'streak-3'},
      leaderboardOptOut: true,
      weekStartDate: DateTime.utc(2026, 1, 1),
      xpAtWeekStart: 100,
      lessonsAtWeekStart: 2,
      projectsAtWeekStart: 1,
    );

    final restored = GamificationProfile.fromMap(profile.toMap());

    expect(restored.totalXp, 140);
    expect(restored.streak.current, 3);
    expect(restored.streak.longest, 5);
    expect(restored.streak.lastActiveDate, DateTime.utc(2026, 1, 5));
    expect(restored.lessonsCompletedCount, 4);
    expect(restored.projectsPublishedCount, 2);
    expect(restored.unlockedBadgeIds, {'first-lesson', 'streak-3'});
    expect(restored.leaderboardOptOut, isTrue);
    expect(restored.weekStartDate, DateTime.utc(2026, 1, 1));
    expect(restored.xpAtWeekStart, 100);
    expect(restored.lessonsAtWeekStart, 2);
    expect(restored.projectsAtWeekStart, 1);
  });

  test('fromMap falls back to sane defaults for missing fields', () {
    final restored = GamificationProfile.fromMap(const {});
    expect(restored.totalXp, 0);
    expect(restored.streak.lastActiveDate, isNull);
    expect(restored.unlockedBadgeIds, isEmpty);
  });

  test('copyWith only overrides the given fields', () {
    const profile = GamificationProfile(totalXp: 20, lessonsCompletedCount: 1);
    final updated = profile.copyWith(totalXp: 40);
    expect(updated.totalXp, 40);
    expect(updated.lessonsCompletedCount, 1);
  });
}
