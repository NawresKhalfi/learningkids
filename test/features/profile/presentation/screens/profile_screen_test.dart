import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/auth/domain/app_user.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/application/profile_controller.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:learningkids/features/profile/presentation/screens/profile_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  final profile = UserProfile(
    uid: 'kid-1',
    pseudo: 'Léo',
    avatar: Avatar.owl,
    ageRange: AgeRange.sevenToNine,
    codingLevel: CodingLevel.beginner,
    goals: const {},
    recommendedPath: RecommendedPath.discovery,
    consentGivenAt: DateTime.utc(2026, 1, 1),
  );

  Future<AppLocalizations> pump(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      const ProfileScreen(),
      overrides: [
        currentProfileProvider.overrideWith((ref) => Stream.value(profile)),
        authStateChangesProvider.overrideWith(
          (ref) => Stream.value(const AppUser(uid: 'kid-1', email: 'kid@example.com')),
        ),
      ],
    );
    return AppLocalizations.of(tester.element(find.byType(ProfileScreen)));
  }

  testWidgets('shows the pseudo, avatar and email', (tester) async {
    final l10n = await pump(tester);

    expect(find.text('Léo'), findsOneWidget);
    expect(find.text('kid@example.com'), findsOneWidget);
    expect(find.text(profile.avatar.emoji), findsOneWidget);
    expect(find.text(l10n.profileEditProfile), findsOneWidget);
  });

  testWidgets('tapping delete opens the confirmation dialog', (tester) async {
    final l10n = await pump(tester);

    await tester.tap(find.text(l10n.profileDeleteAccount));
    await tester.pumpAndSettle();

    expect(find.text(l10n.profileDeleteConfirmTitle), findsOneWidget);
    expect(find.text(l10n.profileDeleteConfirmBody), findsOneWidget);
  });
}
