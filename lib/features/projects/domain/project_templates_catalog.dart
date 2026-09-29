import '../../code_playground/domain/programming_language.dart';
import '../../onboarding/domain/coding_level.dart';
import '../../learning_path/domain/learning_path.dart';
import 'project_category.dart';
import 'project_template.dart';

/// The guided project starting points offered for US38, spanning every
/// language/category/level combination the catalog needs to feel
/// meaningfully "classée par niveau et par langage". Each template is
/// working, runnable code — not a placeholder — chosen to avoid `input()`
/// or DOM events the Code Playground/preview can't drive interactively
/// (the HTML landing page's button click is the one exception, since the
/// live preview is a real WebView that does handle taps).
const projectTemplatesCatalog = <ProjectTemplate>[
  ProjectTemplate(
    id: 'python-dice-game',
    title: 'Le lancer de dé magique',
    description:
        'Un petit jeu qui simule des lancers de dé et affiche les résultats.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.beginner,
    category: ProjectCategory.game,
    starterCode: '''
import random

print("🎲 Le jeu du lancer de dé magique !")
lancers = 5
resultats = []

for i in range(lancers):
    de = random.randint(1, 6)
    resultats.append(de)
    print(f"Lancer {i + 1} : {de}")

print("\\nRésultats :", resultats)
print("Total :", sum(resultats))
print("Meilleur lancer :", max(resultats))
''',
  ),
  ProjectTemplate(
    id: 'python-temperature-converter',
    title: 'Convertisseur de températures',
    description:
        'Transforme une liste de températures en Celsius vers des Fahrenheit.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.someBasics,
    category: ProjectCategory.tool,
    starterCode: '''
temperatures_celsius = [0, 10, 20, 30, 37, 100]

print("Température (°C) -> (°F)")
for celsius in temperatures_celsius:
    fahrenheit = celsius * 9 / 5 + 32
    print(f"{celsius}°C -> {fahrenheit}°F")
''',
  ),
  ProjectTemplate(
    id: 'javascript-random-activity',
    title: 'Machine à idées d\'activités',
    description: 'Tire au sort une activité amusante à faire aujourd\'hui.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.beginner,
    category: ProjectCategory.game,
    starterCode: '''
const activites = [
  "Dessiner un robot",
  "Inventer une histoire",
  "Faire 10 sauts",
  "Chanter une chanson",
  "Construire une tour",
];

const choisie = activites[Math.floor(Math.random() * activites.length)];
console.log("Activité du jour :");
console.log(choisie);
''',
  ),
  ProjectTemplate(
    id: 'javascript-tip-calculator',
    title: 'Calculatrice de pourboire',
    description: 'Calcule le pourboire et le total à payer pour une addition.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.someBasics,
    category: ProjectCategory.tool,
    starterCode: '''
const addition = 24.5;
const pourcentagePourboire = 10;

const pourboire = addition * (pourcentagePourboire / 100);
const total = addition + pourboire;

console.log(`Addition : \${addition.toFixed(2)} €`);
console.log(`Pourboire (\${pourcentagePourboire}%) : \${pourboire.toFixed(2)} €`);
console.log(`Total à payer : \${total.toFixed(2)} €`);
''',
  ),
  ProjectTemplate(
    id: 'html-profile-card',
    title: 'Carte de présentation',
    description:
        'Une petite carte de profil à personnaliser avec ton prénom et tes goûts.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.beginner,
    category: ProjectCategory.website,
    path: LearningPath.frontEnd,
    starterCode: '''
<!DOCTYPE html>
<html>
<head>
<style>
  body { font-family: sans-serif; background: #FBF1E2; display: flex; justify-content: center; padding-top: 40px; }
  .card { background: white; border: 3px solid #241F47; border-radius: 20px; padding: 24px; width: 260px; text-align: center; }
  .avatar { font-size: 64px; }
  h2 { color: #241F47; margin: 8px 0 4px; }
  p { color: #6E6580; }
</style>
</head>
<body>
  <div class="card">
    <div class="avatar">🧑‍💻</div>
    <h2>Ton prénom</h2>
    <p>Apprenti(e) codeur(euse)</p>
    <p>J'aime : les jeux vidéo, les chats, coder !</p>
  </div>
</body>
</html>
''',
  ),
  ProjectTemplate(
    id: 'html-landing-page',
    title: 'Mini-site personnel',
    description:
        'Une page d\'accueil avec plusieurs sections et un bouton interactif.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.website,
    starterCode: '''
<!DOCTYPE html>
<html>
<head>
<style>
  body { font-family: sans-serif; margin: 0; background: #FBF1E2; }
  header { background: #4C5FD9; color: white; padding: 24px; text-align: center; }
  section { padding: 24px; }
  .card { background: white; border: 2px solid #241F47; border-radius: 16px; padding: 16px; margin-bottom: 12px; }
  button { background: #F6C445; border: 2px solid #241F47; border-radius: 12px; padding: 10px 16px; font-weight: bold; }
</style>
</head>
<body>
  <header>
    <h1>Mon Mini-Site</h1>
    <p>Bienvenue sur ma page !</p>
  </header>
  <section>
    <div class="card">
      <h3>À propos</h3>
      <p>Ceci est mon tout premier mini-site fait avec du HTML et du CSS.</p>
    </div>
    <div class="card">
      <h3>Clique pour voir la magie</h3>
      <button onclick="document.getElementById('message').innerText='✨ Bravo, tu as cliqué ! ✨'">
        Clique ici
      </button>
      <p id="message"></p>
    </div>
  </section>
</body>
</html>
''',
  ),
  ProjectTemplate(
    id: 'frontend-portfolio-interactive',
    title: 'Portfolio interactif',
    description:
        'Présente tes compétences avec des cartes et un filtre en JavaScript.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.website,
    starterCode: '''
<!doctype html>
<style>
body { font-family: sans-serif; background:#fff4e4; color:#241f47; max-width:760px; margin:auto; padding:32px; }
button { border:2px solid #241f47; border-radius:12px; padding:10px; background:#fff; margin-right:8px; }
.project { background:#fff; border-radius:16px; padding:16px; margin-top:12px; }
</style>
<h1>Mon portfolio</h1>
<button onclick="filtrer('web')">Web</button><button onclick="filtrer('jeu')">Jeux</button>
<div class="project web">🌐 Site pour un club</div><div class="project jeu">🎮 Mini jeu</div>
<script>
function filtrer(type) { document.querySelectorAll('.project').forEach(p => p.hidden = !p.classList.contains(type)); }
</script>
''',
  ),
  ProjectTemplate(
    id: 'frontend-task-board',
    title: 'Tableau de tâches',
    description:
        'Crée un mini tableau Kanban avec ajout de tâches et compteur.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.frontEnd,
    starterCode: '''
<!doctype html><style>body{font-family:sans-serif;padding:24px;background:#fff4e4}input,button{padding:10px;border-radius:10px;border:2px solid #241f47}li{margin:8px}</style>
<h1>Mes tâches <span id="count">0</span></h1><input id="task" placeholder="Nouvelle tâche"><button onclick="add()">Ajouter</button><ul id="list"></ul>
<script>function add(){const text=task.value.trim();if(!text)return;list.innerHTML+=`<li><input type="checkbox"> \${text}</li>`;task.value='';count.textContent=list.children.length}</script>
''',
  ),
  ProjectTemplate(
    id: 'frontend-weather-dashboard',
    title: 'Dashboard météo',
    description:
        'Mets en page des données météo réactives avec une interface soignée.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.website,
    path: LearningPath.frontEnd,
    starterCode: '''
<!doctype html><style>body{font-family:sans-serif;background:linear-gradient(#86d8ff,#fff4e4);min-height:100vh;padding:30px}.card{background:#fff;border-radius:24px;padding:24px;max-width:360px;box-shadow:0 6px 20px #0002}.temp{font-size:64px}</style>
<main class="card"><h1>☀️ Tunis</h1><div class="temp" id="temp">27°</div><p id="detail">Ensoleillé · Vent léger</p><button onclick="changer()">Actualiser</button></main>
<script>function changer(){temp.textContent=(20+Math.floor(Math.random()*12))+'°';detail.textContent='Mis à jour à '+new Date().toLocaleTimeString()}</script>
''',
  ),
  ProjectTemplate(
    id: 'frontend-memory-game',
    title: 'Jeu de mémoire Web',
    description: 'Programme des cartes à retourner et un score de partie.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.game,
    path: LearningPath.frontEnd,
    starterCode: '''
<!doctype html><style>body{font-family:sans-serif;text-align:center;background:#fff4e4}.grid{display:grid;grid-template-columns:repeat(4,70px);gap:10px;justify-content:center}.card{height:70px;border:2px solid #241f47;border-radius:14px;background:#8d50f4;font-size:32px}</style>
<h1>Jeu de mémoire</h1><p>Score : <span id="score">0</span></p><div class="grid" id="grid"></div>
<script>const icons=['🐱','🦊','🐼','🐸','🐱','🦊','🐼','🐸'];let open=[];icons.sort(()=>Math.random()-.5).forEach(i=>{let b=document.createElement('button');b.className='card';b.onclick=()=>{if(open.includes(b))return;b.textContent=i;open.push(b);if(open.length==2){if(open[0].textContent==open[1].textContent)score.textContent++;else setTimeout(()=>open.forEach(x=>x.textContent=''),500);open=[]}};grid.append(b)})</script>
''',
  ),
  ProjectTemplate(
    id: 'frontend-accessible-form',
    title: 'Formulaire accessible',
    description:
        'Construis un formulaire avec validation et messages compréhensibles.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.frontEnd,
    starterCode: '''
<!doctype html><style>body{font-family:sans-serif;max-width:480px;margin:auto;padding:30px}input,button{display:block;width:100%;box-sizing:border-box;padding:10px;margin:8px 0}.error{color:#b00020}</style>
<h1>Inscription à la newsletter</h1><label for="email">Adresse e-mail</label><input id="email" type="email" aria-describedby="message"><p class="error" id="message" role="alert"></p><button onclick="envoyer()">S'inscrire</button>
<script>function envoyer(){message.textContent=email.validity.valid?'Merci, inscription réussie !':'Entre une adresse e-mail valide.'}</script>
''',
  ),
  ProjectTemplate(
    id: 'mobile-habit-tracker',
    title: 'Suivi d’habitudes mobile',
    description:
        'Modélise les habitudes, les séries et le résumé quotidien en Dart.',
    language: ProgrammingLanguage.dart,
    level: CodingLevel.someBasics,
    category: ProjectCategory.tool,
    path: LearningPath.mobile,
    starterCode: '''
class Habit { Habit(this.name, this.done); final String name; bool done; }
void main() {
  final habits = [Habit('Lire 10 min', true), Habit('Coder', false)];
  final completed = habits.where((habit) => habit.done).length;
  print('Habitudes terminées : ' + completed.toString() + '/' + habits.length.toString());
}
''',
  ),
  ProjectTemplate(
    id: 'mobile-budget-planner',
    title: 'Planificateur de budget',
    description:
        'Calcule un budget et organise des dépenses dans une application Dart.',
    language: ProgrammingLanguage.dart,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.mobile,
    starterCode: '''
class Expense { const Expense(this.label, this.amount); final String label; final double amount; }
void main() {
  const budget = 80.0;
  const expenses = [Expense('Livre', 12), Expense('Bus', 8.5), Expense('Goûter', 6)];
  final spent = expenses.fold<double>(0, (sum, item) => sum + item.amount);
  final remaining = budget - spent;
  print('Reste : ' + remaining.toStringAsFixed(2) + ' €');
}
''',
  ),
  ProjectTemplate(
    id: 'mobile-quiz-engine',
    title: 'Moteur de quiz mobile',
    description:
        'Crée la logique d’un quiz réutilisable pour une future interface Flutter.',
    language: ProgrammingLanguage.dart,
    level: CodingLevel.comfortable,
    category: ProjectCategory.game,
    path: LearningPath.mobile,
    starterCode: '''
class Question { const Question(this.prompt, this.answer); final String prompt; final String answer; }
void main() {
  const question = Question('Quel widget affiche du texte ?', 'Text');
  const response = 'Text';
  print(response == question.answer ? 'Bonne réponse !' : 'Essaie encore.');
}
''',
  ),
  ProjectTemplate(
    id: 'mobile-offline-notes',
    title: 'Notes hors connexion',
    description:
        'Prépare le modèle de données d’une application de notes synchronisable.',
    language: ProgrammingLanguage.dart,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.mobile,
    starterCode: '''
class Note {
  Note(this.id, this.content, this.updatedAt);
  final String id;
  String content;
  DateTime updatedAt;
  void update(String value) { content = value; updatedAt = DateTime.now(); }
}
void main() { final note = Note('1', 'Idée de projet', DateTime.now()); note.update('Idée synchronisée'); print(note.content); }
''',
  ),
  ProjectTemplate(
    id: 'mobile-weather-state',
    title: 'État météo réactif',
    description:
        'Structure les états chargement, succès et erreur d’un écran mobile.',
    language: ProgrammingLanguage.dart,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.mobile,
    starterCode: '''
sealed class WeatherState { const WeatherState(); }
class Loading extends WeatherState { const Loading(); }
class Success extends WeatherState { const Success(this.celsius); final int celsius; }
class Failure extends WeatherState { const Failure(this.message); final String message; }
void main() { const state = Success(26); switch (state) { case Success(:final celsius): print(celsius.toString() + '°C'); default: print('Météo indisponible'); } }
''',
  ),
  ProjectTemplate(
    id: 'game-space-dodger',
    title: 'Esquive spatiale',
    description:
        'Programme la logique d’un jeu où un vaisseau évite des obstacles.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.someBasics,
    category: ProjectCategory.game,
    path: LearningPath.game,
    starterCode: '''
const player = { x: 5, lives: 3 };
const meteors = [2, 8, 5];
const nextPosition = 6;
if (meteors.includes(nextPosition)) {
  player.lives--;
  console.log('Impact ! Vies :', player.lives);
} else {
  player.x = nextPosition;
  console.log('Position sûre :', player.x);
}
''',
  ),
  ProjectTemplate(
    id: 'game-turn-battle',
    title: 'Combat au tour par tour',
    description: 'Gère points de vie, attaques et victoire d’un combat.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.comfortable,
    category: ProjectCategory.game,
    path: LearningPath.game,
    starterCode: '''
const hero = { name: 'Byte', hp: 20, attack: 6 };
const monster = { name: 'Bug', hp: 15 };
while (hero.hp > 0 && monster.hp > 0) {
  monster.hp -= hero.attack;
  console.log(hero.name + ' attaque : ' + monster.hp + ' HP');
  if (monster.hp > 0) hero.hp -= 3;
}
console.log(monster.hp <= 0 ? 'Victoire !' : 'Réessaie !');
''',
  ),
  ProjectTemplate(
    id: 'game-level-generator',
    title: 'Générateur de niveau',
    description:
        'Crée une carte simple et reproductible à partir d’une graine.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.comfortable,
    category: ProjectCategory.game,
    path: LearningPath.game,
    starterCode: '''
let seed = 42;
function random() { seed = (seed * 1664525 + 1013904223) % 4294967296; return seed / 4294967296; }
const tiles = Array.from({ length: 12 }, () => random() > 0.72 ? '🪨' : '🌿');
console.log('Niveau :', tiles.join(' '));
console.log('Même graine = même niveau');
''',
  ),
  ProjectTemplate(
    id: 'game-scoreboard',
    title: 'Classement de joueurs',
    description:
        'Trie un classement et attribue des médailles aux meilleurs scores.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.game,
    starterCode: '''
const players = [{ name: 'Sam', score: 120 }, { name: 'Lina', score: 180 }, { name: 'Noé', score: 145 }];
players.sort((a, b) => b.score - a.score);
players.forEach((player, index) => console.log(['🥇', '🥈', '🥉'][index] + ' ' + player.name + ' — ' + player.score));
''',
  ),
  ProjectTemplate(
    id: 'game-dialogue-tree',
    title: 'Arbre de dialogue',
    description: 'Fais évoluer une aventure selon les choix du joueur.',
    language: ProgrammingLanguage.javascript,
    level: CodingLevel.comfortable,
    category: ProjectCategory.game,
    path: LearningPath.game,
    starterCode: '''
const scenes = {
  start: { text: 'Une porte mystérieuse apparaît.', choices: { entrer: 'treasure', fuir: 'forest' } },
  treasure: { text: 'Tu trouves un trésor !', choices: {} },
  forest: { text: 'Tu rencontres un renard.', choices: {} },
};
const choice = 'entrer';
console.log(scenes.start.text);
console.log('Choix : ' + choice + ' → ' + scenes[scenes.start.choices[choice]].text);
''',
  ),
  ProjectTemplate(
    id: 'ai-rule-recommender',
    title: 'Recommandeur de défis',
    description: 'Propose un défi de code selon le niveau et les intérêts.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.someBasics,
    category: ProjectCategory.tool,
    path: LearningPath.backend,
    starterCode:
        "def recommend(level, likes_games):\n    if level == 'débutant':\n        return 'Crée une carte de profil en HTML'\n    return 'Programme un compteur de score' if likes_games else 'Construis une liste de tâches'\n\nprint(recommend('intermédiaire', True))",
  ),
  ProjectTemplate(
    id: 'ai-sentiment-analyzer',
    title: 'Analyseur de sentiment',
    description: 'Découvre une IA explicable avec un classifieur de mots-clés.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.backend,
    starterCode:
        "positive = {'super', 'génial', 'bravo', 'amusant'}\nnegative = {'triste', 'lent', 'difficile', 'bug'}\nmessage = 'Ce défi est génial mais difficile'\nwords = set(message.lower().split())\nscore = len(words & positive) - len(words & negative)\nprint('positif' if score > 0 else 'négatif' if score < 0 else 'neutre')",
  ),
  ProjectTemplate(
    id: 'ai-data-cleaner',
    title: 'Nettoyeur de données',
    description:
        'Prépare des données fiables avant leur utilisation par un modèle.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.backend,
    starterCode:
        "raw_scores = [' 12 ', '8', '', 'inconnu', '19']\nclean_scores = [int(value.strip()) for value in raw_scores if value.strip().isdigit()]\nprint('Scores valides :', clean_scores)\nprint('Moyenne :', sum(clean_scores) / len(clean_scores))",
  ),
  ProjectTemplate(
    id: 'ai-safe-chat-filter',
    title: 'Filtre de discussion sûr',
    description: 'Détecte des messages à vérifier avant leur publication.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.backend,
    starterCode:
        "blocked_words = {'insulte', 'secret'}\nmessage = 'Voici mon idée de jeu amusant'\nneeds_review = any(word in message.lower() for word in blocked_words)\nprint('À vérifier par un adulte' if needs_review else 'Message accepté')",
  ),
  ProjectTemplate(
    id: 'ai-model-evaluator',
    title: 'Évaluateur de modèle',
    description: 'Calcule précision et erreurs à partir de prédictions test.',
    language: ProgrammingLanguage.python,
    level: CodingLevel.comfortable,
    category: ProjectCategory.tool,
    path: LearningPath.backend,
    starterCode:
        "expected = ['chat', 'chien', 'chat', 'lapin']\npredicted = ['chat', 'chien', 'lapin', 'lapin']\ncorrect = sum(real == guess for real, guess in zip(expected, predicted))\nprint('Précision :', round(correct / len(expected) * 100), '%')\nprint('Erreurs :', [(real, guess) for real, guess in zip(expected, predicted) if real != guess])",
  ),
];
