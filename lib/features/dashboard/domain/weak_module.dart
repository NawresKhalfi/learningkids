import '../../learning_path/domain/curriculum.dart';
import '../../learning_path/domain/learning_path.dart';
import '../../learning_path/domain/learning_progress.dart';
import '../../learning_path/domain/module.dart';

/// A completed module whose quiz score fell below [weakModuleThreshold] —
/// a candidate "notion à retravailler" (US51). A module is only ever a
/// notion-sized unit here, not individual questions: the curriculum has no
/// finer-grained tagging to detect failure rate at a smaller scale.
class WeakModule {
  const WeakModule({required this.module, required this.path, required this.correctAnswers});

  final Module module;
  final LearningPath path;
  final int correctAnswers;

  double get ratio => module.quiz.isEmpty ? 1 : correctAnswers / module.quiz.length;
}

const weakModuleThreshold = 0.7;

/// Modules the learner completed but scored below threshold on — never
/// modules that are still incomplete, or that were completed before EP09
/// started recording scores (no score means "unknown", not "weak").
List<WeakModule> computeWeakModules(LearningProgress progress) {
  final weak = <WeakModule>[];
  for (final path in LearningPath.values) {
    final completedIds = progress.completedIdsFor(path);
    for (final module in curriculumFor(path)) {
      if (!completedIds.contains(module.id) || module.quiz.isEmpty) continue;
      final score = progress.quizScoreFor(module.id);
      if (score == null) continue;
      if (score / module.quiz.length < weakModuleThreshold) {
        weak.add(WeakModule(module: module, path: path, correctAnswers: score));
      }
    }
  }
  return weak;
}
