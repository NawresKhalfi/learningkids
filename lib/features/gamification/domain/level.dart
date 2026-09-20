/// A simple, predictable level curve for US47: 100 XP per level, starting
/// at level 1. No exponential ramp — the goal is a legible progress bar
/// for kids, not a min-maxing curve.
const xpPerLevel = 100;

int levelForXp(int totalXp) => (totalXp ~/ xpPerLevel) + 1;

/// XP already earned within the current level (0..99).
int xpIntoCurrentLevel(int totalXp) => totalXp % xpPerLevel;

/// XP still needed to reach the next level.
int xpToNextLevel(int totalXp) => xpPerLevel - xpIntoCurrentLevel(totalXp);
