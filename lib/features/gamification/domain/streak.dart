/// A learner's consecutive-day activity streak (US43).
class Streak {
  const Streak({this.current = 0, this.longest = 0, this.lastActiveDate});

  final int current;
  final int longest;

  /// The calendar day (time-of-day ignored) the streak was last extended.
  final DateTime? lastActiveDate;

  Streak copyWith({int? current, int? longest, DateTime? lastActiveDate}) => Streak(
    current: current ?? this.current,
    longest: longest ?? this.longest,
    lastActiveDate: lastActiveDate ?? this.lastActiveDate,
  );
}

DateTime _dateOnly(DateTime dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day);

/// Extends, restarts or leaves the streak unchanged for an activity
/// recorded on [today] — called once per completed lesson/published
/// project (see `GamificationRepository.recordActivity`).
Streak recordActivityDay(Streak streak, DateTime today) {
  final day = _dateOnly(today);
  final lastActive = streak.lastActiveDate == null ? null : _dateOnly(streak.lastActiveDate!);

  if (lastActive == day) return streak; // Already recorded today.

  final isConsecutive = lastActive != null && day.difference(lastActive).inDays == 1;
  final newCurrent = isConsecutive ? streak.current + 1 : 1;

  return Streak(current: newCurrent, longest: newCurrent > streak.longest ? newCurrent : streak.longest, lastActiveDate: day);
}

/// True once the learner was active yesterday but not yet today — the
/// streak survives only if they do something before the day ends (US43's
/// "rappel avant la perte du streak", shown as an in-app banner for now).
bool isStreakAtRisk(Streak streak, DateTime today) {
  if (streak.current == 0 || streak.lastActiveDate == null) return false;
  final day = _dateOnly(today);
  final lastActive = _dateOnly(streak.lastActiveDate!);
  return day.difference(lastActive).inDays == 1;
}

/// True once a full calendar day has passed with no activity — the streak
/// shown to the learner should reset to 0 even before their next activity
/// recomputes it for real.
bool isStreakBroken(Streak streak, DateTime today) {
  if (streak.current == 0 || streak.lastActiveDate == null) return false;
  final day = _dateOnly(today);
  final lastActive = _dateOnly(streak.lastActiveDate!);
  return day.difference(lastActive).inDays > 1;
}
