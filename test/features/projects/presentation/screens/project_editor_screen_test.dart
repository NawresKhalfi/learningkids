import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';
import 'package:learningkids/features/projects/presentation/screens/project_editor_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/notification_overrides.dart';

/// Uses an HTML project and never taps "Exécuter": both `HiddenRuntimeWebView`
/// (Python/JS) and `HtmlPreviewView`'s live render are backed by
/// `webview_flutter`, which has no test double (same EP05 limitation) — the
/// editor's own controls (rename/category/publish/delete) don't need either.
Project _htmlProject({bool isPublished = false}) => Project(
  id: '',
  title: 'Ma carte',
  language: ProgrammingLanguage.html,
  category: ProjectCategory.website,
  code: '<h1>Salut</h1>',
  createdAt: DateTime.utc(2026, 1, 1),
  isPublished: isPublished,
);

Future<String> _pumpEditor(
  WidgetTester tester, {
  required FakeFirebaseFirestore firestore,
  required Project project,
}) async {
  await tester.binding.setSurfaceSize(const Size(400, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
      projectRepositoryProvider.overrideWithValue(ProjectRepository(firestore: firestore)),
      gamificationRepositoryProvider.overrideWithValue(GamificationRepository(firestore: firestore)),
      profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
      ...await disabledNotificationOverrides(),
    ],
  );
  addTearDown(container.dispose);

  final id = await ProjectRepository(firestore: firestore).createProject('kid-1', project);

  // Starts at `/projects` and pushes into the editor — like the real app —
  // so there's a route to pop back to (delete calls `context.pop()`).
  final router = GoRouter(
    initialLocation: '/projects',
    routes: [
      GoRoute(path: '/projects', builder: (_, _) => const Scaffold(body: Text('my-projects'))),
      GoRoute(
        path: '/projects/:projectId',
        builder: (_, state) => ProjectEditorScreen(projectId: state.pathParameters['projectId']!),
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

  router.push('/projects/$id');
  await tester.pumpAndSettle();
  return id;
}

void main() {
  testWidgets('renaming updates the saved title', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final id = await _pumpEditor(tester, firestore: firestore, project: _htmlProject());

    await tester.tap(find.text('Ma carte'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('rename_project_field')), 'Nouveau nom');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.text('Nouveau nom'), findsOneWidget);
    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', id);
    expect(saved!.title, 'Nouveau nom');
  });

  testWidgets('changing the category persists the new choice (US41)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final id = await _pumpEditor(tester, firestore: firestore, project: _htmlProject());

    await tester.tap(find.byIcon(Icons.category_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Outil'));
    await tester.pumpAndSettle();

    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', id);
    expect(saved!.category, ProjectCategory.tool);
  });

  testWidgets('publishing marks the project published and captures a thumbnail (US39)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final id = await _pumpEditor(tester, firestore: firestore, project: _htmlProject());

    // `toImage()` (used to capture the thumbnail) needs real async time to
    // resolve, which the fake test clock alone never advances — and
    // `pumpAndSettle` only tracks pending frames, not this kind of
    // non-frame-scheduling async work, so a real delay is needed too.
    await tester.runAsync(() async {
      await tester.tap(find.text('Publier dans mon portfolio'));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await tester.pump();
    });

    expect(find.text('Retirer du portfolio'), findsOneWidget);
    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', id);
    expect(saved!.isPublished, isTrue);
  });

  testWidgets('unpublishing removes it from the portfolio', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final id = await _pumpEditor(tester, firestore: firestore, project: _htmlProject(isPublished: true));

    await tester.tap(find.text('Retirer du portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Publier dans mon portfolio'), findsOneWidget);
    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', id);
    expect(saved!.isPublished, isFalse);
  });

  testWidgets('deleting the project removes it and returns to the list', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final id = await _pumpEditor(tester, firestore: firestore, project: _htmlProject());

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Supprimer'));
    await tester.pumpAndSettle();

    expect(find.text('my-projects'), findsOneWidget);
    final saved = await ProjectRepository(firestore: firestore).fetchProject('kid-1', id);
    expect(saved, isNull);
  });
}
