import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  final modules = curriculumFor(LearningPath.backend);

  test(
    'backend and AI path contains 28 progressive modules, including advanced content',
    () {
      expect(modules, hasLength(28));
      expect(
        modules.map((module) => module.id),
        orderedEquals(List.generate(28, (index) => 'backend-${index + 1}')),
      );
      expect(modules[9].title, 'Projet : assistant de défis');
    },
  );

  test('base AI extension teaches Python and follows the backend project', () {
    final aiModules = modules
        .where((module) => module.order >= 6 && module.order <= 10)
        .toList();

    expect(
      aiModules.every(
        (module) => module.languages.contains(LessonLanguage.python),
      ),
      isTrue,
    );
    expect(aiModules.first.prerequisiteIds, ['backend-5']);
    expect(aiModules.last.prerequisiteIds, ['backend-9']);
  });
}
