import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/storage/local_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../learning_path/domain/learning_path.dart';
import '../../../learning_path/domain/path_code_languages.dart';
import '../../application/code_runtime_providers.dart';
import '../../application/code_snippet_controller.dart';
import '../../application/shared_snippet_providers.dart';
import '../../data/code_runtime_service.dart';
import '../../domain/code_execution_result.dart';
import '../../domain/dart_playground_transpiler.dart';
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
class CodePlaygroundScreen extends ConsumerStatefulWidget {
  const CodePlaygroundScreen({super.key, this.paths});

  final Set<LearningPath>? paths;

  @override
  ConsumerState<CodePlaygroundScreen> createState() =>
      _CodePlaygroundScreenState();
}

class _CodePlaygroundScreenState extends ConsumerState<CodePlaygroundScreen> {
  late final String _scope = () {
    if (widget.paths == null) return 'all';
    final ids = widget.paths!.map((path) => path.name).toList()..sort();
    return ids.join('_');
  }();
  late final List<ProgrammingLanguage> _languages;
  late ProgrammingLanguage _selected;

  @override
  void initState() {
    super.initState();
    final base = widget.paths == null
        ? ProgrammingLanguage.values
        : {
            for (final path in widget.paths!)
              ...programmingLanguagesForPath(path),
          }.toList();
    final extras = ref
        .read(localPreferencesProvider)
        .extraCodeLanguages(_scope);
    _languages = [
      ...base,
      for (final id in extras)
        if (ProgrammingLanguage.values
                .where((language) => language.name == id)
                .firstOrNull
            case final language?)
          if (!base.contains(language)) language,
    ];
    _selected = _languages.first;
  }

  Future<void> _addLanguages() async {
    final available = ProgrammingLanguage.values
        .where((language) => !_languages.contains(language))
        .toList();
    if (available.isEmpty) return;
    final picked = await showDialog<Set<ProgrammingLanguage>>(
      context: context,
      builder: (context) {
        final selection = <ProgrammingLanguage>{};
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Ajouter des langages'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final language in available)
                  CheckboxListTile(
                    value: selection.contains(language),
                    title: Text(programmingLanguageTitle(language)),
                    contentPadding: EdgeInsets.zero,
                    onChanged: (selected) => setDialogState(() {
                      if (selected ?? false) {
                        selection.add(language);
                      } else {
                        selection.remove(language);
                      }
                    }),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: selection.isEmpty
                    ? null
                    : () => Navigator.of(context).pop(selection),
                child: const Text('Ajouter'),
              ),
            ],
          ),
        );
      },
    );
    if (picked == null || picked.isEmpty || !mounted) return;
    setState(() {
      _languages.addAll(picked);
      _selected = picked.first;
    });
    await ref
        .read(localPreferencesProvider)
        .setExtraCodeLanguages(
          _scope,
          _languages.map((language) => language.name).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.playgroundTitle)),
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
                onAdd: _addLanguages,
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
    required this.onAdd,
  });

  final List<ProgrammingLanguage> languages;
  final ProgrammingLanguage selected;
  final ValueChanged<ProgrammingLanguage> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final language in languages) ...[
            SizedBox(
              width: 145,
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
            if (language != languages.last)
              const SizedBox(width: AppSpacing.sm),
          ],
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.chip),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
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
    final source = widget.language == ProgrammingLanguage.dart
        ? transpileDartForPlayground(_controller.text)
        : _controller.text;
    final result = await runtime.run(source);
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _result = result;
    });
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
      ProgrammingLanguage.dart => ref.watch(javascriptRuntimeServiceProvider),
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
                  label: l10n.playgroundShareSnippet,
                  variant: AppButtonVariant.secondary,
                  onPressed: _shareSnippet,
                ),
              ),
            ],
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
