import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/learning_progress_controller.dart';
import '../../domain/curriculum.dart';
import '../../domain/learning_path_info.dart';
import '../../domain/learning_path.dart';
import '../../domain/lesson_language.dart';
import '../../domain/module.dart';
import '../../domain/module_status.dart';

/// US24: every lesson across every path, filterable by language — a
/// catalogue independent of a single path's roadmap, and one that grows
/// automatically as `curriculum.dart` gains new modules/languages.
class LessonCatalogScreen extends ConsumerStatefulWidget {
  const LessonCatalogScreen({super.key, this.path});

  /// When opened from the dashboard, this is the learner's selected path.
  /// Leaving it null preserves the global catalogue entry point.
  final LearningPath? path;

  @override
  ConsumerState<LessonCatalogScreen> createState() =>
      _LessonCatalogScreenState();
}

class _LessonCatalogScreenState extends ConsumerState<LessonCatalogScreen> {
  LessonLanguage? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(learningProgressProvider);

    final pathModules = widget.path == null
        ? allModules
        : curriculumFor(widget.path!);
    final languages = LessonLanguage.values
        .where(
          (language) => pathModules.any((m) => m.languages.contains(language)),
        )
        .toList();
    final modules = _filter == null
        ? pathModules
        : pathModules.where((m) => m.languages.contains(_filter)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.path == null
              ? l10n.lessonCatalogTitle
              : '${l10n.lessonCatalogTitle} · ${learningPathInfo(widget.path!).title}',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  _FilterChip(
                    key: const ValueKey('lesson_catalog_filter_all'),
                    label: l10n.lessonCatalogFilterAll,
                    isSelected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  for (final language in languages) ...[
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      key: ValueKey('lesson_catalog_filter_${language.name}'),
                      label: lessonLanguageLabel(language),
                      isSelected: _filter == language,
                      onTap: () => setState(() => _filter = language),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: progressAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    Center(child: Text(l10n.commonSomethingWentWrong)),
                data: (progress) {
                  return ListView.separated(
                    key: const ValueKey('lesson_catalog_list'),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: modules.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final module = modules[index];
                      final status = resolveModuleStatus(
                        module,
                        progress.completedIdsFor(module.path),
                      );
                      return _CatalogRow(
                        module: module,
                        status: status,
                        onTap: () {
                          if (status == ModuleStatus.locked) {
                            final prereqTitles = module.prerequisiteIds
                                .map((id) => moduleById(id).title)
                                .join(', ');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.roadmapModuleLockedMessage(prereqTitles),
                                ),
                              ),
                            );
                            return;
                          }
                          context.push(
                            AppRoutes.moduleDetail(module.path.name, module.id),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isSelected ? AppColors.surface : AppColors.ink,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _CatalogRow extends StatelessWidget {
  const _CatalogRow({
    required this.module,
    required this.status,
    required this.onTap,
  });

  final Module module;
  final ModuleStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final info = learningPathInfo(module.path);
    final isLocked = status == ModuleStatus.locked;
    final (icon, iconColor) = switch (status) {
      ModuleStatus.locked => (Icons.lock, AppColors.inkMuted),
      ModuleStatus.unlocked => (Icons.play_circle_fill, AppColors.brandBlue),
      ModuleStatus.completed => (Icons.check_circle, AppColors.success),
    };

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isLocked ? 0.6 : 1,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.ink, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(module.title, style: AppTextStyles.title),
                    Row(
                      children: [
                        Text(info.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(info.title, style: AppTextStyles.caption),
                      ],
                    ),
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
