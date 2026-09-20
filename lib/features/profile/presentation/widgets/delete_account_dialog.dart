import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Confirmation dialog for US06 (account deletion) — a destructive, hard
/// to reverse action, so it is never a single tap away.
Future<bool> showDeleteAccountDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.profileDeleteConfirmTitle),
      content: Text(l10n.profileDeleteConfirmBody),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: l10n.commonCancel,
                variant: AppButtonVariant.outline,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: l10n.profileDeleteConfirmCta,
                variant: AppButtonVariant.danger,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
