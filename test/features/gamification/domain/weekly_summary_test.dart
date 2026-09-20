import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/gamification/domain/weekly_summary.dart';

void main() {
  group('weeklySummaryFor', () {
    test('computes deltas over the week-start baseline', () {
      const profile = GamificationProfile(
        totalXp: 150,
        lessonsCompletedCount: 5,
        projectsPublishedCount: 2,
        xpAtWeekStart: 100,
        lessonsAtWeekStart: 3,
        projectsAtWeekStart: 1,
      );

      final summary = weeklySummaryFor(profile);

      expect(summary.xpThisWeek, 50);
      expect(summary.lessonsThisWeek, 2);
      expect(summary.projectsThisWeek, 1);
    });

    test('is all zero right after the baseline is reset', () {
      const profile = GamificationProfile(
        totalXp: 100,
        lessonsCompletedCount: 3,
        xpAtWeekStart: 100,
        lessonsAtWeekStart: 3,
      );

      final summary = weeklySummaryFor(profile);

      expect(summary.xpThisWeek, 0);
      expect(summary.lessonsThisWeek, 0);
    });
  });

  group('shouldResetWeekBaseline', () {
    test('true when there is no baseline yet', () {
      expect(shouldResetWeekBaseline(null, DateTime(2026, 1, 10)), isTrue);
    });

    test('false within the same 7-day window', () {
      expect(shouldResetWeekBaseline(DateTime(2026, 1, 1), DateTime(2026, 1, 5)), isFalse);
    });

    test('true exactly 7 days after the baseline', () {
      expect(shouldResetWeekBaseline(DateTime(2026, 1, 1), DateTime(2026, 1, 8)), isTrue);
    });

    test('true well after the baseline', () {
      expect(shouldResetWeekBaseline(DateTime(2026, 1, 1), DateTime(2026, 2, 1)), isTrue);
    });
  });
}
