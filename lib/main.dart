import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/storage/local_preferences.dart';
import 'features/notifications/data/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final sharedPreferences = await SharedPreferences.getInstance();
  final localPreferences = LocalPreferences(sharedPreferences);

  // EP11/US57: re-arm the daily reminder on every launch (the OS may drop
  // scheduled notifications across a device reboot) — `requestPermission`
  // is a no-op re-read of the existing OS decision once the learner has
  // already answered the permission prompt once, so this never re-asks.
  final notificationService = NotificationService();
  await notificationService.initialize();
  if (localPreferences.dailyReminderEnabled) {
    final granted = await notificationService.requestPermission();
    if (granted) {
      await notificationService.scheduleDailyReminder(
        hour: localPreferences.dailyReminderHour,
        minute: localPreferences.dailyReminderMinute,
      );
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        localPreferencesProvider.overrideWithValue(localPreferences),
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const LearningKidsApp(),
    ),
  );
}
