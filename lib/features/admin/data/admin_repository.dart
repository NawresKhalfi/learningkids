import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/account_summary.dart';

/// Backs the admin-only surfaces of EP12: "am I an admin", the account
/// list (US63), and unpublishing a reported project (US61, called from
/// `ModerationController.rejectReport`).
///
/// `admins/{uid}` is seeded manually from the Firebase console (see
/// `docs/FEATURES.md`) — there is no in-app way to grant admin access,
/// deliberately, since this project has no backend to safely gate who can
/// write that collection.
class AdminRepository {
  AdminRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<bool> watchIsAdmin(String uid) =>
      _firestore.collection('admins').doc(uid).snapshots().map((snapshot) => snapshot.exists);

  Stream<List<AccountSummary>> watchAccountDirectory() {
    return _firestore.collection('accountDirectory').snapshots().map(
      (snapshot) => [for (final doc in snapshot.docs) AccountSummary.fromMap(doc.id, doc.data())],
    );
  }

  /// Admin-only: every account's suspension flag at once, for the account
  /// list. A non-admin cannot run this collection-wide query at all under
  /// the security rules (each doc there is only readable by its own owner
  /// or an admin) — a learner checking their *own* status must use
  /// [watchOwnSuspendedStatus] instead.
  Stream<Map<String, bool>> watchSuspendedStatuses() {
    return _firestore.collection('accountStatus').snapshots().map(
      (snapshot) => {for (final doc in snapshot.docs) doc.id: doc.data()['isSuspended'] as bool? ?? false},
    );
  }

  /// A single learner checking their own suspension flag (EP12/US63) —
  /// reads just `accountStatus/{uid}` so a non-admin's own read stays
  /// allowed under the security rules.
  Stream<bool> watchOwnSuspendedStatus(String uid) {
    return _firestore
        .collection('accountStatus')
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data()?['isSuspended'] as bool? ?? false);
  }

  Future<bool> isAccountSuspended(String uid) async {
    final snapshot = await _firestore.collection('accountStatus').doc(uid).get();
    return snapshot.data()?['isSuspended'] as bool? ?? false;
  }

  Future<void> setAccountSuspended(String uid, bool isSuspended) =>
      _firestore.collection('accountStatus').doc(uid).set({'isSuspended': isSuspended}, SetOptions(merge: true));

  Future<String?> fetchSupportNotes(String uid) async {
    final snapshot = await _firestore.collection('supportNotes').doc(uid).get();
    return snapshot.data()?['notes'] as String?;
  }

  Future<void> setSupportNotes(String uid, String notes) =>
      _firestore.collection('supportNotes').doc(uid).set({'notes': notes}, SetOptions(merge: true));

  /// A blunt, direct unpublish rather than going through
  /// `ProjectRepository` — this is the one place an admin needs to reach
  /// into another learner's `projects` subcollection, so it stays local to
  /// the admin feature rather than becoming a general capability of
  /// `ProjectRepository`.
  Future<void> unpublishProject(String ownerUid, String projectId) => _firestore
      .collection('users')
      .doc(ownerUid)
      .collection('projects')
      .doc(projectId)
      .update({'isPublished': false});
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository());
