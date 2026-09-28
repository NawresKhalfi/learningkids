/// A language/technology tag on a [Module], used by the lesson catalogue
/// (US24) to let a learner browse by language across every path instead of
/// only through a path's own roadmap.
enum LessonLanguage {
  html,
  css,
  javascript,
  vue,
  angular,
  python,
  dart,
  sql,
  typescript,
  git,
}

String lessonLanguageLabel(LessonLanguage language) {
  switch (language) {
    case LessonLanguage.html:
      return 'HTML';
    case LessonLanguage.css:
      return 'CSS';
    case LessonLanguage.javascript:
      return 'JavaScript';
    case LessonLanguage.vue:
      return 'Vue.js';
    case LessonLanguage.angular:
      return 'Angular';
    case LessonLanguage.python:
      return 'Python';
    case LessonLanguage.dart:
      return 'Dart';
    case LessonLanguage.sql:
      return 'SQL';
    case LessonLanguage.typescript:
      return 'TypeScript';
    case LessonLanguage.git:
      return 'Git';
  }
}
