import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../code_assistant/presentation/screens/code_assistant_screen.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../../learning_path/domain/path_code_languages.dart';
import '../../application/code_runtime_providers.dart';
import '../../application/code_snippet_controller.dart';
import '../../application/shared_snippet_providers.dart';
import '../../data/code_runtime_service.dart';
import '../../domain/code_execution_result.dart';
import '../../domain/programming_language.dart';
import '../widgets/code_editor_field.dart';
import '../widgets/code_symbol_toolbar.dart';
import '../widgets/console_output_view.dart';
import '../widgets/hidden_runtime_webview.dart';
import '../widgets/html_preview_view.dart';

/// EP05's "IDE mobile" (US26/US27): one editor + run button + output per
/// language. All three stay mounted at once (`IndexedStack`) so switching
/// tabs never loses unsaved edits or the last run's output, and so a
/// Python/JS runtime only ever has to warm up once per visit to this
/// screen — not once per tab switch.
class CodePlaygroundScreen extends StatefulWidget {
  const CodePlaygroundScreen({super.key, this.path});

  final LearningPath? path;

  @override
  State<CodePlaygroundScreen> createState() => _CodePlaygroundScreenState();
}

class _CodePlaygroundScreenState extends State<CodePlaygroundScreen> {
  late final List<ProgrammingLanguage> _languages = widget.path == null
      ? ProgrammingLanguage.values
      : programmingLanguagesForPath(widget.path!);
  late ProgrammingLanguage _selected = _languages.first;

  Future<void> _promptSnippetCode(BuildContext context) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.playgroundViewSharedSnippet),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: l10n.playgroundSnippetCodeHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: Text(l10n.commonContinue),
            ),
          ],
        );
      },
    );
    if (code == null || code.isEmpty || !context.mounted) return;
    context.push(AppRoutes.sharedSnippetView(code));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.playgroundTitle),
        actions: [
          IconButton(
            tooltip: l10n.playgroundViewSharedSnippet,
            icon: const Icon(Icons.link),
            onPressed: () => _promptSnippetCode(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: _LanguageTabs(
                languages: _languages,
                selected: _selected,
                onSelect: (language) => setState(() => _selected = language),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _languages.indexOf(_selected),
                children: [
                  for (final language in _languages)
                    _LanguageEditorBody(language: language),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTabs extends StatelessWidget {
  const _LanguageTabs({
    required this.languages,
    required this.selected,
    required this.onSelect,
  });

  final List<ProgrammingLanguage> languages;
  final ProgrammingLanguage selected;
  final ValueChanged<ProgrammingLanguage> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final language in languages) ...[
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(language),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: language == selected
                      ? AppColors.brandBlue
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                  border: Border.all(color: AppColors.ink, width: 1.5),
                ),
                child: Text(
                  programmingLanguageTitle(language),
                  style: AppTextStyles.body.copyWith(
                    color: language == selected
                        ? AppColors.surface
                        : AppColors.ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
          if (language != languages.last) const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _LanguageEditorBody extends ConsumerWidget {
  const _LanguageEditorBody({required this.language});

  final ProgrammingLanguage language;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final codeAsync = ref.watch(codeSnippetProvider(language));

    return codeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
      data: (initialCode) =>
          _EditorBody(language: language, initialCode: initialCode),
    );
  }
}

class _EditorBody extends ConsumerStatefulWidget {
  const _EditorBody({required this.language, required this.initialCode});

  final ProgrammingLanguage language;
  final String initialCode;

  @override
  ConsumerState<_EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends ConsumerState<_EditorBody> {
  late final CodeController _controller = CodeController(
    text: widget.initialCode,
    language: highlightModeFor(widget.language),
  );

  CodeExecutionResult? _result;
  String? _htmlOutput;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    ref
        .read(codeSnippetControllerProvider.notifier)
        .onCodeChanged(widget.language, _controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run(CodeRuntimeService? runtime) async {
    if (widget.language == ProgrammingLanguage.html) {
      setState(() => _htmlOutput = _controller.text);
      return;
    }
    if (runtime == null) return;
    setState(() {
      _isRunning = true;
      _result = null;
    });
    final result = await runtime.run(_controller.text);
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _result = result;
    });
  }

  Future<void> _openAssistant() async {
    final acceptedCode = await context.push<String>(
      AppRoutes.codeAssistant,
      extra: CodeAssistantScreen(
        language: widget.language,
        code: _controller.text,
      ),
    );
    if (acceptedCode != null && mounted) {
      _controller.text = acceptedCode;
    }
  }

  Future<void> _shareSnippet() async {
    final l10n = AppLocalizations.of(context);
    try {
      final id = await ref
          .read(sharedSnippetControllerProvider.notifier)
          .shareSnippet(language: widget.language, code: _controller.text);
      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(text: l10n.playgroundShareMessage(id)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.playgroundShareFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final runtime = switch (widget.language) {
      ProgrammingLanguage.python => ref.watch(pythonRuntimeServiceProvider),
      ProgrammingLanguage.javascript => ref.watch(
        javascriptRuntimeServiceProvider,
      ),
      ProgrammingLanguage.html => null,
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (runtime != null)
            HiddenRuntimeWebView(controller: runtime.controller),
          CodeSymbolToolbar(controller: _controller),
          const SizedBox(height: AppSpacing.sm),
          Expanded(flex: 3, child: CodeEditorField(controller: _controller)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.playgroundRun,
                  isLoading: _isRunning,
                  onPressed: () => _run(runtime),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: l10n.playgroundOpenAssistant,
                  variant: AppButtonVariant.secondary,
                  onPressed: _openAssistant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton.icon(
              onPressed: _shareSnippet,
              icon: const Icon(Icons.share_outlined, size: 18),
              label: Text(l10n.playgroundShareSnippet),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            flex: 2,
            child: widget.language == ProgrammingLanguage.html
                ? (_htmlOutput == null
                      ? Center(
                          child: Text(
                            l10n.playgroundConsolePlaceholder,
                            style: AppTextStyles.bodyMuted,
                          ),
                        )
                      : HtmlPreviewView(html: _htmlOutput!))
                : ConsoleOutputView(language: widget.language, result: _result),
          ),
        ],
      ),
    );
  }
}
