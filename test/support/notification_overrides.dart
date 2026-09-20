import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_notification_service.dart';

/// Neutralizes EP11's reward-notification side effects (US58) for tests
/// that exercise a gamification/lesson/project flow without caring about
/// notifications themselves — otherwise `RewardNotifier` hits the
/// unoverridden `localPreferencesProvider` (which throws by design) or the
/// real `flutter_local_notifications` platform channel.
///
/// Calls `SharedPreferences.setMockInitialValues` itself, so call this
/// before any other `SharedPreferences` setup in the same test.
Future<List<Override>> disabledNotificationOverrides() async {
  SharedPreferences.setMockInitialValues({});
  return [
    localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
    notificationServiceProvider.overrideWithValue(FakeNotificationService()),
  ];
}
