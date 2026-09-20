/// The parent-configured settings for a child account: the Espace Parent
/// PIN hash (US07) and the optional daily screen-time limit (US09).
class ParentalSettings {
  const ParentalSettings({this.pinHash, this.dailyLimitMinutes});

  final String? pinHash;
  final int? dailyLimitMinutes;

  bool get hasPin => pinHash != null;

  ParentalSettings copyWith({String? pinHash, int? dailyLimitMinutes}) {
    return ParentalSettings(
      pinHash: pinHash ?? this.pinHash,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
    );
  }

  Map<String, dynamic> toMap() => {
        if (pinHash != null) 'pinHash': pinHash,
        if (dailyLimitMinutes != null) 'dailyLimitMinutes': dailyLimitMinutes,
      };

  static ParentalSettings fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ParentalSettings();
    return ParentalSettings(
      pinHash: map['pinHash'] as String?,
      dailyLimitMinutes: map['dailyLimitMinutes'] as int?,
    );
  }
}
