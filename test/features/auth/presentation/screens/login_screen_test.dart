import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/auth/presentation/screens/login_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows a friendly message when credentials are rejected', (tester) async {
    final mockAuth = MockFirebaseAuth();
    whenCalling(Invocation.method(#signInWithEmailAndPassword, null))
        .on(mockAuth)
        .thenThrow(FirebaseAuthException(code: 'wrong-password'));

    await pumpLocalizedWidget(
      tester,
      const LoginScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));

    await tester.enterText(find.byType(TextField).at(0), 'kid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text(l10n.loginSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.loginErrorInvalidCredentials), findsOneWidget);
  });

  testWidgets('successful login shows no error', (tester) async {
    final mockAuth = MockFirebaseAuth();

    await pumpLocalizedWidget(
      tester,
      const LoginScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(LoginScreen)));

    await tester.enterText(find.byType(TextField).at(0), 'kid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password1');
    await tester.tap(find.text(l10n.loginSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.loginErrorInvalidCredentials), findsNothing);
  });
}
