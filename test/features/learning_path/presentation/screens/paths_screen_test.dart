import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/application/learning_progress_controller.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';
import 'package:learningkids/features/learning_path/presentation/screens/paths_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the active label and the right CTA per path (US18)', (tester) async {
    // Every path card needs to be laid out (not just scrolled into the
    // default test viewport) for the count assertions below.
    await tester.binding.setSurfaceSize(const Size(400, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      const PathsScreen(),
      overrides: [
        learningProgressProvider.overrideWith(
          (ref) => Stream.value(const LearningProgress(activePaths: {LearningPath.frontEnd})),
        ),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(PathsScreen)));

    expect(find.text(l10n.pathsActiveLabel), findsOneWidget);
    expect(find.text(l10n.pathsOpenCta), findsOneWidget);
    expect(find.text(l10n.pathsActivateCta), findsNWidgets(LearningPath.values.length - 1));
  });
}
