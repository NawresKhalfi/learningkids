import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';

void main() {
  test('toMap/fromMap round-trips active paths and per-path completion', () {
    const progress = LearningProgress(
      activePaths: {LearningPath.frontEnd, LearningPath.python},
      completedModuleIds: {
        LearningPath.frontEnd: {'frontend-1', 'frontend-2'},
        LearningPath.python: {'python-1'},
      },
    );

    final restored = LearningProgress.fromMap(progress.toMap());

    expect(restored.activePaths, progress.activePaths);
    expect(restored.completedIdsFor(LearningPath.frontEnd), {'frontend-1', 'frontend-2'});
    expect(restored.completedIdsFor(LearningPath.python), {'python-1'});
    expect(restored.completedIdsFor(LearningPath.backend), isEmpty);
  });

  test('toMap/fromMap round-trips saved lesson step positions (US25)', () {
    const progress = LearningProgress(lessonSteps: {'frontend-2': 3, 'python-1': 1});

    final restored = LearningProgress.fromMap(progress.toMap());

    expect(restored.stepIndexFor('frontend-2'), 3);
    expect(restored.stepIndexFor('python-1'), 1);
  });

  test('stepIndexFor defaults to 0 (not started) for an unknown module', () {
    expect(const LearningProgress().stepIndexFor('frontend-1'), 0);
  });

  test('fromMap(null) is an empty, inactive progress', () {
    final progress = LearningProgress.fromMap(null);
    expect(progress.activePaths, isEmpty);
    expect(progress.isActive(LearningPath.frontEnd), isFalse);
  });

  test('isActive reflects membership in activePaths', () {
    const progress = LearningProgress(activePaths: {LearningPath.backend});
    expect(progress.isActive(LearningPath.backend), isTrue);
    expect(progress.isActive(LearningPath.python), isFalse);
  });

  test('toMap/fromMap round-trips quiz scores (EP09/US51)', () {
    const progress = LearningProgress(quizScores: {'frontend-1': 2, 'python-1': 1});

    final restored = LearningProgress.fromMap(progress.toMap());

    expect(restored.quizScoreFor('frontend-1'), 2);
    expect(restored.quizScoreFor('python-1'), 1);
  });

  test('quizScoreFor is null for a module never scored', () {
    expect(const LearningProgress().quizScoreFor('frontend-1'), isNull);
  });
}
