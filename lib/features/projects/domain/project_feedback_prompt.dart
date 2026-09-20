import '../../code_playground/domain/programming_language.dart';

/// Builds the prompt for the pre-publish AI review (US42). Reuses the same
/// `CodeAssistantClient` plumbing as EP06's assistant, just with a
/// dedicated prompt: concrete, encouraging feedback — never a full
/// rewrite, since the point is for the learner to act on it themselves.
String buildProjectFeedbackPrompt({required ProgrammingLanguage language, required String code}) {
  final lang = programmingLanguageTitle(language);
  return 'Analyse ce projet $lang réalisé par un enfant qui apprend à coder, '
      "avant qu'il ne le publie dans son portfolio. Donne un retour "
      'bienveillant et concret en 3 points maximum : ce qui est réussi, '
      "puis une ou deux pistes d'amélioration simples et réalisables par "
      "l'apprenant lui-même. Ne fournis pas de code corrigé complet, "
      'seulement des conseils :\n\n'
      '```\n$code\n```';
}
