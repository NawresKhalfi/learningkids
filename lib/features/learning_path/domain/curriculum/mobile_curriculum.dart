import 'advanced_curriculum.dart';
import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// A first mobile-development journey: Dart basics, then Flutter widgets,
/// layout, interactions and a small phone app.
final List<Module> mobileCurriculum = [
  Module(
    id: 'mobile-1',
    path: LearningPath.mobile,
    order: 1,
    title: 'Découvrir Dart',
    description: 'Apprends le langage qui permet de créer des apps Flutter.',
    prerequisiteIds: const [],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Dart est le langage utilisé par Flutter. Il permet de donner des instructions claires à une application.',
      sections: [
        LessonSection(
          heading: 'Des variables',
          body:
              'Une variable est une boîte qui porte un nom et contient une valeur.',
          codeExample: "String prenom = 'Zara';\nint score = 10;",
        ),
        LessonSection(
          heading: 'Des fonctions',
          body:
              'Une fonction regroupe une action que le programme peut lancer.',
          codeExample: "void direBonjour() {\n  print('Bonjour !');\n}",
        ),
      ],
      recap:
          'À retenir : Dart sert à décrire les données et les actions de ton application.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel langage utilise Flutter ?',
        options: ['Dart', 'HTML', 'SQL', 'Scratch'],
        correctIndex: 0,
        explanation: 'Flutter utilise le langage Dart.',
      ),
      QuizQuestion(
        prompt: 'À quoi sert une variable ?',
        options: [
          'À stocker une valeur',
          'À dessiner une icône',
          'À installer une app',
          'À effacer du code',
        ],
        correctIndex: 0,
        explanation: 'Une variable garde une information avec un nom.',
      ),
    ],
  ),
  Module(
    id: 'mobile-2',
    path: LearningPath.mobile,
    order: 2,
    title: 'Les widgets Flutter',
    description: 'Compose l’écran de ton application avec des widgets.',
    prerequisiteIds: const ['mobile-1'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Dans Flutter, chaque élément visible est un widget : texte, image, bouton ou écran entier.',
      sections: [
        LessonSection(
          heading: 'Un texte',
          body: 'Le widget Text affiche des mots sur l’écran.',
          codeExample: "const Text('Bienvenue !')",
        ),
        LessonSection(
          heading: 'Un écran',
          body:
              'Scaffold fournit la structure de base d’un écran avec une zone de contenu.',
          codeExample:
              'Scaffold(\n  body: Center(child: Text(\'Mon app\')),\n)',
        ),
      ],
      recap:
          'À retenir : une application Flutter est un arbre de widgets emboîtés.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Qu’est-ce qu’un widget Flutter ?',
        options: [
          'Un élément de l’interface',
          'Un mot de passe',
          'Un navigateur',
          'Une base de données',
        ],
        correctIndex: 0,
        explanation: 'Les widgets constituent l’interface de l’application.',
      ),
      QuizQuestion(
        prompt: 'Quel widget affiche du texte ?',
        options: ['Text', 'Button', 'Image', 'Color'],
        correctIndex: 0,
        explanation: 'Text est le widget prévu pour afficher du texte.',
      ),
    ],
  ),
  Module(
    id: 'mobile-3',
    path: LearningPath.mobile,
    order: 3,
    title: 'Organiser un écran',
    description:
        'Place les éléments de ton app avec des lignes et des colonnes.',
    prerequisiteIds: const ['mobile-2'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Une bonne interface est facile à lire. Flutter aide à positionner chaque widget proprement.',
      sections: [
        LessonSection(
          heading: 'Verticalement',
          body: 'Column place ses enfants les uns sous les autres.',
          codeExample: "Column(children: [Text('Titre'), Text('Message')])",
        ),
        LessonSection(
          heading: 'Horizontalement',
          body:
              'Row place ses enfants côte à côte, par exemple pour une icône et un texte.',
          codeExample: "Row(children: [Icon(Icons.star), Text('Bravo')])",
        ),
      ],
      recap:
          'À retenir : Column organise verticalement et Row organise horizontalement.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel widget aligne des éléments verticalement ?',
        options: ['Column', 'Row', 'Text', 'Icon'],
        correctIndex: 0,
        explanation: 'Column crée une colonne d’éléments.',
      ),
      QuizQuestion(
        prompt: 'Quel widget aligne une icône et un texte côte à côte ?',
        options: ['Row', 'Column', 'Scaffold', 'Center'],
        correctIndex: 0,
        explanation: 'Row organise ses enfants sur une même ligne.',
      ),
    ],
  ),
  Module(
    id: 'mobile-4',
    path: LearningPath.mobile,
    order: 4,
    title: 'Réagir à un appui',
    description: 'Ajoute un bouton qui déclenche une action.',
    prerequisiteIds: const ['mobile-3'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Une application devient utile quand elle réagit aux gestes de la personne qui l’utilise.',
      sections: [
        LessonSection(
          heading: 'Le bouton',
          body:
              'ElevatedButton crée un bouton et onPressed indique ce qui se passe au toucher.',
          codeExample:
              "ElevatedButton(\n  onPressed: () => print('Tap !'),\n  child: Text('Jouer'),\n)",
        ),
        LessonSection(
          heading: 'Changer l’écran',
          body:
              'L’état conserve une information qui peut changer, comme un compteur de points.',
          codeExample: 'setState(() {\n  score++;\n});',
        ),
      ],
      recap:
          'À retenir : onPressed relie un appui à une action, et setState met l’écran à jour.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quelle propriété reçoit l’action d’un bouton ?',
        options: ['onPressed', 'child', 'color', 'title'],
        correctIndex: 0,
        explanation: 'onPressed est appelée lorsque le bouton est touché.',
      ),
      QuizQuestion(
        prompt: 'Pourquoi utiliser setState ?',
        options: [
          'Pour rafraîchir l’interface après un changement',
          'Pour fermer l’app',
          'Pour installer Flutter',
          'Pour créer un mot de passe',
        ],
        correctIndex: 0,
        explanation:
            'setState indique à Flutter que l’écran doit être redessiné.',
      ),
    ],
  ),
  Module(
    id: 'mobile-5',
    path: LearningPath.mobile,
    order: 5,
    title: 'Projet : mon mini compteur',
    description:
        'Assemble une petite application mobile qui compte les points.',
    prerequisiteIds: const ['mobile-4'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Tu as maintenant toutes les briques pour créer un premier écran interactif sur téléphone.',
      sections: [
        LessonSection(
          heading: 'Construire',
          body:
              'Place un titre, le nombre de points et un bouton dans une Column.',
        ),
        LessonSection(
          heading: 'Tester',
          body:
              'Appuie plusieurs fois sur le bouton et vérifie que le nombre affiché augmente.',
        ),
      ],
      recap:
          'Bravo : tu sais créer l’interface et la première interaction d’une application Flutter.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel ensemble forme une mini app interactive ?',
        options: [
          'Widgets, état et action',
          'Uniquement une image',
          'Uniquement du HTML',
          'Un mot de passe',
        ],
        correctIndex: 0,
        explanation:
            'Les widgets affichent l’app, l’état garde les données et l’action les modifie.',
      ),
      QuizQuestion(
        prompt: 'Quel est le rôle du bouton du compteur ?',
        options: [
          'Augmenter le score',
          'Changer la langue Dart',
          'Supprimer Flutter',
          'Créer une base SQL',
        ],
        correctIndex: 0,
        explanation: 'Le bouton lance l’action qui augmente le score.',
      ),
    ],
  ),
  Module(
    id: 'mobile-6',
    path: LearningPath.mobile,
    order: 6,
    title: 'Naviguer entre les écrans',
    description: 'Passe de l’accueil à une nouvelle page de ton application.',
    prerequisiteIds: const ['mobile-5'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Une vraie application possède plusieurs écrans. Flutter peut les empiler et revenir en arrière.',
      sections: [
        LessonSection(
          heading: 'Ouvrir une page',
          body:
              'Navigator.push ajoute un nouvel écran au-dessus de celui qui est ouvert.',
          codeExample:
              "Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilPage()));",
        ),
        LessonSection(
          heading: 'Revenir',
          body:
              'Navigator.pop enlève la page actuelle et affiche la page précédente.',
          codeExample: 'Navigator.pop(context);',
        ),
      ],
      recap:
          'À retenir : push ouvre une page et pop permet de revenir à la précédente.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quelle méthode ouvre un nouvel écran ?',
        options: ['Navigator.push', 'Navigator.pop', 'setState', 'print'],
        correctIndex: 0,
        explanation: 'Navigator.push ajoute une nouvelle page à la navigation.',
      ),
      QuizQuestion(
        prompt: 'Que fait Navigator.pop ?',
        options: [
          'Revient à la page précédente',
          'Crée un bouton',
          'Augmente le score',
          'Télécharge une image',
        ],
        correctIndex: 0,
        explanation: 'pop ferme la page actuelle et révèle la précédente.',
      ),
    ],
  ),
  Module(
    id: 'mobile-7',
    path: LearningPath.mobile,
    order: 7,
    title: 'Saisir des informations',
    description: 'Crée un formulaire pour que la personne écrive dans ton app.',
    prerequisiteIds: const ['mobile-6'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Les formulaires permettent de demander un prénom, un message ou une réponse à la personne qui utilise l’app.',
      sections: [
        LessonSection(
          heading: 'Le champ de texte',
          body: 'TextField affiche une zone dans laquelle on peut écrire.',
          codeExample:
              "const TextField(decoration: InputDecoration(labelText: 'Ton prénom'));",
        ),
        LessonSection(
          heading: 'Vérifier avant d’envoyer',
          body:
              'Avant de continuer, vérifie que la réponse est bien présente et adaptée.',
          codeExample:
              "if (prenom.isNotEmpty) {\n  print('Bonjour \$prenom');\n}",
        ),
      ],
      recap:
          'À retenir : un formulaire recueille des informations et doit vérifier les réponses.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel widget permet d’écrire du texte ?',
        options: ['TextField', 'Text', 'Column', 'Icon'],
        correctIndex: 0,
        explanation: 'TextField crée un champ de saisie.',
      ),
      QuizQuestion(
        prompt: 'Pourquoi vérifier un formulaire ?',
        options: [
          'Pour éviter une réponse vide ou incorrecte',
          'Pour changer la couleur du téléphone',
          'Pour fermer l’app',
          'Pour créer une image',
        ],
        correctIndex: 0,
        explanation:
            'La vérification aide à obtenir une information utilisable.',
      ),
    ],
  ),
  Module(
    id: 'mobile-8',
    path: LearningPath.mobile,
    order: 8,
    title: 'Afficher une liste',
    description: 'Montre plusieurs éléments, comme des tâches ou des recettes.',
    prerequisiteIds: const ['mobile-7'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Les applications affichent souvent beaucoup d’éléments. Une liste les rend faciles à parcourir.',
      sections: [
        LessonSection(
          heading: 'Une liste défilante',
          body:
              'ListView construit une liste qui peut défiler quand il y a trop de contenu pour l’écran.',
          codeExample: "ListView(children: [Text('Lire'), Text('Jouer')])",
        ),
        LessonSection(
          heading: 'Répéter un modèle',
          body:
              'ListView.builder crée seulement les lignes visibles, ce qui reste rapide même avec une longue liste.',
          codeExample:
              'ListView.builder(itemCount: taches.length, itemBuilder: (_, i) => Text(taches[i]))',
        ),
      ],
      recap:
          'À retenir : ListView affiche une collection d’éléments que l’on peut faire défiler.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quel widget affiche une liste défilante ?',
        options: ['ListView', 'Row', 'Scaffold', 'TextField'],
        correctIndex: 0,
        explanation: 'ListView est conçu pour les listes qui défilent.',
      ),
      QuizQuestion(
        prompt: 'Pourquoi utiliser ListView.builder ?',
        options: [
          'Pour créer efficacement les éléments d’une longue liste',
          'Pour naviguer entre les pages',
          'Pour écrire un formulaire',
          'Pour changer une variable',
        ],
        correctIndex: 0,
        explanation: 'builder génère les lignes au besoin.',
      ),
    ],
  ),
  Module(
    id: 'mobile-9',
    path: LearningPath.mobile,
    order: 9,
    title: 'Utiliser des données du web',
    description:
        'Découvre comment une app demande des informations à un service.',
    prerequisiteIds: const ['mobile-8'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Une application peut demander des données, par exemple la météo ou une liste de défis, à une API sur Internet.',
      sections: [
        LessonSection(
          heading: 'Une API',
          body:
              'Une API est une porte organisée qui permet à deux programmes de s’échanger des informations.',
          codeExample:
              "final response = await http.get(Uri.parse('https://exemple.fr/defis'));",
        ),
        LessonSection(
          heading: 'Attendre la réponse',
          body:
              'Le mot await laisse le temps au réseau de répondre sans bloquer l’application.',
          codeExample: 'final reponse = await chargerDefis();',
        ),
      ],
      recap:
          'À retenir : une API fournit des données et await attend leur arrivée de façon fluide.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Qu’est-ce qu’une API ?',
        options: [
          'Un moyen pour des programmes d’échanger des données',
          'Une couleur Flutter',
          'Un type de bouton',
          'Un téléphone',
        ],
        correctIndex: 0,
        explanation: 'Une API organise la communication entre logiciels.',
      ),
      QuizQuestion(
        prompt: 'À quoi sert await ?',
        options: [
          'À attendre une opération asynchrone',
          'À dessiner une liste',
          'À supprimer une page',
          'À écrire un titre',
        ],
        correctIndex: 0,
        explanation: 'await attend la réponse sans figer l’interface.',
      ),
    ],
  ),
  Module(
    id: 'mobile-10',
    path: LearningPath.mobile,
    order: 10,
    title: 'Projet : ma liste de défis',
    description:
        'Crée une application avec une liste, un formulaire et plusieurs écrans.',
    prerequisiteIds: const ['mobile-9'],
    languages: const [LessonLanguage.dart],
    lesson: const Lesson(
      intro:
          'Pour ton projet final, réunis tout ce que tu as appris dans une application de défis personnels.',
      sections: [
        LessonSection(
          heading: 'Imaginer le parcours',
          body:
              'Prépare une page de liste, une page pour ajouter un défi et une page de détails.',
        ),
        LessonSection(
          heading: 'Construire puis tester',
          body:
              'Ajoute un défi, ouvre son détail, puis reviens à la liste pour vérifier que chaque écran fonctionne.',
        ),
      ],
      recap:
          'Bravo : tu sais maintenant concevoir une petite application mobile Flutter complète.',
    ),
    quiz: const [
      QuizQuestion(
        prompt: 'Quels éléments sont utiles pour une app de défis ?',
        options: [
          'Une liste, un formulaire et une navigation',
          'Seulement une image',
          'Seulement une base SQL',
          'Seulement un mot de passe',
        ],
        correctIndex: 0,
        explanation:
            'Ces trois éléments permettent de créer, afficher et consulter les défis.',
      ),
      QuizQuestion(
        prompt: 'Que faut-il faire après avoir construit une app ?',
        options: [
          'La tester avec plusieurs actions',
          'Supprimer tous les écrans',
          'Effacer les données',
          'Changer de langage',
        ],
        correctIndex: 0,
        explanation:
            'Les tests permettent de vérifier que le parcours de l’utilisateur fonctionne.',
      ),
    ],
  ),
  ...advancedModules(
    path: LearningPath.mobile,
    idPrefix: 'mobile',
    firstOrder: 11,
    firstPrerequisite: 'mobile-10',
    courses: [...mobileAdvancedCourses, ...ultraAdvancedCoursesFor(LearningPath.mobile)],
  ),
];
