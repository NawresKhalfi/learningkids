import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_assistant/domain/chat_message.dart';

void main() {
  test('toMap/fromMap round-trips a plain message', () {
    const message = ChatMessage(role: ChatRole.user, text: 'Explique-moi les boucles');
    final restored = ChatMessage.fromMap(message.toMap());

    expect(restored.role, ChatRole.user);
    expect(restored.text, 'Explique-moi les boucles');
    expect(restored.suggestedCode, isNull);
  });

  test('toMap/fromMap round-trips a message carrying a code suggestion', () {
    const message = ChatMessage(role: ChatRole.assistant, text: 'Voici une piste', suggestedCode: 'print(1)');
    final restored = ChatMessage.fromMap(message.toMap());

    expect(restored.role, ChatRole.assistant);
    expect(restored.suggestedCode, 'print(1)');
  });
}
