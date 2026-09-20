import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/application/learning_progress_controller.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';
import 'package:learningkids/features/parental_control/application/parental_control_controller.dart';
import 'package:learningkids/features/parental_control/domain/parental_settings.dart';
import 'package:learningkids/features/parental_control/presentation/screens/parent_dashboard_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the current daily limit and this week\'s usage', (tester) async {
    final today = DateTime.now();
    final history = {
      for (var i = 6; i >= 0; i--)
        DateTime(today.year, today.month, today.day - i): i == 0 ? 20 : 0,
    };

    await pumpLocalizedWidget(
      tester,
      const ParentDashboardScreen(),
      overrides: [
        parentalSettingsProvider.overrideWith(
          (ref) => Stream.value(const ParentalSettings(dailyLimitMinutes: 30)),
        ),
        usageHistoryProvider.overrideWith((ref) async => history),
        learningProgressProvider.overrideWith(
          (ref) => Stream.value(
            const LearningProgress(
              completedModuleIds: {
                LearningPath.frontEnd: {'frontend-1', 'frontend-2'},
                LearningPath.python: {'python-1'},
              },
            ),
          ),
        ),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ParentDashboardScreen)));

    expect(find.text(l10n.parentDashboardLimitSet(30)), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text(l10n.parentDashboardLessonsCount(3)), findsOneWidget);
  });

  testWidgets('shows "no limit" when the parent has not set one', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const ParentDashboardScreen(),
      overrides: [
        parentalSettingsProvider.overrideWith((ref) => Stream.value(const ParentalSettings())),
        usageHistoryProvider.overrideWith((ref) async => const {}),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ParentDashboardScreen)));

    expect(find.text(l10n.parentDashboardLimitNone), findsOneWidget);
  });
}
