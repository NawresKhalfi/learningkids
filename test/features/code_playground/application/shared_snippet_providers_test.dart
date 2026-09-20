import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/application/shared_snippet_providers.dart';
import 'package:learningkids/features/code_playground/data/shared_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
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
        sharedSnippetRepositoryProvider.overrideWithValue(SharedSnippetRepository(firestore: firestore)),
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

  test('shareSnippet stores the current code under the signed-in learner\'s pseudo (US55)', () async {
    final id = await container
        .read(sharedSnippetControllerProvider.notifier)
        .shareSnippet(language: ProgrammingLanguage.python, code: "print('hi')");

    final snippet = await container.read(sharedSnippetProvider(id).future);

    expect(snippet, isNotNull);
    expect(snippet!.pseudo, 'Léo');
    expect(snippet.ownerUid, 'kid-1');
    expect(snippet.code, "print('hi')");
  });

  test('sharedSnippetProvider resolves to null for an unknown id', () async {
    final snippet = await container.read(sharedSnippetProvider('unknown').future);
    expect(snippet, isNull);
  });
}
