/// The activities that earn experience points (US47). Kept to the two
/// milestones the app already tracks elsewhere (a completed lesson, a
/// published project) so awarding XP never needs a new source of truth —
/// just a call from the existing completion/publish flows.
enum GamificationActivity { lessonCompleted, projectPublished }

int xpForActivity(GamificationActivity activity) => switch (activity) {
  GamificationActivity.lessonCompleted => 20,
  GamificationActivity.projectPublished => 30,
};
