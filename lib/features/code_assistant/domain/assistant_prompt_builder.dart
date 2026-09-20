import '../../code_playground/domain/programming_language.dart';
import '../../onboarding/domain/coding_level.dart';
import 'assistant_action.dart';

/// Builds the system instruction and per-action prompts sent to the AI
/// (EP06). Kept as pure string-building functions, independent of the
/// Firebase AI client, so the prompt content itself is unit-testable.
///
/// The system instruction is where US37 (child-safe, on-topic, encouraging
/// tone) is enforced — combined with the model's own safety settings, it's
/// the main defense against inappropriate or off-topic replies.
const _safetyAndTonePreamble =
    "Tu es un assistant pédagogique intégré à une application pour enfants "
    "qui apprennent à coder. Règles strictes : ne parle que de programmation "
    "et d'apprentissage du code ; si on te pose une question hors de ce "
    "cadre, réponds gentiment que tu ne peux aider que sur le code, sans "
    "développer le sujet demandé ; garde toujours un ton bienveillant, "
    "encourageant, jamais grossier, violent ou déplacé.";

String buildSystemInstruction({CodingLevel? codingLevel}) {
  final levelHint = switch (codingLevel) {
    CodingLevel.beginner =>
      "L'apprenant débute tout juste : utilise des mots simples, évite le "
          'jargon technique, illustre avec des analogies concrètes.',
    CodingLevel.someBasics =>
      "L'apprenant connaît déjà quelques bases : tu peux utiliser le "
          'vocabulaire technique courant en l\'expliquant brièvement.',
    CodingLevel.comfortable =>
      "L'apprenant est à l'aise avec le code : tu peux être plus direct et "
          'technique.',
    null => 'Adapte ton langage à un débutant par défaut.',
  };
  return '$_safetyAndTonePreamble\n$levelHint';
}

String buildActionPrompt({
  required AssistantAction action,
  required ProgrammingLanguage language,
  required String code,
}) {
  final lang = programmingLanguageTitle(language);
  return switch (action) {
    AssistantAction.explainCode =>
      'Explique ce code $lang étape par étape, sans donner plus '
          "d'informations que ce que fait réellement le code :\n\n"
          '```\n$code\n```',
    AssistantAction.findBug =>
      'Ce code $lang ne fonctionne pas comme prévu. Aide à trouver où se '
          "situe le problème : indique la zone concernée et explique la "
          "nature de l'erreur, mais ne donne surtout pas le code corrigé "
          "complet — laisse l'apprenant le corriger lui-même :\n\n"
          '```\n$code\n```',
    AssistantAction.suggestImprovement =>
      'Propose une amélioration de ce code $lang (lisibilité, bonnes '
          'pratiques, simplicité) avec une justification pédagogique '
          "claire. Termine ta réponse par le code amélioré complet dans "
          "un unique bloc de code :\n\n"
          '```\n$code\n```',
  };
}
