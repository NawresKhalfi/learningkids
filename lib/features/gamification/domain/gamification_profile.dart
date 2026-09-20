import 'streak.dart';

/// The learner's gamification state (EP08): XP, streak and the milestone
/// counters badge criteria are evaluated against. Stored separately from
/// `UserProfile` (`users/{uid}/gamification/summary`) since it changes on
/// every activity, unlike the rarely-edited profile document.
class GamificationProfile {
  const GamificationProfile({
    this.totalXp = 0,
    this.streak = const Streak(),
    this.lessonsCompletedCount = 0,
    this.projectsPublishedCount = 0,
    this.unlockedBadgeIds = const {},
    this.leaderboardOptOut = false,
    this.weekStartDate,
    this.xpAtWeekStart = 0,
    this.lessonsAtWeekStart = 0,
    this.projectsAtWeekStart = 0,
  });

  final int totalXp;
  final Streak streak;
  final int lessonsCompletedCount;
  final int projectsPublishedCount;
  final Set<String> unlockedBadgeIds;

  /// Set from the parent space (US48) — when true, the learner's entry is
  /// removed from the public leaderboard and no new one is written.
  final bool leaderboardOptOut;

  /// A rolling 7-day baseline for the weekly summary (US50): the totals as
  /// they stood when the current week started, reset automatically once 7
  /// days pass — see `shouldResetWeekBaseline`/`weeklySummaryFor`.
  final DateTime? weekStartDate;
  final int xpAtWeekStart;
  final int lessonsAtWeekStart;
  final int projectsAtWeekStart;

  GamificationProfile copyWith({
    int? totalXp,
    Streak? streak,
    int? lessonsCompletedCount,
    int? projectsPublishedCount,
    Set<String>? unlockedBadgeIds,
    bool? leaderboardOptOut,
    DateTime? weekStartDate,
    int? xpAtWeekStart,
    int? lessonsAtWeekStart,
    int? projectsAtWeekStart,
  }) => GamificationProfile(
    totalXp: totalXp ?? this.totalXp,
    streak: streak ?? this.streak,
    lessonsCompletedCount: lessonsCompletedCount ?? this.lessonsCompletedCount,
    projectsPublishedCount: projectsPublishedCount ?? this.projectsPublishedCount,
    unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
    leaderboardOptOut: leaderboardOptOut ?? this.leaderboardOptOut,
    weekStartDate: weekStartDate ?? this.weekStartDate,
    xpAtWeekStart: xpAtWeekStart ?? this.xpAtWeekStart,
    lessonsAtWeekStart: lessonsAtWeekStart ?? this.lessonsAtWeekStart,
    projectsAtWeekStart: projectsAtWeekStart ?? this.projectsAtWeekStart,
  );

  Map<String, dynamic> toMap() => {
    'totalXp': totalXp,
    'streakCurrent': streak.current,
    'streakLongest': streak.longest,
    if (streak.lastActiveDate != null) 'streakLastActiveDate': streak.lastActiveDate!.toIso8601String(),
    'lessonsCompletedCount': lessonsCompletedCount,
    'projectsPublishedCount': projectsPublishedCount,
    'unlockedBadgeIds': unlockedBadgeIds.toList(),
    'leaderboardOptOut': leaderboardOptOut,
    if (weekStartDate != null) 'weekStartDate': weekStartDate!.toIso8601String(),
    'xpAtWeekStart': xpAtWeekStart,
    'lessonsAtWeekStart': lessonsAtWeekStart,
    'projectsAtWeekStart': projectsAtWeekStart,
  };

  static GamificationProfile fromMap(Map<String, dynamic> map) {
    final lastActiveRaw = map['streakLastActiveDate'] as String?;
    final weekStartRaw = map['weekStartDate'] as String?;
    return GamificationProfile(
      totalXp: map['totalXp'] as int? ?? 0,
      streak: Streak(
        current: map['streakCurrent'] as int? ?? 0,
        longest: map['streakLongest'] as int? ?? 0,
        lastActiveDate: lastActiveRaw == null ? null : DateTime.tryParse(lastActiveRaw),
      ),
      lessonsCompletedCount: map['lessonsCompletedCount'] as int? ?? 0,
      projectsPublishedCount: map['projectsPublishedCount'] as int? ?? 0,
      unlockedBadgeIds: ((map['unlockedBadgeIds'] as List<dynamic>?) ?? []).cast<String>().toSet(),
      leaderboardOptOut: map['leaderboardOptOut'] as bool? ?? false,
      weekStartDate: weekStartRaw == null ? null : DateTime.tryParse(weekStartRaw),
      xpAtWeekStart: map['xpAtWeekStart'] as int? ?? 0,
      lessonsAtWeekStart: map['lessonsAtWeekStart'] as int? ?? 0,
      projectsAtWeekStart: map['projectsAtWeekStart'] as int? ?? 0,
    );
  }
}
