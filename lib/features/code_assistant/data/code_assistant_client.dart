import 'package:firebase_ai/firebase_ai.dart';

import '../domain/chat_message.dart';

/// Sends one prompt to an AI chat session and returns its text reply.
/// Abstracted behind an interface — like `CodeRuntimeService`'s WebView in
/// EP05 — because `firebase_ai` has no test double: the real
/// [FirebaseCodeAssistantClient] is exercised manually, while everything
/// built on top of this interface (prompt building, response parsing, the
/// controller) is unit-tested against a fake implementation.
abstract class CodeAssistantClient {
  Future<String> sendMessage(String prompt);
}

/// A [CodeAssistantClient] backed by Gemini through Firebase AI Logic, so no
/// API key ever ships in the app and no separate backend is needed. Safety
/// settings are turned up (US37) on top of the system instruction's own
/// content-and-tone rules.
class FirebaseCodeAssistantClient implements CodeAssistantClient {
  FirebaseCodeAssistantClient({required String systemInstruction, List<ChatMessage> priorHistory = const []}) {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.0-flash',
      systemInstruction: Content.system(systemInstruction),
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low, null),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low, null),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.low, null),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.low, null),
      ],
    );
    _chat = model.startChat(
      history: [
        for (final message in priorHistory)
          if (message.role == ChatRole.user)
            Content.text(message.text)
          else
            Content.model([TextPart(message.text)]),
      ],
    );
  }

  late final ChatSession _chat;

  @override
  Future<String> sendMessage(String prompt) async {
    final response = await _chat.sendMessage(Content.text(prompt));
    return response.text ?? '';
  }
}

/// Builds a [CodeAssistantClient] for a conversation — a `typedef` so tests
/// can override the provider with a factory that returns a fake client
/// instead of talking to Firebase.
typedef CodeAssistantClientFactory =
    CodeAssistantClient Function({required String systemInstruction, List<ChatMessage> priorHistory});
