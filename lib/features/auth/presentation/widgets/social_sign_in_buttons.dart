import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// The "or" divider plus the Google/Apple continue buttons shared by the
/// sign-up and login screens.
class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({
    super.key,
    required this.onGooglePressed,
    required this.onApplePressed,
    this.isLoading = false,
  });

  final VoidCallback onGooglePressed;
  final VoidCallback onApplePressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.inkMuted)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(l10n.commonOr, style: AppTextStyles.bodyMuted),
            ),
            const Expanded(child: Divider(color: AppColors.inkMuted)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: l10n.authContinueWithGoogle,
          variant: AppButtonVariant.outline,
          onPressed: isLoading ? null : onGooglePressed,
          icon: const Icon(Icons.g_mobiledata, size: 26, color: AppColors.ink),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: l10n.authContinueWithApple,
          variant: AppButtonVariant.outline,
          onPressed: isLoading ? null : onApplePressed,
          icon: const Icon(Icons.apple, size: 22, color: AppColors.ink),
        ),
      ],
    );
  }
}
