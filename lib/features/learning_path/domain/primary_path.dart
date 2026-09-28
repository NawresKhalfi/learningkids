import '../../onboarding/domain/recommended_path.dart';
import 'learning_path.dart';

/// Translates onboarding's US03 recommendation into one of EP03's four real
/// tracks, so the path it points to always exists in the roadmap.
/// "Discovery" (the beginner catch-all from onboarding) starts learners on
/// Front-End, the most approachable of the four.
LearningPath primaryPathFor(RecommendedPath recommended) {
  switch (recommended) {
    case RecommendedPath.discovery:
    case RecommendedPath.frontEnd:
      return LearningPath.frontEnd;
    case RecommendedPath.python:
      return LearningPath.python;
    case RecommendedPath.mobile:
      return LearningPath.mobile;
    case RecommendedPath.fullStack:
      return LearningPath.fullStack;
  }
}
