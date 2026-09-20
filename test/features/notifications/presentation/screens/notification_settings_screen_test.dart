import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:learningkids/features/notifications/presentation/screens/notification_settings_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/fake_notification_service.dart';
import '../../../../support/pump_localized_widget.dart';

void main() {
  Future<FakeNotificationService> pumpScreen(
    WidgetTester tester, {
    Map<String, Object> initialPrefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(initialPrefs);
    final fakeService = FakeNotificationService();
    await pumpLocalizedWidget(
      tester,
      const NotificationSettingsScreen(),
      overrides: [
        localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
        notificationServiceProvider.overrideWithValue(fakeService),
      ],
    );
    return fakeService;
  }

  testWidgets('shows both toggles on by default, with the reminder time (US57/US59)', (tester) async {
    await pumpScreen(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(NotificationSettingsScreen)));

    expect(find.text(l10n.notificationSettingsDailyReminder), findsOneWidget);
    expect(find.text(l10n.notificationSettingsRewards), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.byType(TextButton), findsOneWidget, reason: 'the change-time button shows since the reminder is on by default');
  });

  testWidgets('turning the daily reminder off hides the change-time button', (tester) async {
    await pumpScreen(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(NotificationSettingsScreen)));

    await tester.tap(find.text(l10n.notificationSettingsDailyReminder));
    await tester.pumpAndSettle();

    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('denied permission keeps the reminder off and shows an explanation (US57)', (tester) async {
    final fakeService = await pumpScreen(tester, initialPrefs: {'daily_reminder_enabled': false});
    fakeService.permissionGranted = false;
    final l10n = AppLocalizations.of(tester.element(find.byType(NotificationSettingsScreen)));

    await tester.tap(find.text(l10n.notificationSettingsDailyReminder));
    await tester.pumpAndSettle();

    expect(find.text(l10n.notificationSettingsPermissionDenied), findsOneWidget);
    expect(fakeService.dailyReminderScheduled, isFalse);
  });

  testWidgets('turning reward notifications off persists the toggle (US59)', (tester) async {
    await pumpScreen(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(NotificationSettingsScreen)));

    await tester.tap(find.text(l10n.notificationSettingsRewards));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('reward_notifications_enabled'), isFalse);
  });
}
