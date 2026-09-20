import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/challenge_participant.dart';

/// Stores weekly-challenge completions in a flat, top-level
/// `challengeParticipants` collection (EP10/US56), one doc per learner per
/// week (id `<weekKey>_<uid>`) so a learner can only mark themselves done
/// once per week. Reusable across weeks without ever needing a subcollection
/// per week.
class ChallengeRepository {
  ChallengeRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('challengeParticipants');

  String _docId(String weekKey, String uid) => '${weekKey}_$uid';

  Future<void> markCompleted(
    String weekKey, {
    required String uid,
    required String pseudo,
    required String avatarId,
  }) => _collection.doc(_docId(weekKey, uid)).set({
    'weekKey': weekKey,
    'uid': uid,
    'pseudo': pseudo,
    'avatarId': avatarId,
    'completedAt': DateTime.now().toIso8601String(),
  });

  Future<bool> hasCompleted(String weekKey, String uid) async {
    final snapshot = await _collection.doc(_docId(weekKey, uid)).get();
    return snapshot.exists;
  }

  // Sorted client-side (rather than `.orderBy('completedAt')` alongside the
  // `where` filter) so this never needs a composite Firestore index.
  Stream<List<ChallengeParticipant>> watchParticipants(String weekKey) {
    return _collection.where('weekKey', isEqualTo: weekKey).snapshots().map((snapshot) {
      final participants = [for (final doc in snapshot.docs) ChallengeParticipant.fromMap(doc.data())];
      participants.sort((a, b) => a.completedAt.compareTo(b.completedAt));
      return participants;
    });
  }
}

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) => ChallengeRepository());
