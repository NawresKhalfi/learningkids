import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/git_simulator_step.dart';

/// The simulated Git/GitHub exercise (EP10/US53): a scripted scenario, not
/// a real terminal — the learner picks the right command at each step and
/// sees a plain-language "journal" of what happened build up underneath.
class GitSimulatorScreen extends StatefulWidget {
  const GitSimulatorScreen({super.key});

  @override
  State<GitSimulatorScreen> createState() => _GitSimulatorScreenState();
}

class _GitSimulatorScreenState extends State<GitSimulatorScreen> {
  int _stepIndex = 0;
  String? _wrongAttempt;
  final _journal = <String>[];

  bool get _isFinished => _stepIndex >= gitSimulatorScenario.length;

  void _pick(String command, GitSimulatorStep step) {
    if (command != step.correctCommand) {
      setState(() => _wrongAttempt = command);
      return;
    }
    setState(() {
      _journal.add(step.resultDescription);
      _wrongAttempt = null;
      _stepIndex++;
    });
  }

  void _restart() {
    setState(() {
      _stepIndex = 0;
      _wrongAttempt = null;
      _journal.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gitSimulatorTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_journal.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final entry in _journal)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(entry, style: AppTextStyles.body.copyWith(color: AppColors.surface)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (_isFinished)
                _FinishedView(onRestart: _restart)
              else
                _StepView(
                  step: gitSimulatorScenario[_stepIndex],
                  wrongAttempt: _wrongAttempt,
                  onPick: (command) => _pick(command, gitSimulatorScenario[_stepIndex]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({required this.step, required this.wrongAttempt, required this.onPick});

  final GitSimulatorStep step;
  final String? wrongAttempt;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(step.instruction, style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.md),
        for (final command in step.commandOptions) ...[
          _CommandButton(command: command, onTap: () => onPick(command)),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (wrongAttempt != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.gitSimulatorTryAgain, style: AppTextStyles.body.copyWith(color: AppColors.error)),
        ],
      ],
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({required this.command, required this.onTap});

  final String command;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Text(command, style: AppTextStyles.body.copyWith(fontFamily: 'monospace')),
      ),
    );
  }
}

class _FinishedView extends StatelessWidget {
  const _FinishedView({required this.onRestart});

  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.celebration, size: 56, color: AppColors.accentYellow),
        const SizedBox(height: AppSpacing.md),
        Text(l10n.gitSimulatorFinished, style: AppTextStyles.headline, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: l10n.gitSimulatorRestart, variant: AppButtonVariant.outline, onPressed: onRestart),
        const SizedBox(height: AppSpacing.sm),
        AppButton(label: l10n.commonBack, onPressed: () => context.pop()),
      ],
    );
  }
}
