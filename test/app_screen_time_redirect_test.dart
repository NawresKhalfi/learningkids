import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/app.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/home/presentation/screens/home_screen.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/parental_control/data/parental_control_repository.dart';
import 'package:learningkids/features/parental_control/presentation/screens/screen_time_limit_screen.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end proof of US09's core acceptance criterion — "blocage
/// automatique de l'app une fois la limite atteinte" — through the real
/// router redirect, not just the pure domain check.
void main() {
  testWidgets(
    'an onboarded user who already hit today\'s limit is sent straight to the blocking screen',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = LocalPreferences(await SharedPreferences.getInstance());
      await prefs.setOnboardingCompleted(true);

      const uid = 'kid-1';
      final profileFirestore = FakeFirebaseFirestore();
      await profileFirestore.collection('users').doc(uid).set(
        UserProfile(
          uid: uid,
          pseudo: 'Léo',
          avatar: Avatar.fox,
          ageRange: AgeRange.sevenToNine,
          codingLevel: CodingLevel.beginner,
          goals: const {},
          recommendedPath: RecommendedPath.discovery,
          consentGivenAt: DateTime.utc(2026, 1, 1),
        ).toMap(),
      );

      final parentalControlRepository = ParentalControlRepository(
        firestore: FakeFirebaseFirestore(),
      );
      await parentalControlRepository.setDailyLimit(uid, 5);
      await parentalControlRepository.incrementTodayMinutes(uid, 5);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              AuthRepository(
                firebaseAuth: MockFirebaseAuth(
                  signedIn: true,
                  mockUser: MockUser(uid: uid, email: 'kid@example.com'),
                ),
              ),
            ),
            localPreferencesProvider.overrideWithValue(prefs),
            profileRepositoryProvider.overrideWithValue(
              ProfileRepository(firestore: profileFirestore),
            ),
            parentalControlRepositoryProvider.overrideWithValue(parentalControlRepository),
          ],
          child: const LearningKidsApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ScreenTimeLimitScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    },
  );
}
