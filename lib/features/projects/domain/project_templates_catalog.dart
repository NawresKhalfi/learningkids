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
];
