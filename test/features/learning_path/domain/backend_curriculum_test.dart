import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  final modules = curriculumFor(LearningPath.backend);

  test('backend and AI path contains ten progressive modules', () {
    expect(modules, hasLength(10));
    expect(
      modules.map((module) => module.id),
      orderedEquals([
        'backend-1',
        'backend-2',
        'backend-3',
        'backend-4',
        'backend-5',
        'backend-6',
        'backend-7',
        'backend-8',
        'backend-9',
        'backend-10',
      ]),
    );
    expect(modules.last.title, 'Projet : assistant de défis');
  });

  test('AI extension teaches Python and follows the backend project', () {
    final aiModules = modules.where((module) => module.order >= 6).toList();

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
