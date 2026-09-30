import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  final modules = curriculumFor(LearningPath.game);

  test('game path contains 28 progressive game-development modules', () {
    expect(modules, hasLength(28));
    expect(
      modules.map((module) => module.id),
      orderedEquals(List.generate(28, (index) => 'game-${index + 1}')),
    );
    expect(modules.first.title, 'Imaginer un jeu');
    expect(modules[9].title, 'Projet : aventure à niveaux');
  });

  test('game modules unlock one after another', () {
    expect(modules.first.prerequisiteIds, isEmpty);
    for (var index = 1; index < modules.length; index++) {
      expect(modules[index].prerequisiteIds, ['game-$index']);
    }
  });

  test(
    'game curriculum teaches JavaScript and includes a web-game project',
    () {
      expect(
        modules
            .where(
              (module) => module.languages.contains(LessonLanguage.javascript),
            )
            .length,
        greaterThanOrEqualTo(9),
      );
      expect(
        modules[9].languages,
        containsAll([LessonLanguage.html, LessonLanguage.css]),
      );
    },
  );
}
