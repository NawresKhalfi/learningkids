import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';
import '../../domain/age_range.dart';
import '../widgets/onboarding_scaffold.dart';

class OnboardingAgeScreen extends ConsumerWidget {
  const OnboardingAgeScreen({super.key});

  void _select(WidgetRef ref, BuildContext context, AgeRange ageRange) {
    ref.read(onboardingControllerProvider.notifier).setAgeRange(ageRange);
    context.go(AppRoutes.onboardingLevel);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final name = ref.watch(onboardingControllerProvider).name ?? '';
    final selected = ref.watch(onboardingControllerProvider).ageRange;

    final options = <(AgeRange, String)>[
      (AgeRange.fourToSix, l10n.onboardingAge4to6),
      (AgeRange.sevenToNine, l10n.onboardingAge7to9),
      (AgeRange.tenToTwelve, l10n.onboardingAge10to12),
      (AgeRange.thirteenPlus, l10n.onboardingAge13plus),
    ];

    return OnboardingScaffold(
      message: l10n.onboardingAskAge(name),
      content: Column(
        children: [
          for (final (ageRange, label) in options) ...[
            OptionButton(
              label: label,
              isSelected: selected == ageRange,
              onTap: () => _select(ref, context, ageRange),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
