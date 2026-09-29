import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../application/project_providers.dart';
import '../../domain/project.dart';
import '../../domain/project_category.dart';

/// The learner's own projects (US38 continued, US39, US41): every project
/// they've started, filterable by category, with entry points into the
/// template catalog and their portfolio.
class MyProjectsScreen extends ConsumerStatefulWidget {
  const MyProjectsScreen({super.key, this.paths});

  final Set<LearningPath>? paths;

  @override
  ConsumerState<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends ConsumerState<MyProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projectsAsync = ref.watch(myProjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paths == null
              ? l10n.myProjectsTitle
              : '${l10n.myProjectsTitle} · Mes parcours',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.collections_bookmark_outlined),
            tooltip: l10n.portfolioTitle,
            onPressed: () => context.push(AppRoutes.portfolio),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: AppButton(
                label: l10n.myProjectsNewProject,
                icon: const Icon(Icons.add, color: AppColors.ink),
                onPressed: () => context.push(
                  widget.paths == null
                      ? AppRoutes.projectTemplates
                      : AppRoutes.projectTemplatesForPaths(
                          widget.paths!.map((path) => path.name),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    Center(child: Text(l10n.commonSomethingWentWrong)),
                data: (projects) {
                  final inPath = widget.paths == null
                      ? projects
                      : projects
                            .where(
                              (project) => widget.paths!.contains(project.path),
                            )
                            .toList();
                  final visible = inPath;
                  if (visible.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          l10n.myProjectsEmpty,
                          style: AppTextStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final project = visible[index];
                      return _ProjectRow(
                        project: project,
                        onTap: () =>
                            context.push(AppRoutes.projectDetail(project.id)),
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

class _ProjectRow extends StatelessWidget {
  const _ProjectRow({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(
              project.isPublished ? Icons.public : Icons.edit_note,
              color: project.isPublished
                  ? AppColors.success
                  : AppColors.inkMuted,
              size: 28,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.title, style: AppTextStyles.title),
                  Text(
                    '${programmingLanguageTitle(project.language)} · ${projectCategoryLabel(project.category)}'
                    '${project.isPublished ? ' · ${l10n.myProjectsPublishedBadge}' : ''}',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
