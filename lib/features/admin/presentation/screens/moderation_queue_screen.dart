import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/admin_providers.dart';
import '../../domain/moderation_report.dart';

/// The moderation queue (EP12/US61): every pending report against a
/// shared portfolio project, with "accepter" (dismiss — content stays
/// public) and "rejeter" (unpublish it) actions.
class ModerationQueueScreen extends ConsumerWidget {
  const ModerationQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final queueAsync = ref.watch(moderationQueueProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminModerationQueueTitle)),
      body: SafeArea(
        child: queueAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (reports) {
            if (reports.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l10n.adminModerationQueueEmpty, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: reports.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) => _ReportCard(report: reports[index]),
            );
          },
        ),
      ),
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({required this.report});

  final ModerationReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(report.projectTitle, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.adminModerationQueueReason(report.reason), style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.adminModerationApprove,
                  variant: AppButtonVariant.outline,
                  onPressed: () => ref.read(moderationControllerProvider.notifier).approveReport(report.id),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: l10n.adminModerationReject,
                  variant: AppButtonVariant.danger,
                  onPressed: () => ref.read(moderationControllerProvider.notifier).rejectReport(report),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
