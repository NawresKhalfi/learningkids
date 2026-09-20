import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/application/gamification_providers.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/gamification/domain/streak.dart';
import 'package:learningkids/features/gamification/presentation/widgets/streak_banner.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the current streak and level when not at risk', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const StreakBanner(),
      overrides: [
        gamificationProfileProvider.overrideWith(
          (ref) => Stream.value(
            GamificationProfile(totalXp: 40, streak: Streak(current: 4, longest: 4, lastActiveDate: DateTime.now())),
          ),
        ),
      ],
    );

    expect(find.text('🔥 4 jours de suite'), findsOneWidget);
    expect(find.textContaining('Niveau 1'), findsOneWidget);
  });

  testWidgets('shows the at-risk warning when the learner hasn\'t acted today yet', (tester) async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    await pumpLocalizedWidget(
      tester,
      const StreakBanner(),
      overrides: [
        gamificationProfileProvider.overrideWith(
          (ref) => Stream.value(GamificationProfile(streak: Streak(current: 5, longest: 5, lastActiveDate: yesterday))),
        ),
      ],
    );

    expect(find.text('Ton streak est en danger ! Apprends aujourd\'hui pour le garder.'), findsOneWidget);
  });
}
