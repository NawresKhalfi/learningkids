# Suivi des features — LearningKids

Statut par user story (voir `spec/LearningKids_Cahier_des_Specs_Epics_UserStories.xlsx`
pour le détail complet des critères d'acceptation). Légende : ⬜ non démarré /
🟨 en cours / ✅ implémenté.

Règle de travail : on avance epic par epic (voir `agent.md`). Ce fichier est
mis à jour à la fin de chaque feature, avant de passer à la suivante.

## EP01 — Onboarding & Gestion de compte (implémenté)

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US01 | Créer un compte (email, Google, Apple) | 🟨 | Email/mot de passe fonctionnel de bout en bout (+ e-mail de vérification envoyé). Google/Apple câblés côté app mais nécessitent l'activation des providers dans la console Firebase Auth (+ config Apple Developer) avant de fonctionner réellement. |
| US02 | Se connecter (email/SSO, mot de passe oublié) | ✅ | Écran de connexion + mot de passe oublié. Idem US01 pour Google/Apple. |
| US03 | Test de niveau → parcours recommandé | ✅ | Version minimale (une question) : `resolveRecommendedPath`. Une vraie évaluation de positionnement plus riche relève d'EP03/EP04. |
| US04 | Personnaliser le profil (avatar, pseudo) | ✅ | Écran "Modifier le profil" (pseudo + choix parmi 6 avatars presets). |
| US05 | Choisir ses objectifs d'apprentissage | ✅ | Étape "goals" de l'onboarding (sélection multiple). |
| US06 | Supprimer son compte et ses données | ✅ | Confirmation obligatoire, suppression du profil Firestore puis du compte Firebase Auth. |

**Bloquant côté configuration Firebase (pas du code) avant test réel en prod :**
- ~~Base Firestore à créer~~ — fait par l'utilisateur (`(default)`, Firestore
  Native).
- ~~Règles de sécurité `users/{uid}`~~ — écrites et déployées
  (`firebase deploy --only firestore:rules`).
- Activer les providers Email/Password, Google et Apple dans Firebase
  Authentication → Sign-in method (toujours à faire).
- Pour Apple Sign-In : capability "Sign in with Apple" sur l'App ID +
  configuration Apple Developer (toujours à faire).

## EP02 — Contrôle parental & Sécurité enfant (en cours)

Modèle retenu (validé avec l'utilisateur) : **pas de second compte parent**.
Un seul compte Firebase (celui de l'enfant, comme pour l'Epic 1) ; le parent
accède à un « Espace parent » protégé par un code PIN à 4 chiffres au sein
de la même app. Plus simple que le texte littéral du backlog ("compte
parent lié"), mais couvre le même besoin fonctionnel de supervision.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US07 | Compte parent lié + vue « Espace parent » | ✅ | Réinterprété en Espace Parent gated par PIN (voir ci-dessus) au lieu d'un second compte. Création du PIN au premier accès, puis vérification à chaque entrée. |
| US08 | Dashboard parent (temps, leçons, badges) | ✅ | Temps d'utilisation (7 derniers jours), leçons terminées (EP09) et badges obtenus (EP08) tous réels et fonctionnels, plus la bascule de confidentialité du classement (US48). |
| US09 | Limite de temps quotidienne + blocage auto | ✅ | Timer côté app (1 tick/minute en foreground, pause en arrière-plan), persistance Firestore, écran de blocage automatique via le router dès la limite atteinte. Le parent peut débloquer du temps pour la journée via le PIN. |
| US10 | Alerte parent si l'IA détecte un contenu inapproprié | ⬜ | **Bloqué par EP06** (assistant IA) qui n'existe pas encore — rien à modérer. À reprendre quand EP06 sera construit. |
| US11 | Kids UI adaptée à l'âge | 🟨 | Fondation posée (`KidsUiTier`, dérivé de la tranche d'âge choisie à l'onboarding) + application concrète sur l'écran d'accueil (texte et zone de tap agrandis pour les 4-6 ans). À étendre au fur et à mesure que de nouveaux écrans (leçons EP04) arrivent, plutôt que de construire 4 thèmes complets à l'avance. |
| US12 | Conformité RGPD/COPPA | 🟨 | Écran de consentement (1ère étape de l'onboarding) expliquant les données collectées, sans publicité ni revente. **Attention** : c'est un consentement déclaratif léger ("j'accepte, je suis le parent"), pas un "verifiable parental consent" COPPA au sens strict (qui demanderait un prestataire de vérification d'identité/paiement, hors scope). Minimisation des données et droit à l'effacement déjà couverts par l'Epic 1 (US06). |

## EP03 — Parcours d'apprentissage structurés (implémenté)

À la demande explicite de l'utilisateur, le contenu des leçons a été
rédigé (par l'IA) dès cet epic plutôt que de rester un simple
placeholder « bientôt disponible » — voir la note méthodologique
ci-dessous.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US13 | Parcours Front-End (HTML/CSS/JS/React) | ✅ | 5 modules ordonnés avec prérequis, leçons rédigées (intro + sections + exemple de code + récap), progression sauvegardée automatiquement dans Firestore. |
| US14 | Parcours Python | ✅ | 5 modules débutant → projet, même structure que Front-End. |
| US15 | Parcours Full-Stack | ✅ | 5 modules (Node/Express, SQL, TypeScript, connexion front/back, projet final). |
| US16 | Parcours Backend renforcé par l'IA | 🟨 | 5 modules construits (API REST, données, sécurité, bonnes pratiques IA, projet). Le contenu **texte** sur l'IA est là ; les **exercices interactifs assistés par un vrai assistant IA** dépendent d'EP06 (pas construit) — noté explicitement dans la leçon elle-même. |
| US17 | Roadmap visuelle (verrouillé/en cours/terminé) | ✅ | Écran `RoadmapScreen` : icône de statut par module, message explicite des prérequis manquants au clic sur un module verrouillé. |
| US18 | Suivre plusieurs parcours en parallèle | ✅ | Écran `PathsScreen` (sélecteur), activation indépendante par parcours, progression stockée séparément par parcours dans Firestore. Le parcours recommandé à l'onboarding (Epic 1) est auto-activé. |
| US19 | Difficulté adaptative selon le niveau détecté | ⬜ | Toujours pas fait : les scores de quiz (voir EP04) ne sont pas encore historisés (seul le "module terminé" est sauvegardé, pas le détail des réponses), donc aucune donnée à exploiter pour ajuster la difficulté. À reprendre quand ce suivi existera. |

**Note méthodologique — contenu généré par IA :** à la demande explicite
de l'utilisateur, le contenu pédagogique de chaque module (texte des
leçons, exemples de code, questions de quiz et explications) a été rédigé
dès cet epic plutôt que de rester un simple placeholder « bientôt
disponible ». Le mécanisme de quiz noté avec feedback immédiat construit
en EP04 (voir ci-dessous) remplace donc directement l'auto-déclaration
prévue initialement. Seul le véritable éditeur de code exécutable reste
le périmètre d'EP05.

## EP04 — Leçons interactives & Contenu pédagogique (implémenté)

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US20 | Leçons courtes (~5 min) avec temps estimé | ✅ | Chaque module est présenté étape par étape (une section à la fois) via `LessonPlayerScreen`. Écran d'intro affichant une estimation réelle (`estimatedLessonMinutes`, basée sur le nombre de sections) avant de démarrer — ~5 min pour tous les modules actuels. |
| US21 | Quiz à choix multiples + correction immédiate | ✅ | 2 questions à choix multiples par module (40 au total), rédigées avec le contenu. Correction affichée immédiatement après chaque réponse (vert/rouge). **Exercices de code exécutables** non inclus — nécessitent un éditeur de code réel, qui est le périmètre d'EP05. |
| US22 | Feedback pédagogique explicatif | ✅ | Chaque question a une `explanation` qui renvoie à la notion du cours (pas juste "faux"), affichée après chaque réponse, correcte ou non. |
| US23 | Revoir le contenu théorique à tout moment | ✅ | Bouton "Revoir la leçon" depuis le quiz (retour au contenu de lecture). Depuis la roadmap/le catalogue, rouvrir un module (terminé ou non) redonne accès à tout son contenu. |
| US24 | Catalogue de langages (HTML, CSS, SQL...) | ✅ | Écran `LessonCatalogScreen` : tous les modules toutes parcours confondus, filtrables par langage (`LessonLanguage`). Chaque module est tagué avec son ou ses langages ; le catalogue s'enrichit automatiquement avec `curriculum.dart`. |
| US25 | Mettre en pause et reprendre une leçon | ✅ | Position de lecture (numéro d'étape) sauvegardée à chaque changement d'étape dans Firestore (`step_<moduleId>`) ; à la réouverture, reprise automatique à la bonne étape ("Continuer" au lieu de "Commencer"). |

## EP05 — IDE mobile intégré (implémenté)

Décision validée avec l'utilisateur : Python s'exécute via un interpréteur
**Pyodide (WASM)** embarqué dans une WebView cachée, avec les fichiers du
runtime empaquetés comme assets Flutter (`assets/pyodide/`, ~13 Mo) plutôt
qu'un service cloud tiers — répond à l'US31 (hors-ligne) et évite d'envoyer
le code des enfants à un service externe.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US26 | Éditeur avec coloration syntaxique (Python/JS/HTML) | ✅ | Écran `CodePlaygroundScreen`, un onglet par langage. Éditeur `flutter_code_editor` + grammaires `highlight` (HTML utilise la grammaire XML, comme highlight.js). |
| US27 | Exécuter et voir le résultat instantanément | ✅ | Python et JavaScript s'exécutent réellement (Pyodide / moteur JS de la WebView) avec sortie console. HTML/CSS ont un aperçu visuel réel (WebView chargeant le HTML écrit). |
| US28 | Erreurs claires avec ligne + explication | ✅ | Traceback Python et erreur JS parsés pour extraire ligne + type d'erreur ; explication pédagogique associée à chaque type d'erreur connu (`friendly_error_explanations.dart`). |
| US29 | Auto-complétion + indentation automatique | ✅ | Fournies par `flutter_code_editor` (mots-clés du langage + mots déjà tapés, Tab/Shift-Tab). Barre de symboles dédiée (Tab, `{ } ( ) [ ] " ' : ; =`) en guise de "clavier adapté au code". |
| US30 | Sauvegarde automatique | ✅ | Un document Firestore par langage (`users/{uid}/codePlayground/{language}`), sauvegarde ~800 ms après une pause de frappe. |
| US31 | Coder hors-ligne | ✅ | Les runtimes Python/JS sont 100% embarqués (aucun réseau requis pour exécuter du code). La sauvegarde s'appuie sur le cache offline natif de Firestore (déjà actif dans l'app) qui synchronise automatiquement à la reconnexion. |

**Limite de test assumée :** `webview_flutter` n'a pas d'implémentation de
test (pas de "fake" comme pour Firebase) — toute la logique pure
(parsing d'erreurs, explications, sauvegarde) est couverte par des tests
automatisés, mais l'exécution réelle de code (Pyodide/JS/aperçu HTML) n'a
pu être vérifiée que manuellement sur simulateur, pas via `flutter test`.
Vérification manuelle effectuée : Python (Pyodide), JavaScript et l'aperçu
HTML produisent bien la sortie attendue sur simulateur iOS.

**Point technique rencontré :** charger les pages hôtes via
`WebViewController.loadFlutterAsset` fait échouer le chargement de Pyodide
sur iOS (`Cross-origin script load denied by Cross-Origin Resource Sharing
policy`) — le schéma d'URL personnalisé de `loadFlutterAsset` ne satisfait
pas les vérifications same-origin de WKWebView pour le chargement de
scripts dynamiques de Pyodide. Corrigé en servant les assets embarqués via
un petit serveur HTTP local (`LocalAssetServer`, `dart:io.HttpServer` lié à
`127.0.0.1`) : la WebView charge alors une vraie origine `http://` sans
sortir de l'appareil (iOS exempte les adresses loopback d'App Transport
Security, aucune modification d'Info.plist nécessaire).

## EP06 — Assistant IA pour le code (implémenté)

Décision validée avec l'utilisateur : l'assistant s'appuie sur **Gemini via
Firebase AI Logic** (`firebase_ai`), directement depuis le client Flutter —
pas de backend séparé à écrire, pas de clé API embarquée dans l'app.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US32 | Expliquer une portion de code | ✅ | Bouton « Expliquer ce code » ; le ton s'adapte au `codingLevel` du profil (`buildSystemInstruction`). |
| US33 | Aider à localiser un bug sans donner la solution | ✅ | Bouton « Trouver l'erreur » ; le prompt interdit explicitement de fournir le code corrigé complet. |
| US34 | Suggestions de refactorisation justifiées | ✅ | Bouton « Améliorer mon code » ; la réponse est parsée pour extraire un bloc de code proposé (`parseSuggestionResponse`). |
| US35 | Contrôle total sur les modifications suggérées | ✅ | Le code proposé n'est jamais appliqué automatiquement : une carte Accepter/Ignorer explicite est requise (`SuggestionCard`), et seul « Accepter » écrit dans le snippet sauvegardé. |
| US36 | Chat libre contextualisé, historique conservé | ✅ | Champ de question libre ; historique persisté par langage dans Firestore (`users/{uid}/codeAssistantChats/{language}`) et rejoué comme contexte de conversation Gemini à la reprise. |
| US37 | Réponses filtrées et adaptées aux enfants | ✅ | `SafetySetting`s Gemini réglés strictement + consigne système dédiée (sujets hors-programmation refusés poliment, ton bienveillant) ; si Gemini bloque une réponse, un message de repli fixe et révisé est affiché plutôt que de relayer un contenu potentiellement inapproprié. |

**Limite de test assumée :** `firebase_ai` n'a pas de "fake" testable (comme
`fake_cloud_firestore` pour Firestore) — l'appel réel à Gemini
(`FirebaseCodeAssistantClient`) est donc le seul maillon non couvert par
`flutter test`. Tout le reste (construction des prompts, extraction de la
suggestion, contrôleur, écran complet avec accepter/rejeter/chat) est
testé automatiquement en injectant un faux `CodeAssistantClient`.

**Bug détecté et corrigé pendant la vérification manuelle :** quand aucun
message n'existe encore et qu'une erreur générique survient (ex. Gemini
indisponible), l'écran affichait par erreur le texte d'accueil au lieu du
message d'erreur, masquant silencieusement l'échec — corrigé dans
`CodeAssistantScreen`, avec un test de non-régression dédié.

**Étape restant à la charge de l'utilisateur :** activer Firebase AI Logic
(API Gemini) dans la console Firebase du projet `learningkids-ac360` pour
que les appels réels fonctionnent ; sans cela, l'assistant affiche
poliment son message d'erreur générique au lieu de planter.

## EP07 — Projets & Portfolio (implémenté)

Décisions validées avec l'utilisateur : les captures d'écran des projets
publiés sont de petites miniatures encodées en base64 directement dans le
document Firestore du projet (pas de Firebase Storage à activer) ; le
partage du portfolio (US40) reste intra-app — un « code » (l'uid du
propriétaire) à saisir dans l'app, partagé via la feuille de partage
native — plutôt qu'une vraie page web publique hébergée, hors périmètre
Flutter pour cette session.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US38 | Créer un projet à partir d'un modèle guidé | ✅ | 6 modèles réels et fonctionnels (2 par langage : Python/JS/HTML), classés par niveau (`CodingLevel`) et catégorie. `ProjectTemplatesScreen`, filtrable par langage. |
| US39 | Publier ses projets dans un portfolio personnel | ✅ | `PortfolioScreen` liste les projets `isPublished`, avec une miniature capturée (`RepaintBoundary.toImage`) au moment de la publication. |
| US40 | Partager le lien de son portfolio, public/privé | ✅ | Bascule `portfolioPublic` sur le profil + bouton de partage natif (`share_plus`) une fois public ; un autre utilisateur consulte via « Voir le portfolio d'un ami » en saisissant le code. |
| US41 | Organiser ses projets par catégorie | ✅ | `ProjectCategory` (Jeu/Site/Outil), choisie à la création (héritée du modèle) et modifiable à tout moment ; filtre par catégorie dans « Mes projets ». |
| US42 | Retours automatisés de l'IA avant publication | ✅ | Bouton « Avis de l'IA » réutilisant Gemini/Firebase AI Logic (EP06) avec un prompt dédié : retour concret en 3 points max, jamais de code corrigé complet. |

**Sécurité :** `firestore.rules` a été mis à jour pour autoriser la lecture
d'un projet `users/{uid}/projects/{id}` par quelqu'un d'autre uniquement
si ce projet est `isPublished` **et** que le profil de son propriétaire a
`portfolioPublic == true` — tout le reste (écriture, projets non publiés,
portfolios privés) reste strictement réservé au propriétaire. **Ce fichier
de règles doit être déployé côté Firebase** (`firebase deploy --only
firestore:rules`) pour que le partage de portfolio fonctionne réellement ;
ce n'est pas fait automatiquement par ce travail.

**Limite de test assumée :** comme pour EP05/EP06, `webview_flutter` (aperçu
HTML en direct) et `firebase_ai` (avis IA réel) n'ont pas de double de
test ; vérifiés manuellement sur simulateur. Tout le reste (modèles,
projet, portfolio, contrôleurs, écrans complets avec navigation
create→édite→publie) est couvert par des tests automatisés, y compris la
capture de miniature via `tester.runAsync`.

## EP08 — Gamification & Motivation (implémenté)

Décisions validées avec l'utilisateur : le classement (US46) est **public et
global** (nouvelle collection Firestore `leaderboard/{uid}`, lisible par
tout utilisateur connecté), le certificat (US45) est une **image PNG**
capturée depuis un widget Flutter (même technique que les miniatures de
projets d'EP07) plutôt qu'un vrai PDF, et le rappel de streak (US43) reste
pour l'instant un **bandeau dans l'app** — la vraie notification push est
prévue avec EP11 (« Notifications & Rappels »).

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US43 | Streak de jours consécutifs | ✅ | `StreakBanner` sur l'écran d'accueil ; passe en alerte (bandeau jaune + message) dès que le streak est menacé. Rappel push reporté à EP11. |
| US44 | Badges automatiques | ✅ | 7 badges réels (leçons/streaks/projets), `BadgesScreen` avec état verrouillé/débloqué. |
| US45 | Certificat de fin de parcours | ✅ | `CertificateScreen`, accessible depuis la roadmap une fois tous les modules du parcours terminés (`isPathComplete`) ; capturé en PNG et partagé via la feuille de partage native — vérifié manuellement avec un vrai fichier de 73 Ko généré sur simulateur. |
| US46 | Classement | ✅ | `LeaderboardScreen`, classement global trié par XP, ligne du joueur mise en évidence. |
| US47 | Points d'expérience | ✅ | XP attribués une seule fois par activité (leçon terminée, projet publié — vérifié idempotent) ; niveau affiché dans le bandeau streak (100 XP/niveau). |
| US48 | Désactivation du classement public (parent) | ✅ | Bascule dans l'Espace Parent ; retire/republie immédiatement l'entrée `leaderboard/{uid}` — vérifié manuellement (l'enfant disparaît du classement dès la bascule). |

**Sécurité :** nouvelle règle Firestore top-level `leaderboard/{uid}` :
lecture ouverte à tout utilisateur connecté, écriture réservée au
propriétaire. **À déployer** (`firebase deploy --only firestore:rules`)
comme la règle EP07, sans quoi le classement restera vide en production.

**Bug de course corrigé pendant l'implémentation :** `GamificationController`
lisait `currentProfileProvider` avec `.valueOrNull` (pseudo/avatar
potentiellement pas encore chargés) au lieu d'attendre `.future` — même
piège déjà rencontré et documenté sur ce projet ; corrigé avant d'écrire
les tests, qui l'auraient sinon détecté de toute façon.

## EP09 — Suivi de progression & Tableau de bord (implémenté)

Construit entièrement à partir de données déjà suivies par EP03/EP05/EP07/EP08
— aucun nouveau système de tracking, sauf le score de quiz par module
ajouté pour US51.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US49 | Tableau de bord (leçons, temps, compétences) | ✅ | `DashboardScreen` : indicateurs clés (leçons/niveau, réutilise EP08), progression par parcours et par compétence (barres calculées depuis `LearningProgress` + `curriculumFor`), temps d'apprentissage (graphique hebdomadaire déjà utilisé par l'Espace Parent, désormais partagé via `WeeklyUsageChart`). |
| US50 | Résumé hebdomadaire | ✅ | Carte « Cette semaine » sur le tableau de bord — reste `consultable dans l'app` (pas de notification push, reportée à EP11). Repose sur une base glissante de 7 jours (`weekStartDate`/`xpAtWeekStart`/…) ajoutée à `GamificationProfile`, remise à zéro automatiquement. |
| US51 | Détection des points faibles | ✅ | Chaque module complété enregistre désormais son score de quiz (`quizScore_<moduleId>`) ; un module devient une « notion à retravailler » si son score passe sous 70 %, avec un lien direct « Revoir » vers la leçon. Approximation assumée : la granularité est le module entier, pas la question individuelle — le programme n'a pas de tag plus fin ("notion") que le module. |
| US52 | Objectif vs progression réelle | ✅ | Section « Ton objectif » : réutilise le parcours recommandé de l'onboarding (`UserProfile.recommendedPath` → `primaryPathFor`) et affiche sa progression réelle juste au-dessus des autres parcours actifs. |

**Limite de test assumée :** aucune — contrairement à EP05/06/07/08, rien
dans ce tableau de bord ne dépend de `webview_flutter` ou de `firebase_ai`.
Tout est couvert par des tests automatisés (domaine, dépôts, contrôleurs,
écran complet).

## EP10 — Collaboration & Outils développeurs modernes (implémenté)

Ajoute un 5ᵉ parcours (`LearningPath.collaboration`), indépendant des 4
parcours existants et non recommandé à l'onboarding — un parcours « bonus »
activable manuellement depuis l'écran Parcours, comme les autres.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US53 | Notions Git/GitHub + exercices pratiques simulés | ✅ | 2 modules (bases de Git, branches/GitHub) avec un simulateur Git (`GitSimulatorScreen`) : un scénario scripté et déterministe (init → add → commit → branch → push) où l'apprenant choisit la bonne commande à chaque étape, avec un « journal » qui explique ce qui se passe. Simulé au sens littéral du cahier des charges — pas un vrai terminal ni une vraie intégration Git. |
| US54 | Bonnes pratiques (revue de code, tests, CI/CD) | ✅ | 2 modules supplémentaires (contenu texte uniquement, pas d'exercice pratique associé) : revue de code + tests automatiques, puis intégration/déploiement continu (CI/CD). |
| US55 | Partager un extrait de code avec un ami/mentor | ✅ | Lien partageable au sens d'un « code » à saisir (comme le portfolio EP07), pas un deep-link cliquable : nouvelle collection Firestore `sharedSnippets` (id auto-généré), lisible par tout utilisateur connecté qui a le code, écrite uniquement par son auteur. Bouton « Partager avec un ami » dans l'espace de code (ouvre la feuille de partage iOS/Android) + bouton « Voir un code partagé » dans la barre d'app pour saisir un code reçu. |
| US56 | Défi de collaboration hebdomadaire + classement dédié | ✅ | Défi hebdomadaire léger (pas de collaboration temps réel, pas de correction automatique) : un même énoncé fixe pour tout le monde chaque semaine (`challengeForWeek`, calculé à partir du numéro de semaine ISO-8601), marqué comme relevé par auto-déclaration. Nouvelle collection Firestore `challengeParticipants` (un doc par apprenant et par semaine) alimentant un classement dédié réutilisant le style visuel du classement XP d'EP08. |

**Limite de test assumée :** aucune — comme EP09, rien dans cet epic ne
dépend de `webview_flutter` ou `firebase_ai` (le simulateur Git, l'espace
de code partagé et le défi hebdomadaire sont du Flutter/Firestore pur).
Tout est couvert par des tests automatisés (domaine, dépôts, contrôleurs,
écrans).

**Bloquant côté configuration Firebase (pas du code) avant test réel en
prod :** les nouvelles règles `sharedSnippets` et `challengeParticipants`
dans `firestore.rules` doivent être déployées
(`firebase deploy --only firestore:rules`), sans quoi ces deux
fonctionnalités échoueront silencieusement en production.

## EP11 — Notifications & Rappels (implémenté)

Le cahier des charges parle de « notification push », mais ce projet n'a
aucun backend/Cloud Functions (choix validé avec l'utilisateur). Tout est
donc géré par des notifications **locales** (`flutter_local_notifications`),
programmées ou déclenchées directement par l'app sur l'appareil — pas un
vrai push serveur.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US57 | Rappel quotidien configurable | ✅ | Notification locale programmée chaque jour à une heure choisie (18h par défaut), activable/désactivable et reprogrammée à chaque lancement de l'app (au cas où l'OS l'aurait perdue). Repose sur la permission système, redemandée (sans re-prompt si déjà répondue) à chaque activation. |
| US58 | Notification à chaque récompense (badge/certificat/niveau) | ✅ | `RewardNotifier`, appelé par `GamificationController` (badge/niveau) et `LearningProgressController` (certificat, dès que le dernier module d'un parcours est complété) — déclenchement immédiat, pas de planification nécessaire puisque l'app sait déjà que la récompense vient d'être gagnée. |
| US59 | Préférences de notifications | ✅ | `NotificationSettingsScreen` (accessible depuis Profil) : bascule indépendante pour le rappel quotidien (+ choix de l'heure) et pour les notifications de récompenses. Préférences stockées localement (`LocalPreferences`/SharedPreferences), pas dans Firestore : elles sont propres à cet appareil. |

**Limite de test assumée :** comme `webview_flutter`/`firebase_ai`,
`flutter_local_notifications` n'a pas de double de test pour ses canaux de
plateforme — `NotificationService` (le seul fichier qui le touche
directement) est donc volontairement fin et non testé unitairement ; toute
la logique testable (calcul de la prochaine occurrence, préférences,
gating des notifications de récompense, écran de réglages) passe par une
interface (`FakeNotificationService`) et est bien couverte.

**Bloquant côté configuration native (déjà fait dans ce commit, à vérifier
en cas de futur `flutter create`/upgrade) :** `AppDelegate.swift` déclare le
`UNUserNotificationCenter` comme délégué (nécessaire pour afficher une
notification pendant que l'app est ouverte), et `AndroidManifest.xml`
déclare `POST_NOTIFICATIONS` (Android 13+).

## EP12 — Administration & Gestion de contenu (back-office) (allégé)

Choix validé avec l'utilisateur : back-office **allégé**, avec les limites
documentées ci-dessous, plutôt qu'un vrai backend (Cloud Functions/Admin
SDK) ou l'abandon complet de l'epic. Nouveau rôle admin simple : un doc
`admins/{uid}` (existence = admin), **seedé manuellement depuis la
console Firebase** — il n'y a aucun moyen de le créer depuis l'app,
volontairement, puisque rien ne peut sécuriser qui a le droit d'écrire
cette collection sans un vrai backend.

| US | Résumé | Statut | Notes |
|----|--------|--------|-------|
| US60 | Créer/publier des leçons via back-office | ⬜ | Hors périmètre assumé : tout le contenu pédagogique (EP03) est du Dart statique, testé et versionné — pas un CMS. Migrer vers un contenu éditable depuis l'app demanderait de reconstruire cette base entière ; explicitement exclu par le choix ci-dessus. |
| US61 | File de modération (portfolio) | ✅ | Bouton « Signaler » (icône drapeau) sur chaque projet du portfolio d'un autre apprenant → crée un document dans `moderationReports`. `ModerationQueueScreen` (admin) liste les signalements en attente avec Accepter (classe sans suite) / Rejeter (dépublie le projet via `AdminRepository.unpublishProject` + ferme le signalement). Pas de « commentaires » à modérer : cette fonctionnalité n'existe pas dans l'app. |
| US62 | Statistiques globales (rétention, complétion) | ⬜ | Hors périmètre assumé : une vraie stat globale (tous utilisateurs confondus) demande une agrégation côté serveur (Cloud Functions/BigQuery) — la calculer côté client impliquerait de lire les documents de tous les utilisateurs, impossible avec les règles de sécurité actuelles (et une mauvaise idée même si ça l'était). |
| US63 | Gestion des comptes (suspension, support) | ✅ | `AccountManagementScreen` (admin) : liste tous les comptes (nouvelle collection miroir `accountDirectory`, alimentée par `ProfileRepository` comme le `leaderboard`), bascule de suspension, note de support interne. La « suspension » est une approximation côté client (`accountStatus/{uid}`) qui bloque l'app via le router (`AccountSuspendedScreen`) — **pas** une vraie désactivation du compte Firebase Auth, qui demanderait l'Admin SDK. |

**Sécurité des nouvelles collections (`firestore.rules`) :** `admins/{uid}`
lisible seulement par soi-même, jamais écrit depuis le client ;
`accountDirectory/{uid}` écrit par son propriétaire, lu seulement par un
admin ; `accountStatus/{uid}` lu par son propriétaire ou un admin, écrit
seulement par un admin (piège évité pendant l'implémentation : la
première version lisait toute la collection `accountStatus` juste pour
vérifier son propre statut, ce qu'un non-admin n'a pas le droit de faire —
détecté par un test qui restait bloqué indéfiniment ; corrigé en lisant
uniquement `accountStatus/{monUid}`) ; `supportNotes/{uid}` entièrement
réservé aux admins (jamais lisible par le propriétaire du compte) ;
`moderationReports` : création par n'importe quel apprenant connecté (pour
son propre signalement), lecture/mise à jour réservées aux admins.

**Bloquant côté configuration Firebase (pas du code) avant test réel en
prod :** comme pour EP01 (providers Google/Apple), il faut créer
manuellement un document `admins/{votre-uid}` depuis la console Firebase
pour accéder au back-office — aucun compte n'est admin par défaut.

## EP13 — Paramètres, Accessibilité & Multi-langue
⬜ US64 · ⬜ US65 · ⬜ US66
