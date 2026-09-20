import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../profile/domain/avatar.dart';
import '../../application/gamification_providers.dart';
import '../../domain/leaderboard_entry.dart';

/// The global leaderboard (US46): the top learners by total XP. A parent
/// can remove their child from this entirely from the parent space
/// (US48) — see `ParentDashboardScreen`.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entriesAsync = ref.watch(leaderboardProvider);
    final myUid = ref.watch(authRepositoryProvider).currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaderboardTitle)),
      body: SafeArea(
        child: entriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (entries) {
            if (entries.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(l10n.leaderboardEmpty, style: AppTextStyles.bodyMuted, textAlign: TextAlign.center),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return _LeaderboardRow(rank: index + 1, entry: entry, isMe: entry.uid == myUid);
              },
            );
          },
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.rank, required this.entry, required this.isMe});

  final int rank;
  final LeaderboardEntry entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final avatar = Avatar.fromId(entry.avatarId);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isMe ? AppColors.brandBlue : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('#$rank', style: AppTextStyles.body.copyWith(color: isMe ? AppColors.surface : AppColors.ink)),
          ),
          Text(avatar.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              entry.pseudo,
              style: AppTextStyles.body.copyWith(color: isMe ? AppColors.surface : AppColors.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${entry.totalXp} XP',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w800,
              color: isMe ? AppColors.surface : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
