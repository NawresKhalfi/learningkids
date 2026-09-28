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

    test('website goal recommends the front-end path at every level', () {
      for (final level in CodingLevel.values) {
        expect(
          resolveRecommendedPath(level, {LearningGoal.website}),
          RecommendedPath.frontEnd,
        );
      }
    });

    test('game goal recommends the game development path at every level', () {
      for (final level in CodingLevel.values) {
        expect(
          resolveRecommendedPath(level, {LearningGoal.game}),
          RecommendedPath.game,
        );
      }
    });

    test('AI goal recommends the backend and AI path at every level', () {
      for (final level in CodingLevel.values) {
        expect(
          resolveRecommendedPath(level, {LearningGoal.artificialIntelligence}),
          RecommendedPath.ai,
        );
      }
    });

    test('comfortable level without a specific goal recommends full-stack', () {
      expect(
        resolveRecommendedPath(CodingLevel.comfortable, {}),
        RecommendedPath.fullStack,
      );
    });

    test('beginner level without a specific goal recommends discovery', () {
      expect(
        resolveRecommendedPath(CodingLevel.beginner, {}),
        RecommendedPath.discovery,
      );
    });

    test('some-basics level without a specific goal recommends front-end', () {
      expect(
        resolveRecommendedPath(CodingLevel.someBasics, {}),
        RecommendedPath.frontEnd,
      );
    });
  });
}
