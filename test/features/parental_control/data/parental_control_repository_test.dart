import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/parental_control/data/parental_control_repository.dart';
import 'package:learningkids/features/parental_control/domain/screen_time_snapshot.dart';

void main() {
  late ParentalControlRepository repository;

  setUp(() {
    repository = ParentalControlRepository(firestore: FakeFirebaseFirestore());
  });

  test('fetchSettings returns empty settings before anything is set', () async {
    final settings = await repository.fetchSettings('uid-1');
    expect(settings.hasPin, isFalse);
    expect(settings.dailyLimitMinutes, isNull);
  });

  test('setPin then fetchSettings round-trips the pin hash', () async {
    await repository.setPin('uid-1', 'hash-abc');
    final settings = await repository.fetchSettings('uid-1');
    expect(settings.pinHash, 'hash-abc');
  });

  test('setDailyLimit then clearDailyLimit', () async {
    await repository.setDailyLimit('uid-1', 30);
    expect((await repository.fetchSettings('uid-1')).dailyLimitMinutes, 30);

    await repository.clearDailyLimit('uid-1');
    expect((await repository.fetchSettings('uid-1')).dailyLimitMinutes, isNull);
  });

  test('incrementTodayMinutes accumulates and fetchTodayMinutes agrees', () async {
    final first = await repository.incrementTodayMinutes('uid-1', 1);
    final second = await repository.incrementTodayMinutes('uid-1', 1);

    expect(first, 1);
    expect(second, 2);
    expect(await repository.fetchTodayMinutes('uid-1'), 2);
  });

  test('fetchUsageHistory returns zero-filled days with today\'s minutes included', () async {
    await repository.incrementTodayMinutes('uid-1', 5);

    final history = await repository.fetchUsageHistory('uid-1', days: 3);

    expect(history.length, 3);
    expect(history.values.last, 5);
    expect(history.values.take(2), everyElement(0));
  });

  test('grantExtraTimeToday marks isExtraGrantedToday true for today only', () async {
    expect(await repository.isExtraGrantedToday('uid-1'), isFalse);

    await repository.grantExtraTimeToday('uid-1');

    expect(await repository.isExtraGrantedToday('uid-1'), isTrue);
  });

  test('dateKey matches what the repository stores', () async {
    await repository.incrementTodayMinutes('uid-1', 7);
    final history = await repository.fetchUsageHistory('uid-1', days: 1);
    expect(history[DateTime(history.keys.first.year, history.keys.first.month, history.keys.first.day)], 7);
    expect(dateKey(history.keys.first), dateKey(DateTime.now()));
  });
}
