import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/application/gamification_providers.dart';
import 'package:learningkids/features/gamification/domain/badge_catalog.dart';
import 'package:learningkids/features/gamification/domain/gamification_profile.dart';
import 'package:learningkids/features/gamification/presentation/screens/badges_screen.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows every badge in the catalog, unlocked ones included (US44)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      const BadgesScreen(),
      overrides: [
        gamificationProfileProvider.overrideWith(
          (ref) => Stream.value(const GamificationProfile(unlockedBadgeIds: {'first-lesson'})),
        ),
      ],
    );

    for (final badge in badgeCatalog) {
      expect(find.text(badge.title), findsOneWidget, reason: badge.id);
    }
  });

  testWidgets('locked badges show reduced opacity, unlocked ones do not', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      const BadgesScreen(),
      overrides: [
        gamificationProfileProvider.overrideWith(
          (ref) => Stream.value(const GamificationProfile(unlockedBadgeIds: {'first-lesson'})),
        ),
      ],
    );

    final unlockedTitle = badgeCatalog.firstWhere((b) => b.id == 'first-lesson').title;
    final lockedTitle = badgeCatalog.firstWhere((b) => b.id != 'first-lesson').title;

    final unlockedOpacity = tester.widget<Opacity>(
      find.ancestor(of: find.text(unlockedTitle), matching: find.byType(Opacity)).first,
    );
    final lockedOpacity = tester.widget<Opacity>(
      find.ancestor(of: find.text(lockedTitle), matching: find.byType(Opacity)).first,
    );

    expect(unlockedOpacity.opacity, 1);
    expect(lockedOpacity.opacity, lessThan(1));
  });
}
