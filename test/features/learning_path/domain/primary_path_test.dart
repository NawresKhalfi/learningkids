import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/primary_path.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';

void main() {
  test(
    'discovery and front-end recommendations both map to the Front-End path',
    () {
      expect(primaryPathFor(RecommendedPath.discovery), LearningPath.frontEnd);
      expect(primaryPathFor(RecommendedPath.frontEnd), LearningPath.frontEnd);
    },
  );

  test('python and full-stack recommendations map to their matching path', () {
    expect(primaryPathFor(RecommendedPath.python), LearningPath.python);
    expect(primaryPathFor(RecommendedPath.fullStack), LearningPath.fullStack);
  });

  test('mobile recommendation maps to the mobile path', () {
    expect(primaryPathFor(RecommendedPath.mobile), LearningPath.mobile);
  });

  test('game recommendation maps to the game path', () {
    expect(primaryPathFor(RecommendedPath.game), LearningPath.game);
  });

  test('AI recommendation maps to the backend and AI path', () {
    expect(primaryPathFor(RecommendedPath.ai), LearningPath.backend);
  });
}
