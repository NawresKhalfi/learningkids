import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/notifications/domain/next_reminder_occurrence.dart';

void main() {
  test('schedules later today when the reminder time has not passed yet', () {
    final now = DateTime(2026, 3, 10, 9, 0);

    final next = nextReminderOccurrence(now, hour: 18, minute: 0);

    expect(next, DateTime(2026, 3, 10, 18, 0));
  });

  test('schedules tomorrow when the reminder time has already passed today', () {
    final now = DateTime(2026, 3, 10, 20, 0);

    final next = nextReminderOccurrence(now, hour: 18, minute: 0);

    expect(next, DateTime(2026, 3, 11, 18, 0));
  });

  test('schedules tomorrow when now is exactly the reminder time', () {
    final now = DateTime(2026, 3, 10, 18, 0);

    final next = nextReminderOccurrence(now, hour: 18, minute: 0);

    expect(next, DateTime(2026, 3, 11, 18, 0));
  });
}
