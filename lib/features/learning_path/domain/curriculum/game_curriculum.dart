import 'advanced_curriculum.dart';
import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// A playful introduction to browser game development with JavaScript.
final List<Module> gameCurriculum = [
  Module(
    id: 'game-1',
    path: LearningPath.game,
    order: 1,
    title: 'Imaginer un jeu',
    description: 'Découvre les règles, le but et les personnages d’un jeu.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Avant de coder, un créateur de jeu imagine ce que le joueur doit faire et comment il peut gagner.',
      sections: [
        LessonSection(
          heading: 'Le but',
          body:
              'Un bon jeu donne un objectif clair : récupérer des étoiles, atteindre une sortie ou résoudre une énigme.',
        ),
        LessonSection(
          heading: 'Les règles',
          body:
              'Les règles expliquent ce qui est possible, ce qui fait gagner des points et ce qui termine la partie.',
        ),
      ],
      recap:
          'À retenir : un jeu commence par une idée, un objectif et des règles simples.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Pourquoi définir le but d’un jeu ?',
        options: [
          'Pour que le joueur sache quoi faire',
          'Pour choisir un mot de passe',
          'Pour installer une base de données',
          'Pour supprimer les règles',
        ],
        correctIndex: 0,
        explanation: 'Le but donne une direction au joueur.',
      ),
      QuizQuestion(
        prompt: 'Que décrivent les règles ?',
        options: [
          'Les actions possibles et la façon de gagner',
          'La couleur du téléphone seulement',
          'Le nom du navigateur',
          'Uniquement la musique',
        ],
        correctIndex: 0,
        explanation: 'Les règles définissent le fonctionnement du jeu.',
      ),
    ],
  ),
  Module(
    id: 'game-2',
    path: LearningPath.game,
    order: 2,
    title: 'Dessiner le terrain',
    description: 'Place les éléments de ton jeu dans une page web.',
    prerequisiteIds: const ['game-1'],
    languages: const [LessonLanguage.html, LessonLanguage.css],
    lesson: const Lesson(
      intro:
          'Un jeu dans le navigateur a besoin d’une zone de jeu : le terrain sur lequel les personnages et les objets apparaissent.',
      sections: [
        LessonSection(
          heading: 'La zone de jeu',
          body:
              'Un élément HTML peut représenter le terrain. Le CSS lui donne une taille et une couleur.',
          codeExample: '<div id="jeu"></div>',
        ),
        LessonSection(
          heading: 'Les objets',
          body:
              'Chaque personnage, étoile ou obstacle peut être représenté par un élément avec sa propre classe CSS.',
          codeExample: '.heros { background: orange; }',
        ),
      ],
      recap:
          'À retenir : HTML crée les éléments du terrain et CSS leur donne une apparence.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel langage structure la zone de jeu ?',
        options: ['HTML', 'SQL', 'Dart', 'Git'],
        correctIndex: 0,
        explanation: 'HTML crée les éléments visibles de la page.',
      ),
      QuizQuestion(
        prompt: 'Quel langage donne une couleur au héros ?',
        options: ['CSS', 'Python', 'SQL', 'JSON'],
        correctIndex: 0,
        explanation: 'CSS gère l’apparence des éléments.',
      ),
    ],
  ),
  Module(
    id: 'game-3',
    path: LearningPath.game,
    order: 3,
    title: 'Déplacer le héros',
    description: 'Utilise JavaScript pour réagir aux touches du clavier.',
    prerequisiteIds: const ['game-2'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'JavaScript permet au jeu de réagir quand le joueur appuie sur les flèches du clavier.',
      sections: [
        LessonSection(
          heading: 'Écouter une touche',
          body:
              'Un écouteur d’événement repère la touche utilisée par le joueur.',
          codeExample: "document.addEventListener('keydown', bouger);",
        ),
        LessonSection(
          heading: 'Changer la position',
          body:
              'On modifie la position du héros pour le déplacer petit à petit sur le terrain.',
          codeExample: 'positionX = positionX + 10;',
        ),
      ],
      recap:
          'À retenir : un événement clavier peut déclencher le déplacement du héros.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel événement détecte une touche pressée ?',
        options: ['keydown', 'click', 'load', 'color'],
        correctIndex: 0,
        explanation: 'keydown est envoyé quand une touche est enfoncée.',
      ),
      QuizQuestion(
        prompt: 'Comment déplace-t-on le héros ?',
        options: [
          'En modifiant sa position',
          'En changeant le mot de passe',
          'En fermant le navigateur',
          'En créant du SQL',
        ],
        correctIndex: 0,
        explanation: 'Le déplacement change les coordonnées du héros.',
      ),
    ],
  ),
  Module(
    id: 'game-4',
    path: LearningPath.game,
    order: 4,
    title: 'Points et collisions',
    description: 'Ajoute des étoiles à collecter et un score à ton jeu.',
    prerequisiteIds: const ['game-3'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Les points rendent un jeu motivant. Ils augmentent lorsque le héros rencontre un objet à collecter.',
      sections: [
        LessonSection(
          heading: 'Le score',
          body:
              'Une variable garde le nombre de points et son affichage est mis à jour après chaque étoile.',
          codeExample: 'score += 1;',
        ),
        LessonSection(
          heading: 'La collision',
          body:
              'Une collision se produit quand deux objets se touchent. Le jeu peut alors ajouter un point ou retirer un obstacle.',
        ),
      ],
      recap:
          'À retenir : le score est une donnée qui change quand une collision est détectée.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quelle instruction ajoute un point ?',
        options: ['score += 1', 'score = 0', 'score --', 'print(score)'],
        correctIndex: 0,
        explanation: '+= 1 augmente la valeur de score de un.',
      ),
      QuizQuestion(
        prompt: 'Qu’est-ce qu’une collision ?',
        options: [
          'Deux objets du jeu se touchent',
          'Une page se ferme',
          'Un texte devient bleu',
          'Un compte est créé',
        ],
        correctIndex: 0,
        explanation:
            'La collision permet au jeu de savoir que deux objets se rencontrent.',
      ),
    ],
  ),
  Module(
    id: 'game-5',
    path: LearningPath.game,
    order: 5,
    title: 'Projet : chasse aux étoiles',
    description: 'Construis ton premier mini-jeu complet dans le navigateur.',
    prerequisiteIds: const ['game-4'],
    languages: const [
      LessonLanguage.html,
      LessonLanguage.css,
      LessonLanguage.javascript,
    ],
    lesson: const Lesson(
      intro:
          'Assemble ton terrain, ton héros, des étoiles et un compteur de points dans un vrai mini-jeu.',
      sections: [
        LessonSection(
          heading: 'Assembler les règles',
          body:
              'Le joueur déplace son héros avec les flèches et doit récupérer toutes les étoiles.',
        ),
        LessonSection(
          heading: 'Tester le jeu',
          body:
              'Essaie de gagner plusieurs fois et demande à une autre personne de vérifier si les règles sont faciles à comprendre.',
        ),
      ],
      recap:
          'Bravo : tu sais imaginer et programmer les bases d’un jeu web interactif.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quels éléments composent ton mini-jeu ?',
        options: [
          'Terrain, héros, étoiles et score',
          'Seulement un mot de passe',
          'Une table SQL uniquement',
          'Un écran vide',
        ],
        correctIndex: 0,
        explanation: 'Ces éléments forment le jeu de chasse aux étoiles.',
      ),
      QuizQuestion(
        prompt: 'Pourquoi faire tester le jeu ?',
        options: [
          'Pour vérifier que les règles sont compréhensibles',
          'Pour supprimer les points',
          'Pour éviter de coder',
          'Pour changer de navigateur',
        ],
        correctIndex: 0,
        explanation: 'Un test aide à rendre le jeu agréable et clair.',
      ),
    ],
  ),
  Module(
    id: 'game-6',
    path: LearningPath.game,
    order: 6,
    title: 'Animer le jeu',
    description: 'Fais bouger ton jeu de façon fluide image après image.',
    prerequisiteIds: const ['game-5'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Un jeu paraît vivant lorsqu’il se met à jour très souvent : les personnages bougent et les objets changent de place.',
      sections: [
        LessonSection(
          heading: 'La boucle d’animation',
          body:
              'requestAnimationFrame demande au navigateur de rappeler une fonction juste avant la prochaine image.',
          codeExample: 'requestAnimationFrame(animer);',
        ),
        LessonSection(
          heading: 'Mettre à jour',
          body:
              'À chaque image, le jeu calcule les nouvelles positions puis les affiche à nouveau.',
        ),
      ],
      recap:
          'À retenir : une boucle d’animation met le jeu à jour plusieurs fois par seconde.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quelle fonction aide à animer un jeu dans le navigateur ?',
        options: ['requestAnimationFrame', 'alert', 'prompt', 'localStorage'],
        correctIndex: 0,
        explanation:
            'requestAnimationFrame synchronise une mise à jour avec l’affichage.',
      ),
      QuizQuestion(
        prompt: 'Que fait la boucle d’animation ?',
        options: [
          'Elle met régulièrement le jeu à jour',
          'Elle ferme le jeu',
          'Elle crée une base SQL',
          'Elle change le mot de passe',
        ],
        correctIndex: 0,
        explanation: 'La boucle calcule et affiche de nouvelles images.',
      ),
    ],
  ),
  Module(
    id: 'game-7',
    path: LearningPath.game,
    order: 7,
    title: 'Créer des ennemis',
    description: 'Ajoute des obstacles qui rendent ton jeu plus amusant.',
    prerequisiteIds: const ['game-6'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Les ennemis et les obstacles donnent un défi au joueur. Ils doivent rester justes et compréhensibles.',
      sections: [
        LessonSection(
          heading: 'Un mouvement simple',
          body:
              'Un ennemi peut avancer automatiquement puis changer de direction lorsqu’il atteint un bord.',
          codeExample: 'ennemiX += vitesseEnnemi;',
        ),
        LessonSection(
          heading: 'Perdre une vie',
          body:
              'Si le héros touche un ennemi, le jeu peut retirer une vie puis replacer le héros dans une zone sûre.',
        ),
      ],
      recap:
          'À retenir : les ennemis créent un défi ; leurs règles doivent rester justes pour le joueur.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Pourquoi ajouter des ennemis ?',
        options: [
          'Pour créer un défi pour le joueur',
          'Pour effacer le terrain',
          'Pour empêcher tout mouvement',
          'Pour remplacer le score',
        ],
        correctIndex: 0,
        explanation: 'Les ennemis rendent le jeu plus stimulant.',
      ),
      QuizQuestion(
        prompt: 'Que peut-il se passer si le héros touche un ennemi ?',
        options: [
          'Il peut perdre une vie',
          'Le navigateur disparaît',
          'Le code devient du CSS',
          'Le score devient toujours 100',
        ],
        correctIndex: 0,
        explanation:
            'Toucher un ennemi peut déclencher une pénalité prévue par les règles.',
      ),
    ],
  ),
  Module(
    id: 'game-8',
    path: LearningPath.game,
    order: 8,
    title: 'Sons et retours',
    description: 'Ajoute des effets sonores et des messages utiles au joueur.',
    prerequisiteIds: const ['game-7'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Les sons, les couleurs et les petits messages confirment au joueur qu’une action a bien eu lieu.',
      sections: [
        LessonSection(
          heading: 'Un effet sonore',
          body:
              'Un son court peut signaler qu’une étoile a été collectée ou qu’une partie est terminée.',
        ),
        LessonSection(
          heading: 'Un retour visuel',
          body:
              'Un message comme « Bravo ! » ou une animation légère aide le joueur à comprendre ce qui vient de se passer.',
        ),
      ],
      recap:
          'À retenir : les retours sonores et visuels rendent les actions du jeu plus claires.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'À quoi peut servir un effet sonore ?',
        options: [
          'À confirmer une action du joueur',
          'À cacher le score',
          'À créer une table SQL',
          'À arrêter les touches',
        ],
        correctIndex: 0,
        explanation: 'Un son indique par exemple qu’un objet a été récupéré.',
      ),
      QuizQuestion(
        prompt: 'Quel message aide après une réussite ?',
        options: ['Bravo !', 'Erreur inconnue', 'Aucune règle', 'Mot de passe'],
        correctIndex: 0,
        explanation: 'Un message positif confirme clairement la réussite.',
      ),
    ],
  ),
  Module(
    id: 'game-9',
    path: LearningPath.game,
    order: 9,
    title: 'Niveaux et difficulté',
    description:
        'Crée plusieurs niveaux qui deviennent progressivement plus difficiles.',
    prerequisiteIds: const ['game-8'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          'Les niveaux donnent envie de continuer. Ils doivent apprendre de nouvelles choses sans devenir impossibles.',
      sections: [
        LessonSection(
          heading: 'Définir un niveau',
          body:
              'Chaque niveau peut changer le nombre d’étoiles, la vitesse des ennemis ou la forme du terrain.',
        ),
        LessonSection(
          heading: 'Progresser doucement',
          body:
              'Commence avec peu d’obstacles puis augmente la difficulté une seule petite étape à la fois.',
        ),
      ],
      recap:
          'À retenir : une bonne progression ajoute des défis petit à petit.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que peut changer un nouveau niveau ?',
        options: [
          'Le nombre d’obstacles ou leur vitesse',
          'Le nom du navigateur',
          'La langue JavaScript',
          'Le compte du joueur',
        ],
        correctIndex: 0,
        explanation: 'Ces changements créent un nouveau défi.',
      ),
      QuizQuestion(
        prompt: 'Comment rendre un jeu plus juste ?',
        options: [
          'Augmenter la difficulté petit à petit',
          'Tout rendre impossible immédiatement',
          'Supprimer les règles',
          'Cacher les objectifs',
        ],
        correctIndex: 0,
        explanation: 'Une progression douce laisse le temps d’apprendre.',
      ),
    ],
  ),
  Module(
    id: 'game-10',
    path: LearningPath.game,
    order: 10,
    title: 'Projet : aventure à niveaux',
    description:
        'Construis un jeu complet avec animations, ennemis, sons et niveaux.',
    prerequisiteIds: const ['game-9'],
    languages: const [
      LessonLanguage.html,
      LessonLanguage.css,
      LessonLanguage.javascript,
    ],
    lesson: const Lesson(
      intro:
          'Pour le projet final, transforme ta chasse aux étoiles en une petite aventure avec plusieurs niveaux.',
      sections: [
        LessonSection(
          heading: 'Préparer la partie',
          body:
              'Ajoute un écran de départ, un score, des vies et au moins deux niveaux avec leurs propres défis.',
        ),
        LessonSection(
          heading: 'Faire jouer et améliorer',
          body:
              'Observe une personne jouer, note ce qui est difficile ou confus, puis améliore ton jeu une étape à la fois.',
        ),
      ],
      recap:
          'Bravo : tu connais les grandes étapes pour imaginer, construire, tester et améliorer un jeu web.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que contient un jeu à plusieurs niveaux ?',
        options: [
          'Des défis qui évoluent progressivement',
          'Un seul écran sans règle',
          'Uniquement une image',
          'Aucun score',
        ],
        correctIndex: 0,
        explanation: 'Les niveaux apportent de nouveaux défis au fil du jeu.',
      ),
      QuizQuestion(
        prompt: 'Que faire après avoir créé le projet final ?',
        options: [
          'Le faire tester puis l’améliorer',
          'Supprimer tous les niveaux',
          'Ne jamais y jouer',
          'Effacer le score',
        ],
        correctIndex: 0,
        explanation: 'Les retours des joueurs aident à améliorer le jeu.',
      ),
    ],
  ),
  ...advancedModules(
    path: LearningPath.game,
    idPrefix: 'game',
    firstOrder: 11,
    firstPrerequisite: 'game-10',
    courses: [...gameAdvancedCourses, ...ultraAdvancedCoursesFor(LearningPath.game)],
  ),
];
