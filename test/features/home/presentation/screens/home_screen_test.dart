import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/application/gamification_providers.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/home/presentation/screens/home_screen.dart';
import 'package:learningkids/features/learning_path/domain/learning_path_info.dart';
import 'package:learningkids/features/learning_path/domain/primary_path.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/application/profile_controller.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  final profile = UserProfile(
    uid: 'kid-1',
    pseudo: 'Léo',
    avatar: Avatar.panda,
    ageRange: AgeRange.sevenToNine,
    codingLevel: CodingLevel.someBasics,
    goals: const {},
    recommendedPath: RecommendedPath.frontEnd,
    consentGivenAt: DateTime.utc(2026, 1, 1),
  );

  testWidgets('greets the user and shows the recommended path', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const HomeScreen(),
      overrides: [
        currentProfileProvider.overrideWith((ref) => Stream.value(profile)),
        gamificationProfileProvider.overrideWith((ref) => Stream.value(const GamificationProfile())),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(HomeScreen)));

    final info = learningPathInfo(primaryPathFor(profile.recommendedPath));

    expect(find.text(l10n.homeGreeting('Léo')), findsOneWidget);
    expect(find.text('${info.emoji} ${info.title}'), findsOneWidget);
    expect(find.text(l10n.homeSeeAllPaths), findsOneWidget);
    expect(find.text(l10n.homeSeeLessonCatalog), findsOneWidget);
  });
}
