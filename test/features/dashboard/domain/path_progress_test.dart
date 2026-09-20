import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/dashboard/domain/path_progress.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';

void main() {
  test('pathProgressFor reports 0 completed against the full curriculum size', () {
    final progress = pathProgressFor(LearningPath.frontEnd, const LearningProgress());

    expect(progress.completedCount, 0);
    expect(progress.totalCount, curriculumFor(LearningPath.frontEnd).length);
    expect(progress.ratio, 0);
  });

  test('pathProgressFor reflects completed modules for that path only', () {
    final firstId = curriculumFor(LearningPath.frontEnd).first.id;
    final progress = pathProgressFor(
      LearningPath.frontEnd,
      LearningProgress(completedModuleIds: {LearningPath.frontEnd: {firstId}}),
    );

    expect(progress.completedCount, 1);
    expect(progress.ratio, greaterThan(0));
  });

  test('computePathProgress returns one entry per LearningPath value', () {
    final all = computePathProgress(const LearningProgress());
    expect(all.map((p) => p.path).toSet(), LearningPath.values.toSet());
  });
}
