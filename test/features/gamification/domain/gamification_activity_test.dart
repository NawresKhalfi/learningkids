import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/gamification_activity.dart';

void main() {
  test('every activity awards a positive amount of XP (US47)', () {
    for (final activity in GamificationActivity.values) {
      expect(xpForActivity(activity), greaterThan(0));
    }
  });
}
