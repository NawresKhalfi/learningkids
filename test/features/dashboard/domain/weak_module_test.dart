import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/dashboard/domain/weak_module.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';

void main() {
  test('an incomplete module is never flagged, even with a low score on record', () {
    final module = curriculumFor(LearningPath.frontEnd).first;
    // A score without the module actually being marked completed shouldn't
    // happen in practice, but the function must still ignore it.
    final progress = LearningProgress(quizScores: {module.id: 0});

    expect(computeWeakModules(progress), isEmpty);
  });

  test('a completed module with no recorded score is never flagged (unknown, not weak)', () {
    final module = curriculumFor(LearningPath.frontEnd).first;
    final progress = LearningProgress(completedModuleIds: {LearningPath.frontEnd: {module.id}});

    expect(computeWeakModules(progress), isEmpty);
  });

  test('a completed module scoring below the threshold is flagged (US51)', () {
    final module = curriculumFor(LearningPath.frontEnd).firstWhere((m) => m.quiz.length >= 2);
    final failingScore = 0;
    final progress = LearningProgress(
      completedModuleIds: {LearningPath.frontEnd: {module.id}},
      quizScores: {module.id: failingScore},
    );

    final weak = computeWeakModules(progress);

    expect(weak, hasLength(1));
    expect(weak.single.module.id, module.id);
    expect(weak.single.ratio, lessThan(weakModuleThreshold));
  });

  test('a completed module scoring at or above the threshold is not flagged', () {
    final module = curriculumFor(LearningPath.frontEnd).first;
    final progress = LearningProgress(
      completedModuleIds: {LearningPath.frontEnd: {module.id}},
      quizScores: {module.id: module.quiz.length},
    );

    expect(computeWeakModules(progress), isEmpty);
  });
}
