import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  Future<AppLocalizations> pump(WidgetTester tester) async {
    await pumpLocalizedWidget(
      tester,
      const SignUpScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepository(firebaseAuth: MockFirebaseAuth()),
        ),
      ],
    );
    return AppLocalizations.of(tester.element(find.byType(SignUpScreen)));
  }

  testWidgets('shows an error when the email is invalid', (tester) async {
    final l10n = await pump(tester);

    await tester.enterText(find.byType(TextField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextField).at(1), 'password1');
    await tester.enterText(find.byType(TextField).at(2), 'password1');
    await tester.tap(find.text(l10n.signUpSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.signUpErrorInvalidEmail), findsOneWidget);
  });

  testWidgets('shows an error when passwords do not match', (tester) async {
    final l10n = await pump(tester);

    await tester.enterText(find.byType(TextField).at(0), 'kid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password1');
    await tester.enterText(find.byType(TextField).at(2), 'password2');
    await tester.tap(find.text(l10n.signUpSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.signUpErrorPasswordMismatch), findsOneWidget);
  });

  testWidgets('shows an error when the password is too short', (tester) async {
    final l10n = await pump(tester);

    await tester.enterText(find.byType(TextField).at(0), 'kid@example.com');
    await tester.enterText(find.byType(TextField).at(1), '123');
    await tester.enterText(find.byType(TextField).at(2), '123');
    await tester.tap(find.text(l10n.signUpSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.signUpErrorWeakPassword), findsOneWidget);
  });

  testWidgets('valid input creates the account with no error shown', (
    tester,
  ) async {
    final l10n = await pump(tester);

    await tester.enterText(find.byType(TextField).at(0), 'kid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password1');
    await tester.enterText(find.byType(TextField).at(2), 'password1');
    await tester.tap(find.text(l10n.signUpSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.signUpErrorInvalidEmail), findsNothing);
    expect(find.text(l10n.signUpErrorPasswordMismatch), findsNothing);
    expect(find.text(l10n.signUpErrorWeakPassword), findsNothing);
  });

  testWidgets('shows Google sign-in but not Apple sign-in', (tester) async {
    final l10n = await pump(tester);

    expect(find.text(l10n.authContinueWithGoogle), findsOneWidget);
    expect(find.byIcon(Icons.apple), findsNothing);
  });
}
