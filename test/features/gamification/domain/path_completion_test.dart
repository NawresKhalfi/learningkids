import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/path_completion.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';

void main() {
  test('false when no module is completed', () {
    expect(isPathComplete(LearningPath.frontEnd, const {}), isFalse);
  });

  test('false when only some modules are completed', () {
    final firstId = curriculumFor(LearningPath.frontEnd).first.id;
    expect(isPathComplete(LearningPath.frontEnd, {firstId}), isFalse);
  });

  test('true once every module of the path is completed (US45)', () {
    final allIds = curriculumFor(LearningPath.frontEnd).map((m) => m.id).toSet();
    expect(isPathComplete(LearningPath.frontEnd, allIds), isTrue);
  });

  test('is independent per path', () {
    final frontEndIds = curriculumFor(LearningPath.frontEnd).map((m) => m.id).toSet();
    expect(isPathComplete(LearningPath.python, frontEndIds), isFalse);
  });
}
