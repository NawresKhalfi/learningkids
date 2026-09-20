import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_assistant/application/code_assistant_providers.dart';
import 'package:learningkids/features/code_assistant/data/chat_history_repository.dart';
import 'package:learningkids/features/code_assistant/data/code_assistant_client.dart';
import 'package:learningkids/features/code_assistant/domain/chat_message.dart';
import 'package:learningkids/features/code_assistant/presentation/screens/code_assistant_screen.dart';
import 'package:learningkids/features/code_playground/data/code_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

class _ScriptedCodeAssistantClient implements CodeAssistantClient {
  _ScriptedCodeAssistantClient(this.reply);
  final String reply;

  @override
  Future<String> sendMessage(String prompt) async => reply;
}

class _ThrowingCodeAssistantClient implements CodeAssistantClient {
  @override
  Future<String> sendMessage(String prompt) async => throw Exception('network down');
}

const _language = ProgrammingLanguage.python;
const _code = "print('hi')";

/// Hosts `CodeAssistantScreen` behind a real `/home` -> `/assistant` route,
/// the same way `CodePlaygroundScreen` opens it, so `context.pop(result)`
/// has a GoRouter to pop and the accepted-suggestion result is observable.
Future<({ProviderContainer container, FakeFirebaseFirestore firestore, String? Function() poppedResult})> pumpAssistant(
  WidgetTester tester,
  CodeAssistantClient client,
) async {
  // The default test surface is too short to fit the quick actions, the
  // conversation and the suggestion card's buttons at once, which leaves
  // them laid out below the visible viewport and unable to receive taps.
  await tester.binding.setSurfaceSize(const Size(400, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final firestore = FakeFirebaseFirestore();
  final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
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

  String? acceptedResult;
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, _) => Scaffold(
          body: TextButton(
            onPressed: () async {
              acceptedResult = await context.push<String>(
                '/assistant',
                extra: const CodeAssistantScreen(language: _language, code: _code),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
      GoRoute(path: '/assistant', builder: (_, state) => state.extra! as Widget),
    ],
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();

  return (container: container, firestore: firestore, poppedResult: () => acceptedResult);
}

void main() {
  testWidgets('explaining code shows the reply with no suggestion card (US32)', (tester) async {
    await pumpAssistant(tester, _ScriptedCodeAssistantClient('Ce code affiche un message.'));

    expect(find.text("Choisis une action ci-dessus ou pose une question sur ton code !"), findsOneWidget);

    await tester.tap(find.text('Expliquer ce code'));
    await tester.pumpAndSettle();

    expect(find.text('Ce code affiche un message.'), findsOneWidget);
    expect(find.text('Appliquer'), findsNothing);
  });

  testWidgets('suggesting an improvement shows an accept/reject card (US34)', (tester) async {
    await pumpAssistant(
      tester,
      _ScriptedCodeAssistantClient("Utilise un nom plus clair.\n\n```python\nprint('salut')\n```"),
    );

    await tester.tap(find.text('Améliorer mon code'));
    await tester.pumpAndSettle();

    expect(find.text("print('salut')"), findsOneWidget);
    expect(find.text('Appliquer'), findsOneWidget);
    expect(find.text('Ignorer'), findsOneWidget);
  });

  testWidgets('accepting a suggestion saves it and pops back with the new code (US35)', (tester) async {
    final harness = await pumpAssistant(
      tester,
      _ScriptedCodeAssistantClient("Utilise un nom plus clair.\n\n```python\nprint('salut')\n```"),
    );

    await tester.tap(find.text('Améliorer mon code'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appliquer'));
    await tester.pumpAndSettle();

    expect(harness.poppedResult(), "print('salut')");
    expect(find.byType(CodeAssistantScreen), findsNothing);
    final saved = await CodeSnippetRepository(firestore: harness.firestore).fetchCode('kid-1', _language);
    expect(saved, "print('salut')");
  });

  testWidgets('rejecting a suggestion clears it and saves nothing (US35)', (tester) async {
    final harness = await pumpAssistant(
      tester,
      _ScriptedCodeAssistantClient("Utilise un nom plus clair.\n\n```python\nprint('salut')\n```"),
    );

    await tester.tap(find.text('Améliorer mon code'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ignorer'));
    await tester.pumpAndSettle();

    expect(find.text('Appliquer'), findsNothing);
    expect(find.byType(CodeAssistantScreen), findsOneWidget);
    final saved = await CodeSnippetRepository(firestore: harness.firestore).fetchCode('kid-1', _language);
    expect(saved, isNull);
  });

  testWidgets('sending a free-form question appends it to the conversation (US36)', (tester) async {
    await pumpAssistant(tester, _ScriptedCodeAssistantClient('Une boucle répète des instructions.'));

    await tester.enterText(find.byType(TextField), "C'est quoi une boucle ?");
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text("C'est quoi une boucle ?"), findsOneWidget);
    expect(find.text('Une boucle répète des instructions.'), findsOneWidget);
  });

  testWidgets(
    'a failure before any message exists shows the error, not the empty-state placeholder',
    (tester) async {
      await pumpAssistant(tester, _ThrowingCodeAssistantClient());

      await tester.tap(find.text('Expliquer ce code'));
      await tester.pumpAndSettle();

      expect(find.text("Choisis une action ci-dessus ou pose une question sur ton code !"), findsNothing);
      expect(find.text("L'assistant n'a pas pu répondre, réessaie dans un instant."), findsOneWidget);
    },
  );
}
