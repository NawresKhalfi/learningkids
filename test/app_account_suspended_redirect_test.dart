import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/app.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';
import 'package:learningkids/features/admin/presentation/screens/account_suspended_screen.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/home/presentation/screens/home_screen.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// End-to-end proof of EP12/US63's blocking behaviour through the real
/// router redirect, not just the pure domain check.
void main() {
  testWidgets(
    'a suspended, onboarded user is sent straight to the blocking screen',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = LocalPreferences(await SharedPreferences.getInstance());
      const uid = 'kid-1';
      await prefs.setOnboardingCompleted(uid, true);
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc(uid)
          .set(
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

      final adminRepository = AdminRepository(firestore: firestore);
      await adminRepository.setAccountSuspended(uid, true);

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
              ProfileRepository(firestore: firestore),
            ),
            adminRepositoryProvider.overrideWithValue(adminRepository),
          ],
          child: const LearningKidsApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AccountSuspendedScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    },
  );
}
