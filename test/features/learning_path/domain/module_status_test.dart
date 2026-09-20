import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/lesson.dart';
import 'package:learningkids/features/learning_path/domain/module.dart';
import 'package:learningkids/features/learning_path/domain/module_status.dart';

void main() {
  const lesson = Lesson(intro: 'intro', sections: [], recap: 'recap');
  const firstModule = Module(
    id: 'path-1',
    path: LearningPath.frontEnd,
    order: 1,
    title: 'First',
    description: 'd',
    prerequisiteIds: [],
    lesson: lesson,
    languages: [],
    quiz: [],
  );
  const secondModule = Module(
    id: 'path-2',
    path: LearningPath.frontEnd,
    order: 2,
    title: 'Second',
    description: 'd',
    prerequisiteIds: ['path-1'],
    lesson: lesson,
    languages: [],
    quiz: [],
  );

  test('a module with no prerequisites is unlocked from the start', () {
    expect(resolveModuleStatus(firstModule, {}), ModuleStatus.unlocked);
  });

  test('a module is locked until its prerequisites are completed', () {
    expect(resolveModuleStatus(secondModule, {}), ModuleStatus.locked);
    expect(resolveModuleStatus(secondModule, {'path-1'}), ModuleStatus.unlocked);
  });

  test('a completed module is reported as completed regardless of prerequisites', () {
    expect(resolveModuleStatus(firstModule, {'path-1'}), ModuleStatus.completed);
    expect(resolveModuleStatus(secondModule, {'path-1', 'path-2'}), ModuleStatus.completed);
  });
}
