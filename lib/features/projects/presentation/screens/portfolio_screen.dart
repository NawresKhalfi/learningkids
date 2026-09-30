import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/preview_capture.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../admin/application/admin_providers.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../../profile/application/profile_controller.dart';
import '../../../profile/data/profile_repository.dart';
import '../../application/project_providers.dart';
import '../../domain/project.dart';
import '../../domain/project_category.dart';

/// The portfolio (US39): the learner's published projects with
/// screenshots. With no [ownerUid], shows the signed-in learner's own
/// portfolio plus the sharing controls (US40); with one, shows someone
/// else's — read-only, and only reachable at all if that owner has
/// switched their portfolio to public (enforced by Firestore rules).
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key, this.ownerUid});

  final String? ownerUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final myUid = ref.watch(authRepositoryProvider).currentUser?.uid;
    final isOwnPortfolio = ownerUid == null || ownerUid == myUid;
    final targetUid = ownerUid ?? myUid;

    if (targetUid == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.portfolioTitle)),
        body: Center(child: Text(l10n.commonSomethingWentWrong)),
      );
    }

    final projectsAsync = ref.watch(
      isOwnPortfolio ? myProjectsProvider : portfolioProvider(targetUid),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.portfolioTitle)),
      body: SafeArea(
        child: Column(
          children: [
            if (isOwnPortfolio) _OwnPortfolioControls(uid: targetUid),
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) =>
                    Center(child: Text(l10n.commonSomethingWentWrong)),
                data: (projects) {
                  final published = projects
                      .where((p) => p.isPublished)
                      .toList();
                  if (published.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Text(
                          l10n.portfolioEmpty,
                          style: AppTextStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: published.length,
                    itemBuilder: (context, index) => _PortfolioCard(
                      project: published[index],
                      ownerUid: isOwnPortfolio ? null : targetUid,
                    ),
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

class _OwnPortfolioControls extends ConsumerWidget {
  const _OwnPortfolioControls({required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final isPublic = profileAsync.valueOrNull?.portfolioPublic ?? false;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: isPublic,
            onChanged: (value) => ref
                .read(profileRepositoryProvider)
                .updatePortfolioVisibility(uid, value),
            title: Text(l10n.portfolioPublicToggle),
            subtitle: Text(
              isPublic ? l10n.portfolioPublicOn : l10n.portfolioPublicOff,
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.portfolioShare,
                  variant: AppButtonVariant.secondary,
                  onPressed: isPublic
                      ? () => SharePlus.instance.share(
                          ShareParams(text: l10n.portfolioShareMessage(uid)),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends ConsumerWidget {
  const _PortfolioCard({required this.project, this.ownerUid});

  final Project project;

  /// Non-null only when viewing someone *else's* portfolio (EP12/US61) —
  /// that's when a "Signaler" action makes sense.
  final String? ownerUid;

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(l10n.portfolioReportTitle),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.portfolioReportReasonHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: Text(l10n.portfolioReportSubmit),
            ),
          ],
        );
      },
    );
    if (reason == null || reason.isEmpty || !context.mounted) return;
    await ref
        .read(moderationControllerProvider.notifier)
        .reportProject(
          projectId: project.id,
          ownerUid: ownerUid!,
          projectTitle: project.title,
          reason: reason,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.portfolioReportSent)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thumbnail = decodeThumbnail(project.thumbnailBase64);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: thumbnail == null
                      ? const ColoredBox(
                          color: AppColors.background,
                          child: Icon(Icons.image_not_supported_outlined),
                        )
                      : Image.memory(thumbnail, fit: BoxFit.cover),
                ),
                if (ownerUid != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.flag_outlined),
                      color: AppColors.ink,
                      onPressed: () => _report(context, ref),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${programmingLanguageTitle(project.language)} · ${projectCategoryLabel(project.category)}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
