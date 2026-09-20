enum ChatRole { user, assistant }

/// One turn of the code-assistant conversation (US36). [suggestedCode] is set
/// only on an assistant message produced by [AssistantAction.suggestImprovement]
/// (US34) — the UI offers to apply it, but never does so automatically (US35).
class ChatMessage {
  const ChatMessage({required this.role, required this.text, this.suggestedCode});

  final ChatRole role;
  final String text;
  final String? suggestedCode;

  Map<String, dynamic> toMap() => {
    'role': role.name,
    'text': text,
    if (suggestedCode != null) 'suggestedCode': suggestedCode,
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    role: ChatRole.values.byName(map['role'] as String),
    text: map['text'] as String,
    suggestedCode: map['suggestedCode'] as String?,
  );
}
