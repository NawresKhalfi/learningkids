import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/moderation_report.dart';

/// Stores reports against shared portfolio projects in a flat, top-level
/// `moderationReports` collection (EP12/US61) — any signed-in learner can
/// create one (reporting something they saw on someone's portfolio), but
/// only an admin can read the queue or change a report's status.
class ModerationRepository {
  ModerationRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('moderationReports');

  Future<void> reportProject(ModerationReport report) => _collection.add(report.toMap());

  Stream<List<ModerationReport>> watchPending() {
    return _collection.where('status', isEqualTo: ModerationStatus.pending.name).snapshots().map((snapshot) {
      final reports = [for (final doc in snapshot.docs) ModerationReport.fromMap(doc.id, doc.data())];
      reports.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return reports;
    });
  }

  Future<void> setStatus(String reportId, ModerationStatus status) =>
      _collection.doc(reportId).update({'status': status.name});
}

final moderationRepositoryProvider = Provider<ModerationRepository>((ref) => ModerationRepository());
