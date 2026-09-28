import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  final modules = curriculumFor(LearningPath.game);

  test('game path contains ten progressive game-development modules', () {
    expect(modules, hasLength(10));
    expect(
      modules.map((module) => module.id),
      orderedEquals([
        'game-1',
        'game-2',
        'game-3',
        'game-4',
        'game-5',
        'game-6',
        'game-7',
        'game-8',
        'game-9',
        'game-10',
      ]),
    );
    expect(modules.first.title, 'Imaginer un jeu');
    expect(modules.last.title, 'Projet : aventure à niveaux');
  });

  test('game modules unlock one after another', () {
    expect(modules.first.prerequisiteIds, isEmpty);
    for (var index = 1; index < modules.length; index++) {
      expect(modules[index].prerequisiteIds, ['game-$index']);
    }
  });

  test(
    'game curriculum teaches JavaScript and ends with a web-game project',
    () {
      expect(
        modules.where(
          (module) => module.languages.contains(LessonLanguage.javascript),
        ),
        hasLength(9),
      );
      expect(
        modules.last.languages,
        containsAll([LessonLanguage.html, LessonLanguage.css]),
      );
    },
  );
}
