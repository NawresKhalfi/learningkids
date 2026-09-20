import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// US15: back-end (Node.js/Express, SQL, TypeScript) relié au front-end,
/// avec un projet full-stack en fin de parcours.
final List<Module> fullStackCurriculum = [
  Module(
    id: 'fullstack-1',
    path: LearningPath.fullStack,
    order: 1,
    title: 'Node.js et Express',
    description: 'Fais tourner du JavaScript côté serveur pour la première fois.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "Jusqu'ici, ton JavaScript tournait dans le navigateur. Avec Node.js, il peut "
          "aussi tourner sur un serveur, pour répondre aux sites qui le contactent.",
      sections: [
        LessonSection(
          heading: "Un serveur, à quoi ça sert ?",
          body:
              "Un serveur attend des demandes (par exemple \"donne-moi la liste des "
              "scores\") et y répond. Express est un outil qui simplifie l'écriture de "
              "ces réponses en JavaScript.",
        ),
        LessonSection(
          heading: 'Créer une route',
          body:
              "Une route associe une adresse (comme /scores) à une réponse. Express "
              "rend ça très court à écrire.",
          codeExample:
              "app.get('/scores', (req, res) => {\n  res.send([12, 8, 20]);\n});",
        ),
      ],
      recap:
          "À retenir : un serveur Express écoute des adresses (routes) et répond aux "
          "demandes qui arrivent dessus.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "À quoi sert une route dans Express ?",
        options: [
          'À styliser une page',
          "À associer une adresse à une réponse du serveur",
          'À stocker des mots de passe',
          'À dessiner une image',
        ],
        correctIndex: 1,
        explanation:
            'Une route associe une adresse (comme /scores) à ce que le serveur doit '
            'répondre.',
      ),
      QuizQuestion(
        prompt: 'Node.js permet de faire tourner quel langage côté serveur ?',
        options: ['Python', 'JavaScript', 'CSS', 'SQL'],
        correctIndex: 1,
        explanation:
            'Node.js permet de faire tourner du JavaScript en dehors du navigateur, '
            'sur un serveur.',
      ),
    ],
  ),
  Module(
    id: 'fullstack-2',
    path: LearningPath.fullStack,
    order: 2,
    title: 'Bases de données SQL',
    description: 'Stocke des informations de façon durable et organisée.',
    prerequisiteIds: const ['fullstack-1'],
    languages: const [LessonLanguage.sql],
    lesson: const Lesson(
      intro:
          "Un serveur a besoin de garder des informations même quand il redémarre : "
          "c'est le rôle d'une base de données. SQL est le langage pour lui parler.",
      sections: [
        LessonSection(
          heading: 'Stocker des données dans des tables',
          body:
              "Une base SQL range les informations dans des tables, comme des tableurs : "
              "chaque ligne est une entrée, chaque colonne une information.",
        ),
        LessonSection(
          heading: 'Interroger une base avec SQL',
          body:
              "La commande SELECT permet de demander des informations à une table, en "
              "filtrant éventuellement avec WHERE.",
          codeExample: "SELECT pseudo, score FROM joueurs WHERE score > 10;",
        ),
      ],
      recap:
          "À retenir : SQL permet de ranger des données dans des tables, puis de les "
          "retrouver facilement avec des requêtes.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quelle commande SQL permet de demander des données ?',
        options: ['GET', 'SELECT', 'FIND', 'ASK'],
        correctIndex: 1,
        explanation: 'SELECT est la commande utilisée pour interroger une base SQL.',
      ),
      QuizQuestion(
        prompt: 'Dans une base SQL, une table ressemble le plus à...',
        options: [
          'Un tableur avec des lignes et colonnes',
          'Une image',
          'Un fichier vidéo',
          'Un composant React',
        ],
        correctIndex: 0,
        explanation: 'Une table SQL range les données en lignes et colonnes, comme un tableur.',
      ),
    ],
  ),
  Module(
    id: 'fullstack-3',
    path: LearningPath.fullStack,
    order: 3,
    title: 'TypeScript',
    description: 'Ajoute des garde-fous à ton JavaScript pour éviter les erreurs.',
    prerequisiteIds: const ['fullstack-2'],
    languages: const [LessonLanguage.typescript],
    lesson: const Lesson(
      intro:
          "TypeScript est une version de JavaScript qui ajoute des types : on précise "
          "quel genre de valeur une variable doit contenir.",
      sections: [
        LessonSection(
          heading: 'Ajouter des types à JavaScript',
          body:
              "En TypeScript, on peut indiquer qu'une variable doit toujours être un "
              "nombre, une chaîne de caractères, etc.",
          codeExample: 'let score: number = 12;\nlet pseudo: string = "Léo";',
        ),
        LessonSection(
          heading: "Pourquoi c'est utile",
          body:
              "Si on essaie de mettre du texte dans une variable prévue pour un nombre, "
              "TypeScript prévient tout de suite — avant même d'exécuter le programme.",
        ),
      ],
      recap:
          "À retenir : TypeScript attrape certaines erreurs avant l'exécution, ce qui "
          "fait gagner beaucoup de temps sur un gros projet.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que permet d\'ajouter TypeScript à JavaScript ?',
        options: ['Des couleurs', 'Des types', 'De la musique', 'Des animations'],
        correctIndex: 1,
        explanation: 'TypeScript ajoute un système de types à JavaScript.',
      ),
      QuizQuestion(
        prompt:
            'Que se passe-t-il si on essaie de mettre du texte dans une variable de '
            'type number en TypeScript ?',
        options: [
          'Rien, ça fonctionne normalement',
          "TypeScript prévient d'une erreur avant l'exécution",
          'Le programme devient plus rapide',
          'La variable devient automatiquement un texte',
        ],
        correctIndex: 1,
        explanation:
            'TypeScript vérifie les types et signale l\'erreur avant même d\'exécuter '
            'le programme.',
      ),
    ],
  ),
  Module(
    id: 'fullstack-4',
    path: LearningPath.fullStack,
    order: 4,
    title: 'Connecter front-end et back-end',
    description: 'Fais parler ta page web avec ton serveur.',
    prerequisiteIds: const ['fullstack-3'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "Un site complet a un front-end (ce que l'on voit) et un back-end (le "
          "serveur). Ils communiquent grâce à une API.",
      sections: [
        LessonSection(
          heading: "Qu'est-ce qu'une API ?",
          body:
              "Une API est la liste des adresses qu'un serveur accepte, et de ce qu'il "
              "répond à chacune — un peu comme un menu de restaurant pour le code.",
        ),
        LessonSection(
          heading: 'Appeler une API depuis le front',
          body:
              "Depuis le navigateur, la fonction fetch permet de demander des données à "
              "une API et de les afficher sur la page.",
          codeExample:
              "fetch('/scores')\n  .then(reponse => reponse.json())\n  .then(scores => console.log(scores));",
        ),
      ],
      recap:
          "À retenir : le front-end utilise fetch pour appeler l'API du back-end et "
          "afficher ses données.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "Qu'est-ce qu'une API ?",
        options: [
          'Un langage de programmation',
          "La liste des adresses qu'un serveur accepte et de ce qu'il répond",
          'Un type de base de données',
          'Un éditeur de code',
        ],
        correctIndex: 1,
        explanation:
            'Une API décrit comment un front-end peut demander des données à un '
            'serveur.',
      ),
      QuizQuestion(
        prompt: 'Quelle fonction JavaScript permet d\'appeler une API depuis une page web ?',
        options: ['fetch', 'print', 'connect', 'require'],
        correctIndex: 0,
        explanation: 'fetch envoie une demande à une adresse (souvent une API) et récupère la réponse.',
      ),
    ],
  ),
  Module(
    id: 'fullstack-5',
    path: LearningPath.fullStack,
    order: 5,
    title: 'Projet Full-Stack',
    description: 'Construis une mini-application complète, du serveur à la page web.',
    prerequisiteIds: const ['fullstack-4'],
    languages: const [LessonLanguage.javascript, LessonLanguage.sql, LessonLanguage.typescript],
    lesson: const Lesson(
      intro:
          "C'est le moment d'assembler un serveur Express, une base de données et une "
          "page web qui les utilise, pour construire une vraie petite application.",
      sections: [
        LessonSection(
          heading: 'Assembler les briques',
          body:
              "Commence par le serveur et sa base de données, ajoute les routes de "
              "l'API, puis connecte ta page web avec fetch.",
        ),
        LessonSection(
          heading: 'Aller plus loin',
          body:
              "Une fois ton application terminée, tu pourras la montrer dans ton "
              "portfolio personnel (une fonctionnalité qui arrive bientôt !).",
        ),
      ],
      recap:
          "À retenir : une application full-stack, c'est un front-end, un back-end et "
          "une base de données qui travaillent ensemble.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Une application full-stack combine...',
        options: [
          'Uniquement un serveur',
          'Un front-end, un back-end et une base de données',
          'Uniquement du CSS',
          'Uniquement une base de données',
        ],
        correctIndex: 1,
        explanation:
            "Full-stack signifie qu'on gère à la fois l'affichage (front), le serveur "
            '(back) et les données.',
      ),
      QuizQuestion(
        prompt: 'Par quoi commence-t-on généralement la construction d\'une application full-stack ?',
        options: [
          'Par la couleur des boutons',
          'Par le serveur et sa base de données',
          "Il n'y a pas d'ordre particulier",
          'Par la publication sur internet',
        ],
        correctIndex: 1,
        explanation:
            'On construit d\'abord le serveur et la base de données, avant de les '
            'relier à une interface.',
      ),
    ],
  ),
];
