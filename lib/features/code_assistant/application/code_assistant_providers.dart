import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../code_playground/data/code_snippet_repository.dart';
import '../../code_playground/domain/programming_language.dart';
import '../../profile/application/profile_controller.dart';
import '../data/chat_history_repository.dart';
import '../data/code_assistant_client.dart';
import '../domain/assistant_action.dart';
import '../domain/assistant_prompt_builder.dart';
import '../domain/assistant_response_parser.dart';
import '../domain/chat_message.dart';
import '../domain/off_topic_fallback.dart';

/// Overridable in tests to inject a fake [CodeAssistantClient] instead of
/// the real Firebase-AI-backed one.
final codeAssistantClientFactoryProvider = Provider<CodeAssistantClientFactory>(
  (ref) => FirebaseCodeAssistantClient.new,
);

/// The persisted conversation for one language (US36); falls back to an
/// empty conversation while signed out.
final chatHistoryProvider = StreamProvider.family<List<ChatMessage>, ProgrammingLanguage>((ref, language) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(chatHistoryRepositoryProvider).watchHistory(uid, language);
});

/// Ephemeral, non-persisted assistant state: whether a request is in
/// flight, the latest not-yet-decided suggestion (US34/US35), and the last
/// error, if any. The conversation itself lives in [chatHistoryProvider].
class CodeAssistantUiState {
  const CodeAssistantUiState({this.isSending = false, this.pendingSuggestion, this.hasError = false});

  final bool isSending;
  final String? pendingSuggestion;
  final bool hasError;
}

class CodeAssistantController extends FamilyNotifier<CodeAssistantUiState, ProgrammingLanguage> {
  CodeAssistantClient? _client;

  @override
  CodeAssistantUiState build(ProgrammingLanguage language) => const CodeAssistantUiState();

  CodeAssistantClient _clientFor(List<ChatMessage> priorHistory) {
    return _client ??= ref.read(codeAssistantClientFactoryProvider)(
      systemInstruction: buildSystemInstruction(
        codingLevel: ref.read(currentProfileProvider).valueOrNull?.codingLevel,
      ),
      priorHistory: priorHistory,
    );
  }

  Future<void> runAction(AssistantAction action, String code) {
    return _send(
      userVisibleText: buildActionPrompt(action: action, language: arg, code: code),
      isSuggestionAction: action == AssistantAction.suggestImprovement,
    );
  }

  Future<void> sendFreeMessage(String text) => _send(userVisibleText: text, isSuggestionAction: false);

  Future<void> _send({required String userVisibleText, required bool isSuggestionAction}) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    // Awaits the first snapshot rather than reading `.valueOrNull`, which
    // could still be null/loading right after the screen opens and would
    // silently start the AI chat session with no prior context.
    final history = await ref.read(chatHistoryProvider(arg).future);
    final userMessage = ChatMessage(role: ChatRole.user, text: userVisibleText);
    state = const CodeAssistantUiState(isSending: true);

    try {
      final raw = await _clientFor(history).sendMessage(userVisibleText);
      final parsed = isSuggestionAction
          ? parseSuggestionResponse(raw)
          : ParsedAssistantResponse(explanation: raw);
      final assistantMessage = ChatMessage(
        role: ChatRole.assistant,
        text: parsed.explanation,
        suggestedCode: parsed.suggestedCode,
      );
      if (uid != null) {
        await ref.read(chatHistoryRepositoryProvider).appendMessages(uid, arg, [userMessage, assistantMessage]);
      }
      state = CodeAssistantUiState(pendingSuggestion: parsed.suggestedCode);
    } on FirebaseAIException catch (_) {
      final fallback = ChatMessage(role: ChatRole.assistant, text: offTopicFallbackMessage);
      if (uid != null) {
        await ref.read(chatHistoryRepositoryProvider).appendMessages(uid, arg, [userMessage, fallback]);
      }
      state = const CodeAssistantUiState();
    } catch (error) {
      debugPrint('[CodeAssistantController] $error');
      state = const CodeAssistantUiState(hasError: true);
    }
  }

  /// Writes the suggested code into the learner's saved snippet (US35: only
  /// ever on this explicit, user-initiated action).
  Future<void> acceptSuggestion(String suggestedCode) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid != null) {
      await ref.read(codeSnippetRepositoryProvider).saveCode(uid, arg, suggestedCode);
    }
    state = const CodeAssistantUiState();
  }

  void rejectSuggestion() {
    state = const CodeAssistantUiState();
  }
}

final codeAssistantControllerProvider =
    NotifierProvider.family<CodeAssistantController, CodeAssistantUiState, ProgrammingLanguage>(
      CodeAssistantController.new,
    );
