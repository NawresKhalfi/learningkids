/// One written explanation inside a [Lesson], optionally illustrated with a
/// short code sample.
class LessonSection {
  const LessonSection({required this.heading, required this.body, this.codeExample});

  final String heading;
  final String body;
  final String? codeExample;
}

/// The self-contained reading material for a [Module]. EP03's scope is the
/// path/module structure and real content; the interactive quiz/exercise
/// loop with graded feedback is EP04's job, so completion here is a
/// learner self-report ("j'ai terminé cette leçon"), not a graded pass.
class Lesson {
  const Lesson({required this.intro, required this.sections, required this.recap});

  final String intro;
  final List<LessonSection> sections;
  final String recap;
}
