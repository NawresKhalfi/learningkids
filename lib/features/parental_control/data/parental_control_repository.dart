import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/parental_settings.dart';
import '../domain/screen_time_snapshot.dart';

/// Stores parental-control settings and daily screen-time usage under
/// `users/{uid}/parentalControls/`. Two documents rather than a
/// per-day subcollection: a handful of years of daily minutes easily fits
/// one document, and it keeps the dashboard/limit check to a single read
/// (see `agent.md`: don't reach for a heavier structure prematurely).
class ParentalControlRepository {
  ParentalControlRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _settingsDoc(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('parentalControls')
      .doc('settings');

  DocumentReference<Map<String, dynamic>> _usageDoc(String uid) => _firestore
      .collection('users')
      .doc(uid)
      .collection('parentalControls')
      .doc('usage');

  Future<ParentalSettings> fetchSettings(String uid) async {
    final snapshot = await _settingsDoc(uid).get();
    return ParentalSettings.fromMap(snapshot.data());
  }

  Stream<ParentalSettings> watchSettings(String uid) {
    return _settingsDoc(uid).snapshots().map((s) => ParentalSettings.fromMap(s.data()));
  }

  Future<void> setPin(String uid, String pinHash) =>
      _settingsDoc(uid).set({'pinHash': pinHash}, SetOptions(merge: true));

  Future<void> setDailyLimit(String uid, int minutes) => _settingsDoc(
        uid,
      ).set({'dailyLimitMinutes': minutes}, SetOptions(merge: true));

  Future<void> clearDailyLimit(String uid) =>
      _settingsDoc(uid).set({'dailyLimitMinutes': FieldValue.delete()}, SetOptions(merge: true));

  Future<int> fetchTodayMinutes(String uid) async {
    final snapshot = await _usageDoc(uid).get();
    return (snapshot.data()?['minutes_${dateKey(DateTime.now())}'] as int?) ?? 0;
  }

  /// Atomically adds [delta] minutes to today's total and returns the new
  /// total.
  Future<int> incrementTodayMinutes(String uid, int delta) async {
    final key = 'minutes_${dateKey(DateTime.now())}';
    await _usageDoc(uid).set({key: FieldValue.increment(delta)}, SetOptions(merge: true));
    final snapshot = await _usageDoc(uid).get();
    return (snapshot.data()?[key] as int?) ?? 0;
  }

  /// Minutes used per day for the last [days] days (oldest first), for the
  /// parent dashboard (US08).
  Future<Map<DateTime, int>> fetchUsageHistory(String uid, {int days = 7}) async {
    final snapshot = await _usageDoc(uid).get();
    final data = snapshot.data() ?? const {};
    final today = DateTime.now();
    return {
      for (var i = days - 1; i >= 0; i--)
        DateTime(today.year, today.month, today.day - i):
            (data['minutes_${dateKey(today.subtract(Duration(days: i)))}'] as int?) ?? 0,
    };
  }

  Future<bool> isExtraGrantedToday(String uid) async {
    final snapshot = await _usageDoc(uid).get();
    return snapshot.data()?['extraGrantedDate'] == dateKey(DateTime.now());
  }

  Future<void> grantExtraTimeToday(String uid) => _usageDoc(
        uid,
      ).set({'extraGrantedDate': dateKey(DateTime.now())}, SetOptions(merge: true));
}

final parentalControlRepositoryProvider =
    Provider<ParentalControlRepository>((ref) => ParentalControlRepository());
