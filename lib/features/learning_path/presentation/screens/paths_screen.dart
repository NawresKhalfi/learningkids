import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/learning_progress_controller.dart';
import '../../domain/learning_path.dart';
import '../../domain/learning_path_info.dart';

/// US18: lets a learner activate more than one path and jump into any
/// active path's roadmap.
class PathsScreen extends ConsumerWidget {
  const PathsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(learningProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pathsTitle)),
      body: SafeArea(
        child: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (progress) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(l10n.pathsSubtitle, style: AppTextStyles.bodyMuted),
                const SizedBox(height: AppSpacing.lg),
                for (final path in LearningPath.values) ...[
                  _PathCard(path: path, isActive: progress.isActive(path)),
                  const SizedBox(height: AppSpacing.md),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PathCard extends ConsumerWidget {
  const _PathCard({required this.path, required this.isActive});

  final LearningPath path;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final info = learningPathInfo(path);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: info.palette.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(info.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(info.title, style: AppTextStyles.title)),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: info.palette.on,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                  child: Text(l10n.pathsActiveLabel, style: AppTextStyles.badge),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(info.description, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: isActive ? l10n.pathsOpenCta : l10n.pathsActivateCta,
            variant: AppButtonVariant.outline,
            onPressed: () async {
              if (!isActive) {
                await ref.read(learningProgressControllerProvider.notifier).activatePath(path);
              }
              if (context.mounted) context.push(AppRoutes.roadmap(path.name));
            },
          ),
        ],
      ),
    );
  }
}
