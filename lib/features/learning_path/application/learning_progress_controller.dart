import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../gamification/application/gamification_providers.dart';
import '../../gamification/domain/path_completion.dart';
import '../../notifications/application/reward_notifier.dart';
import '../data/learning_progress_repository.dart';
import '../domain/learning_path.dart';
import '../domain/learning_path_info.dart';
import '../domain/learning_progress.dart';

/// The signed-in learner's active paths and per-path completion, kept in
/// sync with Firestore (same re-subscribe-on-uid-change pattern as
/// `currentProfileProvider`/`parentalSettingsProvider`).
final learningProgressProvider = StreamProvider<LearningProgress>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const LearningProgress());
  return ref.watch(learningProgressRepositoryProvider).watchProgress(uid);
});

/// Drives path activation (US18) and module completion (US13-US17).
class LearningProgressController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  String? get _uid => ref.read(authRepositoryProvider).currentUser?.uid;

  Future<void> activatePath(LearningPath path) async {
    final uid = _uid;
    if (uid == null) return;
    await ref.read(learningProgressRepositoryProvider).activatePath(uid, path);
  }

  Future<void> deactivatePath(LearningPath path) async {
    final uid = _uid;
    if (uid == null) return;
    await ref.read(learningProgressRepositoryProvider).deactivatePath(uid, path);
  }

  /// Awards XP/streak/badge progress (EP08) only the first time a module
  /// is completed — checked against the current progress before writing,
  /// since the repository's `arrayUnion` write is otherwise idempotent
  /// and gives no signal either way.
  Future<void> markModuleCompleted(LearningPath path, String moduleId, {int? correctAnswers}) async {
    final uid = _uid;
    if (uid == null) return;
    final progress = await ref.read(learningProgressProvider.future);
    final completedBefore = progress.completedIdsFor(path);
    final alreadyCompleted = completedBefore.contains(moduleId);
    await ref
        .read(learningProgressRepositoryProvider)
        .markModuleCompleted(uid, path, moduleId, correctAnswers: correctAnswers);
    if (!alreadyCompleted) {
      await ref.read(gamificationControllerProvider.notifier).recordLessonCompleted();
      // EP11/US58: a certificate is "earned" the moment the last module of
      // a path is completed — celebrate it right here, since this is the
      // only place that knows a path just went from incomplete to complete.
      final wasComplete = isPathComplete(path, completedBefore);
      final isComplete = isPathComplete(path, {...completedBefore, moduleId});
      if (!wasComplete && isComplete) {
        await ref.read(rewardNotifierProvider).notifyCertificateUnlocked(learningPathInfo(path).title);
      }
    }
  }

  Future<void> saveLessonStep(String moduleId, int stepIndex) async {
    final uid = _uid;
    if (uid == null) return;
    await ref.read(learningProgressRepositoryProvider).saveLessonStep(uid, moduleId, stepIndex);
  }
}

final learningProgressControllerProvider =
    NotifierProvider<LearningProgressController, AsyncValue<void>>(
  LearningProgressController.new,
);
