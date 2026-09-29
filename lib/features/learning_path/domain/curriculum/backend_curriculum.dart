import 'advanced_curriculum.dart';
import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// US16: API, bases de données et sécurité. Le dernier module explique les
/// bonnes pratiques avec l'IA en texte ; les exercices *assistés* par l'IA
/// eux-mêmes dépendent d'EP06 (assistant IA), pas encore construit.
final List<Module> backendCurriculum = [
  Module(
    id: 'backend-1',
    path: LearningPath.backend,
    order: 1,
    title: 'Concevoir une API REST',
    description: 'Apprends à organiser les adresses que ton serveur expose.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "Une API REST organise les échanges entre une application et un serveur "
          "autour de quelques règles simples et d'adresses claires.",
      sections: [
        LessonSection(
          heading: 'Les verbes HTTP',
          body:
              "GET demande une information, POST en crée une nouvelle, PUT la modifie "
              "et DELETE la supprime — quatre actions pour presque tout faire.",
          codeExample: 'GET    /joueurs\nPOST   /joueurs\nDELETE /joueurs/12',
        ),
        LessonSection(
          heading: 'Organiser ses routes',
          body:
              "On regroupe les routes par type de donnée (/joueurs, /parties...) pour "
              "qu'une API reste facile à comprendre même quand elle grandit.",
        ),
      ],
      recap:
          "À retenir : une bonne API REST utilise des adresses claires et les bons "
          "verbes HTTP pour chaque action.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            'Quel verbe HTTP utilise-t-on pour demander (lire) une information ?',
        options: ['GET', 'POST', 'DELETE', 'PUT'],
        correctIndex: 0,
        explanation:
            'GET sert à demander (lire) une information sans la modifier.',
      ),
      QuizQuestion(
        prompt: 'Quel verbe HTTP utilise-t-on pour supprimer une donnée ?',
        options: ['GET', 'POST', 'DELETE', 'PUT'],
        correctIndex: 2,
        explanation: 'DELETE indique au serveur de supprimer une ressource.',
      ),
    ],
  ),
  Module(
    id: 'backend-2',
    path: LearningPath.backend,
    order: 2,
    title: 'Bases de données & modélisation',
    description: 'Organise tes données pour qu\'elles restent cohérentes.',
    prerequisiteIds: const ['backend-1'],
    languages: const [LessonLanguage.sql],
    lesson: const Lesson(
      intro:
          "Avant d'écrire la moindre ligne de code, un bon serveur commence par bien "
          "réfléchir à comment ranger ses données : c'est la modélisation.",
      sections: [
        LessonSection(
          heading: 'Modéliser ses données',
          body:
              "On liste les informations dont on a besoin (un joueur a un pseudo, un "
              "score, une date d'inscription...) avant de créer les tables.",
        ),
        LessonSection(
          heading: 'Relations entre tables',
          body:
              "Deux tables peuvent être reliées : par exemple, chaque partie appartient "
              "à un joueur, grâce à un identifiant partagé entre les deux tables.",
        ),
      ],
      recap:
          "À retenir : bien modéliser ses données avant de coder évite beaucoup de "
          "problèmes plus tard.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            "Que fait-on avant d'écrire la moindre ligne de code d'un serveur ?",
        options: [
          'On teste directement en production',
          'On modélise ses données',
          'On choisit la couleur du site',
          'On écrit le CSS',
        ],
        correctIndex: 1,
        explanation:
            'Modéliser ses données en premier évite beaucoup de problèmes plus tard.',
      ),
      QuizQuestion(
        prompt: 'Comment relie-t-on deux tables entre elles ?',
        options: [
          'Avec un identifiant partagé',
          'Avec une couleur commune',
          "Ce n'est pas possible",
          'En les fusionnant en une seule ligne',
        ],
        correctIndex: 0,
        explanation:
            "On utilise un identifiant (comme l'id du joueur) présent dans les deux "
            'tables.',
      ),
    ],
  ),
  Module(
    id: 'backend-3',
    path: LearningPath.backend,
    order: 3,
    title: 'Authentification & sécurité',
    description: 'Vérifie qui utilise ton application et protège ses données.',
    prerequisiteIds: const ['backend-2'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "Un serveur doit souvent savoir QUI lui parle, et s'assurer que les données "
          "sensibles restent protégées.",
      sections: [
        LessonSection(
          heading: 'Vérifier une identité',
          body:
              "S'authentifier, c'est prouver qui on est — souvent avec un mot de passe. "
              "Le serveur ne doit jamais stocker ce mot de passe en clair, mais une "
              "version transformée (un hash), comme on l'a fait pour le code PIN de "
              "l'Espace Parent.",
        ),
        LessonSection(
          heading: 'Protéger les données sensibles',
          body:
              "Un bon serveur ne renvoie que les informations nécessaires, et vérifie "
              "toujours que la personne qui demande une donnée a le droit d'y accéder.",
        ),
      ],
      recap:
          "À retenir : ne jamais faire confiance aveuglément, et toujours vérifier qui "
          "demande quoi.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Comment un serveur doit-il stocker un mot de passe ?',
        options: [
          'En clair, tel quel',
          'Sous forme de hash (transformé)',
          'Il ne doit jamais le stocker',
          'Dans un fichier texte public',
        ],
        correctIndex: 1,
        explanation:
            'Un mot de passe doit toujours être transformé (hashé) avant d\'être '
            'stocké, jamais en clair.',
      ),
      QuizQuestion(
        prompt: 'Avant de renvoyer une donnée sensible, un bon serveur doit...',
        options: [
          'La renvoyer à tout le monde',
          "Vérifier que la personne a le droit d'y accéder",
          'L\'afficher en couleur',
          "L'ignorer",
        ],
        correctIndex: 1,
        explanation:
            "Il faut toujours vérifier les droits d'accès avant de renvoyer une donnée "
            'sensible.',
      ),
    ],
  ),
  Module(
    id: 'backend-4',
    path: LearningPath.backend,
    order: 4,
    title: "Bonnes pratiques avec l'IA",
    description:
        "Apprends à utiliser un assistant IA sans perdre le contrôle de ton code.",
    prerequisiteIds: const ['backend-3'],
    languages: const [LessonLanguage.javascript],
    lesson: const Lesson(
      intro:
          "De plus en plus de développeurs utilisent un assistant IA pour coder plus "
          "vite. Bien utilisé, c'est un formidable copilote.",
      sections: [
        LessonSection(
          heading: "Un copilote, pas un pilote",
          body:
              "Une IA peut proposer du code, mais c'est toujours à toi de comprendre ce "
              "qu'elle écrit avant de l'utiliser — jamais l'inverse.",
        ),
        LessonSection(
          heading: 'Toujours relire et tester',
          body:
              "Le code généré par une IA peut contenir des erreurs ou des choix "
              "discutables. On le relit, on le teste, et on l'ajuste si besoin.",
        ),
      ],
      recap:
          "À retenir : garde toujours la main sur ton code, même avec l'aide d'une IA "
          "(les exercices guidés par un assistant IA intégré arriveront avec une "
          "prochaine mise à jour).",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que doit-on toujours faire avec du code proposé par une IA ?',
        options: [
          'L\'utiliser sans le lire',
          'Le relire et le comprendre avant de l\'utiliser',
          'Le supprimer immédiatement',
          'Le partager sans vérification',
        ],
        correctIndex: 1,
        explanation:
            'Une IA peut se tromper : il faut toujours relire et comprendre son code '
            'avant de l\'utiliser.',
      ),
      QuizQuestion(
        prompt: 'Une IA doit être utilisée comme...',
        options: [
          'Un pilote qui décide à ta place',
          "Un copilote qui t'aide",
          'Un remplaçant total du développeur',
          'Une base de données',
        ],
        correctIndex: 1,
        explanation:
            "L'IA est un copilote : elle propose de l'aide, mais c'est toujours toi qui décides.",
      ),
    ],
  ),
  Module(
    id: 'backend-5',
    path: LearningPath.backend,
    order: 5,
    title: 'Projet Backend',
    description: 'Conçois une API sécurisée de bout en bout.',
    prerequisiteIds: const ['backend-4'],
    languages: const [LessonLanguage.javascript, LessonLanguage.sql],
    lesson: const Lesson(
      intro:
          "Pour ce dernier module, conçois une API complète : ses routes, son modèle "
          "de données, et une authentification simple.",
      sections: [
        LessonSection(
          heading: 'Assembler les briques',
          body:
              "Liste d'abord tes routes et le verbe HTTP de chacune, dessine ensuite "
              "tes tables, puis ajoute une vérification d'identité aux routes qui en "
              "ont besoin.",
        ),
        LessonSection(
          heading: 'Aller plus loin',
          body:
              "Une fois ton API terminée, tu pourras la présenter dans ton portfolio "
              "personnel (une fonctionnalité qui arrive bientôt !).",
        ),
      ],
      recap:
          "À retenir : une bonne API backend combine des routes claires, des données "
          "bien modélisées et une sécurité pensée dès le départ.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            'Quelle est la première chose à lister pour concevoir une API ?',
        options: [
          'Les couleurs du site',
          'Les routes et leur verbe HTTP',
          'La musique de fond',
          "Le nombre d'utilisateurs",
        ],
        correctIndex: 1,
        explanation:
            'On commence par lister les routes nécessaires et le bon verbe HTTP pour '
            'chacune.',
      ),
      QuizQuestion(
        prompt: 'Une bonne API backend doit toujours inclure...',
        options: [
          'Une sécurité pensée dès le départ',
          'Aucune vérification',
          'Des mots de passe en clair',
          'Un seul type de données',
        ],
        correctIndex: 0,
        explanation:
            'La sécurité doit être pensée dès la conception, pas ajoutée après coup.',
      ),
    ],
  ),
  Module(
    id: 'backend-6',
    path: LearningPath.backend,
    order: 6,
    title: 'Les données pour l’IA',
    description:
        'Découvre pourquoi les données sont essentielles pour une intelligence artificielle.',
    prerequisiteIds: const ['backend-5'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          'Une IA apprend en observant des exemples. La qualité de ces données influence directement la qualité de ses réponses.',
      sections: [
        LessonSection(
          heading: 'Des exemples utiles',
          body:
              'Pour apprendre à reconnaître des fruits, un modèle a besoin de nombreux exemples variés et correctement nommés.',
        ),
        LessonSection(
          heading: 'Protéger la vie privée',
          body:
              'On ne collecte que les données nécessaires et on évite les informations personnelles ou sensibles.',
        ),
      ],
      recap:
          'À retenir : une IA a besoin de données variées, fiables et respectueuses de la vie privée.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'De quoi une IA a-t-elle besoin pour apprendre ?',
        options: [
          'D’exemples de données',
          'D’un mot de passe public',
          'D’une seule couleur',
          'D’aucune information',
        ],
        correctIndex: 0,
        explanation:
            'Les exemples permettent à un modèle de repérer des régularités.',
      ),
      QuizQuestion(
        prompt: 'Que faut-il éviter de collecter sans raison ?',
        options: [
          'Des données personnelles sensibles',
          'Des exemples utiles',
          'Des titres de leçons',
          'Des points de jeu',
        ],
        correctIndex: 0,
        explanation: 'La vie privée doit toujours être protégée.',
      ),
    ],
  ),
  Module(
    id: 'backend-7',
    path: LearningPath.backend,
    order: 7,
    title: 'Préparer les données',
    description:
        'Nettoie et organise des données avant de les utiliser avec un modèle.',
    prerequisiteIds: const ['backend-6'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          'Avant d’utiliser des données, on les vérifie : les doublons, les erreurs et les informations manquantes peuvent tromper un modèle.',
      sections: [
        LessonSection(
          heading: 'Nettoyer',
          body:
              'On supprime ou corrige les valeurs manifestement fausses et les lignes en double.',
        ),
        LessonSection(
          heading: 'Séparer pour tester',
          body:
              'Une partie des exemples sert à apprendre et une autre, jamais montrée au modèle, sert à vérifier ses résultats.',
        ),
      ],
      recap:
          'À retenir : des données propres et un jeu de test séparé aident à mesurer honnêtement un modèle.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Pourquoi nettoyer les données ?',
        options: [
          'Pour limiter les erreurs du modèle',
          'Pour les rendre secrètes',
          'Pour supprimer tous les exemples',
          'Pour éviter les tests',
        ],
        correctIndex: 0,
        explanation:
            'Des erreurs dans les données peuvent produire de mauvaises réponses.',
      ),
      QuizQuestion(
        prompt: 'À quoi sert un jeu de test ?',
        options: [
          'À vérifier le modèle avec de nouveaux exemples',
          'À décorer l’application',
          'À créer une route API',
          'À stocker un mot de passe',
        ],
        correctIndex: 0,
        explanation:
            'Le jeu de test mesure ce que le modèle sait faire sur des exemples inconnus.',
      ),
    ],
  ),
  Module(
    id: 'backend-8',
    path: LearningPath.backend,
    order: 8,
    title: 'Comprendre les modèles',
    description:
        'Apprends comment un modèle repère des motifs pour faire une prédiction.',
    prerequisiteIds: const ['backend-7'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          'Un modèle est un programme qui cherche des motifs dans les exemples afin de proposer une réponse pour une nouvelle situation.',
      sections: [
        LessonSection(
          heading: 'Apprendre un motif',
          body:
              'Avec des exemples de messages utiles et indésirables, un modèle peut apprendre des indices pour filtrer le spam.',
        ),
        LessonSection(
          heading: 'Prédire, pas deviner',
          body:
              'Une prédiction est une estimation. Elle peut être utile, mais elle n’est jamais une vérité garantie.',
        ),
      ],
      recap:
          'À retenir : un modèle utilise des motifs appris pour estimer une réponse, avec une part d’incertitude.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que fait un modèle d’IA ?',
        options: [
          'Il repère des motifs dans des exemples',
          'Il connaît toujours la vérité',
          'Il remplace les tests',
          'Il supprime les données',
        ],
        correctIndex: 0,
        explanation:
            'Le modèle s’appuie sur des régularités observées dans les données.',
      ),
      QuizQuestion(
        prompt: 'Une prédiction est-elle toujours certaine ?',
        options: [
          'Non, c’est une estimation',
          'Oui, toujours',
          'Seulement en CSS',
          'Uniquement dans un jeu',
        ],
        correctIndex: 0,
        explanation: 'Une IA peut se tromper, même avec de bonnes données.',
      ),
    ],
  ),
  Module(
    id: 'backend-9',
    path: LearningPath.backend,
    order: 9,
    title: 'Tester une IA responsable',
    description:
        'Évalue les erreurs, les biais et les limites d’un système d’IA.',
    prerequisiteIds: const ['backend-8'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          'Avant d’utiliser une IA, on teste ses réponses avec des cas variés et on réfléchit aux personnes qui pourraient être désavantagées.',
      sections: [
        LessonSection(
          heading: 'Mesurer les erreurs',
          body:
              'Note les bonnes réponses et les erreurs. Cherche les situations où le modèle échoue le plus souvent.',
        ),
        LessonSection(
          heading: 'Repérer les biais',
          body:
              'Si les exemples ne représentent pas assez toutes les situations, l’IA peut être moins juste pour certaines personnes.',
        ),
      ],
      recap:
          'À retenir : tester une IA signifie aussi vérifier qu’elle reste juste, sûre et adaptée à ses utilisateurs.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Pourquoi tester une IA avec des cas variés ?',
        options: [
          'Pour repérer ses erreurs et ses limites',
          'Pour éviter toute donnée',
          'Pour changer le langage',
          'Pour cacher les résultats',
        ],
        correctIndex: 0,
        explanation:
            'Des cas variés révèlent les situations où le modèle fonctionne moins bien.',
      ),
      QuizQuestion(
        prompt: 'Qu’est-ce qu’un biais possible ?',
        options: [
          'Une IA moins juste pour certains cas peu représentés',
          'Un bouton violet',
          'Une route API',
          'Un type de base de données',
        ],
        correctIndex: 0,
        explanation:
            'Un manque de diversité dans les exemples peut créer des résultats injustes.',
      ),
    ],
  ),
  Module(
    id: 'backend-10',
    path: LearningPath.backend,
    order: 10,
    title: 'Projet : assistant de défis',
    description:
        'Conçois un assistant qui propose des défis tout en restant utile et responsable.',
    prerequisiteIds: const ['backend-9'],
    languages: const [LessonLanguage.javascript, LessonLanguage.python],
    lesson: const Lesson(
      intro:
          'Pour ton projet final, imagine un assistant qui aide un enfant à trouver un défi de code adapté à son niveau.',
      sections: [
        LessonSection(
          heading: 'Définir les limites',
          body:
              'Écris ce que l’assistant peut faire, ce qu’il ne doit pas faire et quand il doit demander de l’aide à un adulte.',
        ),
        LessonSection(
          heading: 'Tester les réponses',
          body:
              'Prépare des exemples de demandes, vérifie les réponses et améliore les consignes si l’assistant ne reste pas clair ou sûr.',
        ),
      ],
      recap:
          'Bravo : tu sais concevoir une idée d’IA en pensant aux données, aux limites, aux tests et aux personnes qui l’utiliseront.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Que faut-il définir pour un assistant responsable ?',
        options: [
          'Ce qu’il peut et ne peut pas faire',
          'Seulement sa couleur',
          'Aucune règle',
          'Uniquement son nom',
        ],
        correctIndex: 0,
        explanation:
            'Des limites claires rendent l’assistant plus sûr et utile.',
      ),
      QuizQuestion(
        prompt: 'Que faire si une réponse de l’assistant est confuse ?',
        options: [
          'Améliorer les consignes et tester à nouveau',
          'La garder sans vérifier',
          'Supprimer les données au hasard',
          'Ignorer les utilisateurs',
        ],
        correctIndex: 0,
        explanation:
            'Les tests et les améliorations progressives rendent l’outil plus fiable.',
      ),
    ],
  ),
  ...advancedModules(
    path: LearningPath.backend,
    idPrefix: 'backend',
    firstOrder: 11,
    firstPrerequisite: 'backend-10',
    courses: [...backendAdvancedCourses, ...ultraAdvancedCoursesFor(LearningPath.backend)],
  ),
];
