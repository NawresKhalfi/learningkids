import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/project_feedback_provider.dart';

/// The pre-publish AI review (US42), shown as a bottom sheet over the
/// editor so the learner can read it, go back, tweak their code, and
/// re-open it without losing their place.
Future<void> showProjectFeedbackSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _ProjectFeedbackSheetContent(),
  );
}

class _ProjectFeedbackSheetContent extends ConsumerWidget {
  const _ProjectFeedbackSheetContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(projectFeedbackControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.projectFeedbackTitle, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),
            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.hasError)
              Text(l10n.assistantErrorGeneric, style: AppTextStyles.bodyMuted)
            else if (state.feedback != null)
              Text(state.feedback!, style: AppTextStyles.body)
            else
              Text(l10n.projectFeedbackEmpty, style: AppTextStyles.bodyMuted),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
