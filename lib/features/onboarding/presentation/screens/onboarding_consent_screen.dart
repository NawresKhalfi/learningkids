import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

/// First onboarding step (US12): a plain-language notice of what data is
/// collected, accepted by the parent/guardian before the child's own
/// onboarding (name, age, goals...) begins. A lightweight, honest consent
/// gate — not a verified-identity check, which would need a paid
/// verification vendor out of scope for this app.
class OnboardingConsentScreen extends ConsumerWidget {
  const OnboardingConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return OnboardingScaffold(
      message: l10n.onboardingConsentMessage,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.card),
              border: Border.all(color: AppColors.ink, width: 1.5),
            ),
            child: Text(l10n.onboardingConsentBody, style: AppTextStyles.body),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.onboardingConsentAccept,
            onPressed: () {
              ref.read(onboardingControllerProvider.notifier).acceptConsent();
              context.go(AppRoutes.onboardingName);
            },
          ),
        ],
      ),
    );
  }
}
