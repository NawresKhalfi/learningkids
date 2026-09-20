import '../../learning_path/domain/curriculum.dart';
import '../../learning_path/domain/learning_path.dart';
import '../../learning_path/domain/learning_progress.dart';
import '../../learning_path/domain/lesson_language.dart';

/// How many of the modules tagged with a given language the learner has
/// completed, across every path — the "compétences acquises" view (US49).
class SkillProgress {
  const SkillProgress({required this.language, required this.completedCount, required this.totalCount});

  final LessonLanguage language;
  final int completedCount;
  final int totalCount;

  double get ratio => totalCount == 0 ? 0 : completedCount / totalCount;
}

/// Only languages that actually appear in the curriculum are returned —
/// there is no point showing a 0/0 skill.
List<SkillProgress> computeSkillProgress(LearningProgress progress) {
  final totals = <LessonLanguage, int>{};
  final completed = <LessonLanguage, int>{};

  for (final path in LearningPath.values) {
    final completedIds = progress.completedIdsFor(path);
    for (final module in curriculumFor(path)) {
      for (final language in module.languages) {
        totals[language] = (totals[language] ?? 0) + 1;
        if (completedIds.contains(module.id)) {
          completed[language] = (completed[language] ?? 0) + 1;
        }
      }
    }
  }

  return [
    for (final language in LessonLanguage.values)
      if (totals[language] != null)
        SkillProgress(language: language, completedCount: completed[language] ?? 0, totalCount: totals[language]!),
  ];
}
