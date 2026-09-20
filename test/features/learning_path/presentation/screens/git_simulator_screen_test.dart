import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/git_simulator_step.dart';
import 'package:learningkids/features/learning_path/presentation/screens/git_simulator_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('picking a wrong command shows a try-again message and does not advance', (tester) async {
    await pumpLocalizedWidget(tester, const GitSimulatorScreen());
    final l10n = AppLocalizations.of(tester.element(find.byType(GitSimulatorScreen)));
    final firstStep = gitSimulatorScenario.first;
    final wrongOption = firstStep.commandOptions.firstWhere((c) => c != firstStep.correctCommand);

    await tester.tap(find.text(wrongOption));
    await tester.pumpAndSettle();

    expect(find.text(l10n.gitSimulatorTryAgain), findsOneWidget);
    expect(find.text(firstStep.instruction), findsOneWidget);
  });

  testWidgets('picking the correct command at every step reaches the finished view', (tester) async {
    await pumpLocalizedWidget(tester, const GitSimulatorScreen());
    final l10n = AppLocalizations.of(tester.element(find.byType(GitSimulatorScreen)));

    for (final step in gitSimulatorScenario) {
      await tester.tap(find.text(step.correctCommand));
      await tester.pumpAndSettle();
    }

    expect(find.text(l10n.gitSimulatorFinished), findsOneWidget);
    expect(find.text(l10n.gitSimulatorRestart), findsOneWidget);
  });

  testWidgets('restart resets back to the first step', (tester) async {
    await pumpLocalizedWidget(tester, const GitSimulatorScreen());
    final l10n = AppLocalizations.of(tester.element(find.byType(GitSimulatorScreen)));

    for (final step in gitSimulatorScenario) {
      await tester.tap(find.text(step.correctCommand));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text(l10n.gitSimulatorRestart));
    await tester.pumpAndSettle();

    expect(find.text(gitSimulatorScenario.first.instruction), findsOneWidget);
  });
}
