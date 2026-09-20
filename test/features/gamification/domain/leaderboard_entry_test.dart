import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/domain/leaderboard_entry.dart';

void main() {
  test('toMap/fromMap round-trips every field', () {
    const entry = LeaderboardEntry(uid: 'kid-1', pseudo: 'Léo', avatarId: 'panda', totalXp: 240);
    final restored = LeaderboardEntry.fromMap(entry.uid, entry.toMap());

    expect(restored.uid, 'kid-1');
    expect(restored.pseudo, 'Léo');
    expect(restored.avatarId, 'panda');
    expect(restored.totalXp, 240);
  });

  test('fromMap falls back to sane defaults for missing fields', () {
    final restored = LeaderboardEntry.fromMap('kid-2', const {});
    expect(restored.pseudo, '');
    expect(restored.avatarId, '');
    expect(restored.totalXp, 0);
  });
}
