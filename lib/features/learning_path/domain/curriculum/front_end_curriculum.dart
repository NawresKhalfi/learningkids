import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// US13: HTML → CSS → JavaScript → React → projet, chaque module
/// débloqué par le précédent.
final List<Module> frontEndCurriculum = [
  Module(
    id: 'frontend-1',
    path: LearningPath.frontEnd,
    order: 1,
    title: 'Les bases du HTML',
    description: "Écris ta toute première page web avec des balises HTML.",
    prerequisiteIds: const [],
    languages: const [LessonLanguage.html],
    lesson: const Lesson(
      intro:
          "HTML, c'est le squelette de toutes les pages web que tu visites. Chaque titre, "
          "chaque paragraphe, chaque image est écrit avec des balises HTML.",
      sections: [
        LessonSection(
          heading: "Qu'est-ce qu'une balise ?",
          body:
              "Une balise dit au navigateur comment afficher un morceau de texte. Elle "
              "s'ouvre avec <nom> et se ferme avec </nom>, et tout ce qui est entre les "
              "deux fait partie de cette balise.",
          codeExample: '<h1>Bonjour le monde !</h1>\n<p>Voici mon premier site.</p>',
        ),
        LessonSection(
          heading: 'Structurer une page',
          body:
              "Une page HTML a toujours la même charpente : <html> contient tout, <head> "
              "donne des infos sur la page, et <body> contient ce que l'on voit vraiment.",
          codeExample: '<html>\n  <body>\n    <h1>Mon site</h1>\n  </body>\n</html>',
        ),
      ],
      recap:
          "À retenir : le HTML structure une page avec des balises imbriquées les unes "
          "dans les autres, comme des boîtes qui en contiennent d'autres.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Comment écrit-on le titre principal (le plus important) en HTML ?',
        options: ['<h1>Titre</h1>', '<title>Titre</title>', '<head>Titre</head>', '<h>Titre</h>'],
        correctIndex: 0,
        explanation: "La balise <h1> sert à écrire le titre principal d'une page.",
      ),
      QuizQuestion(
        prompt: 'Quelle balise contient tout ce qui est visible sur la page ?',
        options: ['<head>', '<body>', '<html>', '<page>'],
        correctIndex: 1,
        explanation:
            "<body> contient tout ce qui s'affiche à l'écran, alors que <head> contient "
            "des informations invisibles pour la page.",
      ),
    ],
  ),
  Module(
    id: 'frontend-2',
    path: LearningPath.frontEnd,
    order: 2,
    title: 'Mise en forme avec CSS',
    description: 'Donne des couleurs, des tailles et de l\'espace à ta page HTML.',
    prerequisiteIds: const ['frontend-1'],
    languages: const [LessonLanguage.css],
    lesson: const Lesson(
      intro:
          "Le HTML donne la structure, mais c'est le CSS qui rend une page belle : "
          "couleurs, polices, espacements, tout passe par lui.",
      sections: [
        LessonSection(
          heading: 'Sélectionner un élément',
          body:
              "En CSS, on choisit d'abord quel élément on veut décorer (un sélecteur), "
              "puis on liste ses propriétés entre accolades.",
          codeExample: 'h1 {\n  color: purple;\n}',
        ),
        LessonSection(
          heading: 'Couleurs et espacements',
          body:
              "Les propriétés color, background-color et padding permettent de changer "
              "les couleurs et l'espace autour du texte, pour aérer une page.",
          codeExample: 'p {\n  color: navy;\n  padding: 16px;\n}',
        ),
      ],
      recap:
          "À retenir : le CSS cible un élément HTML puis lui applique des styles, "
          "comme on choisirait la couleur d'un dessin après avoir tracé les contours.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que fait la propriété CSS color ?',
        options: [
          'Elle change la couleur du texte',
          'Elle change la taille du texte',
          'Elle supprime un élément',
          'Elle crée un lien',
        ],
        correctIndex: 0,
        explanation: "color change la couleur du texte de l'élément sélectionné.",
      ),
      QuizQuestion(
        prompt: 'Comment sélectionne-t-on tous les <h1> en CSS ?',
        options: ['#h1', '.h1', 'h1', '*h1'],
        correctIndex: 2,
        explanation: "Pour cibler une balise, on écrit simplement son nom : ici, h1.",
      ),
    ],
  ),
  Module(
    id: 'frontend-3',
    path: LearningPath.frontEnd,
    order: 3,
    title: 'Interactivité avec JavaScript',
    description: 'Fais réagir ta page quand quelqu\'un clique dessus.',
    prerequisiteIds: const ['frontend-2'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "HTML et CSS rendent une page belle et statique. JavaScript, lui, la rend "
          "vivante : il peut réagir à un clic, changer un texte, faire des calculs.",
      sections: [
        LessonSection(
          heading: 'Variables et événements',
          body:
              "Une variable garde une information en mémoire (let score = 0;). Un "
              "événement, comme un clic, déclenche du code JavaScript.",
          codeExample: 'let score = 0;',
        ),
        LessonSection(
          heading: 'Réagir à un clic',
          body:
              "On peut dire à un bouton d'exécuter une fonction dès qu'il est cliqué, "
              "grâce à addEventListener.",
          codeExample:
              "bouton.addEventListener('click', () => {\n  score = score + 1;\n});",
        ),
      ],
      recap:
          "À retenir : JavaScript écoute ce que fait la personne sur la page (clic, "
          "saisie...) et peut changer ce qui s'affiche en réaction.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel mot-clé permet de créer une variable en JavaScript ?',
        options: ['let', 'int', 'def', 'make'],
        correctIndex: 0,
        explanation: "En JavaScript, on utilise let (ou var/const) pour créer une variable.",
      ),
      QuizQuestion(
        prompt: "Que fait addEventListener('click', ...) sur un bouton ?",
        options: [
          'Il colore le bouton',
          'Il exécute du code quand on clique dessus',
          'Il crée une variable',
          'Il supprime le bouton',
        ],
        correctIndex: 1,
        explanation:
            "addEventListener('click', ...) exécute une fonction chaque fois que "
            "l'élément est cliqué.",
      ),
    ],
  ),
  Module(
    id: 'frontend-4',
    path: LearningPath.frontEnd,
    order: 4,
    title: 'Introduction à React',
    description: 'Découvre comment les développeurs pros construisent des sites modernes.',
    prerequisiteIds: const ['frontend-3'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "React est un outil très utilisé par les développeurs pour construire des "
          "sites en assemblant des petits morceaux réutilisables : les composants.",
      sections: [
        LessonSection(
          heading: 'Les composants',
          body:
              "Un composant React est une petite fonction qui décrit un bout d'interface, "
              "comme un bouton ou une carte, qu'on peut réutiliser partout.",
          codeExample: 'function Bouton() {\n  return <button>Clique-moi</button>;\n}',
        ),
        LessonSection(
          heading: 'Afficher des données',
          body:
              "Un composant peut afficher une information qui change, comme un score ou "
              "un pseudo, en l'écrivant entre accolades dans le HTML qu'il retourne.",
          codeExample: 'function Salut({ pseudo }) {\n  return <p>Salut {pseudo} !</p>;\n}',
        ),
      ],
      recap:
          "À retenir : avec React, on construit une page en assemblant des composants, "
          "un peu comme des briques de Lego.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "Qu'est-ce qu'un composant React ?",
        options: [
          'Un fichier CSS',
          "Une fonction qui décrit un bout d'interface",
          'Une base de données',
          'Un langage de programmation',
        ],
        correctIndex: 1,
        explanation: "Un composant est une fonction réutilisable qui retourne du HTML/JSX.",
      ),
      QuizQuestion(
        prompt: 'Comment affiche-t-on une variable dans le HTML retourné par un composant ?',
        options: ['Entre crochets [var]', 'Entre parenthèses (var)', 'Entre accolades {var}', 'Avec un \$var'],
        correctIndex: 2,
        explanation: "En React, on écrit une variable entre accolades { } pour l'afficher.",
      ),
    ],
  ),
  Module(
    id: 'frontend-5',
    path: LearningPath.frontEnd,
    order: 5,
    title: 'Projet Front-End',
    description: 'Assemble tout ce que tu as appris dans un mini-site.',
    prerequisiteIds: const ['frontend-4'],
    languages: const [LessonLanguage.html, LessonLanguage.css, LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "C'est l'heure de tout rassembler ! Ce module te propose de construire une "
          "petite page qui utilise HTML, CSS, JavaScript et un composant React.",
      sections: [
        LessonSection(
          heading: 'Assembler les briques',
          body:
              "Commence par la structure HTML, ajoute le style CSS, puis rends la page "
              "interactive avec JavaScript ou un composant React.",
        ),
        LessonSection(
          heading: 'Aller plus loin',
          body:
              "Une fois ton mini-site terminé, tu pourras le publier dans ton portfolio "
              "personnel (une fonctionnalité qui arrive bientôt !).",
        ),
      ],
      recap:
          "À retenir : un vrai site web combine toujours structure (HTML), style (CSS) "
          "et comportement (JavaScript/React).",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "Dans quel ordre construit-on généralement une page web ?",
        options: [
          'CSS puis HTML puis JS',
          'HTML puis CSS puis JS',
          'JS puis CSS puis HTML',
          "L'ordre n'a pas d'importance",
        ],
        correctIndex: 1,
        explanation:
            "On commence par la structure (HTML), puis le style (CSS), puis le "
            "comportement (JavaScript).",
      ),
      QuizQuestion(
        prompt: 'Où pourras-tu bientôt montrer ton mini-site terminé ?',
        options: ['Dans un portfolio personnel', 'Nulle part', 'Uniquement à l\'école', 'Dans une base de données'],
        correctIndex: 0,
        explanation:
            "Une prochaine fonctionnalité te permettra de publier tes projets dans un "
            "portfolio.",
      ),
    ],
  ),
];
