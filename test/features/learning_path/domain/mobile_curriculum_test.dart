import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  final modules = curriculumFor(LearningPath.mobile);

  test('mobile path contains the complete 28-module Flutter journey', () {
    expect(modules, hasLength(28));
    expect(
      modules.map((module) => module.id),
      orderedEquals(List.generate(28, (index) => 'mobile-${index + 1}')),
    );
    expect(modules.first.title, 'Découvrir Dart');
    expect(modules[9].title, 'Projet : ma liste de défis');
  });

  test('mobile modules unlock one after another', () {
    expect(modules.first.prerequisiteIds, isEmpty);

    for (var index = 1; index < modules.length; index++) {
      expect(
        modules[index].prerequisiteIds,
        ['mobile-$index'],
        reason: '${modules[index].id} must follow mobile-$index',
      );
    }
  });

  test('every mobile module teaches Dart and has two quiz questions', () {
    for (final module in modules) {
      expect(module.languages, contains(LessonLanguage.dart));
      expect(module.quiz, hasLength(2));
    }
  });

  test('mobile modules can be found from the global curriculum catalogue', () {
    for (final module in modules) {
      expect(moduleById(module.id), same(module));
    }
  });
}
