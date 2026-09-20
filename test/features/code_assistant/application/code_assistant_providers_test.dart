import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_assistant/application/code_assistant_providers.dart';
import 'package:learningkids/features/code_assistant/data/chat_history_repository.dart';
import 'package:learningkids/features/code_assistant/data/code_assistant_client.dart';
import 'package:learningkids/features/code_assistant/domain/assistant_action.dart';
import 'package:learningkids/features/code_assistant/domain/chat_message.dart';
import 'package:learningkids/features/code_playground/data/code_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';

/// A [CodeAssistantClient] that either returns a canned reply or throws a
/// canned error, so the controller can be tested without a real Firebase AI
/// call — mirrors the `CodeRuntimeService` fakeability gap worked around in
/// EP05 (firebase_ai has no test double of its own).
class FakeCodeAssistantClient implements CodeAssistantClient {
  FakeCodeAssistantClient(this._reply);

  final Object _reply;
  final sentPrompts = <String>[];

  @override
  Future<String> sendMessage(String prompt) async {
    sentPrompts.add(prompt);
    if (_reply is String) return _reply;
    throw _reply;
  }
}

void main() {
  const language = ProgrammingLanguage.python;
  const uid = 'kid-1';
  late FakeFirebaseFirestore firestore;

  ProviderContainer buildContainer(CodeAssistantClient client) {
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid, email: 'kid@example.com'));
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        codeSnippetRepositoryProvider.overrideWithValue(CodeSnippetRepository(firestore: firestore)),
        chatHistoryRepositoryProvider.overrideWithValue(ChatHistoryRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
        codeAssistantClientFactoryProvider.overrideWithValue(
          ({required String systemInstruction, List<ChatMessage> priorHistory = const []}) => client,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    firestore = FakeFirebaseFirestore();
  });

  test('explaining code appends the prompt and the reply, with no pending suggestion (US32)', () async {
    final container = buildContainer(FakeCodeAssistantClient('Ce code affiche un message.'));
    await container.read(authStateChangesProvider.future);

    await container
        .read(codeAssistantControllerProvider(language).notifier)
        .runAction(AssistantAction.explainCode, "print('hi')");

    final history = await ChatHistoryRepository(firestore: firestore).watchHistory(uid, language).first;
    expect(history, hasLength(2));
    expect(history.first.role, ChatRole.user);
    expect(history.last.text, 'Ce code affiche un message.');
    expect(container.read(codeAssistantControllerProvider(language)).pendingSuggestion, isNull);
  });

  test('suggesting an improvement extracts a pending code suggestion (US34)', () async {
    final client = FakeCodeAssistantClient("Utilise un nom plus clair.\n\n```python\nprint('salut')\n```");
    final container = buildContainer(client);
    await container.read(authStateChangesProvider.future);

    await container
        .read(codeAssistantControllerProvider(language).notifier)
        .runAction(AssistantAction.suggestImprovement, "print('hi')");

    expect(container.read(codeAssistantControllerProvider(language)).pendingSuggestion, "print('salut')");
  });

  test('accepting a suggestion saves it as the snippet and clears the pending state (US35)', () async {
    final client = FakeCodeAssistantClient("Explication.\n\n```python\nprint('ok')\n```");
    final container = buildContainer(client);
    await container.read(authStateChangesProvider.future);
    await container
        .read(codeAssistantControllerProvider(language).notifier)
        .runAction(AssistantAction.suggestImprovement, "print('hi')");

    await container.read(codeAssistantControllerProvider(language).notifier).acceptSuggestion("print('ok')");

    final saved = await CodeSnippetRepository(firestore: firestore).fetchCode(uid, language);
    expect(saved, "print('ok')");
    expect(container.read(codeAssistantControllerProvider(language)).pendingSuggestion, isNull);
  });

  test('rejecting a suggestion clears it without saving anything (US35)', () async {
    final client = FakeCodeAssistantClient("Explication.\n\n```python\nprint('ok')\n```");
    final container = buildContainer(client);
    await container.read(authStateChangesProvider.future);
    await container
        .read(codeAssistantControllerProvider(language).notifier)
        .runAction(AssistantAction.suggestImprovement, "print('hi')");

    container.read(codeAssistantControllerProvider(language).notifier).rejectSuggestion();

    final saved = await CodeSnippetRepository(firestore: firestore).fetchCode(uid, language);
    expect(saved, isNull);
    expect(container.read(codeAssistantControllerProvider(language)).pendingSuggestion, isNull);
  });

  test('a blocked reply falls back to a friendly on-topic message instead of crashing (US37)', () async {
    final container = buildContainer(FakeCodeAssistantClient(FirebaseAIException('blocked')));
    await container.read(authStateChangesProvider.future);

    await container.read(codeAssistantControllerProvider(language).notifier).sendFreeMessage('Raconte une blague osée');

    final history = await ChatHistoryRepository(firestore: firestore).watchHistory(uid, language).first;
    expect(history.last.role, ChatRole.assistant);
    expect(history.last.text, isNotEmpty);
    expect(container.read(codeAssistantControllerProvider(language)).hasError, isFalse);
  });

  test('an unexpected error surfaces as a generic error instead of crashing', () async {
    final container = buildContainer(FakeCodeAssistantClient(Exception('network down')));
    await container.read(authStateChangesProvider.future);

    await container.read(codeAssistantControllerProvider(language).notifier).sendFreeMessage('bonjour');

    expect(container.read(codeAssistantControllerProvider(language)).hasError, isTrue);
  });
}
