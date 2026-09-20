import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/module.dart';

void main() {
  test('every path has a non-empty, ordered curriculum', () {
    for (final path in LearningPath.values) {
      final modules = curriculumFor(path);
      expect(modules, isNotEmpty, reason: '$path has no modules');
      expect(modules.every((m) => m.path == path), isTrue);

      final orders = modules.map((m) => m.order).toList();
      expect(orders, orderedEquals([...orders]..sort()), reason: '$path modules out of order');
    }
  });

  test('every prerequisite id refers to a real module in the same path', () {
    for (final path in LearningPath.values) {
      final modules = curriculumFor(path);
      final ids = modules.map((m) => m.id).toSet();
      for (final module in modules) {
        for (final prereqId in module.prerequisiteIds) {
          expect(
            ids.contains(prereqId),
            isTrue,
            reason: '${module.id} references unknown prerequisite $prereqId',
          );
        }
      }
    }
  });

  test('module ids are globally unique across all paths', () {
    final ids = allModules.map((m) => m.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('moduleById finds a module by its id', () {
    final first = curriculumFor(LearningPath.python).first;
    expect(moduleById(first.id).title, first.title);
  });

  test('every module has real lesson content, not a placeholder', () {
    for (final module in allModules) {
      expect(module.lesson.intro, isNotEmpty);
      expect(module.lesson.sections, isNotEmpty);
      expect(module.lesson.recap, isNotEmpty);
      for (final section in module.lesson.sections) {
        expect(section.heading, isNotEmpty);
        expect(section.body, isNotEmpty);
      }
    }
  });

  test('every module is tagged with at least one language (US24)', () {
    for (final module in allModules) {
      expect(module.languages, isNotEmpty, reason: '${module.id} has no language tag');
    }
  });

  test('every module has a well-formed quiz (US21/US22)', () {
    for (final module in allModules) {
      expect(module.quiz, isNotEmpty, reason: '${module.id} has no quiz questions');
      for (final question in module.quiz) {
        expect(question.prompt, isNotEmpty);
        expect(question.options.length, greaterThanOrEqualTo(2));
        expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        expect(question.explanation, isNotEmpty);
      }
    }
  });

  test('estimatedLessonMinutes gives a short, non-zero estimate for every module', () {
    for (final module in allModules) {
      final minutes = estimatedLessonMinutes(module);
      expect(minutes, greaterThanOrEqualTo(3));
      expect(minutes, lessThanOrEqualTo(10));
    }
  });

  test('only the Git-introducing collaboration modules offer the Git simulator (EP10/US53)', () {
    final withExercise = allModules.where((m) => m.practicalExercise != null).map((m) => m.id).toSet();
    expect(withExercise, {'collaboration-1', 'collaboration-2'});
  });
}
