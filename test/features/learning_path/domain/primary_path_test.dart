import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/learning_path/domain/primary_path.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';

void main() {
  test('discovery and front-end recommendations both map to the Front-End path', () {
    expect(primaryPathFor(RecommendedPath.discovery), LearningPath.frontEnd);
    expect(primaryPathFor(RecommendedPath.frontEnd), LearningPath.frontEnd);
  });

  test('python and full-stack recommendations map to their matching path', () {
    expect(primaryPathFor(RecommendedPath.python), LearningPath.python);
    expect(primaryPathFor(RecommendedPath.fullStack), LearningPath.fullStack);
  });
}
