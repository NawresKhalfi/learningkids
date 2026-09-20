import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A 7-day bar chart of minutes spent in the app — shared by the parent
/// dashboard (US08) and the learner-facing progress dashboard (EP09/US49).
class WeeklyUsageChart extends StatelessWidget {
  const WeeklyUsageChart({super.key, required this.history});

  final Map<DateTime, int> history;

  @override
  Widget build(BuildContext context) {
    final maxMinutes = history.values.fold<int>(30, (max, v) => v > max ? v : max);
    const dayLabels = ['lun', 'mar', 'mer', 'jeu', 'ven', 'sam', 'dim'];

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final entry in history.entries)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${entry.value}', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Container(
                      height: 80 * (entry.value / maxMinutes).clamp(0.04, 1.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardBlue.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.ink, width: 1.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(dayLabels[entry.key.weekday - 1], style: AppTextStyles.caption),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
