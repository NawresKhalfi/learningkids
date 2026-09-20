import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../profile/application/profile_controller.dart';
import '../data/challenge_repository.dart';
import '../domain/challenge_participant.dart';
import '../domain/challenge_prompt.dart';

/// This week's fixed challenge prompt (EP10/US56) — the same brief for
/// every learner, changing only once a week.
final currentChallengeProvider = Provider<ChallengePrompt>((ref) => challengeForWeek(DateTime.now()));

final currentWeekKeyProvider = Provider<String>((ref) => weekKeyFor(DateTime.now()));

final challengeParticipantsProvider = StreamProvider<List<ChallengeParticipant>>((ref) {
  final weekKey = ref.watch(currentWeekKeyProvider);
  return ref.watch(challengeRepositoryProvider).watchParticipants(weekKey);
});

final hasCompletedChallengeProvider = FutureProvider<bool>((ref) async {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return false;
  final weekKey = ref.watch(currentWeekKeyProvider);
  return ref.watch(challengeRepositoryProvider).hasCompleted(weekKey, uid);
});

class ChallengeController extends Notifier<void> {
  @override
  void build() {}

  Future<void> markCompleted() async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) return;
    final profile = await ref.read(currentProfileProvider.future);
    final weekKey = ref.read(currentWeekKeyProvider);
    await ref
        .read(challengeRepositoryProvider)
        .markCompleted(weekKey, uid: uid, pseudo: profile?.pseudo ?? '', avatarId: profile?.avatar.name ?? '');
    ref.invalidate(hasCompletedChallengeProvider);
  }
}

final challengeControllerProvider = NotifierProvider<ChallengeController, void>(ChallengeController.new);
