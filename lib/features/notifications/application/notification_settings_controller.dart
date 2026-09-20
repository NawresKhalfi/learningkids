import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../data/notification_service.dart';

/// The learner's notification preferences (US57/US59), read once from
/// [LocalPreferences] and kept in memory here so toggling a switch updates
/// the settings screen immediately.
class NotificationSettings {
  const NotificationSettings({
    required this.dailyReminderEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
    required this.rewardNotificationsEnabled,
  });

  final bool dailyReminderEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool rewardNotificationsEnabled;

  NotificationSettings copyWith({bool? dailyReminderEnabled, int? dailyReminderHour, int? dailyReminderMinute, bool? rewardNotificationsEnabled}) =>
      NotificationSettings(
        dailyReminderEnabled: dailyReminderEnabled ?? this.dailyReminderEnabled,
        dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
        dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
        rewardNotificationsEnabled: rewardNotificationsEnabled ?? this.rewardNotificationsEnabled,
      );
}

class NotificationSettingsController extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    final prefs = ref.read(localPreferencesProvider);
    return NotificationSettings(
      dailyReminderEnabled: prefs.dailyReminderEnabled,
      dailyReminderHour: prefs.dailyReminderHour,
      dailyReminderMinute: prefs.dailyReminderMinute,
      rewardNotificationsEnabled: prefs.rewardNotificationsEnabled,
    );
  }

  /// Returns false if the learner turned the reminder on but denied the OS
  /// permission prompt, so the screen can explain why it stayed off.
  Future<bool> setDailyReminderEnabled(bool enabled) async {
    await ref.read(localPreferencesProvider).setDailyReminderEnabled(enabled);
    final service = ref.read(notificationServiceProvider);
    if (!enabled) {
      await service.cancelDailyReminder();
      state = state.copyWith(dailyReminderEnabled: false);
      return true;
    }
    final granted = await service.requestPermission();
    if (!granted) {
      await ref.read(localPreferencesProvider).setDailyReminderEnabled(false);
      state = state.copyWith(dailyReminderEnabled: false);
      return false;
    }
    await service.scheduleDailyReminder(hour: state.dailyReminderHour, minute: state.dailyReminderMinute);
    state = state.copyWith(dailyReminderEnabled: true);
    return true;
  }

  Future<void> setDailyReminderTime({required int hour, required int minute}) async {
    await ref.read(localPreferencesProvider).setDailyReminderTime(hour, minute);
    if (state.dailyReminderEnabled) {
      await ref.read(notificationServiceProvider).scheduleDailyReminder(hour: hour, minute: minute);
    }
    state = state.copyWith(dailyReminderHour: hour, dailyReminderMinute: minute);
  }

  Future<void> setRewardNotificationsEnabled(bool enabled) async {
    await ref.read(localPreferencesProvider).setRewardNotificationsEnabled(enabled);
    state = state.copyWith(rewardNotificationsEnabled: enabled);
  }
}

final notificationSettingsControllerProvider =
    NotifierProvider<NotificationSettingsController, NotificationSettings>(NotificationSettingsController.new);
