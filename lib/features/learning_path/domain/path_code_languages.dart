import '../../code_playground/domain/programming_language.dart';
import 'learning_path.dart';

/// Langages exécutables dans l'espace de code pour chaque parcours.
/// L'application ne possède pour l'instant un runtime que pour HTML,
/// JavaScript et Python ; les parcours sont donc limités à ces choix réels.
List<ProgrammingLanguage> programmingLanguagesForPath(LearningPath path) =>
    switch (path) {
      LearningPath.frontEnd => const [
        ProgrammingLanguage.html,
        ProgrammingLanguage.javascript,
      ],
      LearningPath.game => const [ProgrammingLanguage.javascript],
      LearningPath.python => const [ProgrammingLanguage.python],
      LearningPath.mobile => const [ProgrammingLanguage.dart],
      LearningPath.fullStack => const [
        ProgrammingLanguage.html,
        ProgrammingLanguage.javascript,
        ProgrammingLanguage.python,
      ],
      LearningPath.backend => const [
        ProgrammingLanguage.python,
        ProgrammingLanguage.javascript,
      ],
      LearningPath.collaboration => const [ProgrammingLanguage.javascript],
    };
