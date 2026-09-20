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
        prompt: 'Quel verbe HTTP utilise-t-on pour demander (lire) une information ?',
        options: ['GET', 'POST', 'DELETE', 'PUT'],
        correctIndex: 0,
        explanation: 'GET sert à demander (lire) une information sans la modifier.',
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
        prompt: "Que fait-on avant d'écrire la moindre ligne de code d'un serveur ?",
        options: [
          'On teste directement en production',
          'On modélise ses données',
          'On choisit la couleur du site',
          'On écrit le CSS',
        ],
        correctIndex: 1,
        explanation: 'Modéliser ses données en premier évite beaucoup de problèmes plus tard.',
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
    description: "Apprends à utiliser un assistant IA sans perdre le contrôle de ton code.",
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
        explanation: "L'IA est un copilote : elle propose de l'aide, mais c'est toujours toi qui décides.",
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
        prompt: 'Quelle est la première chose à lister pour concevoir une API ?',
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
        explanation: 'La sécurité doit être pensée dès la conception, pas ajoutée après coup.',
      ),
    ],
  ),
];
