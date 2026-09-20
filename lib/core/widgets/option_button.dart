import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A big rounded selectable option. Used for the onboarding age/level/goals
/// steps (single- and multi-select) and for quiz answers (US21/US22), where
/// [feedback] colours the tapped answer green/red and reveals the correct
/// one once the learner has answered.
enum OptionFeedback { none, correct, incorrect }

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.emoji,
    this.feedback = OptionFeedback.none,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? emoji;
  final OptionFeedback feedback;

  Color get _backgroundColor {
    switch (feedback) {
      case OptionFeedback.correct:
        return AppColors.success;
      case OptionFeedback.incorrect:
        return AppColors.error;
      case OptionFeedback.none:
        return isSelected ? AppColors.brandBlue : AppColors.surface;
    }
  }

  bool get _isHighlighted => isSelected || feedback != OptionFeedback.none;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.button),
          border: Border.all(color: AppColors.ink, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: _isHighlighted ? 0 : 0.15),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: _isHighlighted ? AppColors.surface : AppColors.ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (feedback == OptionFeedback.correct)
              const Icon(Icons.check_circle, color: AppColors.surface)
            else if (feedback == OptionFeedback.incorrect)
              const Icon(Icons.cancel, color: AppColors.surface)
            else if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.surface),
          ],
        ),
      ),
    );
  }
}
