import 'advanced_curriculum.dart';
import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../practical_exercise_kind.dart';
import '../quiz_question.dart';

/// EP10 (US53/US54): how developers work together — version control with
/// Git/GitHub, then the modern workflow habits (code review, tests,
/// CI/CD) built on top of it.
final List<Module> collaborationCurriculum = [
  Module(
    id: 'collaboration-1',
    path: LearningPath.collaboration,
    order: 1,
    title: 'Les bases de Git',
    description:
        'Découvre comment Git garde une mémoire de toutes les versions de ton projet.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.git],
    practicalExercise: PracticalExerciseKind.gitSimulator,
    lesson: const Lesson(
      intro:
          "Quand tu codes, tu modifies souvent ton projet — et parfois une nouvelle version casse "
          "quelque chose qui marchait avant. Git est un outil qui garde en mémoire chaque version "
          "de ton projet, comme une machine à remonter le temps.",
      sections: [
        LessonSection(
          heading: 'Un dépôt Git',
          body:
              "Un dépôt (repository) est un dossier de projet suivi par Git. Une fois initialisé, "
              "Git peut détecter chaque fichier ajouté, modifié ou supprimé.",
          codeExample: 'git init',
        ),
        LessonSection(
          heading: 'Ajouter puis enregistrer (commit)',
          body:
              "Avant d'enregistrer une version, on choisit quels fichiers inclure avec git add. "
              "Ensuite, git commit crée un instantané permanent avec un message qui explique le "
              "changement.",
          codeExample:
              "git add index.html\ngit commit -m 'Ajoute la page d\\'accueil'",
        ),
      ],
      recap:
          "À retenir : Git suit les changements d'un projet par instantanés (commits), chacun "
          "accompagné d'un message qui explique ce qui a changé.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'À quoi sert Git ?',
        options: [
          "À garder en mémoire toutes les versions d'un projet",
          'À colorer une page web',
          'À héberger un site internet',
          'À corriger les fautes de frappe',
        ],
        correctIndex: 0,
        explanation:
            'Git enregistre l\'historique des versions d\'un projet, comme une machine à remonter le temps.',
      ),
      QuizQuestion(
        prompt: 'Que fait la commande git commit ?',
        options: [
          'Elle supprime le projet',
          'Elle crée un instantané permanent du projet avec un message',
          'Elle envoie le projet sur internet',
          'Elle installe Git',
        ],
        correctIndex: 1,
        explanation:
            'git commit enregistre un instantané des fichiers ajoutés, avec un message explicatif.',
      ),
    ],
  ),
  Module(
    id: 'collaboration-2',
    path: LearningPath.collaboration,
    order: 2,
    title: 'Branches et GitHub',
    description:
        "Apprends à travailler sur une idée sans risque, puis à la partager sur GitHub.",
    prerequisiteIds: const ['collaboration-1'],
    languages: const [LessonLanguage.git],
    practicalExercise: PracticalExerciseKind.gitSimulator,
    lesson: const Lesson(
      intro:
          "Et si tu voulais essayer une nouvelle idée sans risquer de casser ce qui fonctionne "
          "déjà ? C'est exactement à ça que servent les branches Git — et GitHub permet ensuite "
          "de partager ton travail avec d'autres personnes.",
      sections: [
        LessonSection(
          heading: 'Créer une branche',
          body:
              "Une branche est une copie parallèle de ton projet où tu peux expérimenter. Ton "
              "code principal (souvent appelé main) reste intact pendant ce temps.",
          codeExample: 'git branch nouvelle-fonctionnalite',
        ),
        LessonSection(
          heading: 'Partager sur GitHub',
          body:
              "GitHub est un site qui héberge des dépôts Git en ligne. La commande git push y "
              "envoie tes commits, pour que d'autres développeurs puissent voir et utiliser ton "
              "code.",
          codeExample: 'git push',
        ),
      ],
      recap:
          "À retenir : une branche permet d'expérimenter sans risque, et GitHub permet de "
          "partager et de collaborer sur un projet Git en ligne.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Pourquoi utiliser une branche ?',
        options: [
          'Pour supprimer le projet',
          'Pour essayer une idée sans toucher au code principal',
          'Pour changer la couleur du code',
          'Pour créer un compte GitHub',
        ],
        correctIndex: 1,
        explanation:
            "Une branche isole tes expérimentations du code principal (main), qui reste intact.",
      ),
      QuizQuestion(
        prompt: 'Que fait git push ?',
        options: [
          'Il envoie tes commits vers un dépôt en ligne comme GitHub',
          'Il supprime tes commits',
          'Il crée un nouveau fichier',
          'Il installe un langage de programmation',
        ],
        correctIndex: 0,
        explanation:
            'git push envoie tes commits enregistrés localement vers un dépôt distant (GitHub).',
      ),
    ],
  ),
  Module(
    id: 'collaboration-3',
    path: LearningPath.collaboration,
    order: 3,
    title: 'Revue de code et tests',
    description:
        "Découvre comment les équipes de développeurs vérifient leur code avant de le publier.",
    prerequisiteIds: const ['collaboration-2'],
    languages: const [LessonLanguage.git],
    lesson: const Lesson(
      intro:
          "Avant qu'un nouveau code rejoigne un vrai projet, les équipes de développeurs le "
          "vérifient soigneusement : c'est la revue de code et les tests automatiques.",
      sections: [
        LessonSection(
          heading: 'La revue de code',
          body:
              "Avant d'ajouter du nouveau code au projet principal, un·e autre développeur·euse le "
              "relit : c'est la revue de code (code review). Iel peut poser des questions ou "
              "suggérer des améliorations avant d'accepter les changements.",
        ),
        LessonSection(
          heading: 'Les tests automatiques',
          body:
              "Un test automatique est un petit programme qui vérifie qu'une partie du code "
              "fonctionne toujours comme prévu, même après une modification. Cela évite de casser "
              "quelque chose sans s'en rendre compte.",
        ),
      ],
      recap:
          "À retenir : la revue de code fait relire ton travail par quelqu'un d'autre, et les "
          "tests automatiques vérifient que le code fonctionne toujours après un changement.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "Qu'est-ce que la revue de code ?",
        options: [
          'Un jeu vidéo',
          "Le fait qu'une autre personne relise le code avant de l'accepter",
          'Un langage de programmation',
          'Un type de virus informatique',
        ],
        correctIndex: 1,
        explanation:
            "La revue de code consiste à faire relire ses changements par un·e collègue avant de "
            "les intégrer au projet.",
      ),
      QuizQuestion(
        prompt: 'À quoi sert un test automatique ?',
        options: [
          'À vérifier que le code fonctionne toujours après un changement',
          'À changer la couleur du site',
          'À supprimer des fichiers',
          'À écrire de la documentation',
        ],
        correctIndex: 0,
        explanation:
            'Un test automatique détecte si une modification a cassé quelque chose qui marchait avant.',
      ),
    ],
  ),
  Module(
    id: 'collaboration-4',
    path: LearningPath.collaboration,
    order: 4,
    title: 'Intégration continue (CI/CD)',
    description:
        'Comprends comment un projet se met à jour automatiquement en toute sécurité.',
    prerequisiteIds: const ['collaboration-3'],
    languages: const [LessonLanguage.git],
    lesson: const Lesson(
      intro:
          "Dans une entreprise, un projet peut recevoir de nouveaux changements plusieurs fois "
          "par jour. Pour que tout reste fiable, les équipes utilisent des robots qui vérifient "
          "et publient automatiquement le code : c'est l'intégration continue.",
      sections: [
        LessonSection(
          heading: "L'intégration continue (CI)",
          body:
              "Dès qu'un changement est proposé, un robot lance automatiquement tous les tests du "
              "projet. Si un test échoue, l'équipe est prévenue avant que le problème n'atteigne "
              "les utilisateurs.",
        ),
        LessonSection(
          heading: 'Le déploiement continu (CD)',
          body:
              "Une fois les tests réussis, le déploiement continu peut publier automatiquement la "
              "nouvelle version pour que tout le monde en profite, sans qu'un humain ait besoin de "
              "le faire à la main.",
        ),
      ],
      recap:
          "À retenir : la CI lance des tests automatiquement à chaque changement, et la CD publie "
          "le code une fois que ces tests réussissent — un vrai gain de temps et de sécurité pour "
          "les équipes.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: "Que fait l'intégration continue (CI) ?",
        options: [
          "Elle lance automatiquement les tests à chaque nouveau changement",
          'Elle dessine des images',
          'Elle supprime le code',
          'Elle crée des comptes utilisateurs',
        ],
        correctIndex: 0,
        explanation:
            'La CI exécute automatiquement les tests dès qu\'un changement est proposé.',
      ),
      QuizQuestion(
        prompt: 'Que permet le déploiement continu (CD) ?',
        options: [
          'De publier automatiquement une nouvelle version validée',
          "D'écrire le code à la place du développeur",
          'De supprimer les anciens tests',
          "De changer le nom du projet",
        ],
        correctIndex: 0,
        explanation:
            'La CD publie automatiquement une nouvelle version dès que les tests de la CI ont réussi.',
      ),
    ],
  ),
  ...advancedModules(
    path: LearningPath.collaboration,
    idPrefix: 'collaboration',
    firstOrder: 5,
    firstPrerequisite: 'collaboration-4',
    courses: collaborationAdvancedCourses,
  ),
];
