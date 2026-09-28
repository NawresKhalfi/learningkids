import '../../../core/theme/app_colors.dart';
import 'learning_path.dart';

/// Display metadata for a [LearningPath] (title, one-line pitch, emoji and
/// card colour) — kept separate from the enum so presentation concerns
/// don't leak into the domain layer's other consumers (curriculum lookup,
/// progress tracking).
class LearningPathInfo {
  const LearningPathInfo({
    required this.title,
    required this.description,
    required this.emoji,
    required this.palette,
  });

  final String title;
  final String description;
  final String emoji;
  final CardPalette palette;
}

LearningPathInfo learningPathInfo(LearningPath path) {
  switch (path) {
    case LearningPath.frontEnd:
      return const LearningPathInfo(
        title: 'Front-End',
        description:
            'HTML, CSS, JavaScript et React pour construire des pages web.',
        emoji: '🎨',
        palette: AppColors.cardBlue,
      );
    case LearningPath.python:
      return const LearningPathInfo(
        title: 'Python',
        description:
            'Les bases de la programmation avec un langage simple à lire.',
        emoji: '🐍',
        palette: AppColors.cardGreen,
      );
    case LearningPath.mobile:
      return const LearningPathInfo(
        title: 'Développement mobile',
        description:
            'Flutter et Dart pour créer des applications sur téléphone.',
        emoji: '📱',
        palette: AppColors.cardBlue,
      );
    case LearningPath.fullStack:
      return const LearningPathInfo(
        title: 'Full-Stack',
        description:
            'Node.js, SQL et TypeScript pour construire une app complète.',
        emoji: '🧩',
        palette: AppColors.cardPurple,
      );
    case LearningPath.backend:
      return const LearningPathInfo(
        title: 'Backend + IA',
        description:
            'API, bases de données, sécurité et bonnes pratiques avec l\'IA.',
        emoji: '🤖',
        palette: AppColors.cardOrange,
      );
    case LearningPath.collaboration:
      return const LearningPathInfo(
        title: 'Collaboration',
        description:
            'Git, GitHub et les outils utilisés par les développeurs en équipe.',
        emoji: '🤝',
        palette: AppColors.cardPink,
      );
  }
}
