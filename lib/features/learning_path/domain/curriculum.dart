import 'curriculum/backend_curriculum.dart';
import 'curriculum/collaboration_curriculum.dart';
import 'curriculum/front_end_curriculum.dart';
import 'curriculum/full_stack_curriculum.dart';
import 'curriculum/game_curriculum.dart';
import 'curriculum/mobile_curriculum.dart';
import 'curriculum/python_curriculum.dart';
import 'learning_path.dart';
import 'module.dart';

/// The ordered module list for a path (US13-US16), sorted by [Module.order].
List<Module> curriculumFor(LearningPath path) {
  switch (path) {
    case LearningPath.frontEnd:
      return frontEndCurriculum;
    case LearningPath.game:
      return gameCurriculum;
    case LearningPath.python:
      return pythonCurriculum;
    case LearningPath.mobile:
      return mobileCurriculum;
    case LearningPath.fullStack:
      return fullStackCurriculum;
    case LearningPath.backend:
      return backendCurriculum;
    case LearningPath.collaboration:
      return collaborationCurriculum;
  }
}

/// Every module across every path, for lookups that don't already know
/// which path a module id belongs to.
final List<Module> allModules = [
  ...frontEndCurriculum,
  ...gameCurriculum,
  ...pythonCurriculum,
  ...mobileCurriculum,
  ...fullStackCurriculum,
  ...backendCurriculum,
  ...collaborationCurriculum,
];

Module moduleById(String id) =>
    allModules.firstWhere((module) => module.id == id);
