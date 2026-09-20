import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../application/code_assistant_providers.dart';
import '../../domain/assistant_action.dart';
import '../../domain/chat_message.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/suggestion_card.dart';

/// The assistant panel opened from the Code Playground for one language's
/// current code (EP06). Pops with the accepted suggestion's code, if any,
/// so the caller can refresh its editor immediately (US34/US35).
class CodeAssistantScreen extends ConsumerStatefulWidget {
  const CodeAssistantScreen({super.key, required this.language, required this.code});

  final ProgrammingLanguage language;
  final String code;

  @override
  ConsumerState<CodeAssistantScreen> createState() => _CodeAssistantScreenState();
}

class _CodeAssistantScreenState extends ConsumerState<CodeAssistantScreen> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _sendFreeMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    ref.read(codeAssistantControllerProvider(widget.language).notifier).sendFreeMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final historyAsync = ref.watch(chatHistoryProvider(widget.language));
    final uiState = ref.watch(codeAssistantControllerProvider(widget.language));
    final controller = ref.read(codeAssistantControllerProvider(widget.language).notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.assistantTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _QuickAction(
                    label: l10n.assistantActionExplain,
                    onTap: uiState.isSending
                        ? null
                        : () => controller.runAction(AssistantAction.explainCode, widget.code),
                  ),
                  _QuickAction(
                    label: l10n.assistantActionFindBug,
                    onTap: uiState.isSending ? null : () => controller.runAction(AssistantAction.findBug, widget.code),
                  ),
                  _QuickAction(
                    label: l10n.assistantActionImprove,
                    onTap: uiState.isSending
                        ? null
                        : () => controller.runAction(AssistantAction.suggestImprovement, widget.code),
                  ),
                ],
              ),
            ),
            Expanded(
              child: historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
                data: (messages) => _ConversationView(messages: messages, uiState: uiState, controller: controller),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        decoration: InputDecoration(hintText: l10n.assistantInputHint),
                        onSubmitted: (_) => _sendFreeMessage(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: uiState.isSending ? null : _sendFreeMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationView extends StatelessWidget {
  const _ConversationView({required this.messages, required this.uiState, required this.controller});

  final List<ChatMessage> messages;
  final CodeAssistantUiState uiState;
  final CodeAssistantController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (messages.isEmpty && !uiState.isSending && !uiState.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(l10n.assistantEmptyState, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
        ),
      );
    }

    final lastMessage = messages.isEmpty ? null : messages.last;
    final pendingSuggestion = uiState.pendingSuggestion;
    final showSuggestion =
        pendingSuggestion != null && lastMessage?.role == ChatRole.assistant && lastMessage?.suggestedCode == pendingSuggestion;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        for (final message in messages) ChatBubble(message: message),
        if (showSuggestion)
          SuggestionCard(
            suggestedCode: pendingSuggestion,
            onAccept: () async {
              await controller.acceptSuggestion(pendingSuggestion);
              if (context.mounted) context.pop(pendingSuggestion);
            },
            onReject: controller.rejectSuggestion,
          ),
        if (uiState.isSending)
          const Padding(padding: EdgeInsets.symmetric(vertical: AppSpacing.md), child: Center(child: CircularProgressIndicator())),
        if (uiState.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(l10n.assistantErrorGeneric, style: AppTextStyles.bodyMuted),
          ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.brandPurple,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: AppColors.ink, width: 1.5),
          ),
          child: Text(label, style: AppTextStyles.button.copyWith(color: AppColors.surface, fontSize: 14)),
        ),
      ),
    );
  }
}
