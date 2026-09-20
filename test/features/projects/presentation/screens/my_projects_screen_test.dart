import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';
import 'package:learningkids/features/projects/presentation/screens/my_projects_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

void main() {
  Future<void> pumpMyProjects(
    WidgetTester tester, {
    required FakeFirebaseFirestore firestore,
    required Map<String, Widget Function(GoRouterState)> extraRoutes,
  }) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        projectRepositoryProvider.overrideWithValue(ProjectRepository(firestore: firestore)),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/projects',
      routes: [
        GoRoute(path: '/projects', builder: (_, _) => const MyProjectsScreen()),
        for (final entry in extraRoutes.entries) GoRoute(path: entry.key, builder: (_, state) => entry.value(state)),
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
  }

  testWidgets('shows an empty state, then lists created projects', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await pumpMyProjects(tester, firestore: firestore, extraRoutes: {});

    expect(find.text("Tu n'as pas encore de projet. Crée-en un à partir d'un modèle guidé !"), findsOneWidget);

    await ProjectRepository(firestore: firestore).createProject(
      'kid-1',
      Project(
        id: '',
        title: 'Mon jeu',
        language: ProgrammingLanguage.python,
        category: ProjectCategory.game,
        code: "print('hi')",
        createdAt: DateTime.now(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mon jeu'), findsOneWidget);
  });

  testWidgets('filtering by category narrows the list (US41)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final repository = ProjectRepository(firestore: firestore);
    await repository.createProject(
      'kid-1',
      Project(
        id: '',
        title: 'Mon jeu',
        language: ProgrammingLanguage.python,
        category: ProjectCategory.game,
        code: 'code',
        createdAt: DateTime.now(),
      ),
    );
    await repository.createProject(
      'kid-1',
      Project(
        id: '',
        title: 'Mon outil',
        language: ProgrammingLanguage.javascript,
        category: ProjectCategory.tool,
        code: 'code',
        createdAt: DateTime.now(),
      ),
    );

    await pumpMyProjects(tester, firestore: firestore, extraRoutes: {});

    expect(find.text('Mon jeu'), findsOneWidget);
    expect(find.text('Mon outil'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('my_projects_filter_game')));
    await tester.pumpAndSettle();

    expect(find.text('Mon jeu'), findsOneWidget);
    expect(find.text('Mon outil'), findsNothing);
  });

  testWidgets('tapping "Nouveau projet" opens the template catalog', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await pumpMyProjects(
      tester,
      firestore: firestore,
      extraRoutes: {'/projects/templates': (_) => const Scaffold(body: Text('templates'))},
    );

    await tester.tap(find.text('Nouveau projet'));
    await tester.pumpAndSettle();

    expect(find.text('templates'), findsOneWidget);
  });

  testWidgets('tapping the portfolio icon opens the portfolio', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await pumpMyProjects(
      tester,
      firestore: firestore,
      extraRoutes: {'/portfolio': (_) => const Scaffold(body: Text('portfolio'))},
    );

    await tester.tap(find.byIcon(Icons.collections_bookmark_outlined));
    await tester.pumpAndSettle();

    expect(find.text('portfolio'), findsOneWidget);
  });
}
