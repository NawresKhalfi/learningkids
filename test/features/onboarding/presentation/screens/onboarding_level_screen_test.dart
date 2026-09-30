import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/presentation/screens/onboarding_level_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets(
    'explains the progressive curriculum without asking for a level',
    (tester) async {
      await pumpLocalizedWidget(tester, const OnboardingLevelScreen());
      final l10n = AppLocalizations.of(
        tester.element(find.byType(OnboardingLevelScreen)),
      );

      expect(find.text(l10n.onboardingProgramTitle), findsOneWidget);
      expect(find.text(l10n.onboardingProgramBody), findsOneWidget);
      expect(find.text(l10n.onboardingLevelBeginner), findsNothing);
      expect(find.text(l10n.onboardingLevelSomeBasics), findsNothing);
      expect(find.text(l10n.onboardingLevelComfortable), findsNothing);
    },
  );
}
