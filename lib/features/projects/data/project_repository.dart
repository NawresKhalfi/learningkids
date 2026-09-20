import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/project.dart';

/// Stores each project at `users/{uid}/projects/{projectId}` (EP07).
/// Unlike the Code Playground's single doc per language, a learner can
/// have many projects, so each gets its own auto-generated document.
class ProjectRepository {
  ProjectRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String uid) =>
      _firestore.collection('users').doc(uid).collection('projects');

  List<Project> _sortedByNewest(QuerySnapshot<Map<String, dynamic>> snapshot) {
    final projects = [for (final doc in snapshot.docs) Project.fromMap(doc.id, doc.data())];
    projects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return projects;
  }

  Stream<List<Project>> watchProjects(String uid) => _collection(uid).snapshots().map(_sortedByNewest);

  Stream<Project?> watchProject(String uid, String projectId) {
    return _collection(uid).doc(projectId).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data == null ? null : Project.fromMap(snapshot.id, data);
    });
  }

  Future<Project?> fetchProject(String uid, String projectId) async {
    final snapshot = await _collection(uid).doc(projectId).get();
    final data = snapshot.data();
    return data == null ? null : Project.fromMap(snapshot.id, data);
  }

  Future<String> createProject(String uid, Project project) async {
    final doc = await _collection(uid).add(project.toMap());
    return doc.id;
  }

  Future<void> updateProject(String uid, Project project) =>
      _collection(uid).doc(project.id).set(project.toMap(), SetOptions(merge: true));

  Future<void> deleteProject(String uid, String projectId) => _collection(uid).doc(projectId).delete();

  /// The published projects on someone else's portfolio (US40). The
  /// caller already knows [ownerUid] (shared as an in-app "code"); the
  /// Firestore security rules are what actually gate this to portfolios
  /// their owner has switched to public.
  Stream<List<Project>> watchPublicPortfolio(String ownerUid) => _collection(
    ownerUid,
  ).where('isPublished', isEqualTo: true).snapshots().map(_sortedByNewest);
}

final projectRepositoryProvider = Provider<ProjectRepository>((ref) => ProjectRepository());
