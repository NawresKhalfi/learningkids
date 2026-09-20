import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/gamification_providers.dart';
import '../../domain/badge_catalog.dart';
import '../../domain/badge_definition.dart';

/// Every badge, locked or unlocked (US44).
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(gamificationProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.badgesTitle)),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (profile) => GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.75,
            ),
            itemCount: badgeCatalog.length,
            itemBuilder: (context, index) {
              final badge = badgeCatalog[index];
              final unlocked = profile.unlockedBadgeIds.contains(badge.id);
              return _BadgeCard(badge: badge, unlocked: unlocked);
            },
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.unlocked});

  final BadgeDefinition badge;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: unlocked ? AppColors.accentYellow : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.ink, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: AppSpacing.xs),
            Text(
              badge.title,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
