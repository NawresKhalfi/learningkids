/// Formats a [DateTime] as the `YYYY-MM-DD` key used to store per-day usage
/// minutes (see `ParentalControlRepository`).
String dateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Today's usage against the parent-set limit (US09), plus whether the
/// parent has already granted extra time for today via the PIN gate.
class ScreenTimeSnapshot {
  const ScreenTimeSnapshot({
    this.todayMinutes = 0,
    this.dailyLimitMinutes,
    this.extraGrantedToday = false,
  });

  final int todayMinutes;
  final int? dailyLimitMinutes;
  final bool extraGrantedToday;

  /// Pure so the blocking rule (US09: "blocage automatique de l'app une
  /// fois la limite atteinte") is unit-testable without Firestore or a
  /// running timer.
  bool get isLimitReached =>
      dailyLimitMinutes != null &&
      !extraGrantedToday &&
      todayMinutes >= dailyLimitMinutes!;

  ScreenTimeSnapshot copyWith({
    int? todayMinutes,
    int? dailyLimitMinutes,
    bool? extraGrantedToday,
  }) {
    return ScreenTimeSnapshot(
      todayMinutes: todayMinutes ?? this.todayMinutes,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      extraGrantedToday: extraGrantedToday ?? this.extraGrantedToday,
    );
  }
}
