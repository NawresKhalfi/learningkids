import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/gamification/domain/gamification_activity.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late GamificationRepository repository;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = GamificationRepository(firestore: firestore);
  });

  test('watchProfile starts at a fresh profile before anything is recorded', () async {
    final profile = await repository.watchProfile('kid-1').first;
    expect(profile.totalXp, 0);
  });

  test('recordActivity awards XP and increments the matching counter (US47)', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 5),
    );

    final profile = await repository.watchProfile('kid-1').first;
    expect(profile.totalXp, xpForActivity(GamificationActivity.lessonCompleted));
    expect(profile.lessonsCompletedCount, 1);
    expect(profile.projectsPublishedCount, 0);
  });

  test('recordActivity sets the weekly baseline on the very first activity (US50)', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 5),
    );

    final profile = await repository.watchProfile('kid-1').first;
    // The baseline is captured *before* this activity's own XP, so the
    // very first activity already counts as "this week".
    expect(profile.xpAtWeekStart, 0);
    expect(profile.weekStartDate, DateTime(2026, 1, 5));
  });

  test('recordActivity keeps the same baseline within a 7-day window', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 5),
    );
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 7),
    );

    final profile = await repository.watchProfile('kid-1').first;
    expect(profile.weekStartDate, DateTime(2026, 1, 5));
    expect(profile.lessonsAtWeekStart, 0);
    expect(profile.lessonsCompletedCount, 2);
  });

  test('recordActivity resets the baseline once 7+ days have passed', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 1),
    );
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 10),
    );

    final profile = await repository.watchProfile('kid-1').first;
    expect(profile.weekStartDate, DateTime(2026, 1, 10));
    // The baseline resets to the totals *before* this activity, so it
    // still counts toward the new week.
    expect(profile.lessonsAtWeekStart, 1);
    expect(profile.lessonsCompletedCount, 2);
  });

  test('recordActivity extends the streak across consecutive days (US43)', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 5),
    );
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
      now: DateTime(2026, 1, 6),
    );

    final profile = await repository.watchProfile('kid-1').first;
    expect(profile.streak.current, 2);
  });

  test('recordActivity unlocks a badge exactly once it becomes eligible (US44)', () async {
    final unlocked = await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );

    expect(unlocked.unlockedBadges.map((b) => b.id), contains('first-lesson'));

    final secondCall = await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    expect(secondCall.unlockedBadges.map((b) => b.id), isNot(contains('first-lesson')));
  });

  test('recordActivity reports leveledUpTo only when a level boundary is crossed (EP11/US58)', () async {
    // 20 XP/lesson, 100 XP/level (see `gamification_activity.dart` and
    // `level.dart`) — the level boundary is crossed on the 5th lesson.
    for (var i = 0; i < 4; i++) {
      final result = await repository.recordActivity(
        'kid-1',
        activity: GamificationActivity.lessonCompleted,
        pseudo: 'Léo',
        avatarId: 'panda',
      );
      expect(result.leveledUpTo, isNull);
    }

    final fifth = await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    expect(fifth.leveledUpTo, 2);
  });

  test('recordActivity mirrors the entry into the public leaderboard (US46)', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.projectPublished,
      pseudo: 'Léo',
      avatarId: 'panda',
    );

    final entry = await firestore.collection('leaderboard').doc('kid-1').get();
    expect(entry.data()!['pseudo'], 'Léo');
    expect(entry.data()!['totalXp'], xpForActivity(GamificationActivity.projectPublished));
  });

  test('recordActivity does not write to the leaderboard once opted out (US48)', () async {
    await repository.setLeaderboardOptOut('kid-1', true, pseudo: 'Léo', avatarId: 'panda');

    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );

    final entry = await firestore.collection('leaderboard').doc('kid-1').get();
    expect(entry.exists, isFalse);
  });

  test('setLeaderboardOptOut(true) deletes an existing public entry immediately (US48)', () async {
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    expect((await firestore.collection('leaderboard').doc('kid-1').get()).exists, isTrue);

    await repository.setLeaderboardOptOut('kid-1', true, pseudo: 'Léo', avatarId: 'panda');

    expect((await firestore.collection('leaderboard').doc('kid-1').get()).exists, isFalse);
  });

  test('setLeaderboardOptOut(false) re-publishes the current totals', () async {
    await repository.setLeaderboardOptOut('kid-1', true, pseudo: 'Léo', avatarId: 'panda');
    await repository.recordActivity(
      'kid-1',
      activity: GamificationActivity.lessonCompleted,
      pseudo: 'Léo',
      avatarId: 'panda',
    );
    expect((await firestore.collection('leaderboard').doc('kid-1').get()).exists, isFalse);

    await repository.setLeaderboardOptOut('kid-1', false, pseudo: 'Léo', avatarId: 'panda');

    final entry = await firestore.collection('leaderboard').doc('kid-1').get();
    expect(entry.data()!['totalXp'], xpForActivity(GamificationActivity.lessonCompleted));
  });
}
