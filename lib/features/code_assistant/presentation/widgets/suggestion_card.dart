import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// The proposed rewrite from an AssistantAction.suggestImprovement reply
/// (US34), which stays inert until the learner explicitly accepts or
/// rejects it (US35) — nothing here writes to the saved code on its own.
class SuggestionCard extends StatelessWidget {
  const SuggestionCard({super.key, required this.suggestedCode, required this.onAccept, required this.onReject});

  final String suggestedCode;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.assistantSuggestionLabel, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(suggestedCode, style: AppTextStyles.body.copyWith(fontFamily: 'monospace', fontSize: 13)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.assistantReject,
                  variant: AppButtonVariant.outline,
                  onPressed: onReject,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: AppButton(label: l10n.assistantAccept, onPressed: onAccept)),
            ],
          ),
        ],
      ),
    );
  }
}
