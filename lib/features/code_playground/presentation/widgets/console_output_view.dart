import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/code_execution_result.dart';
import '../../domain/friendly_error_explanations.dart';
import '../../domain/programming_language.dart';

/// The "sortie console" from US27: whatever the code printed, plus — when
/// it failed — the line, error type and a plain-language explanation
/// (US28), never just "faux"/a raw crash message.
class ConsoleOutputView extends StatelessWidget {
  const ConsoleOutputView({super.key, required this.language, this.result});

  final ProgrammingLanguage language;
  final CodeExecutionResult? result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final result = this.result;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (result == null)
              Text(l10n.playgroundConsolePlaceholder, style: _outputStyle(AppColors.inkMuted))
            else ...[
              if (result.stdout.isNotEmpty) Text(result.stdout, style: _outputStyle(AppColors.surface)),
              if (result.hasError) ...[
                if (result.stdout.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                _ErrorCard(language: language, result: result),
              ],
              if (result.stdout.isEmpty && !result.hasError)
                Text(l10n.playgroundConsoleNoOutput, style: _outputStyle(AppColors.inkMuted)),
            ],
          ],
        ),
      ),
    );
  }

  TextStyle _outputStyle(Color color) =>
      TextStyle(fontFamily: 'monospace', fontSize: 14, height: 1.4, color: color);
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.language, required this.result});

  final ProgrammingLanguage language;
  final CodeExecutionResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = result.error!;
    final explanation = friendlyErrorExplanation(language, error.errorType);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            error.line == null
                ? '${error.errorType ?? l10n.playgroundErrorGenericType}: ${error.message}'
                : l10n.playgroundErrorAtLine(
                    error.line!,
                    error.errorType ?? l10n.playgroundErrorGenericType,
                    error.message,
                  ),
            style: const TextStyle(
              fontFamily: 'monospace',
              color: AppColors.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (explanation != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(explanation, style: AppTextStyles.body.copyWith(color: AppColors.surface)),
          ],
        ],
      ),
    );
  }
}
