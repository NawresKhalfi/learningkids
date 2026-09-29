import 'advanced_curriculum.dart';
import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// US14: bases de Python, du débutant à un premier petit projet.
final List<Module> pythonCurriculum = [
  Module(
    id: 'python-1',
    path: LearningPath.python,
    order: 1,
    title: 'Variables et types',
    description: 'Apprends à stocker et nommer des informations dans ton code.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          "Python est un langage connu pour être simple à lire. On commence toujours "
          "par apprendre à stocker des informations dans des variables.",
      sections: [
        LessonSection(
          heading: 'Stocker une information',
          body:
              "Une variable, c'est une boîte avec un nom, dans laquelle on range une "
              "valeur. En Python, pas besoin de préciser le type : il le devine.",
          codeExample: "prenom = 'Léo'\nage = 9",
        ),
        LessonSection(
          heading: 'Les types de base',
          body:
              "Les types les plus courants sont les nombres entiers (int), les nombres "
              "à virgule (float), le texte (str) et le vrai/faux (bool).",
          codeExample:
              'score = 12       # int\npi = 3.14        # float\nok = True        # bool',
        ),
      ],
      recap:
          "À retenir : une variable a un nom et une valeur, et Python devine tout seul "
          "son type.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel type de donnée est 3.14 en Python ?',
        options: ['int', 'float', 'str', 'bool'],
        correctIndex: 1,
        explanation: "3.14 a une virgule : c'est un float (nombre décimal).",
      ),
      QuizQuestion(
        prompt: 'Comment crée-t-on une variable nommée age valant 9 ?',
        options: ['age = 9', '9 = age', 'var age = 9', 'int age = 9'],
        correctIndex: 0,
        explanation: "En Python, on écrit simplement nom_de_variable = valeur.",
      ),
    ],
  ),
  Module(
    id: 'python-2',
    path: LearningPath.python,
    order: 2,
    title: 'Conditions et boucles',
    description:
        'Fais prendre des décisions à ton programme et répète des actions.',
    prerequisiteIds: const ['python-1'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          "Un programme intéressant doit pouvoir prendre des décisions et répéter des "
          "actions sans qu'on ait à tout réécrire à la main.",
      sections: [
        LessonSection(
          heading: 'Prendre des décisions',
          body:
              "Le mot-clé if permet d'exécuter du code seulement si une condition est "
              "vraie, et else pour le cas contraire.",
          codeExample:
              "if age >= 7:\n    print('Tu peux jouer !')\nelse:\n    print('Bientôt !')",
        ),
        LessonSection(
          heading: 'Répéter une action',
          body:
              "Une boucle for répète une action pour chaque élément d'une liste, ou un "
              "certain nombre de fois avec range().",
          codeExample: "for i in range(3):\n    print('Coucou', i)",
        ),
      ],
      recap:
          "À retenir : if/else fait des choix, et les boucles évitent de répéter le "
          "même code plusieurs fois.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            'Quel mot-clé exécute du code seulement si une condition est fausse ?',
        options: ['if', 'else', 'for', 'while'],
        correctIndex: 1,
        explanation: "else s'exécute quand la condition du if n'est pas vraie.",
      ),
      QuizQuestion(
        prompt: 'Que fait range(3) dans une boucle for ?',
        options: [
          'Il répète 3 fois',
          'Il crée une liste de texte',
          'Il arrête le programme',
          'Il crée une variable',
        ],
        correctIndex: 0,
        explanation:
            "range(3) donne les nombres 0, 1, 2 : la boucle s'exécute donc 3 fois.",
      ),
    ],
  ),
  Module(
    id: 'python-3',
    path: LearningPath.python,
    order: 3,
    title: 'Fonctions',
    description: 'Range des bouts de code réutilisables dans des fonctions.',
    prerequisiteIds: const ['python-2'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          "Une fonction est un bloc de code auquel on donne un nom, pour pouvoir "
          "l'utiliser plusieurs fois sans le recopier.",
      sections: [
        LessonSection(
          heading: 'Pourquoi des fonctions ?',
          body:
              "Dès qu'on répète la même idée à plusieurs endroits, on peut la transformer "
              "en fonction : le code devient plus court et plus facile à corriger.",
        ),
        LessonSection(
          heading: 'Créer sa première fonction',
          body:
              "On définit une fonction avec def, un nom, et des parenthèses. Elle peut "
              "recevoir des informations (paramètres) et en renvoyer une (return).",
          codeExample:
              "def double(nombre):\n    return nombre * 2\n\nprint(double(4))",
        ),
      ],
      recap:
          "À retenir : une fonction se définit une fois avec def, puis s'utilise "
          "(s'appelle) autant de fois que nécessaire.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel mot-clé sert à définir une fonction en Python ?',
        options: ['func', 'def', 'function', 'fn'],
        correctIndex: 1,
        explanation: 'On utilise def suivi du nom de la fonction.',
      ),
      QuizQuestion(
        prompt: 'Que fait return dans une fonction ?',
        options: [
          'Elle arrête tout le programme',
          "Elle renvoie une valeur au code qui a appelé la fonction",
          'Elle affiche une erreur',
          'Elle crée une boucle',
        ],
        correctIndex: 1,
        explanation:
            'return renvoie un résultat que l\'on peut ensuite utiliser.',
      ),
    ],
  ),
  Module(
    id: 'python-4',
    path: LearningPath.python,
    order: 4,
    title: 'Listes et dictionnaires',
    description:
        'Range plusieurs valeurs ensemble et associe des informations.',
    prerequisiteIds: const ['python-3'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          "Pour ranger plusieurs valeurs à la fois, Python propose deux outils très "
          "utilisés : les listes et les dictionnaires.",
      sections: [
        LessonSection(
          heading: 'Ranger plusieurs valeurs',
          body:
              "Une liste range des valeurs dans l'ordre, entre crochets. On accède à un "
              "élément grâce à sa position (en commençant à 0).",
          codeExample: "fruits = ['pomme', 'banane', 'kiwi']\nprint(fruits[0])",
        ),
        LessonSection(
          heading: 'Associer des informations',
          body:
              "Un dictionnaire associe une clé à une valeur, entre accolades — pratique "
              "pour décrire un objet, comme un joueur avec son pseudo et son score.",
          codeExample:
              "joueur = {'pseudo': 'Léo', 'score': 12}\nprint(joueur['pseudo'])",
        ),
      ],
      recap:
          "À retenir : une liste garde un ordre, un dictionnaire associe des clés à "
          "des valeurs.",
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Comment accède-t-on au premier élément d\'une liste fruits ?',
        options: ['fruits[0]', 'fruits[1]', 'fruits.first', 'fruits(0)'],
        correctIndex: 0,
        explanation: 'En Python, les listes commencent à l\'index 0.',
      ),
      QuizQuestion(
        prompt:
            "Comment récupère-t-on la valeur associée à la clé 'pseudo' dans un "
            'dictionnaire joueur ?',
        options: [
          'joueur.pseudo',
          "joueur['pseudo']",
          'joueur(pseudo)',
          'joueur->pseudo',
        ],
        correctIndex: 1,
        explanation:
            "On utilise des crochets avec la clé entre guillemets : joueur['pseudo'].",
      ),
    ],
  ),
  Module(
    id: 'python-5',
    path: LearningPath.python,
    order: 5,
    title: 'Projet Python',
    description: 'Écris un petit programme qui combine tout ce que tu as vu.',
    prerequisiteIds: const ['python-4'],
    languages: const [LessonLanguage.python],
    lesson: const Lesson(
      intro:
          "Place à la pratique ! Ce module te propose d'écrire un petit programme (par "
          "exemple un quiz ou un carnet de scores) en combinant variables, conditions, "
          "boucles, fonctions et listes.",
      sections: [
        LessonSection(
          heading: 'Assembler les briques',
          body:
              "Découpe ton idée en petites étapes : d'abord stocker les données, puis "
              "écrire une fonction pour chaque action, enfin les relier avec des boucles "
              "et des conditions.",
        ),
        LessonSection(
          heading: 'Aller plus loin',
          body:
              "Une fois ton programme Python terminé, tu pourras le montrer dans ton "
              "portfolio personnel (une fonctionnalité qui arrive bientôt !).",
        ),
      ],
      recap:
          "À retenir : un vrai programme, c'est juste plusieurs petites briques "
          "(variables, fonctions, boucles) assemblées ensemble.",
    ),
    quiz: const [
      QuizQuestion(
        prompt:
            'Quelle est la première étape pour écrire un programme un peu complexe ?',
        options: [
          "Écrire tout le code d'un coup",
          'Découper le problème en petites étapes',
          'Ne jamais utiliser de fonctions',
          'Copier un programme existant',
        ],
        correctIndex: 1,
        explanation:
            'Découper un problème en petites étapes rend le code plus facile à écrire '
            'et à corriger.',
      ),
      QuizQuestion(
        prompt: 'Que peux-tu faire avec un programme Python terminé ?',
        options: [
          'Rien, il faut le supprimer',
          'Le montrer dans ton portfolio personnel',
          'Il ne peut pas être sauvegardé',
          'Le transformer en site HTML automatiquement',
        ],
        correctIndex: 1,
        explanation:
            'Une prochaine fonctionnalité te permettra de publier tes projets dans un '
            'portfolio.',
      ),
    ],
  ),
  ...advancedModules(
    path: LearningPath.python,
    idPrefix: 'python',
    firstOrder: 6,
    firstPrerequisite: 'python-5',
    courses: [
      ...pythonAdvancedCourses,
      ...ultraAdvancedCoursesFor(LearningPath.python),
      ...masteryCoursesFor(LearningPath.python),
    ],
  ),
];
