/// The three guided actions the assistant offers on the current code (EP06):
/// explaining it (US32), pointing at a bug without fixing it (US33), and
/// suggesting an improvement with a proposed rewrite (US34). Free-form
/// questions (US36) don't need an [AssistantAction] — they're sent as plain
/// text.
enum AssistantAction { explainCode, findBug, suggestImprovement }
