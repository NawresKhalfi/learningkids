import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/notifications/application/notification_settings_controller.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_notification_service.dart';

void main() {
  late FakeNotificationService fakeService;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    fakeService = FakeNotificationService();
    container = ProviderContainer(
      overrides: [
        localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
        notificationServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);
  });

  test('initial state mirrors LocalPreferences defaults (on, 18:00, rewards on)', () {
    final state = container.read(notificationSettingsControllerProvider);
    expect(state.dailyReminderEnabled, isTrue);
    expect(state.dailyReminderHour, 18);
    expect(state.dailyReminderMinute, 0);
    expect(state.rewardNotificationsEnabled, isTrue);
  });

  test('enabling the daily reminder requests permission and schedules it (US57)', () async {
    final granted = await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(true);

    expect(granted, isTrue);
    expect(fakeService.dailyReminderScheduled, isTrue);
    expect(fakeService.scheduledHour, 18);
    expect(container.read(notificationSettingsControllerProvider).dailyReminderEnabled, isTrue);
  });

  test('denied permission keeps the reminder off and reports failure', () async {
    fakeService.permissionGranted = false;

    final granted = await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(true);

    expect(granted, isFalse);
    expect(fakeService.dailyReminderScheduled, isFalse);
    expect(container.read(notificationSettingsControllerProvider).dailyReminderEnabled, isFalse);
  });

  test('disabling the daily reminder cancels it', () async {
    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(true);

    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(false);

    expect(fakeService.dailyReminderScheduled, isFalse);
    expect(container.read(notificationSettingsControllerProvider).dailyReminderEnabled, isFalse);
  });

  test('changing the time does not schedule anything while the reminder is off', () async {
    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(false);

    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderTime(hour: 7, minute: 30);

    expect(fakeService.dailyReminderScheduled, isFalse);
    expect(container.read(notificationSettingsControllerProvider).dailyReminderHour, 7, reason: 'the chosen time is still saved for next time');
  });

  test('changing the time while enabled reschedules with the new time', () async {
    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(true);

    await container.read(notificationSettingsControllerProvider.notifier).setDailyReminderTime(hour: 7, minute: 30);

    expect(fakeService.scheduledHour, 7);
    expect(fakeService.scheduledMinute, 30);
    expect(container.read(notificationSettingsControllerProvider).dailyReminderHour, 7);
  });

  test('setRewardNotificationsEnabled persists and updates state (US59)', () async {
    await container.read(notificationSettingsControllerProvider.notifier).setRewardNotificationsEnabled(false);

    expect(container.read(notificationSettingsControllerProvider).rewardNotificationsEnabled, isFalse);
  });
}
