import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/presentation/screens/project_templates_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

ProviderContainer _buildContainer(FakeFirebaseFirestore firestore) {
  final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
      projectRepositoryProvider.overrideWithValue(ProjectRepository(firestore: firestore)),
    ],
  );
}

void main() {
  testWidgets('tapping a template creates a project and navigates to its editor (US38)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final firestore = FakeFirebaseFirestore();
    final container = _buildContainer(firestore);
    addTearDown(container.dispose);

    String? openedProjectId;
    final router = GoRouter(
      initialLocation: '/projects/templates',
      routes: [
        GoRoute(path: '/projects/templates', builder: (_, _) => const ProjectTemplatesScreen()),
        GoRoute(
          path: '/projects/:projectId',
          builder: (_, state) {
            openedProjectId = state.pathParameters['projectId'];
            return const Scaffold(body: Text('editor'));
          },
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

    await tester.tap(find.text('Le lancer de dé magique'));
    await tester.pumpAndSettle();

    expect(find.text('editor'), findsOneWidget);
    expect(openedProjectId, isNotNull);

    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', openedProjectId!);
    expect(saved!.title, 'Le lancer de dé magique');
    expect(saved.code, contains('random'));
  });

  testWidgets('filtering by language narrows the catalog (US38)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = _buildContainer(FakeFirebaseFirestore());
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProjectTemplatesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Le lancer de dé magique'), findsOneWidget);
    expect(find.text('Carte de présentation'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('project_templates_filter_python')));
    await tester.pumpAndSettle();

    expect(find.text('Le lancer de dé magique'), findsOneWidget);
    expect(find.text('Carte de présentation'), findsNothing);
  });
}
