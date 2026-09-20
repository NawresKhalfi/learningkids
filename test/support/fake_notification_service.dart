import 'package:learningkids/features/notifications/data/notification_service.dart';

/// A `NotificationService` double that records calls instead of touching
/// `flutter_local_notifications`' platform channels — which, like
/// `webview_flutter`/`firebase_ai` elsewhere in this project, have no test
/// doubles of their own (see `docs/FEATURES.md`).
class FakeNotificationService implements NotificationService {
  bool permissionGranted = true;
  bool dailyReminderScheduled = false;
  int? scheduledHour;
  int? scheduledMinute;
  final List<({int id, String title, String body})> shownRewards = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermission() async => permissionGranted;

  @override
  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    dailyReminderScheduled = true;
    scheduledHour = hour;
    scheduledMinute = minute;
  }

  @override
  Future<void> cancelDailyReminder() async {
    dailyReminderScheduled = false;
  }

  @override
  Future<void> showRewardNotification({required int id, required String title, required String body}) async {
    shownRewards.add((id: id, title: title, body: body));
  }
}
