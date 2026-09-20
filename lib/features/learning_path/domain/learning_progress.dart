import 'learning_path.dart';

/// One flat `completed_<path>` field per path (rather than a nested map) so
/// a single path's list can be updated with `arrayUnion` via
/// `set(..., merge: true)` without relying on Firestore's dotted-field
/// nested-update semantics. Shared with `LearningProgressRepository` so
/// both sides agree on the field name.
String completedModulesField(LearningPath path) => 'completed_${path.name}';

/// One flat `step_<moduleId>` field per module actually in progress — only
/// modules a learner has opened get a field, so this scales with usage
/// rather than with the size of the (open-ended, "enrichi facilement")
/// module catalogue.
const _stepFieldPrefix = 'step_';

/// Shared with `LearningProgressRepository` so both sides agree on the
/// field name for a given module's saved reading position.
String lessonStepField(String moduleId) => '$_stepFieldPrefix$moduleId';

/// One flat `quizScore_<moduleId>` field per completed module's quiz —
/// only the number of correct answers is stored; the question count comes
/// from the (static) curriculum itself, so it never needs persisting.
/// Used to spot "notions" the learner struggled with (EP09/US51).
const _scoreFieldPrefix = 'quizScore_';

String quizScoreField(String moduleId) => '$_scoreFieldPrefix$moduleId';

/// Which paths a learner has active (US18), which module ids are completed
/// within each — independently per path — and, for an in-progress module,
/// which reading step they last stopped at (US25).
class LearningProgress {
  const LearningProgress({
    this.activePaths = const {},
    this.completedModuleIds = const {},
    this.lessonSteps = const {},
    this.quizScores = const {},
  });

  final Set<LearningPath> activePaths;
  final Map<LearningPath, Set<String>> completedModuleIds;
  final Map<String, int> lessonSteps;
  final Map<String, int> quizScores;

  Set<String> completedIdsFor(LearningPath path) => completedModuleIds[path] ?? const {};

  bool isActive(LearningPath path) => activePaths.contains(path);

  int stepIndexFor(String moduleId) => lessonSteps[moduleId] ?? 0;

  /// The number of correct answers the learner got on this module's quiz
  /// the last time they completed it, or `null` if it was never completed
  /// with a recorded score.
  int? quizScoreFor(String moduleId) => quizScores[moduleId];

  Map<String, dynamic> toMap() => {
        'activePaths': activePaths.map((path) => path.name).toList(),
        for (final path in LearningPath.values)
          completedModulesField(path): completedIdsFor(path).toList(),
        for (final entry in lessonSteps.entries) lessonStepField(entry.key): entry.value,
        for (final entry in quizScores.entries) quizScoreField(entry.key): entry.value,
      };

  static LearningProgress fromMap(Map<String, dynamic>? map) {
    if (map == null) return const LearningProgress();
    final activePaths = ((map['activePaths'] as List<dynamic>?) ?? [])
        .map((id) => LearningPath.values.firstWhere((p) => p.name == id))
        .toSet();
    final completed = <LearningPath, Set<String>>{
      for (final path in LearningPath.values)
        path: ((map[completedModulesField(path)] as List<dynamic>?) ?? [])
            .cast<String>()
            .toSet(),
    };
    final lessonSteps = <String, int>{
      for (final entry in map.entries)
        if (entry.key.startsWith(_stepFieldPrefix))
          entry.key.substring(_stepFieldPrefix.length): entry.value as int,
    };
    final quizScores = <String, int>{
      for (final entry in map.entries)
        if (entry.key.startsWith(_scoreFieldPrefix))
          entry.key.substring(_scoreFieldPrefix.length): entry.value as int,
    };
    return LearningProgress(
      activePaths: activePaths,
      completedModuleIds: completed,
      lessonSteps: lessonSteps,
      quizScores: quizScores,
    );
  }
}
