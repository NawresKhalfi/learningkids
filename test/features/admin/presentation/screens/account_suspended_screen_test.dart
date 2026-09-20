import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/presentation/screens/account_suspended_screen.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the suspension message and a sign-out action (US63)', (tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));

    await pumpLocalizedWidget(
      tester,
      const AccountSuspendedScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth))],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(AccountSuspendedScreen)));

    expect(find.text(l10n.accountSuspendedTitle), findsOneWidget);
    expect(find.text(l10n.profileLogOut), findsOneWidget);

    await tester.tap(find.text(l10n.profileLogOut));
    await tester.pumpAndSettle();

    expect(mockAuth.currentUser, isNull);
  });
}
