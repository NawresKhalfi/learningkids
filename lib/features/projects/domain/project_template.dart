import '../../code_playground/domain/programming_language.dart';
import '../../onboarding/domain/coding_level.dart';
import '../../learning_path/domain/learning_path.dart';
import 'project_category.dart';

/// A guided starting point for a new project (US38): a language, a level,
/// a category and working starter code the learner can run immediately
/// and then make their own.
class ProjectTemplate {
  const ProjectTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.level,
    required this.category,
    required this.starterCode,
    this.path,
  });

  final String id;
  final String title;
  final String description;
  final ProgrammingLanguage language;
  final CodingLevel level;
  final ProjectCategory category;
  final String starterCode;

  /// The course this template belongs to. Generic legacy templates have no
  /// path and remain visible only from the unfiltered project catalogue.
  final LearningPath? path;
}
