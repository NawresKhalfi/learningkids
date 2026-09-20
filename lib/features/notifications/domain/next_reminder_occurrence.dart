/// The next wall-clock moment at [hour]:[minute] at or after [now] (US57) —
/// today if that time hasn't passed yet, tomorrow otherwise. Kept as a pure
/// function, separate from `NotificationService`'s plugin/timezone
/// plumbing, so the date math is unit-testable on its own.
DateTime nextReminderOccurrence(DateTime now, {required int hour, required int minute}) {
  var scheduled = DateTime(now.year, now.month, now.day, hour, minute);
  if (!scheduled.isAfter(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}
