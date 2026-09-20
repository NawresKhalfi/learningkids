/// Shown instead of the model's reply when Gemini's safety filters block the
/// response outright (US37) — e.g. an off-topic or inappropriate question.
/// Keeping this as a fixed, reviewed sentence (rather than trying to relay
/// whatever the model refused to say) guarantees the fallback itself is
/// always age-appropriate.
const offTopicFallbackMessage =
    "Je suis là pour t'aider avec le code ! Je ne peux pas répondre à ça, "
    'mais pose-moi une question sur ton programme et je t\'aiderai avec '
    'plaisir 🙂';
