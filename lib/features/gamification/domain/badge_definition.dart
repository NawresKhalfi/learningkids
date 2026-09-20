import 'gamification_profile.dart';

/// A milestone badge (US44), unlocked automatically the first time
/// [isUnlocked] becomes true for the learner's profile — see
/// `GamificationRepository.recordActivity`, which evaluates every
/// not-yet-unlocked badge after each activity.
class BadgeDefinition {
  const BadgeDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.isUnlocked,
  });

  final String id;
  final String title;
  final String description;
  final String emoji;
  final bool Function(GamificationProfile profile) isUnlocked;
}
