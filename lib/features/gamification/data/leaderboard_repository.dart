import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/leaderboard_entry.dart';

/// Reads the public `leaderboard` collection (US46) — a flat, top-level
/// collection (not nested under `users/{uid}`) since every signed-in
/// learner is allowed to read it; see `firestore.rules`.
class LeaderboardRepository {
  LeaderboardRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<LeaderboardEntry>> watchTop({int limit = 50}) {
    return _firestore.collection('leaderboard').orderBy('totalXp', descending: true).limit(limit).snapshots().map(
      (snapshot) => [for (final doc in snapshot.docs) LeaderboardEntry.fromMap(doc.id, doc.data())],
    );
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) => LeaderboardRepository());
