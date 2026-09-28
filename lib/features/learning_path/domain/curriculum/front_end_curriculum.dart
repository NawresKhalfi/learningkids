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
          codeExample:
              '<h1>Bonjour le monde !</h1>\n<p>Voici mon premier site.</p>',
        ),
        LessonSection(
          heading: 'Structurer une page',
          body:
              "Une page HTML a toujours la même charpente : <html> contient tout, <head> "
              "donne des infos sur la page, et <body> contient ce que l'on voit vraiment.",
          codeExample:
              '<html>\n  <body>\n    <h1>Mon site</h1>\n  </body>\n</html>',
        ),
      ],
      recap:
          "À retenir : le HTML structure une page avec des balises imbriquées les unes "
          "dans les autres, comme des boîtes qui en contiennent d'autres.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            'Comment écrit-on le titre principal (le plus important) en HTML ?',
        options: [
          '<h1>Titre</h1>',
          '<title>Titre</title>',
          '<head>Titre</head>',
          '<h>Titre</h>',
        ],
        correctIndex: 0,
        explanation:
            "La balise <h1> sert à écrire le titre principal d'une page.",
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
    description:
        'Donne des couleurs, des tailles et de l\'espace à ta page HTML.',
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
        explanation:
            "color change la couleur du texte de l'élément sélectionné.",
      ),
      QuizQuestion(
        prompt: 'Comment sélectionne-t-on tous les <h1> en CSS ?',
        options: ['#h1', '.h1', 'h1', '*h1'],
        correctIndex: 2,
        explanation:
            "Pour cibler une balise, on écrit simplement son nom : ici, h1.",
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
        explanation:
            "En JavaScript, on utilise let (ou var/const) pour créer une variable.",
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
    description:
        'Découvre comment les développeurs pros construisent des sites modernes.',
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
          codeExample:
              'function Bouton() {\n  return <button>Clique-moi</button>;\n}',
        ),
        LessonSection(
          heading: 'Afficher des données',
          body:
              "Un composant peut afficher une information qui change, comme un score ou "
              "un pseudo, en l'écrivant entre accolades dans le HTML qu'il retourne.",
          codeExample:
              'function Salut({ pseudo }) {\n  return <p>Salut {pseudo} !</p>;\n}',
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
        explanation:
            "Un composant est une fonction réutilisable qui retourne du HTML/JSX.",
      ),
      QuizQuestion(
        prompt:
            'Comment affiche-t-on une variable dans le HTML retourné par un composant ?',
        options: [
          'Entre crochets [var]',
          'Entre parenthèses (var)',
          'Entre accolades {var}',
          'Avec un \$var',
        ],
        correctIndex: 2,
        explanation:
            "En React, on écrit une variable entre accolades { } pour l'afficher.",
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
    languages: const [
      LessonLanguage.html,
      LessonLanguage.css,
      LessonLanguage.javascript,
    ],
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
        options: [
          'Dans un portfolio personnel',
          'Nulle part',
          'Uniquement à l\'école',
          'Dans une base de données',
        ],
        correctIndex: 0,
        explanation:
            "Une prochaine fonctionnalité te permettra de publier tes projets dans un "
            "portfolio.",
      ),
    ],
  ),
  Module(
    id: 'frontend-6',
    path: LearningPath.frontEnd,
    order: 6,
    title: 'Découvrir Vue.js',
    description: 'Crée une interface web réactive avec le framework Vue.js.',
    prerequisiteIds: const ['frontend-5'],
    languages: const [LessonLanguage.javascript, LessonLanguage.vue],
    lesson: const Lesson(
      intro:
          'Vue.js est un framework JavaScript apprécié pour sa simplicité. Il relie facilement les données à ce que l’on voit sur la page.',
      sections: [
        LessonSection(
          heading: 'Afficher une donnée',
          body:
              'Dans Vue, les doubles accolades affichent une donnée dans le modèle HTML.',
          codeExample: '<p>Bonjour {{ prenom }}</p>',
        ),
        LessonSection(
          heading: 'Réagir à un clic',
          body:
              'La directive @click lance une action lorsqu’une personne clique sur un bouton.',
          codeExample: '<button @click="score++">+1</button>',
        ),
      ],
      recap:
          'À retenir : Vue.js rend une page réactive en reliant les données et les éléments HTML.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel framework est étudié dans ce module ?',
        options: ['Vue.js', 'Flutter', 'Django', 'SQL'],
        correctIndex: 0,
        explanation: 'Ce module présente Vue.js.',
      ),
      QuizQuestion(
        prompt: 'Que fait @click dans Vue ?',
        options: [
          'Il réagit à un clic',
          'Il crée une base de données',
          'Il ajoute du CSS',
          'Il télécharge une image',
        ],
        correctIndex: 0,
        explanation: '@click associe un clic à une action.',
      ),
    ],
  ),
  Module(
    id: 'frontend-7',
    path: LearningPath.frontEnd,
    order: 7,
    title: 'Découvrir Angular',
    description: 'Organise une application web avec les composants Angular.',
    prerequisiteIds: const ['frontend-6'],
    languages: const [
      LessonLanguage.javascript,
      LessonLanguage.typescript,
      LessonLanguage.angular,
    ],
    lesson: const Lesson(
      intro:
          'Angular est un framework complet, souvent utilisé pour les grandes applications web. Il utilise des composants et TypeScript.',
      sections: [
        LessonSection(
          heading: 'Les composants',
          body:
              'Un composant Angular rassemble une partie de l’interface, son modèle et son comportement.',
          codeExample:
              "@Component({ selector: 'app-bonjour', template: '<p>Bonjour !</p>' })",
        ),
        LessonSection(
          heading: 'Afficher une propriété',
          body:
              'Angular utilise aussi les doubles accolades pour afficher une propriété du composant.',
          codeExample: '<h1>{{ titre }}</h1>',
        ),
      ],
      recap:
          'À retenir : Angular structure une application avec des composants TypeScript réutilisables.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel langage est couramment utilisé avec Angular ?',
        options: ['TypeScript', 'Dart', 'Python uniquement', 'HTML uniquement'],
        correctIndex: 0,
        explanation: 'Angular s’appuie généralement sur TypeScript.',
      ),
      QuizQuestion(
        prompt: 'Qu’est-ce qu’un composant Angular ?',
        options: [
          'Une partie réutilisable de l’interface',
          'Un mot de passe',
          'Un navigateur web',
          'Une table SQL',
        ],
        correctIndex: 0,
        explanation: 'Un composant organise une portion de l’application.',
      ),
    ],
  ),
  Module(
    id: 'frontend-8',
    path: LearningPath.frontEnd,
    order: 8,
    title: 'Projet : choisir son framework',
    description:
        'Compare React, Vue et Angular pour choisir l’outil de ton site.',
    prerequisiteIds: const ['frontend-7'],
    languages: const [
      LessonLanguage.javascript,
      LessonLanguage.vue,
      LessonLanguage.angular,
    ],
    lesson: const Lesson(
      intro:
          'React, Vue et Angular servent tous à créer des interfaces web. Le meilleur choix dépend du projet et de l’équipe.',
      sections: [
        LessonSection(
          heading: 'Comparer les outils',
          body:
              'React est une bibliothèque très flexible, Vue est facile à prendre en main et Angular apporte une structure complète.',
        ),
        LessonSection(
          heading: 'Créer ton tableau de bord',
          body:
              'Choisis un framework et imagine une page avec un titre, une liste et un bouton interactif.',
        ),
      ],
      recap:
          'Bravo : tu connais maintenant plusieurs frameworks pour donner vie à tes sites web.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quels frameworks web as-tu explorés ?',
        options: [
          'React, Vue et Angular',
          'Flutter, SQL et Git',
          'Python, Dart et SQL',
          'Aucun framework',
        ],
        correctIndex: 0,
        explanation: 'Le parcours présente React, Vue.js et Angular.',
      ),
      QuizQuestion(
        prompt: 'Comment choisir un framework ?',
        options: [
          'Selon le projet et les besoins de l’équipe',
          'Toujours au hasard',
          'Uniquement selon sa couleur',
          'Sans jamais tester',
        ],
        correctIndex: 0,
        explanation: 'Les besoins du projet guident le choix de l’outil.',
      ),
    ],
  ),
];
