import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/weekly_usage_chart.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../gamification/application/gamification_providers.dart';
import '../../../gamification/domain/badge_catalog.dart';
import '../../../learning_path/application/learning_progress_controller.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../application/parental_control_controller.dart';
import '../../application/screen_time_controller.dart';
import 'parent_gate_screen.dart';

/// The Espace Parent dashboard (US08/US09): usage over the last week, the
/// daily limit control, badge progress, and the public-leaderboard privacy
/// toggle (US48) — a placeholder for lessons progress remains pending
/// design for a dedicated reporting view.
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  Future<void> _editLimit(
    BuildContext context,
    WidgetRef ref,
    int? currentLimit,
  ) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: currentLimit?.toString() ?? '',
    );
    final result = await showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.parentDashboardLimitDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: l10n.parentDashboardLimitDialogHint),
        ),
        actions: [
          if (currentLimit != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(0),
              child: Text(l10n.parentDashboardLimitRemove),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(int.tryParse(controller.text)),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (result == null) return;
    final notifier = ref.read(parentalControlControllerProvider.notifier);
    if (result <= 0) {
      await notifier.clearDailyLimit();
    } else {
      await notifier.setDailyLimitMinutes(result);
    }
    ref.invalidate(usageHistoryProvider);
    await ref.read(screenTimeControllerProvider.notifier).refreshSettings();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(parentalSettingsProvider);
    final historyAsync = ref.watch(usageHistoryProvider);
    final gamificationAsync = ref.watch(gamificationProfileProvider);
    final progressAsync = ref.watch(learningProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentDashboardTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.parentDashboardUsageTitle, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),
              historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => Text(l10n.commonSomethingWentWrong),
                data: (history) => WeeklyUsageChart(history: history),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.parentDashboardLimitTitle, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.sm),
              settingsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => Text(l10n.commonSomethingWentWrong),
                data: (settings) {
                  final limit = settings.dailyLimitMinutes;
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          limit == null
                              ? l10n.parentDashboardLimitNone
                              : l10n.parentDashboardLimitSet(limit),
                          style: AppTextStyles.body,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _editLimit(context, ref, limit),
                        child: Text(l10n.parentDashboardLimitEdit),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(l10n.parentDashboardLessonsTitle, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xs),
              progressAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => Text(l10n.commonSomethingWentWrong),
                data: (progress) {
                  final total = LearningPath.values.fold<int>(
                    0,
                    (sum, path) => sum + progress.completedIdsFor(path).length,
                  );
                  return Text(l10n.parentDashboardLessonsCount(total), style: AppTextStyles.body);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.parentDashboardBadgesTitle, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.xs),
              gamificationAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, _) => Text(l10n.commonSomethingWentWrong),
                data: (profile) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.parentDashboardBadgesCount(profile.unlockedBadgeIds.length, badgeCatalog.length),
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: !profile.leaderboardOptOut,
                      onChanged: (isVisible) =>
                          ref.read(gamificationControllerProvider.notifier).setLeaderboardOptOut(!isVisible),
                      title: Text(l10n.parentDashboardLeaderboardToggle),
                      subtitle: Text(
                        profile.leaderboardOptOut
                            ? l10n.parentDashboardLeaderboardOff
                            : l10n.parentDashboardLeaderboardOn,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: l10n.parentDashboardChangePin,
                variant: AppButtonVariant.outline,
                onPressed: () => context.push(
                  AppRoutes.parentGate,
                  extra: const ParentGateScreen(forceCreatePin: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
