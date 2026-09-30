import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<LocalPreferences> load() async =>
      LocalPreferences(await SharedPreferences.getInstance());

  test(
    'onboarding completion belongs only to the account that completed it',
    () async {
      final prefs = await load();

      await prefs.setOnboardingCompleted('first-child', true);

      expect(prefs.hasCompletedOnboarding('first-child'), isTrue);
      expect(
        prefs.hasCompletedOnboarding('second-child'),
        isFalse,
        reason: 'A new account on the same device must still see onboarding.',
      );
    },
  );

  test('daily reminder is enabled by default at 18:00 (US57)', () async {
    final prefs = await load();
    expect(prefs.dailyReminderEnabled, isTrue);
    expect(prefs.dailyReminderHour, 18);
    expect(prefs.dailyReminderMinute, 0);
  });

  test('setDailyReminderEnabled persists the toggle', () async {
    final prefs = await load();
    await prefs.setDailyReminderEnabled(false);
    expect(prefs.dailyReminderEnabled, isFalse);
  });

  test('setDailyReminderTime persists the chosen hour/minute', () async {
    final prefs = await load();
    await prefs.setDailyReminderTime(7, 30);
    expect(prefs.dailyReminderHour, 7);
    expect(prefs.dailyReminderMinute, 30);
  });

  test(
    'reward notifications are enabled by default and can be disabled (US58/US59)',
    () async {
      final prefs = await load();
      expect(prefs.rewardNotificationsEnabled, isTrue);

      await prefs.setRewardNotificationsEnabled(false);

      expect(prefs.rewardNotificationsEnabled, isFalse);
    },
  );

  test(
    'app language defaults to "system" and can be changed (EP13/US64)',
    () async {
      final prefs = await load();
      expect(prefs.appLanguage, 'system');

      await prefs.setAppLanguage('en');

      expect(prefs.appLanguage, 'en');
    },
  );

  test(
    'text scale option defaults to "normal" and can be changed (EP13/US66)',
    () async {
      final prefs = await load();
      expect(prefs.textScaleOption, 'normal');

      await prefs.setTextScaleOption('large');

      expect(prefs.textScaleOption, 'large');
    },
  );
}
