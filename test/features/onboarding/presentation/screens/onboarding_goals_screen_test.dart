import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/application/onboarding_controller.dart';
import 'package:learningkids/features/onboarding/presentation/screens/onboarding_goals_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows an error when submitting with no goal selected', (tester) async {
    await pumpLocalizedWidget(tester, const OnboardingGoalsScreen());
    final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingGoalsScreen)));

    await tester.tap(find.text(l10n.onboardingGoalsSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.onboardingGoalsErrorEmpty), findsOneWidget);
  });

  testWidgets('tapping a goal selects it in the controller', (tester) async {
    await pumpLocalizedWidget(tester, const OnboardingGoalsScreen());
    final element = tester.element(find.byType(OnboardingGoalsScreen));
    final l10n = AppLocalizations.of(element);
    final container = ProviderScope.containerOf(element);

    await tester.tap(find.text(l10n.onboardingGoalWebsite));
    await tester.pumpAndSettle();

    expect(container.read(onboardingControllerProvider).goals, isNotEmpty);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
