import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// First screen a signed-out user sees: brand + tagline + a single CTA into
/// sign-up (login is reachable from there).
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              const MascotByte(size: 150),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.welcomeTaglineLead,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              Text(
                l10n.welcomeTaglineHighlight,
                style: AppTextStyles.headline.copyWith(color: AppColors.brandPurple),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              AppButton(
                label: l10n.welcomeCta,
                onPressed: () => context.go(AppRoutes.signUp),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
