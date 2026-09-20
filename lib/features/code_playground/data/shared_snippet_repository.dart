import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/shared_snippet.dart';

/// Stores shared snippets in a flat, top-level `sharedSnippets` collection
/// (EP10/US55) — like the portfolio "code" concept from EP07, but for a
/// single code snippet rather than a whole project. Anyone holding the
/// generated document id can read it; only the owner can create it.
class SharedSnippetRepository {
  SharedSnippetRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('sharedSnippets');

  Future<String> shareSnippet(SharedSnippet snippet) async {
    final doc = await _collection.add(snippet.toMap());
    return doc.id;
  }

  Future<SharedSnippet?> fetchSnippet(String id) async {
    final snapshot = await _collection.doc(id).get();
    final data = snapshot.data();
    return data == null ? null : SharedSnippet.fromMap(snapshot.id, data);
  }
}

final sharedSnippetRepositoryProvider = Provider<SharedSnippetRepository>((ref) => SharedSnippetRepository());
