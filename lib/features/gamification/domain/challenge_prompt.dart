import '../../code_playground/domain/programming_language.dart';

/// One weekly challenge prompt (EP10/US56): a single fixed brief shown to
/// every learner for the whole week, marked done by self-report — there is
/// no automatic judging of the submitted code.
class ChallengePrompt {
  const ChallengePrompt({required this.title, required this.description, required this.language});

  final String title;
  final String description;
  final ProgrammingLanguage language;
}

const challengeCatalog = <ChallengePrompt>[
  ChallengePrompt(
    title: 'Le générateur de blagues',
    description:
        "Écris un programme Python qui choisit une blague au hasard dans une liste et l'affiche à l'écran.",
    language: ProgrammingLanguage.python,
  ),
  ChallengePrompt(
    title: 'Le compte à rebours',
    description:
        "Écris un programme JavaScript qui affiche les nombres de 10 à 0, puis un message final quand il arrive à 0.",
    language: ProgrammingLanguage.javascript,
  ),
  ChallengePrompt(
    title: 'Ma carte de visite',
    description: 'Crée une page HTML qui présente ton prénom, ta couleur préférée et un projet dont tu es fier·ère.',
    language: ProgrammingLanguage.html,
  ),
  ChallengePrompt(
    title: 'Le jeu du nombre mystère',
    description:
        "Écris un programme Python qui choisit un nombre entre 1 et 20 et donne des indices (plus grand/plus petit) "
        'jusqu\'à ce que tu le devines.',
    language: ProgrammingLanguage.python,
  ),
];

/// The Thursday of the same ISO-8601 week as [date] (weeks start on
/// Monday) — the ISO week's year and number are both defined in terms of
/// that Thursday, so every calculation below starts from it.
DateTime _isoThursday(DateTime date) => date.add(Duration(days: 3 - ((date.weekday + 6) % 7)));

/// The ISO-8601 week number of [date]'s week (week 1 is the week
/// containing the year's first Thursday).
int isoWeekNumber(DateTime date) {
  final thursday = _isoThursday(date);
  final firstDayOfYear = DateTime(thursday.year, 1, 1);
  return 1 + (thursday.difference(firstDayOfYear).inDays / 7).floor();
}

/// A stable key identifying one calendar week, e.g. `2026-W38`.
String weekKeyFor(DateTime date) {
  final thursday = _isoThursday(date);
  return '${thursday.year}-W${isoWeekNumber(date).toString().padLeft(2, '0')}';
}

ChallengePrompt challengeForWeek(DateTime date) => challengeCatalog[isoWeekNumber(date) % challengeCatalog.length];
