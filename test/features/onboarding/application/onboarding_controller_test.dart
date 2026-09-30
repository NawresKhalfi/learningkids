import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/onboarding/application/onboarding_controller.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/learning_path/data/learning_progress_repository.dart';
import 'package:learningkids/features/onboarding/domain/learning_goal.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FailingProfileRepository extends ProfileRepository {
  _FailingProfileRepository() : super(firestore: FakeFirebaseFirestore());

  @override
  Future<void> createInitialProfile(UserProfile profile) async {
    throw Exception('Firestore write failed');
  }
}

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore firestore;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    final prefs = LocalPreferences(await SharedPreferences.getInstance());

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepository(firebaseAuth: mockAuth),
        ),
        profileRepositoryProvider.overrideWithValue(
          ProfileRepository(firestore: firestore),
        ),
        learningProgressRepositoryProvider.overrideWithValue(
          LearningProgressRepository(firestore: firestore),
        ),
        localPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
  });

  test('submit throws when answers are incomplete', () {
    expect(
      () => container.read(onboardingControllerProvider.notifier).submit(),
      throwsStateError,
    );
  });

  test(
    'submit records onboarding as complete even if Firestore fails',
    () async {
      final failingRepo = _FailingProfileRepository();
      final prefs = LocalPreferences(await SharedPreferences.getInstance());
      final failingContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(
              firebaseAuth: MockFirebaseAuth(
                signedIn: true,
                mockUser: MockUser(uid: 'kid-2'),
              ),
            ),
          ),
          profileRepositoryProvider.overrideWithValue(failingRepo),
          learningProgressRepositoryProvider.overrideWithValue(
            LearningProgressRepository(firestore: firestore),
          ),
          localPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(failingContainer.dispose);

      final notifier = failingContainer.read(
        onboardingControllerProvider.notifier,
      );
      notifier.acceptConsent();
      notifier.setName('Léo');
      notifier.setAgeRange(AgeRange.sevenToNine);
      notifier.setCodingLevel(CodingLevel.someBasics);
      notifier.toggleGoal(LearningGoal.website);

      await expectLater(notifier.submit(), throwsException);
      expect(
        failingContainer
            .read(localPreferencesProvider)
            .hasCompletedOnboarding('kid-2'),
        isTrue,
      );
    },
  );

  test('submit persists the profile and marks onboarding complete', () async {
    final notifier = container.read(onboardingControllerProvider.notifier);
    notifier.acceptConsent();
    notifier.setName('Léo');
    notifier.setAgeRange(AgeRange.sevenToNine);
    notifier.setCodingLevel(CodingLevel.someBasics);
    notifier.toggleGoal(LearningGoal.website);

    await notifier.submit();

    final doc = await firestore.collection('users').doc('kid-1').get();
    expect(doc.data()!['pseudo'], 'Léo');
    expect(doc.data()!['ageRange'], 'sevenToNine');
    expect(doc.data()!['recommendedPath'], 'frontEnd');
    expect(doc.data()!['consentGivenAt'], isNotNull);
    expect(
      container.read(localPreferencesProvider).hasCompletedOnboarding('kid-1'),
      isTrue,
    );

    final progressDoc = await firestore
        .collection('users')
        .doc('kid-1')
        .collection('learning')
        .doc('progress')
        .get();
    expect(progressDoc.data()!['activePaths'], contains('frontEnd'));
  });

  test('toggleGoal adds then removes a goal', () {
    final notifier = container.read(onboardingControllerProvider.notifier);

    notifier.toggleGoal(LearningGoal.game);
    expect(container.read(onboardingControllerProvider).goals, {
      LearningGoal.game,
    });

    notifier.toggleGoal(LearningGoal.game);
    expect(container.read(onboardingControllerProvider).goals, isEmpty);
  });
}
