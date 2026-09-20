import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/data/challenge_repository.dart';
import 'package:learningkids/features/gamification/presentation/screens/challenge_screen.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows this week\'s challenge and marks it done by self-report (US56)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
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

    await pumpLocalizedWidget(
      tester,
      const ChallengeScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        challengeRepositoryProvider.overrideWithValue(ChallengeRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ChallengeScreen)));

    expect(find.text(l10n.challengeMarkCompleted), findsOneWidget);
    expect(find.text(l10n.challengeLeaderboardEmpty), findsOneWidget);

    await tester.tap(find.text(l10n.challengeMarkCompleted));
    await tester.pumpAndSettle();

    expect(find.text(l10n.challengeCompleted), findsOneWidget);
    expect(find.text('Léo'), findsOneWidget);
  });
}
