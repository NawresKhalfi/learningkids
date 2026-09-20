import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/next_reminder_occurrence.dart';

const dailyReminderNotificationId = 1;
const _dailyReminderChannelId = 'daily_reminder';
const _rewardChannelId = 'reward';

/// Wraps `flutter_local_notifications` for EP11's reminders/rewards. This
/// project has no server or Cloud Functions backend, so — as documented in
/// `docs/FEATURES.md` — everything here is a device-local scheduled or
/// instantly-triggered notification, not a real remote push.
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _timeZoneReady = false;

  Future<void> initialize() {
    return _plugin
        .initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings(),
          ),
        )
        .then((_) {});
  }

  Future<bool> requestPermission() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  Future<void> _ensureTimeZone() async {
    if (_timeZoneReady) return;
    tz_data.initializeTimeZones();
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
    _timeZoneReady = true;
  }

  /// Schedules (or replaces) the recurring daily reminder (US57) at the
  /// given local time — `matchDateTimeComponents: time` makes the plugin
  /// re-fire it every day rather than just once.
  Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    await _ensureTimeZone();
    await _plugin.zonedSchedule(
      dailyReminderNotificationId,
      "C'est l'heure de coder ! 💻",
      "Reviens t'entraîner un peu aujourd'hui pour garder ton streak 🔥",
      _nextInstanceOf(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(_dailyReminderChannelId, 'Rappel quotidien'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() => _plugin.cancel(dailyReminderNotificationId);

  /// Fires immediately — used for US58's badge/certificate/level-up
  /// celebrations, which the app already knows about the moment they
  /// happen (no need to schedule anything).
  Future<void> showRewardNotification({required int id, required String title, required String body}) {
    return _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(_rewardChannelId, 'Récompenses'),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    final target = nextReminderOccurrence(now, hour: hour, minute: minute);
    return tz.TZDateTime(tz.local, target.year, target.month, target.day, target.hour, target.minute);
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());
