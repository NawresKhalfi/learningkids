import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../code_playground/domain/programming_language.dart';
import '../../../profile/domain/avatar.dart';
import '../../application/challenge_providers.dart';
import '../../domain/challenge_participant.dart';

/// The weekly challenge (EP10/US56): one fixed prompt for the whole week,
/// marked done by self-report (no automatic judging of the code), with a
/// dedicated leaderboard of everyone who's completed it so far this week.
class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final challenge = ref.watch(currentChallengeProvider);
    final hasCompletedAsync = ref.watch(hasCompletedChallengeProvider);
    final participantsAsync = ref.watch(challengeParticipantsProvider);
    final myUid = ref.watch(authRepositoryProvider).currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.challengeTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cardPurple.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
                border: Border.all(color: AppColors.ink, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(programmingLanguageTitle(challenge.language), style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Text(challenge.title, style: AppTextStyles.headline),
                  const SizedBox(height: AppSpacing.sm),
                  Text(challenge.description, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.md),
                  hasCompletedAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (hasCompleted) => AppButton(
                      label: hasCompleted ? l10n.challengeCompleted : l10n.challengeMarkCompleted,
                      onPressed: hasCompleted
                          ? null
                          : () => ref.read(challengeControllerProvider.notifier).markCompleted(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.challengeLeaderboardTitle, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            participantsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
              data: (participants) {
                if (participants.isEmpty) {
                  return Text(l10n.challengeLeaderboardEmpty, style: AppTextStyles.bodyMuted);
                }
                return Column(
                  children: [
                    for (var i = 0; i < participants.length; i++) ...[
                      _ParticipantRow(rank: i + 1, participant: participants[i], isMe: participants[i].uid == myUid),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({required this.rank, required this.participant, required this.isMe});

  final int rank;
  final ChallengeParticipant participant;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final avatar = Avatar.fromId(participant.avatarId);
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
              participant.pseudo,
              style: AppTextStyles.body.copyWith(color: isMe ? AppColors.surface : AppColors.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
