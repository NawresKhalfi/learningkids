import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../gamification/presentation/widgets/streak_banner.dart';
import '../../../learning_path/domain/learning_path_info.dart';
import '../../../learning_path/domain/primary_path.dart';
import '../../../parental_control/domain/kids_ui_tier.dart';
import '../../../profile/application/profile_controller.dart';

/// Greets the user and opens straight into the path recommended during
/// onboarding (already auto-activated — see `OnboardingController.submit`),
/// or the full path picker (US18) for anyone who wants another track.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
            data: (profile) {
              // US11 "Kids UI": the youngest bracket gets bigger text and a
              // bigger tap target rather than a whole separate theme.
              final tier =
                  profile != null ? resolveKidsUiTier(profile.ageRange) : KidsUiTier.standard;
              final isYoung = tier == KidsUiTier.young;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.homeGreeting(profile?.pseudo ?? ''),
                        style: AppTextStyles.headline.copyWith(fontSize: isYoung ? 34 : 28),
                      ),
                      IconButton(
                        tooltip: l10n.homeProfileTooltip,
                        onPressed: () => context.push(AppRoutes.profile),
                        icon: Container(
                          width: isYoung ? 56 : 44,
                          height: isYoung ? 56 : 44,
                          decoration: BoxDecoration(
                            color:
                                profile?.avatar.palette.surface ?? AppColors.cardBlue.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.ink, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(profile?.avatar.emoji ?? '🙂'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const StreakBanner(),
                  const SizedBox(height: AppSpacing.xl),
                  if (profile != null) ...[
                    Builder(
                      builder: (context) {
                        final primaryPath = primaryPathFor(profile.recommendedPath);
                        final info = learningPathInfo(primaryPath);
                        return GestureDetector(
                          onTap: () => context.push(AppRoutes.roadmap(primaryPath.name)),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.brandPurple,
                              borderRadius: BorderRadius.circular(AppRadii.card),
                              border: Border.all(color: AppColors.ink, width: 2.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.homeRecommendedPathLabel,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.surface,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  '${info.emoji} ${info.title}',
                                  style: AppTextStyles.headline.copyWith(
                                    color: AppColors.surface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.dashboard),
                    child: Text(l10n.homeOpenDashboard),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.paths),
                    child: Text(l10n.homeSeeAllPaths),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.lessonCatalog),
                    child: Text(l10n.homeSeeLessonCatalog),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.codePlayground),
                    child: Text(l10n.homeOpenPlayground),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.myProjects),
                    child: Text(l10n.homeOpenProjects),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.badges),
                    child: Text(l10n.homeOpenBadges),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.leaderboard),
                    child: Text(l10n.homeOpenLeaderboard),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.challenge),
                    child: Text(l10n.homeOpenChallenge),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
