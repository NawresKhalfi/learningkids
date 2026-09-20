import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/coding_level.dart';
import '../widgets/onboarding_scaffold.dart';

/// The US03 "level test": a single question used to seed the recommended
/// path (see `recommended_path.dart`). A fuller positioning quiz belongs to
/// EP03/EP04, not this minimal onboarding step.
class OnboardingLevelScreen extends ConsumerWidget {
  const OnboardingLevelScreen({super.key});

  void _select(WidgetRef ref, BuildContext context, CodingLevel level) {
    ref.read(onboardingControllerProvider.notifier).setCodingLevel(level);
    context.go(AppRoutes.onboardingGoals);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(onboardingControllerProvider).codingLevel;

    final options = <(CodingLevel, String)>[
      (CodingLevel.beginner, l10n.onboardingLevelBeginner),
      (CodingLevel.someBasics, l10n.onboardingLevelSomeBasics),
      (CodingLevel.comfortable, l10n.onboardingLevelComfortable),
    ];

    return OnboardingScaffold(
      message: l10n.onboardingLevelTitle,
      content: Column(
        children: [
          for (final (level, label) in options) ...[
            OptionButton(
              label: label,
              isSelected: selected == level,
              onTap: () => _select(ref, context, level),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
