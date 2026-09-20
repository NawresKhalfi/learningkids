import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/weekly_usage_chart.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../gamification/application/gamification_providers.dart';
import '../../../gamification/domain/level.dart';
import '../../../gamification/domain/weekly_summary.dart';
import '../../../learning_path/application/learning_progress_controller.dart';
import '../../../learning_path/domain/learning_path_info.dart';
import '../../../learning_path/domain/lesson_language.dart';
import '../../../learning_path/domain/primary_path.dart';
import '../../../parental_control/application/parental_control_controller.dart';
import '../../../profile/application/profile_controller.dart';
import '../../domain/path_progress.dart';
import '../../domain/skill_progress.dart';
import '../../domain/weak_module.dart';
import '../widgets/progress_bar_row.dart';

/// The learner-facing progress dashboard (EP09): key indicators, a
/// graphical progress view per path and skill (US49), a weekly summary
/// (US50), goal-vs-progress (US52) and weak-point detection (US51). Built
/// entirely from data EP03/EP05/EP07/EP08 already track — no new tracking
/// beyond the per-module quiz score added for US51.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(learningProgressProvider);
    final gamificationAsync = ref.watch(gamificationProfileProvider);
    final usageAsync = ref.watch(usageHistoryProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: SafeArea(
        child: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (progress) => gamificationAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
            data: (gamification) {
              final pathProgress = computePathProgress(progress).where((p) => progress.isActive(p.path)).toList();
              final skillProgress = computeSkillProgress(progress);
              final weakModules = computeWeakModules(progress);
              final weekly = weeklySummaryFor(gamification);
              final recommendedPath = profileAsync.valueOrNull?.recommendedPath;

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatChip(
                          emoji: '📚',
                          label: l10n.dashboardLessonsCompleted(gamification.lessonsCompletedCount),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatChip(emoji: '⭐', label: l10n.levelLabel(levelForXp(gamification.totalXp), xpIntoCurrentLevel(gamification.totalXp), xpPerLevel)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(l10n.dashboardWeeklySummaryTitle, style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      border: Border.all(color: AppColors.ink, width: 1.5),
                    ),
                    child: Text(
                      l10n.dashboardWeeklySummaryBody(weekly.lessonsThisWeek, weekly.xpThisWeek, weekly.projectsThisWeek),
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (recommendedPath != null) ...[
                    Text(l10n.dashboardGoalTitle, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Builder(
                      builder: (context) {
                        final goalPath = primaryPathFor(recommendedPath);
                        final info = learningPathInfo(goalPath);
                        final goalProgress = pathProgressFor(goalPath, progress);
                        return ProgressBarRow(
                          label: '${info.emoji} ${info.title}',
                          ratio: goalProgress.ratio,
                          trailing: l10n.dashboardModulesCount(goalProgress.completedCount, goalProgress.totalCount),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (pathProgress.isNotEmpty) ...[
                    Text(l10n.dashboardPathsTitle, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    for (final p in pathProgress) ...[
                      ProgressBarRow(
                        label: '${learningPathInfo(p.path).emoji} ${learningPathInfo(p.path).title}',
                        ratio: p.ratio,
                        trailing: l10n.dashboardModulesCount(p.completedCount, p.totalCount),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (skillProgress.isNotEmpty) ...[
                    Text(l10n.dashboardSkillsTitle, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [for (final skill in skillProgress) _SkillChip(skill: skill)],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  if (weakModules.isNotEmpty) ...[
                    Text(l10n.dashboardWeakModulesTitle, style: AppTextStyles.title),
                    const SizedBox(height: AppSpacing.xs),
                    Text(l10n.dashboardWeakModulesSubtitle, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: AppSpacing.sm),
                    for (final weak in weakModules) ...[
                      _WeakModuleRow(weak: weak),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.md),
                  ],
                  Text(l10n.dashboardUsageTitle, style: AppTextStyles.title),
                  const SizedBox(height: AppSpacing.sm),
                  usageAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, _) => Text(l10n.commonSomethingWentWrong),
                    data: (history) => WeeklyUsageChart(history: history),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.emoji, required this.label});

  final String emoji;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(label, style: AppTextStyles.caption)),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.skill});

  final SkillProgress skill;

  @override
  Widget build(BuildContext context) {
    final mastered = skill.ratio >= 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: mastered ? AppColors.accentYellow : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Text(
        '${lessonLanguageLabel(skill.language)} ${skill.completedCount}/${skill.totalCount}',
        style: AppTextStyles.caption,
      ),
    );
  }
}

class _WeakModuleRow extends StatelessWidget {
  const _WeakModuleRow({required this.weak});

  final WeakModule weak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.moduleDetail(weak.path.name, weak.module.id)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(weak.module.title, style: AppTextStyles.body),
                  Text(
                    l10n.dashboardWeakModuleScore(weak.correctAnswers, weak.module.quiz.length),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Text(l10n.dashboardReview, style: AppTextStyles.body.copyWith(color: AppColors.brandBlue)),
          ],
        ),
      ),
    );
  }
}
