import 'age_range.dart';
import 'coding_level.dart';
import 'learning_goal.dart';

/// The draft answers collected across the onboarding chat screens, held by
/// `OnboardingController` while the user steps through the flow.
class OnboardingAnswers {
  const OnboardingAnswers({
    this.consentGivenAt,
    this.name,
    this.ageRange = AgeRange.unspecified,
    this.codingLevel,
    this.goals = const {},
  });

  /// Set once the parental data-collection notice (US12) is accepted; the
  /// consent screen is the first onboarding step, so every later step can
  /// assume it is non-null.
  final DateTime? consentGivenAt;
  final String? name;
  final AgeRange ageRange;
  final CodingLevel? codingLevel;
  final Set<LearningGoal> goals;

  bool get isComplete =>
      consentGivenAt != null &&
      name != null &&
      name!.isNotEmpty &&
      codingLevel != null &&
      goals.isNotEmpty;

  OnboardingAnswers copyWith({
    DateTime? consentGivenAt,
    String? name,
    AgeRange? ageRange,
    CodingLevel? codingLevel,
    Set<LearningGoal>? goals,
  }) {
    return OnboardingAnswers(
      consentGivenAt: consentGivenAt ?? this.consentGivenAt,
      name: name ?? this.name,
      ageRange: ageRange ?? this.ageRange,
      codingLevel: codingLevel ?? this.codingLevel,
      goals: goals ?? this.goals,
    );
  }
}
