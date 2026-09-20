/// One row of the global leaderboard (US46): a snapshot of a learner's
/// pseudo/avatar/XP, mirrored into the public `leaderboard/{uid}`
/// collection whenever their gamification profile changes and they
/// haven't opted out (US48).
class LeaderboardEntry {
  const LeaderboardEntry({required this.uid, required this.pseudo, required this.avatarId, required this.totalXp});

  final String uid;
  final String pseudo;
  final String avatarId;
  final int totalXp;

  Map<String, dynamic> toMap() => {'pseudo': pseudo, 'avatarId': avatarId, 'totalXp': totalXp};

  static LeaderboardEntry fromMap(String uid, Map<String, dynamic> map) => LeaderboardEntry(
    uid: uid,
    pseudo: map['pseudo'] as String? ?? '',
    avatarId: map['avatarId'] as String? ?? '',
    totalXp: map['totalXp'] as int? ?? 0,
  );
}
