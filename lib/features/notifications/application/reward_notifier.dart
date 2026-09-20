import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../../gamification/domain/badge_definition.dart';
import '../data/notification_service.dart';

/// Fires a local celebration notification for a newly-earned reward
/// (US58) — gated by the learner's own preference (US59). Called from
/// `GamificationController` (badges/level-ups) and
/// `LearningProgressController` (certificates), which already know the
/// moment a reward is earned, so nothing needs scheduling here.
class RewardNotifier {
  RewardNotifier(this._ref);

  final Ref _ref;

  Future<void> notifyBadgeUnlocked(BadgeDefinition badge) => _notify(
    id: 100 + badge.id.hashCode.remainder(10000),
    title: 'Nouveau badge débloqué ! ${badge.emoji}',
    body: badge.title,
  );

  Future<void> notifyLevelUp(int newLevel) =>
      _notify(id: 200 + newLevel, title: 'Niveau supérieur ! ⭐', body: 'Tu as atteint le niveau $newLevel !');

  Future<void> notifyCertificateUnlocked(String pathTitle) => _notify(
    id: 300 + pathTitle.hashCode.remainder(10000),
    title: 'Certificat obtenu ! 🎓',
    body: 'Tu as terminé le parcours « $pathTitle » !',
  );

  Future<void> _notify({required int id, required String title, required String body}) async {
    if (!_ref.read(localPreferencesProvider).rewardNotificationsEnabled) return;
    await _ref.read(notificationServiceProvider).showRewardNotification(id: id, title: title, body: body);
  }
}

final rewardNotifierProvider = Provider<RewardNotifier>((ref) => RewardNotifier(ref));
