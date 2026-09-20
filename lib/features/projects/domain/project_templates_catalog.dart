import '../../code_playground/domain/programming_language.dart';
import '../../onboarding/domain/coding_level.dart';
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
    description: 'Un petit jeu qui simule des lancers de dé et affiche les résultats.',
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
    description: 'Transforme une liste de températures en Celsius vers des Fahrenheit.',
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
    description: 'Une petite carte de profil à personnaliser avec ton prénom et tes goûts.',
    language: ProgrammingLanguage.html,
    level: CodingLevel.beginner,
    category: ProjectCategory.website,
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
    description: 'Une page d\'accueil avec plusieurs sections et un bouton interactif.',
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
];
