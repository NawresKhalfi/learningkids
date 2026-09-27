import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/gamification/domain/gamification_activity.dart';
import 'package:learningkids/features/learning_path/data/learning_progress_repository.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/parental_control/application/parental_control_controller.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the path progress and weekly summary', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));

    final profileRepository = ProfileRepository(firestore: firestore);
    await profileRepository.createInitialProfile(
      UserProfile(
        uid: 'kid-1',
        pseudo: 'Léo',
        avatar: Avatar.panda,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.someBasics,
        goals: const {},
        recommendedPath: RecommendedPath.frontEnd,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final learningRepository = LearningProgressRepository(firestore: firestore);
    await learningRepository.activatePath('kid-1', LearningPath.frontEnd);
    final modules = curriculumFor(LearningPath.frontEnd);
    // First module: a strong score (not weak). Second: a failing score
    // (flagged as a weak point, US51).
    await learningRepository.markModuleCompleted(
      'kid-1',
      LearningPath.frontEnd,
      modules[0].id,
      correctAnswers: modules[0].quiz.length,
    );
    await learningRepository.markModuleCompleted('kid-1', LearningPath.frontEnd, modules[1].id, correctAnswers: 0);

    // Mirrors the two modules marked completed above (the repository call
    // alone doesn't award XP — that coupling lives in
    // `LearningProgressController`, exercised separately).
    final gamificationRepository = GamificationRepository(firestore: firestore);
    await gamificationRepository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    await gamificationRepository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    await gamificationRepository.recordActivity(
      'kid-1',
      activity: GamificationActivity.projectPublished,
      pseudo: 'Léo',
      avatarId: 'panda',
    );

    await pumpLocalizedWidget(
      tester,
      const DashboardScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        learningProgressRepositoryProvider.overrideWithValue(learningRepository),
        gamificationRepositoryProvider.overrideWithValue(gamificationRepository),
        profileRepositoryProvider.overrideWithValue(profileRepository),
        usageHistoryProvider.overrideWith((ref) async => {DateTime.now(): 15}),
      ],
    );

    // Recommended-path progress.
    expect(find.text('2/${modules.length} modules terminés'), findsOneWidget);

    // Weekly summary (US50): 2 lessons (20 XP each) + 1 project (30 XP),
    // all recorded just now, so the whole total counts as "this week".
    await tester.tap(find.text('Cette semaine'));
    await tester.pumpAndSettle();
    expect(find.text('2 leçons terminées'), findsOneWidget);
    expect(find.text('70 XP gagnés'), findsOneWidget);
    expect(find.text('1 projets publiés'), findsOneWidget);

    // Recommended path is Front-End.
    expect(find.textContaining('Front-End'), findsWidgets);
  });
}
