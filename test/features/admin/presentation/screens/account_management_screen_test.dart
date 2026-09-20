import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';
import 'package:learningkids/features/admin/presentation/screens/account_management_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows an empty state with no accounts', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const AccountManagementScreen(),
      overrides: [adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: FakeFirebaseFirestore()))],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(AccountManagementScreen)));

    expect(find.text(l10n.adminAccountsEmpty), findsOneWidget);
  });

  testWidgets('lists accounts and toggling suspension persists it (US63)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('accountDirectory').doc('kid-2').set({'pseudo': 'Nora', 'avatarId': 'cat'});
    final adminRepository = AdminRepository(firestore: firestore);

    await pumpLocalizedWidget(
      tester,
      const AccountManagementScreen(),
      overrides: [adminRepositoryProvider.overrideWithValue(adminRepository)],
    );

    expect(find.text('Nora'), findsOneWidget);
    expect(await adminRepository.isAccountSuspended('kid-2'), isFalse);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(await adminRepository.isAccountSuspended('kid-2'), isTrue);
  });
}
