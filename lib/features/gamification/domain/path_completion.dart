import '../../learning_path/domain/curriculum.dart';
import '../../learning_path/domain/learning_path.dart';

/// Whether every module of [path] is in [completedModuleIds] — the
/// certificate (US45) is offered once this is true.
bool isPathComplete(LearningPath path, Set<String> completedModuleIds) {
  final allIds = curriculumFor(path).map((module) => module.id);
  return allIds.every(completedModuleIds.contains);
}
