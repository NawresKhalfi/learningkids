import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/parental_control/domain/screen_time_snapshot.dart';

void main() {
  group('dateKey', () {
    test('pads month and day to two digits', () {
      expect(dateKey(DateTime(2026, 1, 5)), '2026-01-05');
      expect(dateKey(DateTime(2026, 12, 31)), '2026-12-31');
    });
  });

  group('ScreenTimeSnapshot.isLimitReached', () {
    test('is false when no limit has been set', () {
      const snapshot = ScreenTimeSnapshot(todayMinutes: 999);
      expect(snapshot.isLimitReached, isFalse);
    });

    test('is false while under the limit', () {
      const snapshot = ScreenTimeSnapshot(todayMinutes: 10, dailyLimitMinutes: 30);
      expect(snapshot.isLimitReached, isFalse);
    });

    test('is true once usage reaches the limit (US09: automatic blocking)', () {
      const snapshot = ScreenTimeSnapshot(todayMinutes: 30, dailyLimitMinutes: 30);
      expect(snapshot.isLimitReached, isTrue);
    });

    test('is true once usage exceeds the limit', () {
      const snapshot = ScreenTimeSnapshot(todayMinutes: 45, dailyLimitMinutes: 30);
      expect(snapshot.isLimitReached, isTrue);
    });

    test('a parent-granted extra day bypasses an otherwise-reached limit', () {
      const snapshot = ScreenTimeSnapshot(
        todayMinutes: 45,
        dailyLimitMinutes: 30,
        extraGrantedToday: true,
      );
      expect(snapshot.isLimitReached, isFalse);
    });
  });
}
