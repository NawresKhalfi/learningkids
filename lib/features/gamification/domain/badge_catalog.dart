import 'badge_definition.dart';
import 'gamification_profile.dart';

bool _hasLessons1(GamificationProfile p) => p.lessonsCompletedCount >= 1;
bool _hasLessons5(GamificationProfile p) => p.lessonsCompletedCount >= 5;
bool _hasLessons15(GamificationProfile p) => p.lessonsCompletedCount >= 15;
bool _hasStreak3(GamificationProfile p) => p.streak.longest >= 3;
bool _hasStreak7(GamificationProfile p) => p.streak.longest >= 7;
bool _hasProjects1(GamificationProfile p) => p.projectsPublishedCount >= 1;
bool _hasProjects3(GamificationProfile p) => p.projectsPublishedCount >= 3;

/// Every badge a learner can unlock (US44), spanning the three milestone
/// families named in the backlog: lessons, streaks, projects.
const badgeCatalog = <BadgeDefinition>[
  BadgeDefinition(
    id: 'first-lesson',
    title: 'Premiers pas',
    description: 'Termine ta première leçon.',
    emoji: '🌱',
    isUnlocked: _hasLessons1,
  ),
  BadgeDefinition(
    id: 'five-lessons',
    title: 'Sur la lancée',
    description: 'Termine 5 leçons.',
    emoji: '🚀',
    isUnlocked: _hasLessons5,
  ),
  BadgeDefinition(
    id: 'fifteen-lessons',
    title: 'Codeur assidu',
    description: 'Termine 15 leçons.',
    emoji: '🏆',
    isUnlocked: _hasLessons15,
  ),
  BadgeDefinition(
    id: 'streak-3',
    title: 'Trois jours de suite',
    description: 'Apprends 3 jours d\'affilée.',
    emoji: '🔥',
    isUnlocked: _hasStreak3,
  ),
  BadgeDefinition(
    id: 'streak-7',
    title: 'Semaine complète',
    description: 'Apprends 7 jours d\'affilée.',
    emoji: '⭐',
    isUnlocked: _hasStreak7,
  ),
  BadgeDefinition(
    id: 'first-project',
    title: 'Créateur·rice',
    description: 'Publie ton premier projet dans ton portfolio.',
    emoji: '🎨',
    isUnlocked: _hasProjects1,
  ),
  BadgeDefinition(
    id: 'three-projects',
    title: 'Portfolio garni',
    description: 'Publie 3 projets dans ton portfolio.',
    emoji: '💼',
    isUnlocked: _hasProjects3,
  ),
];
