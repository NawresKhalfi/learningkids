# learning kids — instructions de travail

Application Flutter earning kids pour la programmation qui permet : est une app complète de programmation avec des parcours guidés.
- Apprends les bases de Python, JavaScript, HTML, CSS, SQL code et plus encore.
- Passe du débutant au développeur grâce à des parcours structurés en Front-End, Full-Stack, Python et Backend renforcés par l’IA.
- Crée des apps, des sites et des outils pour un portfolio professionnel qui attire l’attention.
- Pratique le développement moderne avec l’IA en comprenant, éditant et améliorant ton code comme un développeur actuel.- Code où tu veux grâce à l’IDE mobile, écris, exécute et modifie du code Python, JavaScript et HTML directement dans l’app.
- Maîtrise la collaboration, les outils et les workflows utilisés par les développeurs modernes.
- Suis ta progression, gagne des certificats et reste motivé grâce aux streaks et aux classements.

Comment ça fonctionne

Apprends à coder pas à pas
Commence par des leçons interactives faciles à suivre en Python, JavaScript, React, Node.JS, Express, TypeScript, CSS, SQL ou HTML pour te construire une base solide.

Construis avec l’IA comme un développeur moderne
Utilise l’IA pour améliorer ton workflow : comprendre du Python, JavaScript, HTML, CSS ou SQL code, trouver des bugs, explorer des solutions et affiner ton travail. Tu gardes toujours le contrôle. l’IA travaille avec toi, pas à ta place.

Crée des projets durables
Transforme tes compétences en apps, sites, automatisations, jeux et autres projets à ajouter à ton portfolio.

Pourquoi learningkids est différent

combine la programmation pratique avec des outils de développement assistés par IA.
Dès ton premier projet, tu acquiers des compétences réelles et utiles dans l’industrie tech.

Tu apprends à coder en construisant de vrais logiciels dès le premier jour.
Tu pratiques Python, JavaScript, HTML, CSS, SQL, TypeScript et React, sans attendre des mois de théorie.

Tu apprends le développement moderne propulsé par l’IA, pas seulement la syntaxe.
L’IA t’aide à analyser du code, explorer des solutions et progresser plus rapidement.

Tu construis des compétences durables et un portfolio qui évoluera avec ta carrière.

Témoignages

« Tu peux intégrer l’apprentissage du code dans n’importe quel moment de ta journée. » – TechCrunch
« Les leçons courtes t’aident à continuer même les jours les plus chargés. » – The New York Times

Ne te limite pas à la syntaxe du passé et ne cours pas après chaque nouveau hype IA. Apprenez à coder pas à pas et maîtrisez Python, JavaScript, HTML code et d’autres langages de programmation populaires en seulement 5 minutes par jour. Créez ensuite votre portfolio de projets et lancez votre carrière dans la tech.

Développe les compétences qui feront de toi le développeur de demain.

Commence à apprendre Python, JavaScript, HTML, CSS ou SQL  dès aujourd’hui . Le backlog produit
(66 user stories, 13 epics) vit dans
`spec/LearningKids_Cahier_des_Specs_Epics_UserStories.xlsx`. C'est la source de
vérité pour ce qu'il faut construire.

## Méthode de travail (à respecter à chaque nouvelle fonctionnalité)

1. **Implémenter feature par feature**, jamais plusieurs epics en parallèle.
   Une "feature" = un epic du backlog (ou un sous-ensemble cohérent si l'epic
   est gros). Ne pas anticiper les epics suivants au-delà du strict nécessaire
   pour brancher un écran de transition minimal.
2. **Suivi des fonctionnalités** : `docs/FEATURES.md` liste les 66 user
   stories groupées par epic avec un statut (⬜ non démarré / 🟨 en cours /
   ✅ implémenté). Mettre à jour ce fichier à la fin de chaque feature —
   c'est le "check" de ce qui a déjà été livré, à consulter avant de
   commencer une nouvelle feature pour éviter les doublons.
3. **Tests obligatoires pour chaque feature** :
   - Tests unitaires pour la logique (controllers Riverpod, resolvers,
     validators, repositories) sous `test/.../application|domain|data/`.
   - Tests UI (widget tests Flutter) pour les écrans, sous
     `test/.../presentation/`. Ils tournent via la **virtualisation Flutter**
     (`flutter test`, le "flutter tester" headless) — **pas** de device réel
     ni `integration_test`. (Le dossier `ui-test/` à la racine est un sujet
     séparé : smoke test Maestro/Firebase App Distribution sur device réel en
     CI, ne pas le confondre avec les tests Flutter du dossier `test/`.)
   - Lancer `flutter test` avant de considérer une feature terminée.
4. **Fichiers courts** : viser max ~500 lignes par fichier. Découper en
   petits widgets/fonctions plutôt que des fichiers monolithiques.
5. **Organisation en dossiers/sous-dossiers**, miroir entre `lib/` et `test/`
   (voir structure ci-dessous).
6. **Vérification visuelle après chaque feature** : lancer l'app sur un
   simulateur iOS (`flutter run -d <simulator-id>`), naviguer le parcours,
   prendre des captures d'écran (`xcrun simctl io <udid> screenshot ...` ou
   la commande `s` de `flutter run` qui écrit dans `screenshots/`), et
   vérifier que le rendu est correct avant de clore la tâche.


## Architecture technique

- **State management** : Riverpod (`flutter_riverpod`, `Notifier`/
  `NotifierProvider`). Toute logique métier vit dans des controllers
  Riverpod testables sans widget (via `ProviderContainer` en test).
- **Navigation** : `go_router`. Router déclaré dans
  `lib/core/router/app_router.dart`.
- **Stockage local** : `shared_preferences` via le wrapper
  `lib/core/storage/local_preferences.dart` (`LocalPreferences`), injecté
  par provider (`localPreferencesProvider`, surchargé dans `main.dart` avec
  l'instance réelle chargée avant `runApp`). Chaque feature ajoute son
  propre "local store" typé dans sa couche `data/` plutôt que de manipuler
  des clés brutes partout. Si une feature a besoin de données relationnelles
  plus riches (constats, véhicules...), réévaluer vers une solution
  structurée (ex. Drift) le moment venu — ne pas le faire prématurément.
- **Firebase** : uniquement avec consentement explicite de l'utilisateur . Ne jamais pousser de données par défaut.
- **i18n** : `flutter gen-l10n` (fichiers source dans `lib/l10n/arb/`,
  généré dans `lib/l10n/gen/`, non versionné — régénéré automatiquement par
  `flutter pub get` / `flutter run` / `flutter test` grâce à
  `generate: true` dans `pubspec.yaml`). Langue française = template ARB.
  Langues supportées déclarées dans
  `lib/core/localization/app_language.dart` (garder en phase avec les
  fichiers `.arb` ajoutés). Le choix de langue déduit de la locale du
  téléphone est résolu par `lib/core/localization/locale_resolver.dart`
  (fonction pure, testée unitairement).
- **Thème** : `lib/core/theme/app_theme.dart`.

## Structure des dossiers

```
lib/
  main.dart                 # init Firebase + SharedPreferences + runApp
  app.dart                  # MaterialApp.router, theme, locale, l10n
  core/                     # infra transverse, pas de logique métier produit
    router/
    theme/
    storage/
    localization/
  features/
    <feature>/               # un dossier par epic/feature (ex: onboarding)
      domain/                 # modèles, enums, règles pures
      data/                   # repositories / local stores
      application/            # controllers Riverpod (state + use cases)
      presentation/
        screens/
        widgets/
  l10n/
    arb/                     # sources traduisibles (app_fr.arb = template)
    gen/                     # généré, gitignored

test/
  core/...                  # miroir de lib/core
  features/<feature>/
    domain/ data/ application/ presentation/   # miroir de lib/features/<feature>
```

## État d'avancement

Voir `docs/FEATURES.md` pour le détail complet epic par epic.
