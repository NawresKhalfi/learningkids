import '../../learning_path/domain/curriculum.dart';
import '../../learning_path/domain/learning_path.dart';
import '../../learning_path/domain/learning_progress.dart';

/// How far a learner has gotten through one path's curriculum (US49/US52).
class PathProgress {
  const PathProgress({required this.path, required this.completedCount, required this.totalCount});

  final LearningPath path;
  final int completedCount;
  final int totalCount;

  double get ratio => totalCount == 0 ? 0 : completedCount / totalCount;
}

PathProgress pathProgressFor(LearningPath path, LearningProgress progress) => PathProgress(
  path: path,
  completedCount: progress.completedIdsFor(path).length,
  totalCount: curriculumFor(path).length,
);

List<PathProgress> computePathProgress(LearningProgress progress) => [
  for (final path in LearningPath.values) pathProgressFor(path, progress),
];
