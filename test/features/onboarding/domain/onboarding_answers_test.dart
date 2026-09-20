import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/learning_goal.dart';
import 'package:learningkids/features/onboarding/domain/onboarding_answers.dart';

void main() {
  group('OnboardingAnswers.isComplete', () {
    test('is false for the initial empty draft', () {
      expect(const OnboardingAnswers().isComplete, isFalse);
    });

    test('is false when any field is still missing', () {
      final partial = OnboardingAnswers(
        consentGivenAt: DateTime.utc(2026, 1, 1),
        name: 'Léo',
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.beginner,
      );
      expect(partial.isComplete, isFalse);
    });

    test('is false when the parental consent has not been given', () {
      const answers = OnboardingAnswers(
        name: 'Léo',
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.beginner,
        goals: {LearningGoal.game},
      );
      expect(answers.isComplete, isFalse);
    });

    test('is false when the name is empty', () {
      final answers = OnboardingAnswers(
        consentGivenAt: DateTime.utc(2026, 1, 1),
        name: '',
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.beginner,
        goals: {LearningGoal.game},
      );
      expect(answers.isComplete, isFalse);
    });

    test('is true once every field is set and goals is non-empty', () {
      final answers = OnboardingAnswers(
        consentGivenAt: DateTime.utc(2026, 1, 1),
        name: 'Léo',
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.beginner,
        goals: {LearningGoal.game},
      );
      expect(answers.isComplete, isTrue);
    });
  });

  group('OnboardingAnswers.copyWith', () {
    test('keeps existing fields untouched when not overridden', () {
      const answers = OnboardingAnswers(name: 'Léo', goals: {LearningGoal.website});
      final updated = answers.copyWith(ageRange: AgeRange.tenToTwelve);

      expect(updated.name, 'Léo');
      expect(updated.goals, {LearningGoal.website});
      expect(updated.ageRange, AgeRange.tenToTwelve);
    });
  });
}
