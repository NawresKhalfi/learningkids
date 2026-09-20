/// A language/technology tag on a [Module], used by the lesson catalogue
/// (US24) to let a learner browse by language across every path instead of
/// only through a path's own roadmap.
enum LessonLanguage { html, css, javascript, python, sql, typescript, git }

String lessonLanguageLabel(LessonLanguage language) {
  switch (language) {
    case LessonLanguage.html:
      return 'HTML';
    case LessonLanguage.css:
      return 'CSS';
    case LessonLanguage.javascript:
      return 'JavaScript';
    case LessonLanguage.python:
      return 'Python';
    case LessonLanguage.sql:
      return 'SQL';
    case LessonLanguage.typescript:
      return 'TypeScript';
    case LessonLanguage.git:
      return 'Git';
  }
}
