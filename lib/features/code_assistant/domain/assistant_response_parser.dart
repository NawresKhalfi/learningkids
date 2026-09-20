/// An assistant reply split into its human-readable explanation and an
/// optional proposed code rewrite (US34), extracted from the last fenced
/// code block in the raw model output.
class ParsedAssistantResponse {
  const ParsedAssistantResponse({required this.explanation, this.suggestedCode});

  final String explanation;
  final String? suggestedCode;
}

final _fencedCodeBlock = RegExp(r'```[a-zA-Z0-9]*\n([\s\S]*?)```');

/// Only [AssistantAction.suggestImprovement] replies are parsed for a code
/// suggestion — "explain" and "find the bug" replies are shown as plain
/// text even if they happen to contain a code block, since US33 explicitly
/// requires those to never hand over a ready-to-apply fix.
ParsedAssistantResponse parseSuggestionResponse(String raw) {
  final match = _fencedCodeBlock.firstMatch(raw);
  if (match == null) return ParsedAssistantResponse(explanation: raw.trim());

  final suggestedCode = match.group(1)!.trimRight();
  final explanation = raw.replaceRange(match.start, match.end, '').trim();
  return ParsedAssistantResponse(explanation: explanation, suggestedCode: suggestedCode);
}
