/// One row of the admin account list (EP12/US63) — a narrow view combining
/// the public-ish identity mirror (`accountDirectory`) with the
/// admin-only suspension flag (`accountStatus`). Support notes are kept
/// separate (`supportNotes`) since, unlike the suspension flag, they must
/// never be readable by the account's own owner.
class AccountSummary {
  const AccountSummary({
    required this.uid,
    required this.pseudo,
    required this.avatarId,
    required this.isSuspended,
  });

  final String uid;
  final String pseudo;
  final String avatarId;
  final bool isSuspended;

  AccountSummary copyWith({bool? isSuspended}) =>
      AccountSummary(uid: uid, pseudo: pseudo, avatarId: avatarId, isSuspended: isSuspended ?? this.isSuspended);

  static AccountSummary fromMap(String uid, Map<String, dynamic> map) => AccountSummary(
    uid: uid,
    pseudo: map['pseudo'] as String? ?? '',
    avatarId: map['avatarId'] as String? ?? '',
    isSuspended: false,
  );
}
