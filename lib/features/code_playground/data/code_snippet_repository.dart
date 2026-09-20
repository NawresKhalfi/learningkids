import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/programming_language.dart';

/// Stores each language's scratch buffer at
/// `users/{uid}/codePlayground/{language}` (US30). One doc per language so
/// autosaving one doesn't race with another, and so Firestore's built-in
/// offline cache/queue (already enabled for this app) covers "save now,
/// sync once back online" for free (US31) without any custom queueing.
class CodeSnippetRepository {
  CodeSnippetRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid, ProgrammingLanguage language) =>
      _firestore.collection('users').doc(uid).collection('codePlayground').doc(language.name);

  /// `null` means no snippet has ever been saved (show the starter code);
  /// an empty string means the learner deliberately cleared their code.
  Future<String?> fetchCode(String uid, ProgrammingLanguage language) async {
    final snapshot = await _doc(uid, language).get();
    return snapshot.data()?['code'] as String?;
  }

  Stream<String?> watchCode(String uid, ProgrammingLanguage language) {
    return _doc(uid, language).snapshots().map((s) => s.data()?['code'] as String?);
  }

  Future<void> saveCode(String uid, ProgrammingLanguage language, String code) =>
      _doc(uid, language).set({'code': code}, SetOptions(merge: true));
}

final codeSnippetRepositoryProvider =
    Provider<CodeSnippetRepository>((ref) => CodeSnippetRepository());
