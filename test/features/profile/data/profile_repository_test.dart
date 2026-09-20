import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';

void main() {
  test('updatePortfolioVisibility flips the flag without touching other fields (US40)', () async {
    final repository = ProfileRepository(firestore: FakeFirebaseFirestore());
    final profile = UserProfile(
      uid: 'uid-1',
      pseudo: 'Léo',
      avatar: Avatar.panda,
      ageRange: AgeRange.sevenToNine,
      codingLevel: CodingLevel.someBasics,
      goals: const {},
      recommendedPath: RecommendedPath.frontEnd,
      consentGivenAt: DateTime.utc(2026, 1, 1),
    );
    await repository.createInitialProfile(profile);

    await repository.updatePortfolioVisibility('uid-1', true);

    final updated = await repository.fetchProfile('uid-1');
    expect(updated!.portfolioPublic, isTrue);
    expect(updated.pseudo, 'Léo');
  });

  test('createInitialProfile mirrors pseudo/avatar into accountDirectory (EP12/US63)', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = ProfileRepository(firestore: firestore);
    await repository.createInitialProfile(
      UserProfile(
        uid: 'uid-1',
        pseudo: 'Léo',
        avatar: Avatar.panda,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.someBasics,
        goals: const {},
        recommendedPath: RecommendedPath.frontEnd,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final directoryDoc = await firestore.collection('accountDirectory').doc('uid-1').get();
    expect(directoryDoc.data()!['pseudo'], 'Léo');
    expect(directoryDoc.data()!['avatarId'], 'panda');
  });

  test('updatePseudoAndAvatar keeps accountDirectory in sync', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = ProfileRepository(firestore: firestore);
    await repository.createInitialProfile(
      UserProfile(
        uid: 'uid-1',
        pseudo: 'Léo',
        avatar: Avatar.panda,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.someBasics,
        goals: const {},
        recommendedPath: RecommendedPath.frontEnd,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ),
    );

    await repository.updatePseudoAndAvatar(uid: 'uid-1', pseudo: 'Léa', avatar: Avatar.fox);

    final directoryDoc = await firestore.collection('accountDirectory').doc('uid-1').get();
    expect(directoryDoc.data()!['pseudo'], 'Léa');
    expect(directoryDoc.data()!['avatarId'], 'fox');
  });

  test('deleteProfile also removes the accountDirectory mirror', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = ProfileRepository(firestore: firestore);
    await repository.createInitialProfile(
      UserProfile(
        uid: 'uid-1',
        pseudo: 'Léo',
        avatar: Avatar.panda,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.someBasics,
        goals: const {},
        recommendedPath: RecommendedPath.frontEnd,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ),
    );

    await repository.deleteProfile('uid-1');

    final directoryDoc = await firestore.collection('accountDirectory').doc('uid-1').get();
    expect(directoryDoc.exists, isFalse);
  });
}
