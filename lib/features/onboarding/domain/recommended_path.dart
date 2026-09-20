import 'coding_level.dart';
import 'learning_goal.dart';

enum RecommendedPath { discovery, frontEnd, python, fullStack }

/// Turns the level test (US03) and chosen goals (US05) into the learning
/// path recommended on the home screen. Pure so it is unit-testable without
/// Firebase or a widget tree; the actual curriculum for each path is EP03's
/// job, not this feature's.
RecommendedPath resolveRecommendedPath(
  CodingLevel level,
  Set<LearningGoal> goals,
) {
  switch (level) {
    case CodingLevel.comfortable:
      return RecommendedPath.fullStack;
    case CodingLevel.someBasics:
      if (goals.contains(LearningGoal.artificialIntelligence)) {
        return RecommendedPath.python;
      }
      return RecommendedPath.frontEnd;
    case CodingLevel.beginner:
      return RecommendedPath.discovery;
  }
}
