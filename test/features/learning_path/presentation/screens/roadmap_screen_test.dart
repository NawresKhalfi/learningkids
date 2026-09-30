import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/application/learning_progress_controller.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';
import 'package:learningkids/features/learning_path/presentation/screens/roadmap_screen.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows unlocked/locked icons per prerequisite and warns when tapping a locked module',
      (tester) async {
    await pumpLocalizedWidget(
      tester,
      const RoadmapScreen(path: LearningPath.python),
      overrides: [
        learningProgressProvider.overrideWith((ref) => Stream.value(const LearningProgress())),
      ],
    );

    final modules = curriculumFor(LearningPath.python);
    // First module has no prerequisites: unlocked.
    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
    // The list lazily builds only visible rows; the visible later modules
    // must nevertheless display the locked state.
    expect(find.byIcon(Icons.lock), findsWidgets);

    await tester.tap(find.text(modules[1].title));
    await tester.pump(); // let the SnackBar animate in
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining(modules[0].title), findsWidgets);
  });

  testWidgets('a completed module shows the check icon', (tester) async {
    final firstModuleId = curriculumFor(LearningPath.frontEnd).first.id;

    await pumpLocalizedWidget(
      tester,
      const RoadmapScreen(path: LearningPath.frontEnd),
      overrides: [
        learningProgressProvider.overrideWith(
          (ref) => Stream.value(
            LearningProgress(
              activePaths: const {LearningPath.frontEnd},
              completedModuleIds: {
                LearningPath.frontEnd: {firstModuleId},
              },
            ),
          ),
        ),
      ],
    );

    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
