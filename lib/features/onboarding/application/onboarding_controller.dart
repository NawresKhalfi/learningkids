import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../../auth/data/auth_repository.dart';
import '../../learning_path/data/learning_progress_repository.dart';
import '../../learning_path/domain/primary_path.dart';
import '../../profile/data/profile_repository.dart';
import '../../profile/domain/avatar.dart';
import '../../profile/domain/user_profile.dart';
import '../domain/age_range.dart';
import '../domain/coding_level.dart';
import '../domain/learning_goal.dart';
import '../domain/onboarding_answers.dart';
import '../domain/recommended_path.dart';

/// Holds the draft answers as the user steps through the onboarding chat
/// (US03/US04/US05), then persists the resulting profile once complete.
class OnboardingController extends Notifier<OnboardingAnswers> {
  @override
  OnboardingAnswers build() => const OnboardingAnswers();

  void acceptConsent() =>
      state = state.copyWith(consentGivenAt: DateTime.now());

  void setName(String name) => state = state.copyWith(name: name);

  void setAgeRange(AgeRange ageRange) =>
      state = state.copyWith(ageRange: ageRange);

  void setCodingLevel(CodingLevel level) =>
      state = state.copyWith(codingLevel: level);

  void toggleGoal(LearningGoal goal) {
    final goals = {...state.goals};
    if (!goals.remove(goal)) {
      goals.add(goal);
    }
    state = state.copyWith(goals: goals);
  }

  /// Builds the recommended path from the collected answers and saves the
  /// initial `users/{uid}` profile. Throws if called before [state] is
  /// complete or while signed out — screens gate the "submit" button on
  /// [OnboardingAnswers.isComplete] so this should not happen in practice.
  Future<void> submit() async {
    final answers = state;
    if (!answers.isComplete) {
      throw StateError('Cannot submit incomplete onboarding answers.');
    }
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) {
      throw StateError('Cannot submit onboarding answers while signed out.');
    }

    final recommendedPath = resolveRecommendedPath(
      answers.codingLevel!,
      answers.goals,
    );

    final profile = UserProfile(
      uid: uid,
      pseudo: answers.name!,
      avatar: Avatar.fox,
      ageRange: answers.ageRange!,
      codingLevel: answers.codingLevel!,
      goals: answers.goals,
      recommendedPath: recommendedPath,
      consentGivenAt: answers.consentGivenAt!,
    );

    await ref.read(localPreferencesProvider).setOnboardingCompleted(uid, true);
    await ref.read(profileRepositoryProvider).createInitialProfile(profile);
    await ref
        .read(learningProgressRepositoryProvider)
        .activatePath(uid, primaryPathFor(recommendedPath));
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingAnswers>(
      OnboardingController.new,
    );
