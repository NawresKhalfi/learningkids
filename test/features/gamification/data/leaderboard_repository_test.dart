import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/data/leaderboard_repository.dart';

void main() {
  test('watchTop orders entries by XP, highest first (US46)', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('leaderboard').doc('low').set({'pseudo': 'Low', 'avatarId': 'fox', 'totalXp': 10});
    await firestore.collection('leaderboard').doc('high').set({'pseudo': 'High', 'avatarId': 'cat', 'totalXp': 90});
    await firestore.collection('leaderboard').doc('mid').set({'pseudo': 'Mid', 'avatarId': 'owl', 'totalXp': 50});

    final entries = await LeaderboardRepository(firestore: firestore).watchTop().first;

    expect(entries.map((e) => e.uid), ['high', 'mid', 'low']);
  });

  test('watchTop respects the limit', () async {
    final firestore = FakeFirebaseFirestore();
    for (var i = 0; i < 5; i++) {
      await firestore.collection('leaderboard').doc('kid-$i').set({'pseudo': 'K$i', 'avatarId': 'fox', 'totalXp': i});
    }

    final entries = await LeaderboardRepository(firestore: firestore).watchTop(limit: 2).first;

    expect(entries, hasLength(2));
  });
}
