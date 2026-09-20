import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/notification_settings_controller.dart';

/// US59: lets the learner turn the daily reminder (US57) and reward
/// celebrations (US58) on or off independently, and pick the reminder time.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  Future<void> _pickTime(BuildContext context, WidgetRef ref, NotificationSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.dailyReminderHour, minute: settings.dailyReminderMinute),
    );
    if (picked == null) return;
    await ref
        .read(notificationSettingsControllerProvider.notifier)
        .setDailyReminderTime(hour: picked.hour, minute: picked.minute);
  }

  Future<void> _setDailyReminderEnabled(BuildContext context, WidgetRef ref, bool enabled) async {
    final l10n = AppLocalizations.of(context);
    final granted = await ref.read(notificationSettingsControllerProvider.notifier).setDailyReminderEnabled(enabled);
    if (!granted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.notificationSettingsPermissionDenied)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(notificationSettingsControllerProvider);
    final time = TimeOfDay(hour: settings.dailyReminderHour, minute: settings.dailyReminderMinute);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationSettingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.dailyReminderEnabled,
              onChanged: (value) => _setDailyReminderEnabled(context, ref, value),
              title: Text(l10n.notificationSettingsDailyReminder),
              subtitle: Text(l10n.notificationSettingsDailyReminderSubtitle, style: AppTextStyles.caption),
            ),
            if (settings.dailyReminderEnabled)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md, bottom: AppSpacing.md),
                child: TextButton(
                  onPressed: () => _pickTime(context, ref, settings),
                  child: Text(l10n.notificationSettingsChangeTime(time.format(context))),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: settings.rewardNotificationsEnabled,
              onChanged: (value) =>
                  ref.read(notificationSettingsControllerProvider.notifier).setRewardNotificationsEnabled(value),
              title: Text(l10n.notificationSettingsRewards),
              subtitle: Text(l10n.notificationSettingsRewardsSubtitle, style: AppTextStyles.caption),
            ),
          ],
        ),
      ),
    );
  }
}
