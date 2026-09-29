import '../learning_path.dart';
import '../lesson.dart';
import '../lesson_language.dart';
import '../module.dart';
import '../quiz_question.dart';

/// Les extensions « expert » des parcours. Elles gardent une progression
/// linéaire : chaque défi débloque le suivant, sans changer la progression
/// déjà enregistrée pour les modules existants.
List<Module> advancedModules({
  required LearningPath path,
  required String idPrefix,
  required int firstOrder,
  required String firstPrerequisite,
  required List<AdvancedCourse> courses,
}) {
  return [
    for (var index = 0; index < courses.length; index++)
      Module(
        id: '$idPrefix-${firstOrder + index}',
        path: path,
        order: firstOrder + index,
        title: courses[index].title,
        description: courses[index].description,
        prerequisiteIds: [
          index == 0
              ? firstPrerequisite
              : '$idPrefix-${firstOrder + index - 1}',
        ],
        languages: courses[index].languages,
        lesson: Lesson(
          intro: courses[index].intro,
          sections: [
            LessonSection(
              heading: 'Penser comme un·e ingénieur·e',
              body: courses[index].principle,
              codeExample: courses[index].example,
            ),
            LessonSection(
              heading: 'Méthode de pro',
              body: courses[index].practice,
            ),
            LessonSection(
              heading: 'Défi expert',
              body:
                  'Avant de livrer, écris une hypothèse, mesure le résultat et note ce que tu améliorerais. C’est ainsi que les équipes rendent un système fiable, pas seulement impressionnant.',
            ),
          ],
          recap: courses[index].recap,
        ),
        quiz: [
          QuizQuestion(
            prompt: courses[index].question,
            options: courses[index].options,
            correctIndex: courses[index].correctIndex,
            explanation: courses[index].explanation,
          ),
          QuizQuestion(
            prompt: 'Quelle habitude rend un projet avancé plus robuste ?',
            options: const [
              'Mesurer, tester et améliorer progressivement',
              'Ajouter des fonctions sans les vérifier',
              'Tout modifier en production en une fois',
              'Cacher les erreurs plutôt que les analyser',
            ],
            correctIndex: 0,
            explanation:
                'Les tests, les mesures et de petits changements réversibles permettent de détecter les problèmes tôt.',
          ),
        ],
      ),
  ];
}

/// Le contenu est volontairement précis par spécialité, tandis que le format
/// pédagogique reste le même pour que l’application puisse l’afficher partout.
class AdvancedCourse {
  const AdvancedCourse({
    required this.title,
    required this.description,
    required this.languages,
    required this.intro,
    required this.principle,
    required this.practice,
    required this.recap,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.example,
  });

  final String title, description, intro, principle, practice, recap;
  final List<LessonLanguage> languages;
  final String question, explanation;
  final List<String> options;
  final int correctIndex;
  final String? example;
}

final frontEndAdvancedCourses = [
  const AdvancedCourse(
    title: 'Architecture front-end à grande échelle',
    description:
        'Organise une interface complexe en composants, états et frontières claires.',
    languages: [LessonLanguage.typescript, LessonLanguage.javascript],
    intro:
        'Une grande application doit rester facile à modifier même lorsque plusieurs personnes y travaillent.',
    principle:
        'Sépare les composants de présentation, la logique métier et les accès réseau. Chaque partie doit avoir une responsabilité observable.',
    practice:
        'Dessine les flux de données d’un tableau de bord puis isole un composant réutilisable avant de coder.',
    recap:
        'Une architecture front-end solide réduit les effets de bord et rend les évolutions prévisibles.',
    question: 'Pourquoi séparer la logique métier des composants visuels ?',
    options: [
      'Pour tester et faire évoluer chaque partie indépendamment',
      'Pour supprimer TypeScript',
      'Pour éviter tous les états',
      'Pour rendre les fichiers plus longs',
    ],
    correctIndex: 0,
    explanation:
        'Des responsabilités séparées se testent et se modifient sans casser l’affichage.',
  ),
  const AdvancedCourse(
    title: 'Performance web et rendu',
    description:
        'Mesure et accélère le chargement, le rendu et les interactions.',
    languages: [LessonLanguage.javascript, LessonLanguage.css],
    intro:
        'La performance est une fonctionnalité : une page lente exclut des utilisateurs.',
    principle:
        'Mesure d’abord les vraies interactions et le temps de rendu. Réduis le JavaScript critique, fractionne les ressources et évite les recalculs inutiles.',
    practice:
        'Compare une page avant et après chargement différé d’une zone non visible.',
    recap:
        'On améliore une expérience en partant de mesures, puis en optimisant le chemin critique.',
    question: 'Quelle étape vient avant une optimisation ?',
    options: [
      'Mesurer le problème réel',
      'Réécrire toute l’application',
      'Ajouter une animation',
      'Minifier au hasard',
    ],
    correctIndex: 0,
    explanation:
        'Une mesure évite d’optimiser une zone qui n’est pas la cause du ralentissement.',
  ),
  const AdvancedCourse(
    title: 'Accessibilité avancée et design system',
    description:
        'Construis des composants inclusifs, cohérents et utilisables au clavier.',
    languages: [LessonLanguage.html, LessonLanguage.css],
    intro:
        'Un design system mature sert aussi les personnes qui naviguent au clavier, avec un lecteur d’écran ou sur petit écran.',
    principle:
        'Utilise le HTML sémantique avant ARIA, rends le focus visible et définis des contrastes testables dans les jetons de design.',
    practice:
        'Teste un formulaire sans souris et vérifie que chaque champ possède un libellé clair.',
    recap:
        'L’accessibilité intégrée aux composants évite de réparer l’interface écran par écran.',
    question: 'Quel choix est prioritaire pour un bouton ?',
    options: [
      'Utiliser un vrai élément button avec un nom clair',
      'Créer une div cliquable sans clavier',
      'Masquer le focus',
      'Utiliser uniquement une couleur',
    ],
    correctIndex: 0,
    explanation:
        'Le bouton natif apporte déjà la sémantique, le clavier et des comportements attendus.',
  ),
];

final pythonAdvancedCourses = [
  const AdvancedCourse(
    title: 'Concurrence et asynchronisme Python',
    description: 'Orchestre des tâches I/O sans bloquer ton programme.',
    languages: [LessonLanguage.python],
    intro:
        'Les programmes avancés attendent souvent un réseau, un fichier ou une base de données.',
    principle:
        'asyncio permet de suspendre une tâche pendant une attente afin qu’une autre puisse progresser. Il ne rend pas automatiquement le calcul lourd plus rapide.',
    practice:
        'Lance plusieurs requêtes simulées puis observe que leur attente peut se chevaucher.',
    recap:
        'Choisis l’asynchronisme pour les attentes I/O et mesure toujours le gain.',
    question: 'À quoi sert surtout asyncio ?',
    options: [
      'Gérer efficacement des attentes I/O concurrentes',
      'Rendre tout calcul instantané',
      'Supprimer les exceptions',
      'Éviter les tests',
    ],
    correctIndex: 0,
    explanation:
        'Pendant une attente I/O, la boucle peut laisser une autre coroutine avancer.',
  ),
  const AdvancedCourse(
    title: 'Qualité, types et tests Python',
    description: 'Sécurise un programme avec annotations, tests et propriétés.',
    languages: [LessonLanguage.python],
    intro:
        'Les projets durables rendent leurs contrats explicites et vérifiables.',
    principle:
        'Les annotations documentent les valeurs attendues ; des tests unitaires et d’intégration protègent ensuite les comportements importants.',
    practice:
        'Écris un test de cas limite avant de corriger un bug, puis exécute toute la suite.',
    recap:
        'Les types et les tests transforment une intuition en contrat contrôlé.',
    question: 'Que protège le mieux un test de régression ?',
    options: [
      'Un bug déjà corrigé qui pourrait revenir',
      'La couleur de l’éditeur',
      'Le nom du projet',
      'La vitesse du clavier',
    ],
    correctIndex: 0,
    explanation:
        'Un test ajouté après un bug empêche ce scénario de repasser inaperçu.',
  ),
  const AdvancedCourse(
    title: 'Architecture Python et événements',
    description: 'Découpe un système en domaines, adaptateurs et événements.',
    languages: [LessonLanguage.python],
    intro:
        'Quand le code grandit, les dépendances directes rendent les changements risqués.',
    principle:
        'Le cœur métier ne doit pas dépendre d’un écran ou d’une base précise. Des adaptateurs relient ces détails au domaine.',
    practice:
        'Modélise une commande et un événement métier, puis écris un adaptateur de stockage factice pour le test.',
    recap:
        'Une architecture par frontières garde le métier testable et les détails remplaçables.',
    question: 'Pourquoi utiliser un adaptateur de stockage ?',
    options: [
      'Pour isoler le métier de la technologie de stockage',
      'Pour éviter les données',
      'Pour supprimer les classes',
      'Pour remplacer toutes les fonctions',
    ],
    correctIndex: 0,
    explanation:
        'Le métier peut alors être testé sans dépendre d’une base réelle.',
  ),
];

final gameAdvancedCourses = [
  const AdvancedCourse(
    title: 'Moteur de jeu et boucle temps réel',
    description:
        'Stabilise une simulation avec delta time, états et interpolation.',
    languages: [LessonLanguage.javascript],
    intro:
        'Un jeu doit rester cohérent sur des appareils aux vitesses très différentes.',
    principle:
        'Sépare mise à jour de simulation et rendu ; utilise le temps écoulé avec prudence pour que les déplacements ne dépendent pas du nombre d’images.',
    practice:
        'Teste un déplacement à 30 et 120 images par seconde puis compare la distance.',
    recap:
        'Une boucle maîtrisée garantit une simulation plus juste et plus fluide.',
    question: 'Pourquoi utiliser le temps écoulé dans une boucle de jeu ?',
    options: [
      'Pour rendre le mouvement indépendant de la fréquence d’images',
      'Pour dessiner plus de sprites',
      'Pour supprimer les collisions',
      'Pour éviter les sons',
    ],
    correctIndex: 0,
    explanation:
        'Le delta time adapte la mise à jour au temps réellement passé.',
  ),
  const AdvancedCourse(
    title: 'IA de jeu et comportement',
    description:
        'Crée des ennemis lisibles avec machines à états et navigation.',
    languages: [LessonLanguage.javascript],
    intro:
        'Une bonne IA de jeu est prévisible pour le joueur, mais pas monotone.',
    principle:
        'Une machine à états encode des intentions simples : patrouiller, poursuivre, chercher. Les transitions doivent avoir des conditions explicites.',
    practice:
        'Écris les transitions d’un gardien avant de choisir ses animations.',
    recap:
        'Des états clairs rendent l’IA plus facile à équilibrer et déboguer.',
    question: 'Quel avantage apporte une machine à états ?',
    options: [
      'Des comportements et transitions explicites',
      'Des graphismes automatiques',
      'Un réseau plus rapide',
      'Moins de règles de jeu',
    ],
    correctIndex: 0,
    explanation:
        'Chaque état décrit une intention et les règles expliquent quand la quitter.',
  ),
  const AdvancedCourse(
    title: 'Jeu en ligne et synchronisation',
    description:
        'Comprends autorité serveur, prédiction et résolution des conflits.',
    languages: [LessonLanguage.javascript],
    intro:
        'En multijoueur, les joueurs ne voient jamais exactement le même réseau au même instant.',
    principle:
        'Le serveur autoritaire valide l’état important. Le client peut prédire localement puis se réconcilier avec la réponse du serveur.',
    practice:
        'Liste les actions à valider côté serveur, comme un score ou une collision compétitive.',
    recap:
        'L’autorité serveur limite la triche et garde une source de vérité partagée.',
    question: 'Qui doit valider un score compétitif ?',
    options: [
      'Le serveur autoritaire',
      'Uniquement le navigateur du joueur',
      'Le dernier joueur connecté',
      'Un fichier CSS',
    ],
    correctIndex: 0,
    explanation:
        'Le serveur est plus difficile à modifier par un client malveillant.',
  ),
];

final mobileAdvancedCourses = [
  const AdvancedCourse(
    title: 'Architecture Flutter évolutive',
    description:
        'Isole présentation, état, domaine et données dans une application mobile.',
    languages: [LessonLanguage.dart],
    intro:
        'Une application mobile complexe doit survivre aux nouvelles fonctionnalités.',
    principle:
        'Le domaine exprime les règles métier ; les couches externes fournissent API et stockage. L’interface observe un état prévisible.',
    practice:
        'Remplace un dépôt réseau par un faux dépôt dans un test de logique.',
    recap:
        'Des frontières nettes facilitent les tests et le remplacement des détails techniques.',
    question: 'Pourquoi isoler le domaine ?',
    options: [
      'Pour tester les règles sans dépendre de l’interface ou du réseau',
      'Pour enlever les modèles',
      'Pour éviter Dart',
      'Pour doubler les écrans',
    ],
    correctIndex: 0,
    explanation:
        'Le domaine reste utilisable même si l’API ou l’interface change.',
  ),
  const AdvancedCourse(
    title: 'Rendu, mémoire et fluidité mobile',
    description:
        'Diagnostique les jank, reconstructions et fuites de ressources.',
    languages: [LessonLanguage.dart],
    intro:
        'Sur mobile, chaque image doit être produite dans un budget très court.',
    principle:
        'Profile les images lentes, limite les reconstructions inutiles et libère contrôleurs ou abonnements au bon moment.',
    practice:
        'Repère un widget qui se reconstruit trop largement puis découpe son état.',
    recap:
        'La fluidité se gagne avec un profilage réel et un cycle de vie soigné.',
    question: 'Que faut-il faire avec un contrôleur devenu inutile ?',
    options: [
      'Le libérer dans le cycle de vie approprié',
      'Le garder pour toujours',
      'Le mettre dans un widget statique',
      'Le convertir en image',
    ],
    correctIndex: 0,
    explanation:
        'Libérer les ressources évite les fuites mémoire et les comportements persistants.',
  ),
  const AdvancedCourse(
    title: 'Mobile hors-ligne et synchronisation',
    description:
        'Conçois des données locales fiables malgré un réseau instable.',
    languages: [LessonLanguage.dart, LessonLanguage.sql],
    intro: 'Le réseau mobile peut disparaître au milieu d’une action.',
    principle:
        'Écris d’abord localement, conserve les opérations à synchroniser et traite les conflits avec une règle métier explicite.',
    practice:
        'Simule deux modifications hors-ligne d’un même profil et décide comment les réconcilier.',
    recap:
        'Le hors-ligne demande une source locale et une stratégie de conflit visible.',
    question: 'Quel principe améliore une expérience hors-ligne ?',
    options: [
      'Enregistrer localement puis synchroniser',
      'Bloquer toute action sans réseau',
      'Effacer les changements locaux',
      'Ignorer les conflits',
    ],
    correctIndex: 0,
    explanation:
        'L’utilisateur peut continuer, et le système synchronise dès que possible.',
  ),
];

final fullStackAdvancedCourses = [
  const AdvancedCourse(
    title: 'Contrats API et versionnement',
    description: 'Fais évoluer une API sans casser les applications clientes.',
    languages: [LessonLanguage.typescript, LessonLanguage.javascript],
    intro: 'Une API est un contrat partagé par plusieurs équipes.',
    principle:
        'Documente les entrées, sorties et erreurs ; ajoute des champs compatibles et versionne les ruptures nécessaires.',
    practice:
        'Écris un exemple de réponse et un test de contrat pour un client existant.',
    recap:
        'Un contrat explicite permet aux services et interfaces d’évoluer ensemble.',
    question: 'Pourquoi tester un contrat API ?',
    options: [
      'Pour détecter une rupture entre serveur et client',
      'Pour accélérer le CSS',
      'Pour éviter les bases de données',
      'Pour remplacer l’authentification',
    ],
    correctIndex: 0,
    explanation:
        'Le test vérifie que les formes de données attendues restent compatibles.',
  ),
  const AdvancedCourse(
    title: 'Sécurité full-stack',
    description: 'Protège sessions, entrées, secrets et autorisations.',
    languages: [LessonLanguage.javascript, LessonLanguage.sql],
    intro:
        'Chaque donnée venant d’un utilisateur doit être considérée comme non fiable.',
    principle:
        'Valide côté serveur, applique le moindre privilège, protège les secrets et vérifie une autorisation pour chaque action sensible.',
    practice:
        'Pour une route de profil, distingue clairement authentification et droit de modification.',
    recap:
        'La sécurité est un ensemble de contrôles superposés, pas un unique bouton.',
    question: 'Que vérifie une autorisation ?',
    options: [
      'Si la personne a le droit de faire cette action',
      'Si la page est jolie',
      'Si le mot de passe est long',
      'Si le navigateur est récent',
    ],
    correctIndex: 0,
    explanation:
        'Être identifié ne donne pas automatiquement le droit de tout modifier.',
  ),
  const AdvancedCourse(
    title: 'Observabilité et fiabilité',
    description:
        'Utilise journaux, métriques et traces pour résoudre un incident.',
    languages: [LessonLanguage.typescript, LessonLanguage.javascript],
    intro: 'Un système distribué doit expliquer ce qui se passe en production.',
    principle:
        'Les logs donnent le contexte, les métriques montrent les tendances et les traces suivent une requête entre services.',
    practice:
        'Définis un indicateur de succès utilisateur et une alerte liée à un seuil utile.',
    recap:
        'Observer un système permet de corriger un incident à partir de preuves.',
    question: 'Que montre le mieux une tendance de taux d’erreur ?',
    options: [
      'Une métrique dans le temps',
      'Un nom de variable',
      'Une maquette',
      'Un commit isolé',
    ],
    correctIndex: 0,
    explanation:
        'Les métriques agrégées révèlent l’évolution d’un comportement à grande échelle.',
  ),
];

final backendAdvancedCourses = [
  const AdvancedCourse(
    title: 'Conception de bases de données distribuées',
    description:
        'Choisis cohérence, partitionnement et réplication selon le besoin.',
    languages: [LessonLanguage.sql],
    intro:
        'À grande échelle, une donnée peut être copiée et lue depuis plusieurs machines.',
    principle:
        'Un choix de cohérence est un choix produit : certaines données tolèrent un léger retard, d’autres exigent une validation stricte.',
    practice:
        'Classe un compteur de vues et un solde de paiement selon leur exigence de cohérence.',
    recap:
        'Le modèle de données doit refléter la valeur et le risque de chaque information.',
    question: 'Quelle donnée exige généralement une cohérence forte ?',
    options: [
      'Un solde de paiement',
      'Une couleur de thème',
      'Un compteur de vues approximatif',
      'Une icône',
    ],
    correctIndex: 0,
    explanation:
        'Une erreur de solde peut avoir une conséquence financière réelle.',
  ),
  const AdvancedCourse(
    title: 'Systèmes événementiels et files',
    description:
        'Découple les services avec événements, reprises et idempotence.',
    languages: [LessonLanguage.python, LessonLanguage.javascript],
    intro:
        'Les files permettent d’absorber des pics et de traiter des tâches plus tard.',
    principle:
        'Un consommateur doit pouvoir recevoir deux fois le même événement sans créer deux effets. Prévois des reprises et une zone pour les messages en échec.',
    practice:
        'Conçois un identifiant d’opération pour empêcher une facturation en double.',
    recap: 'L’idempotence rend les reprises sûres dans un réseau imparfait.',
    question: 'Que garantit une opération idempotente ?',
    options: [
      'La répéter produit le même effet final',
      'Elle ne peut jamais échouer',
      'Elle est toujours instantanée',
      'Elle ne contient aucune donnée',
    ],
    correctIndex: 0,
    explanation:
        'C’est essentiel lorsque les messages peuvent être livrés plusieurs fois.',
  ),
  const AdvancedCourse(
    title: 'Résilience et ingénierie du chaos',
    description:
        'Prépare les services aux pannes, délais et dépendances indisponibles.',
    languages: [LessonLanguage.python, LessonLanguage.javascript],
    intro: 'Les pannes réseau et services lents font partie de la réalité.',
    principle:
        'Utilise délais d’expiration, limites de tentatives et coupe-circuits. Teste les scénarios de panne en environnement contrôlé.',
    practice:
        'Définis ce que ton service renvoie si une dépendance dépasse son délai.',
    recap:
        'La résilience consiste à échouer de manière contrôlée et récupérable.',
    question: 'Pourquoi définir un délai d’expiration ?',
    options: [
      'Pour éviter d’attendre une dépendance indéfiniment',
      'Pour supprimer les erreurs',
      'Pour chiffrer les bases',
      'Pour créer une nouvelle route',
    ],
    correctIndex: 0,
    explanation:
        'Un timeout libère les ressources et permet une réponse ou une reprise contrôlée.',
  ),
];

final collaborationAdvancedCourses = [
  const AdvancedCourse(
    title: 'Revue de code experte',
    description:
        'Transforme la revue en outil de qualité, de sécurité et d’apprentissage.',
    languages: [LessonLanguage.git],
    intro:
        'Une revue utile cherche à améliorer le système, pas à juger une personne.',
    principle:
        'Commence par les risques : comportement, tests, sécurité et lisibilité. Des changements petits et contextualisés reçoivent de meilleurs retours.',
    practice:
        'Écris un commentaire qui explique le risque puis propose une question ou une alternative concrète.',
    recap:
        'Une bonne revue est précise, respectueuse et centrée sur le changement.',
    question: 'Quel commentaire de revue est le plus utile ?',
    options: [
      'Expliquer le risque et proposer une piste concrète',
      'Dire seulement « mauvais »',
      'Commenter la personne',
      'Approuver sans lire',
    ],
    correctIndex: 0,
    explanation:
        'Un retour actionnable aide à améliorer le code et à partager les connaissances.',
  ),
  const AdvancedCourse(
    title: 'Livraison continue et déploiement sûr',
    description:
        'Déploie progressivement avec canaris, bascules et retour arrière.',
    languages: [LessonLanguage.git],
    intro:
        'Livrer vite est utile seulement si un problème peut être détecté et annulé rapidement.',
    principle:
        'Automatise les contrôles, expose une version à peu d’utilisateurs puis surveille les indicateurs avant d’élargir le déploiement.',
    practice:
        'Prépare un plan de retour arrière avant de lancer une fonctionnalité risquée.',
    recap: 'Un déploiement progressif réduit le rayon d’impact d’une erreur.',
    question: 'Quel est le but d’un déploiement canari ?',
    options: [
      'Tester une version sur un petit groupe avant généralisation',
      'Supprimer les tests',
      'Publier sans surveillance',
      'Remplacer Git',
    ],
    correctIndex: 0,
    explanation:
        'Un petit périmètre permet de détecter un problème avec moins d’utilisateurs touchés.',
  ),
  const AdvancedCourse(
    title: 'Décisions techniques et gouvernance',
    description:
        'Documente les compromis et aligne une équipe sur les choix durables.',
    languages: [LessonLanguage.git, LessonLanguage.typescript],
    intro:
        'Les décisions importantes doivent rester compréhensibles après le départ des personnes qui les ont prises.',
    principle:
        'Un ADR décrit le contexte, les options, la décision et ses conséquences. Il rend les compromis discutables et révisables.',
    practice:
        'Rédige un ADR court pour comparer deux solutions de stockage avec leurs coûts et risques.',
    recap:
        'La documentation des décisions crée une mémoire technique partagée.',
    question: 'Que doit contenir un ADR ?',
    options: [
      'Le contexte, les options, la décision et ses conséquences',
      'Seulement le nom du développeur',
      'Un dessin sans texte',
      'Toutes les lignes de code',
    ],
    correctIndex: 0,
    explanation:
        'Ces éléments permettent de comprendre et réévaluer le choix plus tard.',
  ),
];
