import 'learning_path.dart';
import 'lesson.dart';
import 'lesson_language.dart';
import 'practical_exercise_kind.dart';
import 'quiz_question.dart';

/// One step of a [LearningPath]'s roadmap (US13-US17): its position, the
/// modules it depends on, and its reading + quiz content.
class Module {
  const Module({
    required this.id,
    required this.path,
    required this.order,
    required this.title,
    required this.description,
    required this.prerequisiteIds,
    required this.lesson,
    required this.languages,
    required this.quiz,
    this.practicalExercise,
  });

  /// Stable, globally unique id (e.g. `frontend-1`) used as the Firestore
  /// key for completion tracking — never reused across paths.
  final String id;
  final LearningPath path;
  final int order;
  final String title;
  final String description;
  final List<String> prerequisiteIds;
  final Lesson lesson;

  /// Language/technology tags for the lesson catalogue filter (US24).
  final List<LessonLanguage> languages;

  /// The multiple-choice check shown after the reading content (US21/US22).
  final List<QuizQuestion> quiz;

  /// A simulated hands-on exercise offered alongside the quiz (EP10/US53),
  /// or `null` for modules that only have reading + quiz.
  final PracticalExerciseKind? practicalExercise;
}

/// US20: a rough "how long will this take" estimate shown before starting,
/// based on the number of reading sections — real content, not a made-up
/// number, but not meant to be precise to the second either.
int estimatedLessonMinutes(Module module) =>
    (module.lesson.sections.length * 2 + 1).clamp(3, 10);
