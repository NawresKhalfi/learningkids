import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/application/gamification_providers.dart';
import 'package:learningkids/features/gamification/domain/leaderboard_entry.dart';
import 'package:learningkids/features/gamification/presentation/screens/leaderboard_screen.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('lists entries ordered by rank and highlights the signed-in learner (US46)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));

    await pumpLocalizedWidget(
      tester,
      const LeaderboardScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        leaderboardProvider.overrideWith(
          (ref) => Stream.value(const [
            LeaderboardEntry(uid: 'kid-2', pseudo: 'Emma', avatarId: 'fox', totalXp: 300),
            LeaderboardEntry(uid: 'kid-1', pseudo: 'Léo', avatarId: 'panda', totalXp: 150),
          ]),
        ),
      ],
    );

    expect(find.text('#1'), findsOneWidget);
    expect(find.text('Emma'), findsOneWidget);
    expect(find.text('#2'), findsOneWidget);
    expect(find.text('Léo'), findsOneWidget);
    expect(find.text('300 XP'), findsOneWidget);
  });

  testWidgets('shows an empty state before anyone has a score', (tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));

    await pumpLocalizedWidget(
      tester,
      const LeaderboardScreen(),
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        leaderboardProvider.overrideWith((ref) => Stream.value(const [])),
      ],
    );

    expect(find.text("Personne n'a encore de score. Sois le·la premier·ère !"), findsOneWidget);
  });
}
