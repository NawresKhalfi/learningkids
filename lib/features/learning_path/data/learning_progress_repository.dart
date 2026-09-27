import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/learning_path.dart';
import '../domain/learning_progress.dart';

/// Stores which paths are active and which modules are completed at
/// `users/{uid}/learning/progress` — one document, like
/// `ParentalControlRepository`'s settings/usage docs, since the whole
/// history easily fits a single read/write and needs no querying.
class LearningProgressRepository {
  LearningProgressRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid).collection('learning').doc('progress');

  Future<LearningProgress> fetchProgress(String uid) async {
    final snapshot = await _doc(uid).get();
    return LearningProgress.fromMap(snapshot.data());
  }

  Stream<LearningProgress> watchProgress(String uid) {
    return _doc(uid).snapshots().map((snapshot) => LearningProgress.fromMap(snapshot.data()));
  }

  Future<void> activatePath(String uid, LearningPath path) =>
      _doc(uid).set({
        'activePaths': FieldValue.arrayUnion([path.name]),
      }, SetOptions(merge: true));

  Future<void> deactivatePath(String uid, LearningPath path) =>
      _doc(uid).set({
        'activePaths': FieldValue.arrayRemove([path.name]),
      }, SetOptions(merge: true));

  /// Called once the learner finishes the module's quiz (US21/US22).
  /// [correctAnswers], when given, records that attempt's score for the
  /// weak-point detection in EP09/US51 — a later, better attempt simply
  /// overwrites the previous score.
  Future<void> markModuleCompleted(
    String uid,
    LearningPath path,
    String moduleId, {
    int? correctAnswers,
  }) =>
      _doc(uid).set({
        completedModulesField(path): FieldValue.arrayUnion([moduleId]),
        quizScoreField(moduleId): ?correctAnswers,
      }, SetOptions(merge: true));

  /// Saves where in the lesson the learner last stopped, so reopening it
  /// resumes at the same step (US25) instead of restarting from the top.
  Future<void> saveLessonStep(String uid, String moduleId, int stepIndex) =>
      _doc(uid).set({
        lessonStepField(moduleId): stepIndex,
      }, SetOptions(merge: true));
}

final learningProgressRepositoryProvider =
    Provider<LearningProgressRepository>((ref) => LearningProgressRepository());
