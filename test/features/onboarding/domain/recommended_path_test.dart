import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/learning_goal.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';

void main() {
  group('resolveRecommendedPath', () {
    test(
      'mobile-app goal recommends the mobile development path at every level',
      () {
        for (final level in CodingLevel.values) {
          expect(
            resolveRecommendedPath(level, {LearningGoal.mobileApp}),
            RecommendedPath.mobile,
          );
        }
      },
    );

    test('comfortable level always recommends full-stack', () {
      expect(
        resolveRecommendedPath(CodingLevel.comfortable, {}),
        RecommendedPath.fullStack,
      );
      expect(
        resolveRecommendedPath(CodingLevel.comfortable, {LearningGoal.game}),
        RecommendedPath.fullStack,
      );
    });

    test('beginner level always recommends discovery', () {
      expect(
        resolveRecommendedPath(CodingLevel.beginner, {
          LearningGoal.artificialIntelligence,
        }),
        RecommendedPath.discovery,
      );
    });

    test('some-basics level with AI goal recommends python', () {
      expect(
        resolveRecommendedPath(CodingLevel.someBasics, {
          LearningGoal.artificialIntelligence,
        }),
        RecommendedPath.python,
      );
    });

    test('some-basics level without AI goal recommends front-end', () {
      expect(
        resolveRecommendedPath(CodingLevel.someBasics, {LearningGoal.website}),
        RecommendedPath.frontEnd,
      );
      expect(
        resolveRecommendedPath(CodingLevel.someBasics, {}),
        RecommendedPath.frontEnd,
      );
    });
  });
}
