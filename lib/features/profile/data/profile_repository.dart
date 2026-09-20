import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/avatar.dart';
import '../domain/user_profile.dart';

/// Reads and writes the `users/{uid}` document. Firestore is only ever
/// touched after the user has explicitly created/linked an account (see
/// `agent.md`: no data is pushed by default without consent).
class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  // EP12/US63: a flat, admin-readable-only mirror of just enough identity
  // (pseudo/avatar) for the account management screen — `users/{uid}`
  // itself can't be listed by an admin without opening up read access to
  // every learner's private data, so this is a deliberately narrow index
  // instead, following the same mirror pattern as the public `leaderboard`.
  DocumentReference<Map<String, dynamic>> _directoryDoc(String uid) =>
      _firestore.collection('accountDirectory').doc(uid);

  Future<void> _mirrorToDirectory(UserProfile profile) => _directoryDoc(profile.uid).set({
    'pseudo': profile.pseudo,
    'avatarId': profile.avatar.name,
  }, SetOptions(merge: true));

  Future<UserProfile?> fetchProfile(String uid) async {
    final snapshot = await _doc(uid).get();
    final data = snapshot.data();
    if (data == null) return null;
    return UserProfile.fromMap(uid, data);
  }

  Stream<UserProfile?> watchProfile(String uid) {
    return _doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return UserProfile.fromMap(uid, data);
    });
  }

  Future<void> createInitialProfile(UserProfile profile) async {
    await _doc(profile.uid).set(profile.toMap());
    await _mirrorToDirectory(profile);
  }

  Future<void> updatePseudoAndAvatar({
    required String uid,
    required String pseudo,
    required Avatar avatar,
  }) async {
    await _doc(uid).update({'pseudo': pseudo, 'avatarId': avatar.name});
    await _directoryDoc(uid).set({'pseudo': pseudo, 'avatarId': avatar.name}, SetOptions(merge: true));
  }

  Future<void> updatePortfolioVisibility(String uid, bool isPublic) =>
      _doc(uid).update({'portfolioPublic': isPublic});

  Future<void> deleteProfile(String uid) async {
    await _doc(uid).delete();
    await _directoryDoc(uid).delete();
  }
}

final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepository());
