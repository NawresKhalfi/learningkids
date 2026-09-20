import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/parental_control/application/parental_control_controller.dart';
import 'package:learningkids/features/parental_control/domain/parent_pin.dart';
import 'package:learningkids/features/parental_control/domain/parental_settings.dart';
import 'package:learningkids/features/parental_control/presentation/screens/parent_gate_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('creating a PIN rejects a non-4-digit code', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const ParentGateScreen(),
      overrides: [
        parentalSettingsProvider.overrideWith((ref) => Stream.value(const ParentalSettings())),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ParentGateScreen)));

    await tester.enterText(find.byType(TextField), '12');
    await tester.tap(find.text(l10n.parentGateSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentGateErrorInvalidFormat), findsOneWidget);
  });

  testWidgets('creating a PIN moves to confirmation, then flags a mismatch', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const ParentGateScreen(),
      overrides: [
        parentalSettingsProvider.overrideWith((ref) => Stream.value(const ParentalSettings())),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ParentGateScreen)));

    await tester.enterText(find.byType(TextField), '1234');
    await tester.tap(find.text(l10n.parentGateSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentGateConfirmPinPrompt), findsOneWidget);

    await tester.enterText(find.byType(TextField), '4321');
    await tester.tap(find.text(l10n.parentGateSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentGateErrorMismatch), findsOneWidget);
  });

  testWidgets('entering the wrong PIN when one already exists shows an error', (tester) async {
    const uid = 'kid-1';
    final existingHash = hashParentPin('4242', uid);

    await pumpLocalizedWidget(
      tester,
      const ParentGateScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepository(
            firebaseAuth: MockFirebaseAuth(
              signedIn: true,
              mockUser: MockUser(uid: uid, email: 'kid@example.com'),
            ),
          ),
        ),
        parentalSettingsProvider.overrideWith(
          (ref) => Stream.value(ParentalSettings(pinHash: existingHash)),
        ),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ParentGateScreen)));

    expect(find.text(l10n.parentGateEnterPinPrompt), findsOneWidget);

    await tester.enterText(find.byType(TextField), '0000');
    await tester.tap(find.text(l10n.parentGateSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.parentGateErrorWrongPin), findsOneWidget);
  });
}
