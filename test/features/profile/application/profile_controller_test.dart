import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/application/profile_controller.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';

void main() {
  late ProviderContainer container;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth mockAuth;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    await firestore.collection('users').doc('kid-1').set(
      UserProfile(
        uid: 'kid-1',
        pseudo: 'Léo',
        avatar: Avatar.fox,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.beginner,
        goals: const {},
        recommendedPath: RecommendedPath.discovery,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ).toMap(),
    );

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        profileRepositoryProvider
            .overrideWithValue(ProfileRepository(firestore: firestore)),
      ],
    );
    addTearDown(container.dispose);
  });

  test('updateProfile writes the new pseudo and avatar', () async {
    final failure = await container
        .read(profileControllerProvider.notifier)
        .updateProfile(pseudo: 'Emma', avatar: Avatar.owl);

    expect(failure, isNull);
    final doc = await firestore.collection('users').doc('kid-1').get();
    expect(doc.data()!['pseudo'], 'Emma');
    expect(doc.data()!['avatarId'], 'owl');
  });

  test('deleteAccount removes the Firestore profile', () async {
    final failure = await container.read(profileControllerProvider.notifier).deleteAccount();

    expect(failure, isNull);
    final doc = await firestore.collection('users').doc('kid-1').get();
    expect(doc.exists, isFalse);
  });

  test('currentProfileProvider streams the Firestore profile for the signed-in user',
      () async {
    // Let the auth stream resolve first: reading `currentProfileProvider.future`
    // before that would capture its very first build (made while the uid is
    // still unknown), which gets superseded once auth resolves and never
    // completes on its own.
    await container.read(authStateChangesProvider.future);
    final profile = await container.read(currentProfileProvider.future);
    expect(profile?.pseudo, 'Léo');
  });
}
