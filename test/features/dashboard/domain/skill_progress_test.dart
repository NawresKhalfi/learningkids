import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/dashboard/domain/skill_progress.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/learning_progress.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  test('only languages that actually appear in the curriculum are returned', () {
    final skills = computeSkillProgress(const LearningProgress());
    final languagesInCurriculum = <LessonLanguage>{
      for (final path in LearningPath.values)
        for (final module in curriculumFor(path)) ...module.languages,
    };

    expect(skills.map((s) => s.language).toSet(), languagesInCurriculum);
  });

  test('completedCount is 0 for every skill before anything is completed', () {
    final skills = computeSkillProgress(const LearningProgress());
    expect(skills.every((s) => s.completedCount == 0), isTrue);
  });

  test('completing a module increases the count for each language it is tagged with', () {
    final module = curriculumFor(LearningPath.frontEnd).firstWhere((m) => m.languages.isNotEmpty);
    final progress = LearningProgress(
      completedModuleIds: {LearningPath.frontEnd: {module.id}},
    );

    final skills = computeSkillProgress(progress);
    for (final language in module.languages) {
      final skill = skills.firstWhere((s) => s.language == language);
      expect(skill.completedCount, greaterThanOrEqualTo(1));
    }
  });

  test('ratio is between 0 and 1', () {
    for (final skill in computeSkillProgress(const LearningProgress())) {
      expect(skill.ratio, inInclusiveRange(0, 1));
    }
  });
}
