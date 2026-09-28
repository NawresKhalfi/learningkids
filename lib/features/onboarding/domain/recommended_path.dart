import 'coding_level.dart';
import 'learning_goal.dart';

enum RecommendedPath {
  discovery,
  frontEnd,
  game,
  ai,
  python,
  mobile,
  fullStack,
}

/// Turns the level test (US03) and chosen goals (US05) into the learning
/// path recommended on the home screen. Pure so it is unit-testable without
/// Firebase or a widget tree; the actual curriculum for each path is EP03's
/// job, not this feature's.
RecommendedPath resolveRecommendedPath(
  CodingLevel level,
  Set<LearningGoal> goals,
) {
  // A chosen project goal is more specific than the general level. Learners
  // asking for mobile or web development should not be sent to the unrelated
  // full-stack roadmap just because they already know basics.
  if (goals.contains(LearningGoal.mobileApp)) {
    return RecommendedPath.mobile;
  }
  if (goals.contains(LearningGoal.website)) {
    return RecommendedPath.frontEnd;
  }
  if (goals.contains(LearningGoal.game)) {
    return RecommendedPath.game;
  }
  if (goals.contains(LearningGoal.artificialIntelligence)) {
    return RecommendedPath.ai;
  }
  switch (level) {
    case CodingLevel.comfortable:
      return RecommendedPath.fullStack;
    case CodingLevel.someBasics:
      return RecommendedPath.frontEnd;
    case CodingLevel.beginner:
      return RecommendedPath.discovery;
  }
}
