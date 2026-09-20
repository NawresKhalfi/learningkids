import 'gamification_profile.dart';

/// This week's deltas over the profile's rolling 7-day baseline (US50):
/// "this week" means the last 7 days, reset automatically once a full week
/// passes — see `shouldResetWeekBaseline`, applied in
/// `GamificationRepository.recordActivity`.
class WeeklySummary {
  const WeeklySummary({required this.xpThisWeek, required this.lessonsThisWeek, required this.projectsThisWeek});

  final int xpThisWeek;
  final int lessonsThisWeek;
  final int projectsThisWeek;
}

WeeklySummary weeklySummaryFor(GamificationProfile profile) => WeeklySummary(
  xpThisWeek: profile.totalXp - profile.xpAtWeekStart,
  lessonsThisWeek: profile.lessonsCompletedCount - profile.lessonsAtWeekStart,
  projectsThisWeek: profile.projectsPublishedCount - profile.projectsAtWeekStart,
);

/// True once 7+ days have passed since the baseline was last reset (or it
/// was never set) — checked before applying a new activity, so the
/// baseline the deltas above are computed from always reflects "the start
/// of the current 7-day window", not a fixed calendar week.
bool shouldResetWeekBaseline(DateTime? weekStartDate, DateTime now) {
  if (weekStartDate == null) return true;
  return now.difference(weekStartDate).inDays >= 7;
}
