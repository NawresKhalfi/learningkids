/// One step of the simulated Git exercise (EP10/US53): a scripted
/// scenario, not a real Git integration — the learner picks the right
/// command from a short list and sees a plain-language description of
/// what would happen to their project.
class GitSimulatorStep {
  const GitSimulatorStep({
    required this.instruction,
    required this.commandOptions,
    required this.correctCommand,
    required this.resultDescription,
  });

  final String instruction;
  final List<String> commandOptions;
  final String correctCommand;
  final String resultDescription;
}

/// A single guided scenario covering the everyday Git commands named in
/// the backlog: init, add, commit, branch, push.
const gitSimulatorScenario = <GitSimulatorStep>[
  GitSimulatorStep(
    instruction:
        'Tu viens de créer un nouveau dossier pour ton projet. Quelle commande le transforme en dépôt Git ?',
    commandOptions: ['git init', 'git status', 'git clone'],
    correctCommand: 'git init',
    resultDescription: '📁 Dépôt Git créé ! Git peut maintenant suivre les changements dans ce dossier.',
  ),
  GitSimulatorStep(
    instruction: 'Tu as créé un fichier index.html. Quelle commande dit à Git de commencer à le suivre ?',
    commandOptions: ['git add index.html', 'git commit index.html', 'git push index.html'],
    correctCommand: 'git add index.html',
    resultDescription: '✅ index.html est prêt à être enregistré (zone de préparation).',
  ),
  GitSimulatorStep(
    instruction: 'Tu veux enregistrer cette version de ton projet avec un message. Quelle commande utiliser ?',
    commandOptions: ["git commit -m 'Première version'", 'git save', 'git add -m'],
    correctCommand: "git commit -m 'Première version'",
    resultDescription: "📸 Un instantané de ton projet est enregistré dans l'historique !",
  ),
  GitSimulatorStep(
    instruction:
        'Tu veux essayer une nouvelle fonctionnalité sans casser ton code actuel. Quelle commande crée une '
        'nouvelle branche ?',
    commandOptions: ['git branch nouvelle-fonctionnalite', 'git fork', 'git copy'],
    correctCommand: 'git branch nouvelle-fonctionnalite',
    resultDescription: '🌿 Une nouvelle branche existe : tu peux expérimenter sans risque !',
  ),
  GitSimulatorStep(
    instruction: 'Ta nouvelle fonctionnalité marche bien ! Comment l\'envoyer sur GitHub pour la partager ?',
    commandOptions: ['git push', 'git pull', 'git delete'],
    correctCommand: 'git push',
    resultDescription: "🚀 Ton code est en ligne sur GitHub, prêt à être vu par d'autres !",
  ),
];
