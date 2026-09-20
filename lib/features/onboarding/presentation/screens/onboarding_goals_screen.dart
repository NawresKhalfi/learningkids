import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/learning_goal.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingGoalsScreen extends ConsumerStatefulWidget {
  const OnboardingGoalsScreen({super.key});

  @override
  ConsumerState<OnboardingGoalsScreen> createState() => _OnboardingGoalsScreenState();
}

class _OnboardingGoalsScreenState extends ConsumerState<OnboardingGoalsScreen> {
  String? _errorText;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final goals = ref.read(onboardingControllerProvider).goals;
    if (goals.isEmpty) {
      setState(() => _errorText = l10n.onboardingGoalsErrorEmpty);
      return;
    }
    setState(() => _errorText = null);
    context.go(AppRoutes.onboardingLoading);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedGoals = ref.watch(onboardingControllerProvider).goals;

    final options = <(LearningGoal, String, String)>[
      (LearningGoal.website, l10n.onboardingGoalWebsite, '🌐'),
      (LearningGoal.game, l10n.onboardingGoalGame, '🎮'),
      (LearningGoal.mobileApp, l10n.onboardingGoalApp, '📱'),
      (LearningGoal.artificialIntelligence, l10n.onboardingGoalAi, '🤖'),
    ];

    return OnboardingScaffold(
      message: l10n.onboardingGoalsTitle,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.onboardingGoalsSubtitle, style: AppTextStyles.bodyMuted),
          const SizedBox(height: AppSpacing.md),
          for (final (goal, label, emoji) in options) ...[
            OptionButton(
              label: label,
              emoji: emoji,
              isSelected: selectedGoals.contains(goal),
              onTap: () =>
                  ref.read(onboardingControllerProvider.notifier).toggleGoal(goal),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (_errorText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              _errorText!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(label: l10n.onboardingGoalsSubmit, onPressed: _submit),
        ],
      ),
    );
  }
}
