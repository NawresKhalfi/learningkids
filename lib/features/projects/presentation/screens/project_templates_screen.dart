import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../../onboarding/domain/coding_level.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../../learning_path/domain/learning_path_info.dart';
import '../../../learning_path/domain/path_code_languages.dart';
import '../../application/project_providers.dart';
import '../../domain/project_category.dart';
import '../../domain/project_template.dart';
import '../../domain/project_templates_catalog.dart';

/// The guided project catalog (US38): every template, filterable by
/// language, so a learner picks a realistic starting point instead of a
/// blank editor.
class ProjectTemplatesScreen extends ConsumerStatefulWidget {
  const ProjectTemplatesScreen({super.key, this.path});

  final LearningPath? path;

  @override
  ConsumerState<ProjectTemplatesScreen> createState() =>
      _ProjectTemplatesScreenState();
}

class _ProjectTemplatesScreenState
    extends ConsumerState<ProjectTemplatesScreen> {
  ProgrammingLanguage? _filter;
  bool _isCreating = false;

  Future<void> _create(ProjectTemplate template) async {
    if (_isCreating) return;
    setState(() => _isCreating = true);
    final projectId = await ref
        .read(projectsControllerProvider.notifier)
        .createFromTemplate(template);
    if (!mounted) return;
    setState(() => _isCreating = false);
    context.push(AppRoutes.projectDetail(projectId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pathTemplates = widget.path == null
        ? projectTemplatesCatalog
        : projectTemplatesCatalog
              .where((template) => template.path == widget.path)
              .toList();
    final languages = widget.path == null
        ? ProgrammingLanguage.values
        : programmingLanguagesForPath(widget.path!);
    final templates = _filter == null
        ? pathTemplates
        : pathTemplates.where((t) => t.language == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.path == null
              ? l10n.projectTemplatesTitle
              : '${l10n.projectTemplatesTitle} · ${learningPathInfo(widget.path!).title}',
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
                    key: const ValueKey('project_templates_filter_all'),
                    label: l10n.lessonCatalogFilterAll,
                    isSelected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  for (final language in languages) ...[
                    const SizedBox(width: AppSpacing.sm),
                    _FilterChip(
                      key: ValueKey(
                        'project_templates_filter_${language.name}',
                      ),
                      label: programmingLanguageTitle(language),
                      isSelected: _filter == language,
                      onTap: () => setState(() => _filter = language),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: templates.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return _TemplateCard(
                    template: template,
                    onTap: _isCreating ? null : () => _create(template),
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

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onTap});

  final ProjectTemplate template;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.title, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.xs),
            Text(template.description, style: AppTextStyles.bodyMuted),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _Badge(programmingLanguageTitle(template.language)),
                _Badge(projectCategoryLabel(template.category)),
                _Badge(codingLevelShortLabel(template.level)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: AppColors.ink, width: 1),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}
