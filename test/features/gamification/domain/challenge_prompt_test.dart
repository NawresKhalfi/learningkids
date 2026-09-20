import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/challenge_prompt.dart';

void main() {
  test('challengeCatalog is non-empty and well-formed', () {
    expect(challengeCatalog, isNotEmpty);
    for (final prompt in challengeCatalog) {
      expect(prompt.title, isNotEmpty);
      expect(prompt.description, isNotEmpty);
    }
  });

  test('isoWeekNumber matches known ISO-8601 week numbers', () {
    // 2026-01-01 is a Thursday, so it falls in week 1 of 2026.
    expect(isoWeekNumber(DateTime(2026, 1, 1)), 1);
    // 2025-12-29 (Monday) starts ISO week 1 of 2026, not week 53 of 2025.
    expect(isoWeekNumber(DateTime(2025, 12, 29)), 1);
    // 2024-01-01 (Monday) is ISO week 1 of 2024.
    expect(isoWeekNumber(DateTime(2024, 1, 1)), 1);
  });

  test('weekKeyFor is stable across every day of the same ISO week', () {
    final monday = DateTime(2026, 3, 2);
    final key = weekKeyFor(monday);
    for (var i = 0; i < 7; i++) {
      expect(weekKeyFor(monday.add(Duration(days: i))), key);
    }
    expect(weekKeyFor(monday.add(const Duration(days: 7))), isNot(key));
  });

  test('challengeForWeek is the same prompt for the whole week and cycles through the catalog', () {
    final monday = DateTime(2026, 3, 2);
    final prompt = challengeForWeek(monday);
    expect(challengeForWeek(monday.add(const Duration(days: 3))), prompt);
    expect(challengeCatalog, contains(prompt));
  });
}
