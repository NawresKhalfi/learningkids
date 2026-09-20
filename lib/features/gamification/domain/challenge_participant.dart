/// One learner's self-reported completion of a given week's challenge
/// (EP10/US56) — a row on that week's dedicated leaderboard.
class ChallengeParticipant {
  const ChallengeParticipant({
    required this.uid,
    required this.pseudo,
    required this.avatarId,
    required this.completedAt,
  });

  final String uid;
  final String pseudo;
  final String avatarId;
  final DateTime completedAt;

  static ChallengeParticipant fromMap(Map<String, dynamic> map) => ChallengeParticipant(
    uid: map['uid'] as String? ?? '',
    pseudo: map['pseudo'] as String? ?? '',
    avatarId: map['avatarId'] as String? ?? '',
    completedAt: DateTime.tryParse(map['completedAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}
