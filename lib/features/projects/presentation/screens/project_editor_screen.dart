import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/preview_capture.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../code_playground/application/code_runtime_providers.dart';
import '../../../code_playground/data/code_runtime_service.dart';
import '../../../code_playground/domain/code_execution_result.dart';
import '../../../code_playground/domain/dart_playground_transpiler.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../../code_playground/presentation/widgets/code_editor_field.dart';
import '../../../code_playground/presentation/widgets/code_symbol_toolbar.dart';
import '../../../code_playground/presentation/widgets/console_output_view.dart';
import '../../../code_playground/presentation/widgets/hidden_runtime_webview.dart';
import '../../../code_playground/presentation/widgets/html_preview_view.dart';
import '../../application/project_providers.dart';
import '../../domain/project.dart';
import '../widgets/rename_project_dialog.dart';
import '../widgets/select_category_dialog.dart';

/// The single-project workspace (US38 continued, US39, US41, US42): the
/// same editor/run/console building blocks as the Code Playground (EP05),
/// bound to one saved [Project] instead of a per-language scratch buffer,
/// plus category, AI feedback and publish controls.
class ProjectEditorScreen extends ConsumerWidget {
  const ProjectEditorScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final projectAsync = ref.watch(projectByIdProvider(projectId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.projectEditorTitle)),
      body: SafeArea(
        child: projectAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (project) => project == null
              ? Center(child: Text(l10n.commonSomethingWentWrong))
              : _EditorBody(project: project),
        ),
      ),
    );
  }
}

class _EditorBody extends ConsumerStatefulWidget {
  const _EditorBody({required this.project});

  final Project project;

  @override
  ConsumerState<_EditorBody> createState() => _EditorBodyState();
}

class _EditorBodyState extends ConsumerState<_EditorBody> {
  late final CodeController _controller = CodeController(
    text: widget.project.code,
    language: highlightModeFor(widget.project.language),
  );
  final _previewKey = GlobalKey();

  CodeExecutionResult? _result;
  String? _htmlOutput;
  bool _isRunning = false;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    ref
        .read(projectsControllerProvider.notifier)
        .updateCode(widget.project, _controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run(CodeRuntimeService? runtime) async {
    if (widget.project.language == ProgrammingLanguage.html) {
      setState(() => _htmlOutput = _controller.text);
      return;
    }
    if (runtime == null) return;
    setState(() {
      _isRunning = true;
      _result = null;
    });
    final source = widget.project.language == ProgrammingLanguage.dart
        ? transpileDartForPlayground(_controller.text)
        : _controller.text;
    final result = await runtime.run(source);
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _result = result;
    });
  }

  Future<void> _shareWithFriend() => SharePlus.instance.share(
    ShareParams(
      text:
          'Regarde mon projet « ${widget.project.title} » !\n\n${_controller.text}',
    ),
  );

  Future<void> _togglePublish() async {
    setState(() => _isPublishing = true);
    final controller = ref.read(projectsControllerProvider.notifier);
    if (widget.project.isPublished) {
      await controller.unpublish(widget.project);
    } else {
      final thumbnail = await PreviewCapture.captureBase64(_previewKey);
      await controller.publish(widget.project, thumbnailBase64: thumbnail);
    }
    if (!mounted) return;
    setState(() => _isPublishing = false);
  }

  Future<void> _rename() async {
    final newTitle = await showRenameProjectDialog(
      context,
      initialTitle: widget.project.title,
    );
    if (newTitle == null || newTitle.isEmpty) return;
    await ref
        .read(projectsControllerProvider.notifier)
        .rename(widget.project, newTitle);
  }

  Future<void> _pickCategory() async {
    final category = await showSelectCategoryDialog(
      context,
      initial: widget.project.category,
    );
    if (category == null) return;
    await ref
        .read(projectsControllerProvider.notifier)
        .setCategory(widget.project, category);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.projectDeleteConfirmTitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.projectDeleteConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    await ref.read(projectsControllerProvider.notifier).delete(widget.project);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final runtime = switch (widget.project.language) {
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
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _rename,
                  child: Text(
                    widget.project.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.category_outlined),
                onPressed: _pickCategory,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _delete,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
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
                  onPressed: _shareWithFriend,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            flex: 2,
            child: PreviewCapture(
              boundaryKey: _previewKey,
              child: widget.project.language == ProgrammingLanguage.html
                  ? (_htmlOutput == null
                        ? Center(child: Text(l10n.playgroundConsolePlaceholder))
                        : HtmlPreviewView(html: _htmlOutput!))
                  : ConsoleOutputView(
                      language: widget.project.language,
                      result: _result,
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: widget.project.isPublished
                ? l10n.projectUnpublish
                : l10n.projectPublish,
            variant: widget.project.isPublished
                ? AppButtonVariant.outline
                : AppButtonVariant.primary,
            isLoading: _isPublishing,
            onPressed: _togglePublish,
          ),
        ],
      ),
    );
  }
}
