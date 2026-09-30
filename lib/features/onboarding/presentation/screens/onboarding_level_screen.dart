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
import '../../domain/coding_level.dart';
import '../widgets/onboarding_scaffold.dart';

/// Explains that every path grows from introductory concepts to advanced
/// projects; learners are no longer asked to self-assess their level.
class OnboardingLevelScreen extends ConsumerWidget {
  const OnboardingLevelScreen({super.key});

  void _continue(WidgetRef ref, BuildContext context) {
    // Goals choose the recommended path. This neutral value preserves the
    // existing profile and code-assistance data model without a level quiz.
    ref
        .read(onboardingControllerProvider.notifier)
        .setCodingLevel(CodingLevel.beginner);
    context.go(AppRoutes.onboardingGoals);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OnboardingScaffold(
      message: l10n.onboardingLevelTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.card),
              border: Border.all(color: AppColors.ink, width: 2),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.stairs_rounded,
                  size: 56,
                  color: AppColors.brandPurple,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.onboardingProgramTitle,
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.onboardingProgramBody,
                  style: AppTextStyles.bodyMuted,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: l10n.commonContinue,
            onPressed: () => _continue(ref, context),
          ),
        ],
      ),
    );
  }
}
