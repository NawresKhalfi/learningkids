import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../code_playground/domain/programming_language.dart';
import '../domain/chat_message.dart';

/// Stores each language's assistant conversation at
/// `users/{uid}/codeAssistantChats/{language}` (US36) — one doc per
/// language, mirroring `CodeSnippetRepository`, so reopening the assistant
/// on a given tab resumes that tab's own conversation.
class ChatHistoryRepository {
  ChatHistoryRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String uid, ProgrammingLanguage language) =>
      _firestore.collection('users').doc(uid).collection('codeAssistantChats').doc(language.name);

  Stream<List<ChatMessage>> watchHistory(String uid, ProgrammingLanguage language) {
    return _doc(uid, language).snapshots().map(_messagesFrom);
  }

  Future<void> appendMessages(String uid, ProgrammingLanguage language, List<ChatMessage> newMessages) async {
    final doc = _doc(uid, language);
    final existing = _messagesFrom(await doc.get());
    final updated = [...existing, ...newMessages];
    await doc.set({'messages': updated.map((m) => m.toMap()).toList()}, SetOptions(merge: true));
  }

  List<ChatMessage> _messagesFrom(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final raw = snapshot.data()?['messages'] as List<dynamic>? ?? [];
    return [for (final m in raw) ChatMessage.fromMap(m as Map<String, dynamic>)];
  }
}

final chatHistoryRepositoryProvider = Provider<ChatHistoryRepository>((ref) => ChatHistoryRepository());
