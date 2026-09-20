import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_assistant/data/chat_history_repository.dart';
import 'package:learningkids/features/code_assistant/domain/chat_message.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';

void main() {
  late ChatHistoryRepository repository;

  setUp(() {
    repository = ChatHistoryRepository(firestore: FakeFirebaseFirestore());
  });

  test('watchHistory starts empty before anything is saved', () async {
    final history = await repository.watchHistory('uid-1', ProgrammingLanguage.python).first;
    expect(history, isEmpty);
  });

  test('appendMessages then watchHistory returns them in order', () async {
    await repository.appendMessages('uid-1', ProgrammingLanguage.python, const [
      ChatMessage(role: ChatRole.user, text: 'Explique ce code'),
      ChatMessage(role: ChatRole.assistant, text: 'Bien sûr !'),
    ]);

    final history = await repository.watchHistory('uid-1', ProgrammingLanguage.python).first;

    expect(history, hasLength(2));
    expect(history[0].role, ChatRole.user);
    expect(history[1].text, 'Bien sûr !');
  });

  test('a second append preserves earlier messages (US36 history is kept)', () async {
    await repository.appendMessages('uid-1', ProgrammingLanguage.python, const [
      ChatMessage(role: ChatRole.user, text: 'Première question'),
    ]);
    await repository.appendMessages('uid-1', ProgrammingLanguage.python, const [
      ChatMessage(role: ChatRole.user, text: 'Deuxième question'),
    ]);

    final history = await repository.watchHistory('uid-1', ProgrammingLanguage.python).first;
    expect(history.map((m) => m.text), ['Première question', 'Deuxième question']);
  });

  test('each language keeps its own independent conversation', () async {
    await repository.appendMessages('uid-1', ProgrammingLanguage.python, const [
      ChatMessage(role: ChatRole.user, text: 'question python'),
    ]);

    final jsHistory = await repository.watchHistory('uid-1', ProgrammingLanguage.javascript).first;
    expect(jsHistory, isEmpty);
  });
}
