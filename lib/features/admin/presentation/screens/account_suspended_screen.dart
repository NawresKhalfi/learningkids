import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../core/widgets/speech_bubble.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../auth/application/auth_controller.dart';

/// Blocks the app for a suspended account (EP12/US63) — the client-side
/// analogue of disabling a Firebase Auth account, since that itself needs
/// the Admin SDK/a real backend this project doesn't have (see
/// `docs/FEATURES.md`). Lifted only by an admin unsuspending the account.
class AccountSuspendedScreen extends ConsumerWidget {
  const AccountSuspendedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Text(l10n.accountSuspendedTitle, style: AppTextStyles.headline, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              const MascotByte(size: 140),
              const SizedBox(height: AppSpacing.lg),
              SpeechBubble(message: l10n.accountSuspendedMessage, color: AppColors.cardOrange.surface),
              const Spacer(),
              AppButton(
                label: l10n.profileLogOut,
                variant: AppButtonVariant.outline,
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
