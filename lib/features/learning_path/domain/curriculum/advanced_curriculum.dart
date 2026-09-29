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

/// Forme courte employée pour les cours expert supplémentaires. Chaque cours
/// conserve une vraie leçon, un exercice de réflexion et deux quiz dans
/// [advancedModules].
AdvancedCourse _expert(
  String title,
  String description,
  List<LessonLanguage> languages,
  String intro,
  String principle,
  String practice,
  String recap,
  String question,
  List<String> options,
  int correctIndex,
  String explanation,
) => AdvancedCourse(
  title: title,
  description: description,
  languages: languages,
  intro: intro,
  principle: principle,
  practice: practice,
  recap: recap,
  question: question,
  options: options,
  correctIndex: correctIndex,
  explanation: explanation,
);

/// Le dernier niveau de chaque parcours : sujets utilisés dans les équipes qui
/// opèrent des produits complexes. Les cours sont générés depuis des fiches
/// spécialisées afin de conserver la même expérience de lecture et de quiz.
List<AdvancedCourse> ultraAdvancedCoursesFor(
  LearningPath path,
) => switch (path) {
  LearningPath.frontEnd => [
    _ultra(
      'Micro-frontends et fédération de modules',
      'Compose plusieurs interfaces indépendantes sans perdre cohérence et performance.',
      [LessonLanguage.typescript, LessonLanguage.javascript],
      'Une fédération de modules charge une frontière applicative explicite plutôt qu’un assemblage implicite.',
      'Comment éviter que des micro-frontends deviennent ingérables ?',
      'Définir des contrats, une propriété claire et des dépendances limitées',
    ),
    _ultra(
      'Rendu côté serveur et hydratation sélective',
      'Choisis précisément ce qui doit être rendu sur le serveur ou activé dans le navigateur.',
      [LessonLanguage.javascript, LessonLanguage.html],
      'Le rendu hybride réduit le JavaScript envoyé lorsque les interactions sont localisées.',
      'Quel est le bénéfice d’une hydratation sélective ?',
      'Envoyer moins de JavaScript pour les zones non interactives',
    ),
    _ultra(
      'GraphQL à grande échelle',
      'Évite sur-récupération, N+1 et contrats instables dans un graphe de données.',
      [LessonLanguage.typescript, LessonLanguage.javascript],
      'Un schéma GraphQL doit avoir des limites de profondeur, coûts et ownership explicites.',
      'Quel problème un mécanisme de batching peut-il réduire ?',
      'Les requêtes N+1 vers une source de données',
    ),
    _ultra(
      'WebGPU et calcul graphique',
      'Explore les pipelines GPU modernes pour visualisation et calcul parallèle.',
      [LessonLanguage.javascript],
      'Le GPU excelle sur de nombreux calculs semblables, mais les transferts mémoire doivent rester mesurés.',
      'Quand WebGPU est-il particulièrement adapté ?',
      'Pour des opérations massivement parallèles mesurées',
    ),
    _ultra(
      'Résilience front-end hors connexion',
      'Gère cache, conflits et mises à jour de service worker sans surprise.',
      [LessonLanguage.javascript, LessonLanguage.html],
      'Une stratégie offline définit quelle version et quelles données restent sûres à servir.',
      'Quel risque un service worker mal géré peut-il créer ?',
      'Servir longtemps une version périmée de l’application',
    ),
  ],
  LearningPath.python => [
    _ultra(
      'Interpréteur CPython et GIL',
      'Comprends les limites des threads et les options pour le calcul parallèle.',
      [LessonLanguage.python],
      'Le GIL protège certaines structures CPython ; les processus peuvent être préférables pour le CPU intensif.',
      'Pourquoi des processus peuvent-ils aider un calcul CPU Python ?',
      'Ils peuvent exécuter du calcul hors du GIL',
    ),
    _ultra(
      'Systèmes de types avancés',
      'Modélise des contrats complexes avec génériques, Protocol et vérification statique.',
      [LessonLanguage.python],
      'Les types structurels permettent de dépendre d’un comportement plutôt que d’une classe concrète.',
      'Quel est l’intérêt d’un Protocol Python ?',
      'Décrire une interface par son comportement attendu',
    ),
    _ultra(
      'Calcul scientifique reproductible',
      'Rends une analyse rejouable avec environnements, graines et données versionnées.',
      [LessonLanguage.python],
      'Un résultat fiable indique ses données, paramètres, versions et conditions d’exécution.',
      'Pourquoi fixer une graine aléatoire ?',
      'Pour reproduire une expérience et comparer les résultats',
    ),
    _ultra(
      'Compilateurs et analyse statique',
      'Construis une analyse basée sur AST pour comprendre ou transformer du code.',
      [LessonLanguage.python],
      'Un AST représente la structure du programme, ce qui permet d’analyser sans exécuter du code non fiable.',
      'Pourquoi analyser un AST plutôt qu’exécuter le programme ?',
      'Pour examiner sa structure sans lancer son comportement',
    ),
    _ultra(
      'MLOps et déploiement de modèles',
      'Versionne modèles, jeux de données et règles de déploiement.',
      [LessonLanguage.python],
      'Un modèle en production nécessite validation, surveillance, retour arrière et traçabilité.',
      'Que faut-il versionner en MLOps ?',
      'Le modèle, les données et la configuration qui l’ont produit',
    ),
  ],
  LearningPath.game => [
    _ultra(
      'Physique déterministe et rollback',
      'Rends une simulation rejouable pour le réseau compétitif.',
      [LessonLanguage.javascript],
      'Un rollback nécessite des entrées et états reproductibles afin de corriger une prédiction tardive.',
      'Pourquoi rechercher le déterminisme en jeu réseau ?',
      'Pour rejouer la même simulation avec les mêmes entrées',
    ),
    _ultra(
      'ECS et architecture orientée données',
      'Organise de nombreuses entités pour le cache et le parallélisme.',
      [LessonLanguage.javascript],
      'Un Entity Component System sépare identités, données et traitements pour traiter des groupes homogènes.',
      'Quel avantage apporte une architecture orientée données ?',
      'Traiter efficacement de nombreux objets semblables',
    ),
    _ultra(
      'Animation procédurale et IK',
      'Adapte les mouvements aux surfaces et aux interactions en temps réel.',
      [LessonLanguage.javascript],
      'La cinématique inverse calcule des articulations pour atteindre une cible sous contraintes.',
      'Que résout la cinématique inverse ?',
      'La pose des articulations nécessaire pour atteindre une cible',
    ),
    _ultra(
      'Audio adaptatif et spatialisation',
      'Fais réagir musique et son à l’état du jeu et à l’espace.',
      [LessonLanguage.javascript],
      'Un mix adaptatif doit préserver la lisibilité des signaux importants pour le joueur.',
      'Quel but a la spatialisation audio ?',
      'Indiquer la position relative d’une source sonore',
    ),
    _ultra(
      'Accessibilité avancée du jeu',
      'Conçois remappage, aides perceptives et difficulté adaptable.',
      [LessonLanguage.javascript],
      'Les options d’accessibilité doivent être testées avec des besoins réels et indépendantes du niveau de difficulté.',
      'Quel choix favorise une commande accessible ?',
      'Permettre le remappage des actions importantes',
    ),
  ],
  LearningPath.mobile => [
    _ultra(
      'Flutter engine et platform channels',
      'Relie une interface Dart à des capacités natives avec des contrats sûrs.',
      [LessonLanguage.dart],
      'Un channel définit des messages typés, des erreurs et un cycle de vie entre Flutter et la plateforme.',
      'Quel risque doit être géré avec un platform channel ?',
      'Un appel natif qui échoue ou répond après la fermeture de l’écran',
    ),
    _ultra(
      'Réactivité et programmation fonctionnelle',
      'Modélise des flux, annulations et états immuables complexes.',
      [LessonLanguage.dart],
      'Un flux doit définir clairement qui possède l’abonnement et quand il se termine.',
      'Pourquoi annuler un abonnement à un flux ?',
      'Pour éviter de garder des ressources ou mises à jour inutiles',
    ),
    _ultra(
      'Réalité augmentée mobile',
      'Aligne contenu virtuel, capteurs et monde physique de façon stable.',
      [LessonLanguage.dart],
      'La RA combine suivi de pose, compréhension de surfaces et gestion attentive des permissions.',
      'Quel élément est essentiel à une expérience RA stable ?',
      'Un suivi fiable de la position et de l’orientation de l’appareil',
    ),
    _ultra(
      'Paiements mobiles et conformité',
      'Intègre un achat en protégeant les reçus et les états de transaction.',
      [LessonLanguage.dart],
      'Un achat n’est final qu’après validation côté serveur du reçu ou de la transaction.',
      'Pourquoi vérifier un reçu côté serveur ?',
      'Le client peut être modifié et ne constitue pas une preuve fiable',
    ),
    _ultra(
      'Observabilité de l’expérience mobile',
      'Relie crashs, lenteurs et parcours sans collecter plus que nécessaire.',
      [LessonLanguage.dart],
      'Les événements doivent être minimisés, consentis et associés à des diagnostics actionnables.',
      'Quelle donnée aide à diagnostiquer un crash ?',
      'Une trace technique anonymisée avec la version de l’application',
    ),
  ],
  LearningPath.fullStack => [
    _ultra(
      'Domain-driven design stratégique',
      'Découpe un produit en contextes bornés et langages partagés.',
      [LessonLanguage.typescript, LessonLanguage.sql],
      'Un contexte borné fixe le sens d’un terme métier afin d’éviter des modèles ambiguës entre équipes.',
      'Pourquoi définir un contexte borné ?',
      'Pour donner un sens clair et cohérent aux règles d’un domaine',
    ),
    _ultra(
      'Event sourcing et projections',
      'Conserve les faits métier et reconstruis des vues adaptées aux usages.',
      [LessonLanguage.javascript, LessonLanguage.sql],
      'Les événements sont immuables ; les projections peuvent être reconstruites lorsque les besoins de lecture changent.',
      'Quel avantage donne une projection reconstruisible ?',
      'Créer une nouvelle vue de lecture depuis l’historique des faits',
    ),
    _ultra(
      'Zero trust applicatif',
      'Vérifie identité, appareil et autorisation à chaque frontière.',
      [LessonLanguage.typescript, LessonLanguage.javascript],
      'Zero trust ne suppose pas qu’un réseau interne est sûr ; chaque requête prouve son droit.',
      'Quel principe caractérise zero trust ?',
      'Vérifier explicitement chaque accès plutôt que faire confiance au réseau',
    ),
    _ultra(
      'FinOps et coût du cloud',
      'Relie décisions techniques, consommation et valeur produit.',
      [LessonLanguage.sql, LessonLanguage.typescript],
      'Les coûts cloud sont des signaux de conception : dimensionnement, stockage et transfert doivent être observés.',
      'Quel premier pas aide à maîtriser un coût cloud ?',
      'Attribuer les coûts à un service ou une fonctionnalité mesurable',
    ),
    _ultra(
      'SLO et budgets d’erreur',
      'Équilibre vitesse de livraison et fiabilité vécue par les utilisateurs.',
      [LessonLanguage.typescript],
      'Un SLO fixe une cible de service ; le budget d’erreur indique la marge avant de privilégier la fiabilité.',
      'À quoi sert un budget d’erreur ?',
      'Décider quand ralentir les changements pour restaurer la fiabilité',
    ),
  ],
  LearningPath.backend => [
    _ultra(
      'Consensus distribué',
      'Comprends leader, quorum et tolérance aux pannes dans un cluster.',
      [LessonLanguage.python, LessonLanguage.javascript],
      'Un protocole de consensus choisit un ordre commun malgré les pannes, au prix de contraintes de disponibilité.',
      'Pourquoi un quorum est-il utilisé ?',
      'Pour valider une décision avec une majorité cohérente de nœuds',
    ),
    _ultra(
      'Streaming de données',
      'Traite des événements continus avec fenêtres, retard et état.',
      [LessonLanguage.python, LessonLanguage.sql],
      'Un système de streaming doit préciser le temps d’événement, le retard accepté et les garanties de traitement.',
      'Que représente le temps d’événement ?',
      'Le moment où le fait est réellement survenu',
    ),
    _ultra(
      'Recherche vectorielle et RAG',
      'Construis une recherche sémantique en évaluant récupération et réponses.',
      [LessonLanguage.python],
      'Un système RAG doit citer ses sources, filtrer ses accès et mesurer la qualité de récupération séparément de la génération.',
      'Que faut-il évaluer dans un système RAG ?',
      'La pertinence des documents récupérés et la qualité de la réponse',
    ),
    _ultra(
      'Sécurité des API à haute assurance',
      'Applique limitation, mTLS, rotation de clés et journalisation d’audit.',
      [LessonLanguage.javascript, LessonLanguage.python],
      'Les API sensibles nécessitent identité mutuelle, autorisations fines et traces résistantes aux modifications.',
      'Quel contrôle limite un abus automatisé d’API ?',
      'Une limitation de débit adaptée à l’identité et au risque',
    ),
    _ultra(
      'Reprise après sinistre',
      'Prépare objectifs RPO/RTO, sauvegardes testées et bascule régionale.',
      [LessonLanguage.sql, LessonLanguage.python],
      'Une sauvegarde non restaurée en exercice n’est pas une preuve de reprise réelle.',
      'Que mesure le RPO ?',
      'La quantité maximale de données que l’on accepte de perdre',
    ),
  ],
  LearningPath.collaboration => [
    _ultra(
      'Leadership technique sans autorité hiérarchique',
      'Influence par clarté, preuves et création d’alignement.',
      [LessonLanguage.git],
      'Un leader technique facilite une décision et rend les contraintes compréhensibles sans imposer une solution.',
      'Quelle pratique augmente l’influence technique ?',
      'Rendre les compromis et les preuves accessibles à l’équipe',
    ),
    _ultra(
      'Organisation socio-technique',
      'Aligne limites de services, flux de communication et responsabilités d’équipe.',
      [LessonLanguage.git, LessonLanguage.typescript],
      'Les interfaces logicielles reflètent souvent les interfaces de communication : elles doivent être conçues ensemble.',
      'Pourquoi examiner les flux d’équipe avec l’architecture ?',
      'Les dépendances humaines peuvent devenir des dépendances techniques',
    ),
    _ultra(
      'Gestion de crise et communication',
      'Informe clairement pendant un incident sans spéculation.',
      [LessonLanguage.git],
      'Une communication de crise indique impact, action en cours, prochaine mise à jour et canal de contact.',
      'Que doit contenir une mise à jour d’incident ?',
      'L’impact observé, les actions en cours et la prochaine échéance',
    ),
    _ultra(
      'Éthique de l’ingénierie',
      'Évalue conséquences, équité et risques des décisions techniques.',
      [LessonLanguage.git],
      'Une décision responsable inclut les personnes affectées, les abus possibles et les mécanismes de recours.',
      'Quelle question relève de l’éthique technique ?',
      'Qui peut subir un impact négatif de cette fonctionnalité ?',
    ),
    _ultra(
      'Stratégie et modernisation de système',
      'Planifie une migration incrémentale d’un système critique.',
      [LessonLanguage.git, LessonLanguage.typescript],
      'Une stratégie de modernisation réduit les risques par étapes observables et réversibles plutôt que par un remplacement total aveugle.',
      'Quel choix réduit le risque d’une migration ?',
      'Migrer progressivement avec des mesures et un retour arrière',
    ),
  ],
};

AdvancedCourse _ultra(
  String title,
  String description,
  List<LessonLanguage> languages,
  String principle,
  String question,
  String answer,
) => AdvancedCourse(
  title: title,
  description: description,
  languages: languages,
  intro:
      'Ce cours ultra-avancé relie les principes techniques aux décisions réelles d’un produit en production.',
  principle: principle,
  practice:
      'Définis une hypothèse, un indicateur vérifiable et un scénario d’échec avant de choisir une solution.',
  recap:
      'La maîtrise avancée vient de compromis explicites, mesurés et révisables.',
  question: question,
  options: [
    answer,
    'Ajouter davantage de code sans mesurer',
    'Ignorer les contraintes du système',
    'Reporter toute vérification',
  ],
  correctIndex: 0,
  explanation: answer,
);

/// Une série de spécialisation finale, conçue pour aller au-delà de la mise en
/// œuvre : optimisation, sûreté, recherche et conception de systèmes.
List<AdvancedCourse> masteryCoursesFor(LearningPath path) => switch (path) {
  LearningPath.frontEnd => [
    _master(
      'Compilateurs UI et optimisation AOT',
      'Étudie la compilation des interfaces et les compromis entre taille, temps de démarrage et flexibilité.',
      [LessonLanguage.typescript],
      'Pourquoi analyser la taille d’un bundle de production ?',
      'Pour identifier le code qui ralentit le chargement réel',
    ),
    _master(
      'Systèmes de design tokenisés',
      'Gouverne couleurs, typographie et variantes comme une API versionnée.',
      [LessonLanguage.css, LessonLanguage.typescript],
      'Quel avantage donne un jeton de design ?',
      'Propager une décision visuelle cohérente dans toute l’interface',
    ),
    _master(
      'Visualisation de données dense',
      'Présente beaucoup de données sans tromper ni surcharger la personne.',
      [LessonLanguage.javascript, LessonLanguage.css],
      'Quelle règle protège une visualisation ?',
      'Préserver les échelles et rendre les incertitudes visibles',
    ),
    _master(
      'Expériences temps réel dans le navigateur',
      'Gère WebSocket, reconnexion, ordre des messages et présence collaborative.',
      [LessonLanguage.javascript],
      'Que faut-il prévoir avec un réseau temps réel ?',
      'La reconnexion et les messages reçus dans un ordre inattendu',
    ),
    _master(
      'Privacy engineering front-end',
      'Réduit empreintes, scripts tiers et exposition de données dans le navigateur.',
      [LessonLanguage.javascript, LessonLanguage.html],
      'Quel choix réduit une exposition de données ?',
      'Charger uniquement les scripts tiers strictement nécessaires',
    ),
    _master(
      'Audit UX de systèmes critiques',
      'Teste des interfaces où une erreur humaine peut avoir un coût élevé.',
      [LessonLanguage.html, LessonLanguage.css],
      'Quelle technique réduit le risque d’une action destructive ?',
      'Demander une confirmation informative et réversible',
    ),
  ],
  LearningPath.python => [
    _master(
      'Systèmes distribués en Python',
      'Conçois des workers, verrous et reprises sans supposer un réseau parfait.',
      [LessonLanguage.python],
      'Quel principe protège un worker distribué ?',
      'Considérer qu’un message peut être dupliqué ou perdu',
    ),
    _master(
      'Traitement du langage naturel',
      'Évalue tokenisation, représentation et biais dans des pipelines linguistiques.',
      [LessonLanguage.python],
      'Pourquoi évaluer un modèle NLP sur plusieurs groupes ?',
      'Pour détecter des erreurs ou biais qui varient selon le contexte',
    ),
    _master(
      'Simulation et Monte-Carlo',
      'Estime une incertitude avec expériences aléatoires reproductibles.',
      [LessonLanguage.python],
      'Que permet une simulation Monte-Carlo ?',
      'Estimer une distribution de résultats incertains',
    ),
    _master(
      'Sûreté de code et property-based testing',
      'Génère des cas limites pour vérifier des invariants plutôt que quelques exemples.',
      [LessonLanguage.python],
      'Que vérifie un test basé sur une propriété ?',
      'Une règle qui doit rester vraie pour de nombreuses entrées',
    ),
    _master(
      'Interopérabilité Python-Rust',
      'Utilise une extension native seulement après mesure et avec une frontière sûre.',
      [LessonLanguage.python],
      'Quand une extension native est-elle justifiée ?',
      'Après avoir prouvé un goulet d’étranglement important',
    ),
    _master(
      'Recherche reproductible et publication',
      'Prépare code, données et protocole pour qu’une autre personne puisse vérifier un résultat.',
      [LessonLanguage.python],
      'Quel élément soutient la reproductibilité ?',
      'Un environnement et un protocole d’exécution documentés',
    ),
  ],
  LearningPath.game => [
    _master(
      'Réseaux pair-à-pair et NAT traversal',
      'Comprends les limites de connexion directe entre joueurs.',
      [LessonLanguage.javascript],
      'Pourquoi le NAT traversal est-il difficile ?',
      'Les routeurs privés ne rendent pas toujours un appareil joignable directement',
    ),
    _master(
      'Rendu global et illumination temps réel',
      'Évalue les compromis entre fidélité visuelle, bruit et budget GPU.',
      [LessonLanguage.javascript],
      'Quel compromis guide l’illumination temps réel ?',
      'La qualité visuelle face au budget de calcul par image',
    ),
    _master(
      'Narration systémique',
      'Fais émerger des histoires depuis les règles, agents et choix des joueurs.',
      [LessonLanguage.javascript],
      'Qu’est-ce qui distingue une narration systémique ?',
      'Les situations naissent des interactions entre règles et actions',
    ),
    _master(
      'Sécurité des serveurs de jeu',
      'Isole sessions, protocoles et données compétitives face aux abus.',
      [LessonLanguage.javascript],
      'Quelle donnée ne doit pas être confiée au client ?',
      'L’état autoritaire d’une partie compétitive',
    ),
    _master(
      'Optimisation console et mémoire',
      'Travaille dans des budgets stricts de mémoire, CPU et GPU.',
      [LessonLanguage.javascript],
      'Pourquoi établir un budget mémoire ?',
      'Pour prévenir une saturation avant qu’elle ne provoque un échec',
    ),
    _master(
      'Recherche joueur et éthique du fun',
      'Mesure l’engagement sans concevoir de mécaniques manipulatrices.',
      [LessonLanguage.javascript],
      'Quelle pratique respecte les joueurs ?',
      'Donner des choix transparents et éviter la pression artificielle',
    ),
  ],
  LearningPath.mobile => [
    _master(
      'Systèmes embarqués et Bluetooth',
      'Communique avec des périphériques malgré latence, permissions et déconnexions.',
      [LessonLanguage.dart],
      'Quel comportement est normal avec Bluetooth ?',
      'Une déconnexion qui doit être gérée sans perdre l’état',
    ),
    _master(
      'Calcul IA sur appareil',
      'Exécute un modèle local en évaluant mémoire, énergie et confidentialité.',
      [LessonLanguage.dart],
      'Quel avantage offre une IA exécutée localement ?',
      'Réduire l’envoi de données sensibles vers un serveur',
    ),
    _master(
      'Optimisation énergétique',
      'Mesure l’impact de réseau, capteurs et rendu sur l’autonomie.',
      [LessonLanguage.dart],
      'Pourquoi mesurer la consommation d’énergie ?',
      'Une fonction peut dégrader fortement l’autonomie sans erreur visible',
    ),
    _master(
      'Mobile device management',
      'Déploie et sécurise une application dans un parc d’appareils gérés.',
      [LessonLanguage.dart],
      'Quel besoin répond au MDM ?',
      'Appliquer des règles de sécurité sur de nombreux appareils',
    ),
    _master(
      'Continuité multi-appareils',
      'Synchronise une expérience entre téléphone, tablette et ordinateur.',
      [LessonLanguage.dart],
      'Quel problème doit résoudre la continuité ?',
      'Le conflit entre modifications faites sur plusieurs appareils',
    ),
    _master(
      'Qualité inclusive sur matériel contraint',
      'Teste l’application sur réseau lent, vieux appareils et technologies d’assistance.',
      [LessonLanguage.dart],
      'Pourquoi tester sur matériel contraint ?',
      'Les performances réelles varient fortement selon les appareils',
    ),
  ],
  LearningPath.fullStack => [
    _master(
      'Architecture hexagonale à l’échelle',
      'Protège le domaine métier des frameworks, transports et fournisseurs externes.',
      [LessonLanguage.typescript],
      'Quel est le rôle d’un port en architecture hexagonale ?',
      'Définir une frontière stable entre le métier et un adaptateur',
    ),
    _master(
      'Systèmes de paiement distribués',
      'Conçois idempotence, audit et réconciliation de transactions financières.',
      [LessonLanguage.sql, LessonLanguage.typescript],
      'Quelle propriété est essentielle à un paiement ?',
      'Ne jamais débiter deux fois la même intention',
    ),
    _master(
      'Conformité et auditabilité',
      'Conserve des preuves de décision et d’accès sans exposer inutilement les données.',
      [LessonLanguage.sql],
      'Pourquoi produire une piste d’audit ?',
      'Comprendre qui a fait quelle action et quand',
    ),
    _master(
      'Multi-région et souveraineté',
      'Choisis localisation, latence et réplication selon les contraintes du produit.',
      [LessonLanguage.typescript, LessonLanguage.sql],
      'Quel compromis apparaît en multi-région ?',
      'La proximité des utilisateurs face à la cohérence et au coût',
    ),
    _master(
      'Ingénierie de la fiabilité produit',
      'Relie alertes, objectifs utilisateurs et capacité de récupération.',
      [LessonLanguage.typescript],
      'Quelle alerte est la plus utile ?',
      'Une alerte liée à un impact réel sur les utilisateurs',
    ),
    _master(
      'Migration de monolithe critique',
      'Étrangle progressivement un monolithe tout en gardant le service fonctionnel.',
      [LessonLanguage.typescript, LessonLanguage.git],
      'Quelle stratégie limite le risque d’une migration ?',
      'Remplacer une frontière à la fois avec des mesures de compatibilité',
    ),
  ],
  LearningPath.backend => [
    _master(
      'Bases de données temporelles',
      'Interroge l’état passé et les changements sans perdre la chronologie métier.',
      [LessonLanguage.sql],
      'Quelle question répond une base temporelle ?',
      'Quel était l’état valide d’une donnée à une date donnée ?',
    ),
    _master(
      'Calcul confidentiel et enclaves',
      'Évalue les environnements d’exécution isolés pour données sensibles.',
      [LessonLanguage.python],
      'Quel objectif vise une enclave sécurisée ?',
      'Réduire l’exposition de données pendant leur traitement',
    ),
    _master(
      'Planificateurs et optimisation combinatoire',
      'Affecte ressources et tâches sous contraintes mesurables.',
      [LessonLanguage.python],
      'Quel est le premier élément d’un problème d’optimisation ?',
      'Une fonction objectif et des contraintes explicites',
    ),
    _master(
      'Protocoles réseau modernes',
      'Compare HTTP/3, QUIC, multiplexage et gestion de congestion.',
      [LessonLanguage.javascript],
      'Quel avantage apporte QUIC ?',
      'Réduire certains blocages liés à une connexion de transport unique',
    ),
    _master(
      'Vérification formelle de protocoles',
      'Exprime des invariants pour raisonner sur sécurité et concurrence.',
      [LessonLanguage.python],
      'Que cherche une vérification formelle ?',
      'Prouver ou réfuter une propriété sur tous les états pertinents',
    ),
    _master(
      'Green software et efficacité serveur',
      'Réduit calcul inutile, stockage et transfert sans sacrifier la qualité.',
      [LessonLanguage.python, LessonLanguage.sql],
      'Quel geste réduit souvent l’impact serveur ?',
      'Éviter les traitements et transferts qui ne créent pas de valeur',
    ),
  ],
  LearningPath.collaboration => [
    _master(
      'Négociation de compromis techniques',
      'Rends visibles coût, délai, dette et risque dans une décision partagée.',
      [LessonLanguage.git],
      'Quel outil améliore une négociation technique ?',
      'Une comparaison explicite des options selon des critères communs',
    ),
    _master(
      'Gouvernance open source',
      'Gère contributions, règles de communauté et sécurité des mainteneurs.',
      [LessonLanguage.git],
      'Pourquoi définir une gouvernance open source ?',
      'Clarifier comment les décisions et contributions sont traitées',
    ),
    _master(
      'Conception d’organisations apprenantes',
      'Crée des boucles de retour entre incidents, produits et pratiques d’équipe.',
      [LessonLanguage.git],
      'Quelle pratique transforme un incident en apprentissage ?',
      'Suivre des actions d’amélioration vérifiables après l’analyse',
    ),
    _master(
      'Communication interculturelle technique',
      'Adapte précision, canal et rythme dans une équipe répartie.',
      [LessonLanguage.git],
      'Quelle pratique aide une équipe internationale ?',
      'Documenter les décisions dans un format accessible et asynchrone',
    ),
    _master(
      'Mesure de santé d’équipe',
      'Utilise indicateurs qualitatifs et quantitatifs sans surveiller les personnes.',
      [LessonLanguage.git],
      'Quel indicateur respecte une équipe ?',
      'Un signal agrégé sur le flux de travail plutôt qu’un classement individuel',
    ),
    _master(
      'Stratégie de plateforme interne',
      'Conçois des outils qui réduisent la charge cognitive des équipes produit.',
      [LessonLanguage.git, LessonLanguage.typescript],
      'Quel objectif guide une plateforme interne ?',
      'Rendre les choix sûrs et simples pour les équipes utilisatrices',
    ),
  ],
};

AdvancedCourse _master(
  String title,
  String description,
  List<LessonLanguage> languages,
  String question,
  String answer,
) => AdvancedCourse(
  title: title,
  description: description,
  languages: languages,
  intro:
      'Ce module de maîtrise explore les contraintes, les preuves et les compromis d’un système de niveau professionnel.',
  principle: description,
  practice:
      'Construis un petit protocole : scénario réel, hypothèse, risque principal, mesure de réussite et plan de retour arrière.',
  recap:
      'L’expertise consiste à faire des choix explicables dans des conditions imparfaites.',
  question: question,
  options: [
    answer,
    'Choisir sans analyser les contraintes',
    'Éviter toute mesure',
    'Ignorer les cas d’échec',
  ],
  correctIndex: 0,
  explanation: answer,
);

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
  _expert(
    'WebAssembly et calcul côté client',
    'Exécute des calculs proches du navigateur sans sacrifier la sécurité.',
    [LessonLanguage.javascript, LessonLanguage.typescript],
    'WebAssembly permet d’intégrer des modules performants pour des tâches ciblées.',
    'Garde une frontière claire entre le module, les données validées et l’interface.',
    'Compare le coût du transfert de données avec le gain de calcul.',
    'WebAssembly est un outil spécialisé, à mesurer avant adoption.',
    'Quand WebAssembly est-il pertinent ?',
    [
      'Pour une tâche de calcul ciblée et mesurée',
      'Pour remplacer tout HTML',
      'Pour éviter les tests',
      'Pour stocker les mots de passe',
    ],
    0,
    'Il est utile lorsque les mesures montrent un vrai besoin de performance.',
  ),
  _expert(
    'Internationalisation et interfaces adaptatives',
    'Conçois une interface fiable dans plusieurs langues, écritures et formats.',
    [LessonLanguage.html, LessonLanguage.css],
    'Une interface mondiale ne peut pas supposer la longueur d’un texte ni le sens de lecture.',
    'Évite les chaînes concaténées et teste les contenus longs, pluriels et langues RTL.',
    'Vérifie une même carte avec une traduction deux fois plus longue.',
    'L’internationalisation fait partie de la conception, pas d’une dernière étape.',
    'Pourquoi éviter de concaténer des phrases traduites ?',
    [
      'La grammaire et l’ordre des mots changent selon la langue',
      'Cela accélère le rendu',
      'Les couleurs changent',
      'Les images deviennent plus petites',
    ],
    0,
    'Les langues n’assemblent pas les informations dans le même ordre.',
  ),
  _expert(
    'Sécurité navigateur avancée',
    'Réduis les risques XSS, fuite de jetons et dépendances compromises.',
    [LessonLanguage.javascript, LessonLanguage.html],
    'Le navigateur est une frontière exposée : les données affichées et les scripts tiers doivent être maîtrisés.',
    'Échappe les contenus non fiables, applique une CSP et limite la portée des jetons.',
    'Analyse un champ de commentaire qui contient du HTML non fiable.',
    'La défense en profondeur limite les conséquences d’une erreur.',
    'Quel contrôle réduit l’exécution de scripts non autorisés ?',
    [
      'Une Content Security Policy',
      'Une police plus grande',
      'Un nouveau thème',
      'Une animation',
    ],
    0,
    'Une CSP précise quelles sources de scripts le navigateur peut charger.',
  ),
  _expert(
    'Tests de parcours et qualité perçue',
    'Valide les scénarios critiques sur navigateur et appareils réels.',
    [LessonLanguage.typescript, LessonLanguage.javascript],
    'Les tests de composants ne suffisent pas pour garantir un achat, une inscription ou un parcours accessible.',
    'Combine tests unitaires rapides, intégration et quelques scénarios de bout en bout stables.',
    'Automatise le parcours de connexion puis vérifie le résultat visible par la personne.',
    'La pyramide de tests donne un retour rapide sans oublier les parcours réels.',
    'Que vérifie un test de bout en bout ?',
    [
      'Un parcours utilisateur complet entre plusieurs couches',
      'Une seule fonction isolée',
      'La couleur du terminal',
      'Le nom de la branche',
    ],
    0,
    'Il simule le comportement depuis l’interface jusqu’aux dépendances nécessaires.',
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
  _expert(
    'Python natif et optimisation',
    'Identifie les vrais goulets d’étranglement avant d’optimiser.',
    [LessonLanguage.python],
    'Le code rapide commence par un profil, pas par une intuition.',
    'Mesure CPU, mémoire et appels ; améliore l’algorithme avant d’envisager une extension native.',
    'Profile une fonction lente avec des données représentatives.',
    'Une optimisation utile est prouvée par une mesure reproductible.',
    'Quelle action précède une optimisation ?',
    [
      'Profiler le programme avec un cas réaliste',
      'Réécrire au hasard',
      'Supprimer les tests',
      'Changer le nom des variables',
    ],
    0,
    'Le profil révèle où le temps est réellement dépensé.',
  ),
  _expert(
    'Sécurité applicative Python',
    'Protège secrets, entrées, sérialisation et dépendances.',
    [LessonLanguage.python],
    'Un script peut devenir un service exposé dès qu’il lit des entrées externes.',
    'Valide les données, n’exécute jamais une désérialisation non fiable et stocke les secrets hors du code.',
    'Remplace une configuration codée en dur par une variable gérée par l’environnement.',
    'La sécurité dépend aussi des bibliothèques et du déploiement.',
    'Quel contenu ne faut-il jamais désérialiser sans confiance ?',
    [
      'Une donnée fournie par une source inconnue',
      'Un entier créé localement',
      'Une chaîne documentée',
      'Un test unitaire',
    ],
    0,
    'Une désérialisation dangereuse peut exécuter ou reconstruire des objets inattendus.',
  ),
  _expert(
    'Pipelines de données Python',
    'Traite des volumes importants de façon traçable et récupérable.',
    [LessonLanguage.python, LessonLanguage.sql],
    'Un pipeline expert doit pouvoir être relancé sans corrompre les résultats.',
    'Conserve les étapes, valide les schémas et rends chaque transformation idempotente.',
    'Ajoute un identifiant de lot et une règle de reprise à une importation.',
    'Des pipelines observables rendent les données fiables dans le temps.',
    'Pourquoi rendre une étape idempotente ?',
    [
      'Pour pouvoir la relancer sans dupliquer son effet',
      'Pour supprimer les données',
      'Pour éviter SQL',
      'Pour masquer les erreurs',
    ],
    0,
    'Une reprise est normale dans un traitement long ou distribué.',
  ),
  _expert(
    'Apprentissage automatique responsable',
    'Évalue un modèle au-delà de son score moyen.',
    [LessonLanguage.python],
    'Un modèle performant globalement peut échouer pour des groupes ou contextes importants.',
    'Sépare entraînement et évaluation, examine les erreurs par sous-groupe et surveille la dérive après livraison.',
    'Construis une matrice d’erreurs pour deux types de situations.',
    'Un modèle responsable reste mesuré, explicable et surveillé.',
    'Pourquoi surveiller la dérive d’un modèle ?',
    [
      'Les données réelles peuvent changer après l’entraînement',
      'Le code ne change jamais',
      'Les tests deviennent inutiles',
      'Le modèle s’arrête automatiquement',
    ],
    0,
    'Un changement de données peut dégrader les prédictions au fil du temps.',
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
  _expert(
    'Rendu graphique et shaders',
    'Utilise le GPU avec des budgets visuels et des effets contrôlés.',
    [LessonLanguage.javascript],
    'Les effets graphiques avancés peuvent saturer le GPU plus vite qu’un calcul classique.',
    'Mesure le coût des draw calls, textures et shaders avant de multiplier les effets.',
    'Réduis la résolution d’un effet de post-traitement et compare son impact.',
    'Une belle image doit rester fluide sur le matériel visé.',
    'Quel risque pose un shader coûteux ?',
    [
      'Dépasser le budget GPU et provoquer des ralentissements',
      'Supprimer les contrôles',
      'Changer le scénario',
      'Créer une base SQL',
    ],
    0,
    'Chaque image doit être dessinée dans un délai limité.',
  ),
  _expert(
    'Génération procédurale contrôlée',
    'Crée des mondes variés qui restent jouables et testables.',
    [LessonLanguage.javascript],
    'Le hasard seul produit facilement des niveaux impossibles ou répétitifs.',
    'Utilise une graine, des contraintes et une validation automatique des chemins essentiels.',
    'Génère cent cartes avec la même règle puis détecte celles sans sortie.',
    'La génération procédurale combine diversité et garanties de jouabilité.',
    'Pourquoi conserver une graine de génération ?',
    [
      'Pour reproduire exactement un monde et le déboguer',
      'Pour accélérer le son',
      'Pour supprimer les niveaux',
      'Pour éviter le hasard',
    ],
    0,
    'La même graine permet de retrouver un cas problématique.',
  ),
  _expert(
    'Équilibrage par télémétrie',
    'Lis les données de jeu sans perdre le respect des joueurs.',
    [LessonLanguage.javascript],
    'Les données révèlent où les joueurs échouent ou abandonnent, mais elles doivent rester minimales et consenties.',
    'Mesure une hypothèse précise, anonymise et compare des cohortes avant de modifier une règle.',
    'Teste deux réglages d’un niveau puis compare le taux de réussite.',
    'La télémétrie utile respecte la vie privée et guide les décisions.',
    'Quelle donnée est la plus utile pour équilibrer un niveau ?',
    [
      'Le taux de réussite anonyme du niveau',
      'Le mot de passe du joueur',
      'Sa liste de contacts',
      'Une donnée sans lien avec le jeu',
    ],
    0,
    'Un indicateur lié au niveau aide à vérifier l’hypothèse de difficulté.',
  ),
  _expert(
    'Anti-triche et économie de jeu',
    'Protège les règles compétitives et les ressources rares.',
    [LessonLanguage.javascript],
    'Dans un jeu connecté, le client doit être considéré comme modifiable.',
    'Valide les récompenses sensibles côté serveur, journalise les anomalies et limite les actions répétées.',
    'Définis la règle serveur qui refuse deux achats du même objet.',
    'Une économie saine dépend de règles vérifiables et auditables.',
    'Pourquoi valider les récompenses côté serveur ?',
    [
      'Le client peut être modifié par un joueur',
      'Le serveur dessine mieux',
      'Les textures le demandent',
      'Pour supprimer les comptes',
    ],
    0,
    'Le serveur est la source d’autorité pour les ressources partagées.',
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
  _expert(
    'Sécurité mobile et protection des secrets',
    'Protège les données locales, sessions et échanges sensibles.',
    [LessonLanguage.dart],
    'Un téléphone peut être perdu, partagé ou compromis : les données sensibles demandent une défense en profondeur.',
    'Utilise le stockage sécurisé, limite les jetons et ne fais jamais confiance aux contrôles uniquement côté client.',
    'Définis ce qui doit être effacé lors d’une déconnexion.',
    'La sécurité mobile protège à la fois les données et le compte de la personne.',
    'Où stocker un jeton sensible ?',
    [
      'Dans un stockage sécurisé adapté à la plateforme',
      'En clair dans le code source',
      'Dans le titre de l’écran',
      'Dans une capture d’écran',
    ],
    0,
    'Les mécanismes sécurisés de la plateforme réduisent l’exposition du secret.',
  ),
  _expert(
    'Notifications et exécution en arrière-plan',
    'Conçois des rappels utiles malgré les limites du système.',
    [LessonLanguage.dart],
    'Les systèmes mobiles contrôlent fortement l’énergie et le travail en arrière-plan.',
    'Programme des tâches pertinentes, respecte le consentement et gère le cas où le système retarde leur exécution.',
    'Crée un rappel qui reste correct s’il arrive plus tard que prévu.',
    'Les notifications efficaces sont choisies, pertinentes et fiables.',
    'Pourquoi ne pas supposer une exécution exacte en arrière-plan ?',
    [
      'Le système peut retarder les tâches pour préserver batterie et ressources',
      'Dart ne sait pas attendre',
      'Les écrans sont fixes',
      'Les tests sont interdits',
    ],
    0,
    'Le système priorise l’autonomie et les ressources de l’appareil.',
  ),
  _expert(
    'Expérimentation produit mobile',
    'Évalue une amélioration sans confondre corrélation et causalité.',
    [LessonLanguage.dart],
    'Une nouvelle interface doit aider les utilisateurs, pas seulement sembler moderne.',
    'Définis une métrique principale, un garde-fou et une population comparable avant le test.',
    'Prépare un test A/B dont le critère de succès est l’achèvement d’une tâche.',
    'Une expérimentation fiable prend aussi en compte les effets négatifs.',
    'Quel élément est essentiel avant un test A/B ?',
    [
      'Une hypothèse et une métrique de succès définies',
      'Une nouvelle police uniquement',
      'Une version sans suivi',
      'Un résultat déjà choisi',
    ],
    0,
    'Sans mesure fixée à l’avance, on interprète facilement les données après coup.',
  ),
  _expert(
    'Publication et opérations mobiles',
    'Prépare une sortie progressive, surveillée et récupérable.',
    [LessonLanguage.dart, LessonLanguage.git],
    'Une version mobile reste longtemps sur des appareils variés après sa publication.',
    'Utilise des fonctionnalités activables à distance, surveille les crashs et maintiens la compatibilité des données.',
    'Prévois comment désactiver une fonction problématique sans publier une nouvelle version.',
    'Les opérations mobiles prolongent la qualité au-delà de la mise en ligne.',
    'Quel outil limite le risque d’une fonction nouvelle ?',
    [
      'Un indicateur de fonctionnalité activable progressivement',
      'Une capture d’écran',
      'Un nom de version plus long',
      'Un thème sombre',
    ],
    0,
    'Il permet de réduire le périmètre ou de désactiver une fonction rapidement.',
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
  _expert(
    'Cache, CDN et cohérence',
    'Accélère les lectures sans livrer de données périmées au mauvais moment.',
    [LessonLanguage.javascript, LessonLanguage.typescript],
    'Un cache déplace la question de performance vers celle de fraîcheur des données.',
    'Définis ce qui peut être mis en cache, sa durée et comment invalider les versions importantes.',
    'Compare une page publique cacheable et un solde qui doit rester récent.',
    'Un cache réussi a une politique de cohérence explicite.',
    'Quel risque doit être traité avec un cache ?',
    [
      'Afficher une donnée devenue périmée',
      'Avoir moins de fichiers',
      'Écrire moins de HTML',
      'Utiliser Git',
    ],
    0,
    'Le gain de vitesse doit être équilibré avec le besoin de fraîcheur.',
  ),
  _expert(
    'Architecture multi-tenant',
    'Isole les données et droits de plusieurs organisations.',
    [LessonLanguage.sql, LessonLanguage.typescript],
    'Un produit B2B doit garantir qu’une organisation ne voit jamais les données d’une autre.',
    'Porte le contexte du tenant dans chaque requête, applique les règles côté serveur et teste les tentatives de franchissement.',
    'Écris un test où un utilisateur du tenant A tente de lire une ressource du tenant B.',
    'L’isolation des tenants est une exigence de sécurité fondamentale.',
    'Quel contrôle empêche une fuite entre organisations ?',
    [
      'Vérifier le tenant et les droits dans chaque accès serveur',
      'Masquer le bouton dans l’interface',
      'Changer le logo',
      'Utiliser une seule couleur',
    ],
    0,
    'Un contrôle visuel ne protège pas une requête directe vers le serveur.',
  ),
  _expert(
    'Transactions et sagas',
    'Coordonne des opérations réparties sans transaction globale fragile.',
    [LessonLanguage.sql, LessonLanguage.javascript],
    'Une commande peut toucher paiement, stock et notification, chacun avec ses propres pannes.',
    'Découpe le flux en étapes compensables et enregistre l’état de la saga pour pouvoir reprendre.',
    'Définis l’action de compensation si la réservation de stock échoue après un paiement.',
    'Les sagas gèrent les compromis des systèmes distribués.',
    'Qu’est-ce qu’une compensation dans une saga ?',
    [
      'Une action qui annule l’effet métier d’une étape précédente',
      'Un commentaire de code',
      'Une copie de fichier',
      'Un test visuel',
    ],
    0,
    'Elle restaure une situation cohérente lorsqu’une étape suivante échoue.',
  ),
  _expert(
    'Gestion d’incident full-stack',
    'Réponds à une panne avec diagnostic, communication et apprentissage.',
    [LessonLanguage.git, LessonLanguage.typescript],
    'Un incident se gère mieux avec des rôles clairs et des informations vérifiables.',
    'Stabilise le service, mesure l’impact, communique un état factuel puis rédige un retour sans blâme.',
    'Prépare une checklist pour désactiver une fonctionnalité et informer les personnes concernées.',
    'L’apprentissage après incident réduit les risques futurs.',
    'Quelle est la première priorité durant un incident ?',
    [
      'Réduire l’impact pour les utilisateurs',
      'Chercher un coupable',
      'Réécrire tout le service',
      'Masquer les alertes',
    ],
    0,
    'Stabiliser et limiter les dommages donnent ensuite le temps d’analyser correctement.',
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
  _expert(
    'Cryptographie appliquée',
    'Choisis les primitives adaptées sans inventer ton propre chiffrement.',
    [LessonLanguage.python, LessonLanguage.javascript],
    'La cryptographie sûre repose sur des bibliothèques reconnues et des protocoles éprouvés.',
    'Utilise des algorithmes modernes via une bibliothèque, gère les clés séparément et distingue hachage, signature et chiffrement.',
    'Associe le besoin « vérifier un mot de passe » à un hachage lent adapté.',
    'La cryptographie est une discipline où les détails comptent.',
    'Comment stocker un mot de passe ?',
    [
      'Avec un hachage lent et salé adapté',
      'En clair dans la base',
      'Dans le navigateur seulement',
      'Dans le nom de compte',
    ],
    0,
    'Un hachage adapté limite les dégâts si une base est compromise.',
  ),
  _expert(
    'Planification de capacité',
    'Prévois charge, coûts et saturation avant la panne.',
    [LessonLanguage.python, LessonLanguage.sql],
    'Les systèmes se dégradent souvent quand une ressource atteint une limite invisible.',
    'Mesure utilisation, latence et files ; fixe des seuils et teste une charge réaliste avant une campagne.',
    'Estime la marge nécessaire si le trafic double pendant une heure.',
    'La capacité se planifie avec des données et des marges explicites.',
    'Quel signal peut annoncer une saturation ?',
    [
      'Une file d’attente qui augmente durablement',
      'Un titre de page',
      'Une couleur de bouton',
      'Un commit ancien',
    ],
    0,
    'Une file qui grandit signifie que le traitement ne suit plus l’arrivée.',
  ),
  _expert(
    'Plateforme et infrastructure as code',
    'Rends les environnements reproductibles, revus et auditables.',
    [LessonLanguage.git, LessonLanguage.python],
    'Une infrastructure créée manuellement dérive vite entre test et production.',
    'Déclare les ressources dans des fichiers versionnés, révise les changements et applique-les de façon contrôlée.',
    'Compare une modification réseau proposée dans une revue avec une commande manuelle non tracée.',
    'L’infrastructure as code rend les changements répétables et lisibles.',
    'Pourquoi versionner l’infrastructure ?',
    [
      'Pour revoir et reproduire les changements',
      'Pour supprimer les serveurs',
      'Pour éviter les permissions',
      'Pour remplacer les tests',
    ],
    0,
    'Le code versionné fournit un historique et un processus de validation.',
  ),
  _expert(
    'Confidentialité et gouvernance des données',
    'Applique minimisation, rétention et accès justifié aux données.',
    [LessonLanguage.sql, LessonLanguage.python],
    'Les données personnelles doivent avoir une finalité claire et une durée limitée.',
    'Collecte le minimum, sépare les identifiants, journalise les accès et automatise la suppression selon les règles.',
    'Supprime un champ analytics qui n’est lié à aucune décision produit.',
    'La meilleure donnée sensible est souvent celle qui n’est pas collectée.',
    'Quel principe réduit le risque lié aux données ?',
    [
      'Ne collecter que ce qui est nécessaire',
      'Garder toutes les données indéfiniment',
      'Partager les exports sans contrôle',
      'Retirer les permissions',
    ],
    0,
    'Moins de données inutiles signifie moins de risques à protéger.',
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
  _expert(
    'Mentorat technique et transmission',
    'Partage les connaissances sans créer de dépendance à une seule personne.',
    [LessonLanguage.git],
    'Une équipe durable distribue les connaissances critiques.',
    'Associe documentation, binômage et tâches progressives afin que chacun puisse expliquer et pratiquer.',
    'Prépare une session où une autre personne exécute le changement pendant que tu guides.',
    'Le mentorat rend l’équipe plus autonome et résiliente.',
    'Quel résultat indique un bon mentorat ?',
    [
      'La personne peut réaliser la tâche avec une autonomie croissante',
      'Elle mémorise toutes tes phrases',
      'Elle ne pose plus de question',
      'Elle évite la documentation',
    ],
    0,
    'Le but est de transmettre la capacité d’agir, pas de conserver le savoir.',
  ),
  _expert(
    'Gestion des dépendances et chaîne logicielle',
    'Évalue les bibliothèques, licences et risques de la chaîne de fourniture.',
    [LessonLanguage.git, LessonLanguage.typescript],
    'Une dépendance pratique peut aussi introduire une vulnérabilité ou une contrainte de licence.',
    'Inventorie les dépendances, mets-les à jour de façon contrôlée et vérifie leur provenance.',
    'Définis une règle pour examiner une dépendance nouvelle avant son ajout.',
    'La sécurité de la chaîne logicielle commence par savoir ce qui est utilisé.',
    'Pourquoi produire un inventaire des dépendances ?',
    [
      'Pour identifier rapidement les composants à risque',
      'Pour augmenter le nombre de fichiers',
      'Pour cacher les versions',
      'Pour éviter les mises à jour',
    ],
    0,
    'Un inventaire permet de réagir lorsqu’une vulnérabilité est annoncée.',
  ),
  _expert(
    'Facilitation de décisions difficiles',
    'Mène une discussion technique vers une décision claire et réversible.',
    [LessonLanguage.git],
    'Les désaccords utiles révèlent des risques ; ils doivent être structurés plutôt qu’étouffés.',
    'Cadre le problème, collecte les critères, distingue décision réversible et irréversible puis note le résultat.',
    'Anime une comparaison où chaque option est évaluée selon coût, risque et délai.',
    'Une décision explicite évite de refaire le même débat chaque semaine.',
    'Quelle pratique aide une décision d’équipe ?',
    [
      'Écrire les critères et le compromis retenu',
      'Voter sans contexte',
      'Ignorer les risques',
      'Reporter sans fin',
    ],
    0,
    'Les critères partagés rendent le raisonnement transparent et révisable.',
  ),
  _expert(
    'Fiabilité humaine et culture sans blâme',
    'Apprends des erreurs en améliorant le système plutôt qu’en ciblant une personne.',
    [LessonLanguage.git],
    'Les incidents sont souvent la rencontre de plusieurs conditions normales dans un système complexe.',
    'Analyse le contexte, les signaux disponibles et les protections manquantes ; transforme le retour en actions suivies.',
    'Rédige une action qui réduit concrètement le risque plutôt qu’une injonction générale.',
    'Une culture juste fait remonter les problèmes plus tôt.',
    'Pourquoi éviter le blâme dans une analyse d’incident ?',
    [
      'Pour comprendre les causes systémiques et améliorer les protections',
      'Pour cacher l’incident',
      'Pour ne rien changer',
      'Pour supprimer les journaux',
    ],
    0,
    'Le blâme simplifie trop un système complexe et décourage le signalement.',
  ),
];
