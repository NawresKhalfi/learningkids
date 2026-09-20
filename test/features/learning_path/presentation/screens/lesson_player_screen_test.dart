import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/core/router/app_routes.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/learning_path/data/learning_progress_repository.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/module.dart';
import 'package:learningkids/features/learning_path/presentation/screens/lesson_player_screen.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/notification_overrides.dart';
import '../../../../support/pump_localized_widget.dart';

void main() {
  final module = curriculumFor(LearningPath.frontEnd).first; // 'frontend-1': 2 sections, 2 quiz Qs

  Future<FakeFirebaseFirestore> pumpPlayer(WidgetTester tester, {String uid = 'kid-1'}) async {
    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: uid, email: 'kid@example.com'),
    );

    await pumpLocalizedWidget(
      tester,
      LessonPlayerScreen(path: LearningPath.frontEnd, moduleId: module.id),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        learningProgressRepositoryProvider.overrideWithValue(
          LearningProgressRepository(firestore: firestore),
        ),
        gamificationRepositoryProvider.overrideWithValue(GamificationRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
        ...await disabledNotificationOverrides(),
      ],
    );
    return firestore;
  }

  testWidgets('shows the intro with a duration estimate and the section outline (US20)', (
    tester,
  ) async {
    await pumpPlayer(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(LessonPlayerScreen)));

    expect(find.text(l10n.lessonIntroDuration(estimatedLessonMinutes(module))), findsOneWidget);
    for (final section in module.lesson.sections) {
      expect(find.text(section.heading), findsOneWidget);
    }
    expect(find.text(l10n.lessonIntroStart), findsOneWidget);
  });

  testWidgets(
    'walks through reading, answers the quiz with immediate feedback, and marks it complete '
    '(US21/US22)',
    (tester) async {
      final firestore = await pumpPlayer(tester);
      final l10n = AppLocalizations.of(tester.element(find.byType(LessonPlayerScreen)));

      await tester.tap(find.text(l10n.lessonIntroStart));
      await tester.pumpAndSettle();
      expect(find.text(module.lesson.sections[0].heading), findsOneWidget);

      await tester.tap(find.text(l10n.lessonNext));
      await tester.pumpAndSettle();
      expect(find.text(module.lesson.sections[1].heading), findsOneWidget);

      await tester.tap(find.text(l10n.lessonNext));
      await tester.pumpAndSettle();
      expect(find.text(l10n.lessonRecapTitle), findsOneWidget);
      expect(find.text(l10n.lessonStartQuiz), findsOneWidget);

      await tester.tap(find.text(l10n.lessonStartQuiz));
      await tester.pumpAndSettle();

      // Question 1: tap the correct option, expect explanation + feedback.
      final q1 = module.quiz[0];
      await tester.tap(find.text(q1.options[q1.correctIndex]));
      await tester.pumpAndSettle();
      expect(find.text(q1.explanation), findsOneWidget);
      expect(find.text(l10n.quizNext), findsOneWidget);

      await tester.tap(find.text(l10n.quizNext));
      await tester.pumpAndSettle();

      // Question 2: tap the correct option, then finish.
      final q2 = module.quiz[1];
      expect(find.text(q2.prompt), findsOneWidget);
      await tester.tap(find.text(q2.options[q2.correctIndex]));
      await tester.pumpAndSettle();
      expect(find.text(l10n.quizFinish), findsOneWidget);

      await tester.tap(find.text(l10n.quizFinish));
      await tester.pumpAndSettle();

      expect(find.text(l10n.lessonCompletedTitle), findsOneWidget);
      expect(find.text(l10n.lessonCompletedMessage(2, 2)), findsOneWidget);

      final doc = await firestore
          .collection('users')
          .doc('kid-1')
          .collection('learning')
          .doc('progress')
          .get();
      expect(doc.data()!['completed_frontEnd'], contains(module.id));
      expect(doc.data()!['quizScore_${module.id}'], 2, reason: 'EP09/US51: the quiz score should be recorded too');
    },
  );

  testWidgets('resumes at the saved step instead of restarting from the top (US25)', (
    tester,
  ) async {
    final firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    final repo = LearningProgressRepository(firestore: firestore);
    // Step 2 means: 0-indexed section 1 (the second reading section).
    await repo.saveLessonStep('kid-1', module.id, 2);

    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      LessonPlayerScreen(path: LearningPath.frontEnd, moduleId: module.id),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        learningProgressRepositoryProvider.overrideWithValue(repo),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(LessonPlayerScreen)));

    expect(find.text(l10n.lessonIntroResume), findsOneWidget);

    await tester.tap(find.text(l10n.lessonIntroResume));
    await tester.pumpAndSettle();

    expect(find.text(module.lesson.sections[1].heading), findsOneWidget);
    expect(find.text(module.lesson.sections[0].heading), findsNothing);
  });

  testWidgets('"Revoir la leçon" from the quiz jumps back to the first reading section (US23)', (
    tester,
  ) async {
    await pumpPlayer(tester);
    final l10n = AppLocalizations.of(tester.element(find.byType(LessonPlayerScreen)));

    await tester.tap(find.text(l10n.lessonIntroStart));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.lessonNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.lessonNext));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.lessonStartQuiz));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.quizReviewLesson));
    await tester.pumpAndSettle();

    expect(find.text(module.lesson.sections[0].heading), findsOneWidget);
  });

  testWidgets(
    '"Essayer en pratique" appears only for modules with a practical exercise and opens the Git '
    'simulator (EP10/US53)',
    (tester) async {
      final gitModule = curriculumFor(LearningPath.collaboration).first; // 'collaboration-1'
      expect(gitModule.practicalExercise, isNotNull);

      await tester.binding.setSurfaceSize(const Size(400, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final firestore = FakeFirebaseFirestore();
      final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
          learningProgressRepositoryProvider.overrideWithValue(LearningProgressRepository(firestore: firestore)),
          gamificationRepositoryProvider.overrideWithValue(GamificationRepository(firestore: firestore)),
          profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
          ...await disabledNotificationOverrides(),
        ],
      );
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/lesson',
        routes: [
          GoRoute(
            path: '/lesson',
            builder: (_, _) => LessonPlayerScreen(path: LearningPath.collaboration, moduleId: gitModule.id),
          ),
          GoRoute(path: AppRoutes.gitSimulator, builder: (_, _) => const Scaffold(body: Text('git simulator stub'))),
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

      final l10n = AppLocalizations.of(tester.element(find.byType(LessonPlayerScreen)));

      await tester.tap(find.text(l10n.lessonIntroStart));
      await tester.pumpAndSettle();
      for (var i = 0; i < gitModule.lesson.sections.length; i++) {
        await tester.tap(find.text(l10n.lessonNext));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text(l10n.lessonStartQuiz));
      await tester.pumpAndSettle();

      for (final question in gitModule.quiz) {
        await tester.tap(find.text(question.options[question.correctIndex]));
        await tester.pumpAndSettle();
        final isLast = question == gitModule.quiz.last;
        await tester.tap(find.text(isLast ? l10n.quizFinish : l10n.quizNext));
        await tester.pumpAndSettle();
      }

      expect(find.text(l10n.lessonTryPracticalExercise), findsOneWidget);

      await tester.tap(find.text(l10n.lessonTryPracticalExercise));
      await tester.pumpAndSettle();

      expect(find.text('git simulator stub'), findsOneWidget);
    },
  );
}
