import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/core/router/app_routes.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';
import 'package:learningkids/features/admin/data/moderation_repository.dart';
import 'package:learningkids/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

void main() {
  testWidgets('links to the moderation queue and accounts screens', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(path: '/admin', builder: (_, _) => const AdminHomeScreen()),
        GoRoute(path: AppRoutes.adminModerationQueue, builder: (_, _) => const Scaffold(body: Text('moderation stub'))),
        GoRoute(path: AppRoutes.adminAccounts, builder: (_, _) => const Scaffold(body: Text('accounts stub'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: firestore)),
          moderationRepositoryProvider.overrideWithValue(ModerationRepository(firestore: firestore)),
        ],
        child: MaterialApp.router(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(AdminHomeScreen)));

    await tester.tap(find.text(l10n.adminModerationQueueTitle));
    await tester.pumpAndSettle();
    expect(find.text('moderation stub'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.adminAccountsTitle));
    await tester.pumpAndSettle();
    expect(find.text('accounts stub'), findsOneWidget);
  });
}
