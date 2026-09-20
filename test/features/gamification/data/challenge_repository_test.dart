import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/data/challenge_repository.dart';

void main() {
  test('hasCompleted is false until markCompleted is called for that week', () async {
    final repository = ChallengeRepository(firestore: FakeFirebaseFirestore());
    expect(await repository.hasCompleted('2026-W10', 'kid-1'), isFalse);

    await repository.markCompleted('2026-W10', uid: 'kid-1', pseudo: 'Léo', avatarId: 'panda');

    expect(await repository.hasCompleted('2026-W10', 'kid-1'), isTrue);
  });

  test('markCompleted for a different week does not mark the current week as completed', () async {
    final repository = ChallengeRepository(firestore: FakeFirebaseFirestore());
    await repository.markCompleted('2026-W09', uid: 'kid-1', pseudo: 'Léo', avatarId: 'panda');

    expect(await repository.hasCompleted('2026-W10', 'kid-1'), isFalse);
  });

  test('watchParticipants only returns entries for the given week, sorted by completion time', () async {
    final repository = ChallengeRepository(firestore: FakeFirebaseFirestore());
    await repository.markCompleted('2026-W10', uid: 'completed-first', pseudo: 'First', avatarId: 'fox');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await repository.markCompleted('2026-W10', uid: 'completed-second', pseudo: 'Second', avatarId: 'cat');
    await repository.markCompleted('2026-W09', uid: 'other-week', pseudo: 'Other', avatarId: 'owl');

    final participants = await repository.watchParticipants('2026-W10').first;

    expect(participants.map((p) => p.uid), ['completed-first', 'completed-second']);
  });
}
