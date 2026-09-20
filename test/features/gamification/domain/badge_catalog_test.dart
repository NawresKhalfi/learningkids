import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/badge_catalog.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/gamification/domain/streak.dart';

void main() {
  test('badge ids are unique', () {
    final ids = badgeCatalog.map((b) => b.id).toSet();
    expect(ids, hasLength(badgeCatalog.length));
  });

  test('every badge has a title, description and emoji', () {
    for (final badge in badgeCatalog) {
      expect(badge.title, isNotEmpty, reason: badge.id);
      expect(badge.description, isNotEmpty, reason: badge.id);
      expect(badge.emoji, isNotEmpty, reason: badge.id);
    }
  });

  test('no badge is unlocked for a fresh profile', () {
    const profile = GamificationProfile();
    for (final badge in badgeCatalog) {
      expect(badge.isUnlocked(profile), isFalse, reason: badge.id);
    }
  });

  test('first-lesson unlocks after exactly one completed lesson', () {
    final badge = badgeCatalog.firstWhere((b) => b.id == 'first-lesson');
    expect(badge.isUnlocked(const GamificationProfile(lessonsCompletedCount: 1)), isTrue);
  });

  test('streak-3 unlocks from the longest streak ever reached, not just the current one', () {
    final badge = badgeCatalog.firstWhere((b) => b.id == 'streak-3');
    const profile = GamificationProfile(streak: Streak(current: 1, longest: 3));
    expect(badge.isUnlocked(profile), isTrue);
  });

  test('first-project unlocks after exactly one published project', () {
    final badge = badgeCatalog.firstWhere((b) => b.id == 'first-project');
    expect(badge.isUnlocked(const GamificationProfile(projectsPublishedCount: 1)), isTrue);
  });
}
