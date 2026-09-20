import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/application/gamification_providers.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_notification_service.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;
  late FakeNotificationService fakeNotificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    firestore = FakeFirebaseFirestore();
    fakeNotificationService = FakeNotificationService();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        gamificationRepositoryProvider.overrideWithValue(GamificationRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
        localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
        notificationServiceProvider.overrideWithValue(fakeNotificationService),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authStateChangesProvider.future);
    await ProfileRepository(firestore: firestore).createInitialProfile(
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
  });

  test('recordLessonCompleted awards XP using the signed-in learner\'s pseudo/avatar', () async {
    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();

    final profile = await GamificationRepository(firestore: firestore).watchProfile('kid-1').first;
    expect(profile.lessonsCompletedCount, 1);

    final entry = await firestore.collection('leaderboard').doc('kid-1').get();
    expect(entry.data()!['pseudo'], 'Léo');
    expect(entry.data()!['avatarId'], 'panda');
  });

  test('recordProjectPublished awards XP for the project counter', () async {
    await container.read(gamificationControllerProvider.notifier).recordProjectPublished();

    final profile = await GamificationRepository(firestore: firestore).watchProfile('kid-1').first;
    expect(profile.projectsPublishedCount, 1);
  });

  test('recordLessonCompleted fires a badge reward notification the first time it unlocks (EP11/US58)', () async {
    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();

    expect(fakeNotificationService.shownRewards.any((r) => r.title.contains('badge')), isTrue);

    fakeNotificationService.shownRewards.clear();
    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();

    expect(fakeNotificationService.shownRewards.any((r) => r.title.contains('badge')), isFalse);
  });

  test('recordLessonCompleted fires a level-up reward notification once a level boundary is crossed', () async {
    // 20 XP/lesson, 100 XP/level — level 2 is reached on the 5th lesson.
    for (var i = 0; i < 4; i++) {
      await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();
    }
    expect(fakeNotificationService.shownRewards.any((r) => r.title.contains('Niveau')), isFalse);

    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();

    expect(fakeNotificationService.shownRewards.any((r) => r.title.contains('Niveau')), isTrue);
  });

  test('no reward notification fires once the learner disabled them (US59)', () async {
    await container.read(localPreferencesProvider).setRewardNotificationsEnabled(false);

    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();

    expect(fakeNotificationService.shownRewards, isEmpty);
  });

  test('setLeaderboardOptOut(true) removes the learner from the leaderboard (US48)', () async {
    await container.read(gamificationControllerProvider.notifier).recordLessonCompleted();
    expect((await firestore.collection('leaderboard').doc('kid-1').get()).exists, isTrue);

    await container.read(gamificationControllerProvider.notifier).setLeaderboardOptOut(true);

    expect((await firestore.collection('leaderboard').doc('kid-1').get()).exists, isFalse);
  });
}
