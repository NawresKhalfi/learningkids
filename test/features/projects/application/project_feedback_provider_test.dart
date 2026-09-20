import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_assistant/application/code_assistant_providers.dart';
import 'package:learningkids/features/code_assistant/data/code_assistant_client.dart';
import 'package:learningkids/features/code_assistant/domain/chat_message.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/projects/application/project_feedback_provider.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';

class _ScriptedClient implements CodeAssistantClient {
  _ScriptedClient(this._reply);
  final Object _reply;

  @override
  Future<String> sendMessage(String prompt) async {
    if (_reply is String) return _reply;
    throw _reply;
  }
}

void main() {
  final project = Project(
    id: 'p1',
    title: 'Mon jeu',
    language: ProgrammingLanguage.python,
    category: ProjectCategory.game,
    code: "print('salut')",
    createdAt: DateTime.utc(2026, 1, 1),
  );

  ProviderContainer buildContainer(CodeAssistantClient client) {
    final container = ProviderContainer(
      overrides: [
        codeAssistantClientFactoryProvider.overrideWithValue(
          ({required String systemInstruction, List<ChatMessage> priorHistory = const []}) => client,
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('analyze surfaces the AI feedback text (US42)', () async {
    final container = buildContainer(_ScriptedClient('Bravo, ton code est clair !'));

    await container.read(projectFeedbackControllerProvider.notifier).analyze(project);

    final state = container.read(projectFeedbackControllerProvider);
    expect(state.feedback, 'Bravo, ton code est clair !');
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
  });

  test('a failure surfaces as a generic error instead of crashing', () async {
    final container = buildContainer(_ScriptedClient(Exception('offline')));

    await container.read(projectFeedbackControllerProvider.notifier).analyze(project);

    final state = container.read(projectFeedbackControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.feedback, isNull);
  });

  test('reset clears the feedback state', () async {
    final container = buildContainer(_ScriptedClient('Bravo !'));
    final notifier = container.read(projectFeedbackControllerProvider.notifier);
    await notifier.analyze(project);

    notifier.reset();

    final state = container.read(projectFeedbackControllerProvider);
    expect(state.feedback, isNull);
    expect(state.hasError, isFalse);
    expect(state.isLoading, isFalse);
  });
}
