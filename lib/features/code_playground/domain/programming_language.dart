/// The three languages EP05 lets a learner write and run directly in the
/// app (US26), matching the three named in the backlog. Each gets its own
/// persistent scratch buffer (US30) — a full multi-file project manager is
/// EP07's job, not this one.
enum ProgrammingLanguage { python, javascript, html }

String programmingLanguageTitle(ProgrammingLanguage language) {
  switch (language) {
    case ProgrammingLanguage.python:
      return 'Python';
    case ProgrammingLanguage.javascript:
      return 'JavaScript';
    case ProgrammingLanguage.html:
      return 'HTML';
  }
}

/// Friendly starter content so a first-time visitor sees something runnable
/// rather than a blank editor.
String starterCodeFor(ProgrammingLanguage language) {
  switch (language) {
    case ProgrammingLanguage.python:
      return "print('Salut depuis Python !')";
    case ProgrammingLanguage.javascript:
      return "console.log('Salut depuis JavaScript !');";
    case ProgrammingLanguage.html:
      return '<h1>Salut !</h1>\n<p>Modifie ce HTML et regarde l\'aperçu changer.</p>';
  }
}
