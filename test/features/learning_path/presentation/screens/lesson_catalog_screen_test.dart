import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/application/learning_progress_controller.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';
import 'package:learningkids/features/learning_path/presentation/screens/lesson_catalog_screen.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('lists every module by default, then narrows down when filtering by language (US24)', (
    tester,
  ) async {
    // Wide enough that every filter chip is laid out (not just scrolled
    // into range) so `find.byKey` can reach each one directly.
    await tester.binding.setSurfaceSize(const Size(1000, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpLocalizedWidget(
      tester,
      const LessonCatalogScreen(),
      overrides: [
        learningProgressProvider.overrideWith((ref) => Stream.value(const LearningProgress())),
      ],
    );
    expect(find.text(allModules.first.title), findsOneWidget);
    expect(find.text(allModules.last.title), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('lesson_catalog_filter_python')));
    await tester.pumpAndSettle();

    final languageLabels = LessonLanguage.values.map(lessonLanguageLabel).toSet();
    final pythonModules = allModules.where((m) => m.languages.contains(LessonLanguage.python));
    // Exclude modules whose title happens to equal a language's chip label
    // (e.g. the "TypeScript" module) — that label is always on screen as a
    // filter chip, so it isn't a reliable signal that the *row* is hidden.
    final nonPythonModules = allModules.where(
      (m) => !m.languages.contains(LessonLanguage.python) && !languageLabels.contains(m.title),
    );
    for (final module in pythonModules) {
      expect(find.text(module.title), findsOneWidget);
    }
    for (final module in nonPythonModules) {
      expect(find.text(module.title), findsNothing);
    }

    await tester.tap(find.byKey(const ValueKey('lesson_catalog_filter_all')));
    await tester.pumpAndSettle();
    expect(find.text(allModules.first.title), findsOneWidget);
  });
}
