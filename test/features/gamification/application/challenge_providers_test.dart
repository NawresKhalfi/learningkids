import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/application/challenge_providers.dart';
import 'package:learningkids/features/gamification/data/challenge_repository.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        challengeRepositoryProvider.overrideWithValue(ChallengeRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
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

  test('hasCompletedChallengeProvider is false, then true after markCompleted (US56)', () async {
    expect(await container.read(hasCompletedChallengeProvider.future), isFalse);

    await container.read(challengeControllerProvider.notifier).markCompleted();

    expect(await container.read(hasCompletedChallengeProvider.future), isTrue);
  });

  test('markCompleted records the signed-in learner\'s pseudo/avatar on the current week\'s leaderboard', () async {
    await container.read(challengeControllerProvider.notifier).markCompleted();

    final weekKey = container.read(currentWeekKeyProvider);
    final participants = await container.read(challengeParticipantsProvider.future);

    expect(participants, hasLength(1));
    expect(participants.first.uid, 'kid-1');
    expect(participants.first.pseudo, 'Léo');
    expect(weekKey, isNotEmpty);
  });
}
