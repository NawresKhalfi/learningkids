import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../settings/presentation/widgets/read_aloud_button.dart';
import '../../application/learning_progress_controller.dart';
import '../../domain/curriculum.dart';
import '../../domain/learning_path.dart';
import '../../domain/learning_progress.dart';
import '../../domain/lesson.dart';
import '../../domain/module.dart';
import '../widgets/code_block.dart';

enum _Phase { intro, reading, quiz, completed }

/// The full lesson experience for one module: an intro with a time
/// estimate (US20), the reading content one section at a time with its
/// position saved for later (US25), then a multiple-choice quiz with
/// immediate, explanatory feedback (US21/US22).
class LessonPlayerScreen extends ConsumerStatefulWidget {
  const LessonPlayerScreen({super.key, required this.path, required this.moduleId});

  final LearningPath path;
  final String moduleId;

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen> {
  late final Module _module = moduleById(widget.moduleId);

  _Phase _phase = _Phase.intro;
  int _sectionIndex = 0;
  int _quizIndex = 0;
  int? _selectedAnswerIndex;
  int _correctCount = 0;
  bool _initializedFromProgress = false;

  int get _recapStepIndex => _module.lesson.sections.length;

  void _initFromProgress(LearningProgress progress) {
    if (_initializedFromProgress) return;
    _initializedFromProgress = true;
    final saved = progress.stepIndexFor(_module.id);
    if (saved > 0) {
      _sectionIndex = (saved - 1).clamp(0, _recapStepIndex);
    }
  }

  void _saveStep(int step) {
    ref.read(learningProgressControllerProvider.notifier).saveLessonStep(_module.id, step);
  }

  void _start() => setState(() {
        _phase = _Phase.reading;
        _saveStep(_sectionIndex + 1);
      });

  void _next() {
    if (_sectionIndex < _recapStepIndex) {
      setState(() => _sectionIndex++);
      _saveStep(_sectionIndex + 1);
    } else {
      setState(() => _phase = _Phase.quiz);
    }
  }

  void _previous() {
    if (_sectionIndex > 0) {
      setState(() => _sectionIndex--);
      _saveStep(_sectionIndex + 1);
    } else {
      setState(() => _phase = _Phase.intro);
    }
  }

  void _selectAnswer(int index) {
    if (_selectedAnswerIndex != null) return;
    setState(() {
      _selectedAnswerIndex = index;
      if (_module.quiz[_quizIndex].isCorrect(index)) _correctCount++;
    });
  }

  Future<void> _nextQuestion() async {
    if (_quizIndex < _module.quiz.length - 1) {
      setState(() {
        _quizIndex++;
        _selectedAnswerIndex = null;
      });
      return;
    }
    await ref
        .read(learningProgressControllerProvider.notifier)
        .markModuleCompleted(widget.path, _module.id, correctAnswers: _correctCount);
    if (mounted) setState(() => _phase = _Phase.completed);
  }

  void _reviewLesson() {
    setState(() {
      _phase = _Phase.reading;
      _sectionIndex = 0;
      _quizIndex = 0;
      _correctCount = 0;
      _selectedAnswerIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progressAsync = ref.watch(learningProgressProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_module.title)),
      body: SafeArea(
        child: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (progress) {
            _initFromProgress(progress);
            switch (_phase) {
              case _Phase.intro:
                return _buildIntro(l10n, progress);
              case _Phase.reading:
                return _buildReading(l10n);
              case _Phase.quiz:
                return _buildQuiz(l10n);
              case _Phase.completed:
                return _buildCompleted(l10n);
            }
          },
        ),
      ),
    );
  }

  Widget _buildIntro(AppLocalizations l10n, LearningProgress progress) {
    final isCompleted = progress.completedIdsFor(widget.path).contains(_module.id);
    final hasSavedStep = progress.stepIndexFor(_module.id) > 0;
    final startLabel = isCompleted
        ? l10n.lessonIntroReread
        : (hasSavedStep ? l10n.lessonIntroResume : l10n.lessonIntroStart);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_module.description, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardYellow.surface,
              borderRadius: BorderRadius.circular(AppRadii.chip),
              border: Border.all(color: AppColors.ink, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule, size: 18, color: AppColors.ink),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.lessonIntroDuration(estimatedLessonMinutes(_module)),
                  style: AppTextStyles.caption.copyWith(color: AppColors.ink),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.lessonIntroOutlineTitle, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          for (final section in _module.lesson.sections)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.inkMuted),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(section.heading, style: AppTextStyles.body)),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: startLabel, onPressed: _start),
        ],
      ),
    );
  }

  Widget _buildReading(AppLocalizations l10n) {
    final isRecap = _sectionIndex == _recapStepIndex;
    final totalSteps = _recapStepIndex + 1;
    final currentSection = isRecap ? null : _module.lesson.sections[_sectionIndex];
    final readAloudText = isRecap ? _module.lesson.recap : '${currentSection!.heading}. ${currentSection.body}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.lessonStepProgress(_sectionIndex + 1, totalSteps),
                  style: AppTextStyles.caption,
                ),
              ),
              ReadAloudButton(text: readAloudText),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: isRecap
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.lessonRecapTitle, style: AppTextStyles.headline),
                      const SizedBox(height: AppSpacing.sm),
                      Text(_module.lesson.recap, style: AppTextStyles.body),
                    ],
                  )
                : _SectionView(section: _module.lesson.sections[_sectionIndex]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.lessonPrevious,
                  variant: AppButtonVariant.outline,
                  onPressed: _previous,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: isRecap ? l10n.lessonStartQuiz : l10n.lessonNext,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz(AppLocalizations l10n) {
    final question = _module.quiz[_quizIndex];
    final hasAnswered = _selectedAnswerIndex != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quizQuestionProgress(_quizIndex + 1, _module.quiz.length),
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(question.prompt, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < question.options.length; i++) ...[
            OptionButton(
              label: question.options[i],
              isSelected: _selectedAnswerIndex == i,
              feedback: !hasAnswered
                  ? OptionFeedback.none
                  : i == question.correctIndex
                      ? OptionFeedback.correct
                      : (i == _selectedAnswerIndex ? OptionFeedback.incorrect : OptionFeedback.none),
              onTap: hasAnswered ? null : () => _selectAnswer(i),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (hasAnswered) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardBlue.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: Text(question.explanation, style: AppTextStyles.body),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: _quizIndex < _module.quiz.length - 1 ? l10n.quizNext : l10n.quizFinish,
              onPressed: _nextQuestion,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Center(
            child: TextButton(
              onPressed: _reviewLesson,
              child: Text(l10n.quizReviewLesson),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleted(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 64, color: AppColors.accentYellow),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.lessonCompletedTitle, style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.lessonCompletedMessage(_correctCount, _module.quiz.length),
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_module.practicalExercise != null) ...[
            AppButton(
              label: l10n.lessonTryPracticalExercise,
              variant: AppButtonVariant.secondary,
              onPressed: () => context.push(AppRoutes.gitSimulator),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppButton(
            label: l10n.lessonCompletedBackToRoadmap,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({required this.section});

  final LessonSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(section.heading, style: AppTextStyles.headline),
        const SizedBox(height: AppSpacing.sm),
        Text(section.body, style: AppTextStyles.body),
        if (section.codeExample != null) ...[
          const SizedBox(height: AppSpacing.md),
          CodeBlock(code: section.codeExample!),
        ],
      ],
    );
  }
}
