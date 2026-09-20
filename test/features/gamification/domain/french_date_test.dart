import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/french_date.dart';

void main() {
  test('formats a date as a long French date', () {
    expect(formatFrenchDate(DateTime(2026, 9, 20)), '20 septembre 2026');
  });

  test('handles every month name', () {
    expect(formatFrenchDate(DateTime(2026, 1, 1)), '1 janvier 2026');
    expect(formatFrenchDate(DateTime(2026, 12, 31)), '31 décembre 2026');
  });
}
