import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A labelled progress bar — used for both per-path and goal-vs-progress
/// rows on the dashboard (US49/US52).
class ProgressBarRow extends StatelessWidget {
  const ProgressBarRow({super.key, required this.label, required this.ratio, required this.trailing});

  final String label;
  final double ratio;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body),
            Text(trailing, style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: LinearProgressIndicator(
            value: ratio.clamp(0, 1),
            minHeight: 10,
            backgroundColor: AppColors.background,
            color: AppColors.brandBlue,
          ),
        ),
      ],
    );
  }
}
