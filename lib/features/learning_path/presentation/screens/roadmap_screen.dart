import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../gamification/domain/path_completion.dart';
import '../../application/learning_progress_controller.dart';
import '../../domain/curriculum.dart';
import '../../domain/learning_path.dart';
import '../../domain/learning_path_info.dart';
import '../../domain/module.dart';
import '../../domain/module_status.dart';

/// US17: a visual roadmap of a path's modules, each shown as locked, in
/// progress (unlocked) or completed.
class RoadmapScreen extends ConsumerWidget {
  const RoadmapScreen({super.key, required this.path});

  final LearningPath path;

  void _onModuleTap(
    BuildContext context,
    WidgetRef ref,
    Module module,
    ModuleStatus status,
  ) {
    if (status == ModuleStatus.locked) {
      final l10n = AppLocalizations.of(context);
      final prereqTitles = module.prerequisiteIds.map((id) => moduleById(id).title).join(', ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.roadmapModuleLockedMessage(prereqTitles))),
      );
      return;
    }
    context.push(AppRoutes.moduleDetail(path.name, module.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = learningPathInfo(path);
    final modules = curriculumFor(path);
    final progressAsync = ref.watch(learningProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(info.title)),
      body: SafeArea(
        child: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Text(AppLocalizations.of(context).commonSomethingWentWrong),
          ),
          data: (progress) {
            final completedIds = progress.completedIdsFor(path);
            final l10n = AppLocalizations.of(context);
            return Column(
              children: [
                if (isPathComplete(path, completedIds))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                    child: AppButton(
                      label: l10n.roadmapViewCertificate,
                      onPressed: () => context.push(AppRoutes.certificate(path.name)),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: modules.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      final status = resolveModuleStatus(module, completedIds);
                      return _ModuleRow(
                        module: module,
                        status: status,
                        palette: info.palette,
                        onTap: () => _onModuleTap(context, ref, module, status),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.module,
    required this.status,
    required this.palette,
    required this.onTap,
  });

  final Module module;
  final ModuleStatus status;
  final CardPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = status == ModuleStatus.locked;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isLocked ? 0.6 : 1,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: status == ModuleStatus.completed ? palette.surface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.ink, width: 1.5),
          ),
          child: Row(
            children: [
              _StatusIcon(status: status),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.title, style: AppTextStyles.title),
                    Text(module.description, style: AppTextStyles.bodyMuted),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final ModuleStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      ModuleStatus.locked => (Icons.lock, AppColors.inkMuted),
      ModuleStatus.unlocked => (Icons.play_circle_fill, AppColors.brandBlue),
      ModuleStatus.completed => (Icons.check_circle, AppColors.success),
    };
    return Icon(icon, color: color, size: 32);
  }
}
