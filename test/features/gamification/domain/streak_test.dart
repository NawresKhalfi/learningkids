import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/streak.dart';

void main() {
  final monday = DateTime(2026, 1, 5);
  final tuesday = DateTime(2026, 1, 6);
  final wednesday = DateTime(2026, 1, 7);
  final friday = DateTime(2026, 1, 9);

  group('recordActivityDay', () {
    test('the very first activity starts a streak of 1', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(streak.current, 1);
      expect(streak.longest, 1);
      expect(streak.lastActiveDate, monday);
    });

    test('a second activity the same day changes nothing', () {
      final first = recordActivityDay(const Streak(), monday);
      final second = recordActivityDay(first, DateTime(2026, 1, 5, 18));
      expect(second.current, 1);
    });

    test('an activity the next day extends the streak', () {
      final day1 = recordActivityDay(const Streak(), monday);
      final day2 = recordActivityDay(day1, tuesday);
      expect(day2.current, 2);
      expect(day2.longest, 2);
    });

    test('a gap of more than one day resets the streak to 1', () {
      final day1 = recordActivityDay(const Streak(), monday);
      final day2 = recordActivityDay(day1, tuesday);
      final afterGap = recordActivityDay(day2, friday);
      expect(afterGap.current, 1);
    });

    test('longest never decreases even after the streak resets', () {
      final day1 = recordActivityDay(const Streak(), monday);
      final day2 = recordActivityDay(day1, tuesday);
      final day3 = recordActivityDay(day2, wednesday);
      final afterGap = recordActivityDay(day3, friday);
      expect(afterGap.current, 1);
      expect(afterGap.longest, 3);
    });
  });

  group('isStreakAtRisk', () {
    test('false when there is no streak yet', () {
      expect(isStreakAtRisk(const Streak(), tuesday), isFalse);
    });

    test('false the same day the streak was extended', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(isStreakAtRisk(streak, monday), isFalse);
    });

    test('true exactly one day after the last activity', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(isStreakAtRisk(streak, tuesday), isTrue);
    });

    test('false once the streak has already broken (gap > 1 day)', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(isStreakAtRisk(streak, friday), isFalse);
    });
  });

  group('isStreakBroken', () {
    test('false within a day of the last activity', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(isStreakBroken(streak, tuesday), isFalse);
    });

    test('true once more than a day has passed with no activity', () {
      final streak = recordActivityDay(const Streak(), monday);
      expect(isStreakBroken(streak, friday), isTrue);
    });
  });
}
