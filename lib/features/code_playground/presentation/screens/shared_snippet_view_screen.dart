import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/shared_snippet_providers.dart';
import '../../domain/programming_language.dart';

/// A read-only view of a snippet shared with a code (EP10/US55) — the
/// counterpart to `_OwnPortfolioControls`'s "enter a friend's code" flow in
/// `PortfolioScreen`, for a single code snippet instead of a whole project.
class SharedSnippetViewScreen extends ConsumerWidget {
  const SharedSnippetViewScreen({super.key, required this.snippetId});

  final String snippetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snippetAsync = ref.watch(sharedSnippetProvider(snippetId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sharedSnippetTitle)),
      body: SafeArea(
        child: snippetAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.sharedSnippetNotFound)),
          data: (snippet) {
            if (snippet == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l10n.sharedSnippetNotFound, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.sharedSnippetBy(snippet.pseudo, programmingLanguageTitle(snippet.language)),
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                    child: Text(
                      snippet.code,
                      style: const TextStyle(fontFamily: 'monospace', color: AppColors.surface, fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
