import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/gamification_providers.dart';
import '../../domain/level.dart';
import '../../domain/streak.dart';

/// The streak + level summary shown on the home screen (US43/US47). Turns
/// yellow with a warning line once the streak is at risk of lapsing today
/// — the in-app half of US43's "rappel avant la perte du streak"; real
/// push reminders are EP11's job.
class StreakBanner extends ConsumerWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(gamificationProfileProvider);

    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (profile) {
        final atRisk = isStreakAtRisk(profile.streak, DateTime.now());
        final level = levelForXp(profile.totalXp);
        final xpIntoLevel = xpIntoCurrentLevel(profile.totalXp);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: atRisk ? AppColors.accentYellow : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.ink, width: 1.5),
          ),
          child: Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 30)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.streakDaysCount(profile.streak.current),
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      atRisk ? l10n.streakAtRiskWarning : l10n.levelLabel(level, xpIntoLevel, xpPerLevel),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
