import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/features/onboarding/application/onboarding_controller.dart';
import 'package:learningkids/features/onboarding/presentation/screens/onboarding_consent_screen.dart';
import 'package:learningkids/features/onboarding/presentation/screens/onboarding_name_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

void main() {
  testWidgets(
    'accepting records the consent timestamp and moves to the name step (US12)',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/onboarding/consent',
        routes: [
          GoRoute(
            path: '/onboarding/consent',
            builder: (_, _) => const OnboardingConsentScreen(),
          ),
          GoRoute(
            path: '/onboarding/name',
            builder: (_, _) => const OnboardingNameScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            locale: const Locale('fr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(container.read(onboardingControllerProvider).consentGivenAt, isNull);

      final l10n = AppLocalizations.of(tester.element(find.byType(OnboardingConsentScreen)));
      await tester.tap(find.text(l10n.onboardingConsentAccept));
      await tester.pumpAndSettle();

      expect(container.read(onboardingControllerProvider).consentGivenAt, isNotNull);
      expect(find.byType(OnboardingNameScreen), findsOneWidget);
    },
  );
}
