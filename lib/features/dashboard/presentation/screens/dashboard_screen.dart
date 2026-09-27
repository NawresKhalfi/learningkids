import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../gamification/application/gamification_providers.dart';
import '../../../gamification/domain/level.dart';
import '../../../gamification/domain/weekly_summary.dart';
import '../../../learning_path/application/learning_progress_controller.dart';
import '../../../learning_path/domain/learning_path_info.dart';
import '../../../learning_path/domain/primary_path.dart';
import '../../../profile/application/profile_controller.dart';
import '../../domain/path_progress.dart';

/// Learner dashboard based on the supplied mobile mockup, connected to real
/// LearningKids data and destinations.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentProfileProvider);
    final game = ref.watch(gamificationProfileProvider);
    final learning = ref.watch(learningProgressProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: profile.when(
          loading: _loading,
          error: (_, _) => _Error(l10n.commonSomethingWentWrong),
          data: (user) => game.when(
            loading: _loading,
            error: (_, _) => _Error(l10n.commonSomethingWentWrong),
            data: (gamification) => learning.when(
              loading: _loading,
              error: (_, _) => _Error(l10n.commonSomethingWentWrong),
              data: (progress) {
                final weekly = weeklySummaryFor(gamification);
                final path = user == null
                    ? null
                    : primaryPathFor(user.recommendedPath);
                final info = path == null ? null : learningPathInfo(path);
                final pathProgress = path == null
                    ? null
                    : pathProgressFor(path, progress);
                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 112),
                      children: [
                        _Header(
                          name: user?.pseudo ?? '',
                          avatar: user?.avatar.emoji ?? '🙂',
                          avatarColor:
                              user?.avatar.palette.surface ??
                              AppColors.cardBlue.surface,
                          onTap: () => context.push(AppRoutes.profile),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: '🔥',
                                label: 'Série',
                                value: '${gamification.streak.current}',
                                detail: 'jours de suite',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: '⭐',
                                label:
                                    'Niveau ${levelForXp(gamification.totalXp)}',
                                value:
                                    '${xpIntoCurrentLevel(gamification.totalXp)}',
                                detail: '/ $xpPerLevel XP',
                                progress:
                                    xpIntoCurrentLevel(gamification.totalXp) /
                                    xpPerLevel,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _RecommendedCard(
                          title: info?.title ?? 'Choisis ton parcours',
                          emoji: info?.emoji ?? '🧩',
                          progress: pathProgress,
                          onTap: () => context.push(
                            path == null
                                ? AppRoutes.paths
                                : AppRoutes.roadmap(path.name),
                          ),
                        ),
                        const SizedBox(height: 26),
                        const _SectionTitle('Apprendre'),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.18,
                          children: [
                            _Tile(
                              '🗺️',
                              'Tous les parcours',
                              'Choisis ta voie',
                              () => context.push(AppRoutes.paths),
                            ),
                            _Tile(
                              '📚',
                              'Catalogue de leçons',
                              'Explore librement',
                              () => context.push(AppRoutes.lessonCatalog),
                            ),
                            _Tile(
                              '💻',
                              'Espace de code',
                              'Code en direct',
                              () => context.push(AppRoutes.codePlayground),
                            ),
                            _Tile(
                              '🛠️',
                              'Mes projets',
                              'Tes créations',
                              () => context.push(AppRoutes.myProjects),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const _SectionTitle('Ma progression'),
                        const SizedBox(height: 12),
                        _ProgressList(
                          items: [
                            _ListItem(
                              '📊',
                              'Cette semaine',
                              () => _showSummary(
                                context,
                                weekly.lessonsThisWeek,
                                weekly.xpThisWeek,
                                weekly.projectsThisWeek,
                              ),
                            ),
                            _ListItem(
                              '🏅',
                              'Mes badges',
                              () => context.push(AppRoutes.badges),
                            ),
                            _ListItem(
                              '🏆',
                              'Le classement',
                              () => context.push(AppRoutes.leaderboard),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        _Challenge(
                          onTap: () => context.push(AppRoutes.challenge),
                        ),
                      ],
                    ),
                    const _DashboardNavigation(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  static Widget _loading() => const Center(child: CircularProgressIndicator());

  static void _showSummary(
    BuildContext context,
    int lessons,
    int xp,
    int projects,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ta progression', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text('$lessons leçons terminées', style: AppTextStyles.body),
            Text('$xp XP gagnés', style: AppTextStyles.body),
            Text('$projects projets publiés', style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.avatar,
    required this.avatarColor,
    required this.onTap,
  });
  final String name, avatar;
  final Color avatarColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Content de te revoir 👋', style: AppTextStyles.caption),
            Text(
              'Salut, $name !',
              style: AppTextStyles.headline.copyWith(fontSize: 30),
            ),
          ],
        ),
      ),
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 54,
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: avatarColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: Text(avatar, style: const TextStyle(fontSize: 27)),
        ),
      ),
    ],
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
    this.progress,
  });
  final String icon, label, value, detail;
  final double? progress;
  @override
  Widget build(BuildContext context) => _Card(
    radius: 22,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$icon  $label', style: AppTextStyles.caption),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppTextStyles.title.copyWith(fontSize: 26),
              ),
              TextSpan(text: ' $detail', style: AppTextStyles.caption),
            ],
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: AppColors.brandPurple,
              backgroundColor: const Color(0xFFEFE8F9),
            ),
          ),
        ],
      ],
    ),
  );
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.title,
    required this.emoji,
    required this.progress,
    required this.onTap,
  });
  final String title, emoji;
  final PathProgress? progress;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppRadii.card),
    child: Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.brandPurple,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0x19FFFFFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ton parcours recommandé',
                style: AppTextStyles.caption.copyWith(color: AppColors.surface),
              ),
              Text(
                '$emoji $title',
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.surface,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      progress == null
                          ? 'Prêt·e à commencer ?'
                          : '${progress!.completedCount}/${progress!.totalCount} modules terminés',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.surface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppColors.ink, width: 1.5),
                    ),
                    child: Text(
                      'Continuer →',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.brandPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.value);
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(value, style: AppTextStyles.title),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, this.subtitle, this.onTap);
  final String icon, title, subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(22),
    child: _Card(
      radius: 22,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE8F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const Spacer(),
          Text(
            title,
            style: AppTextStyles.body.copyWith(fontSize: 15, height: 1.2),
          ),
          const SizedBox(height: 3),
          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    ),
  );
}

class _ListItem {
  const _ListItem(this.icon, this.label, this.onTap);
  final String icon, label;
  final VoidCallback onTap;
}

class _ProgressList extends StatelessWidget {
  const _ProgressList({required this.items});
  final List<_ListItem> items;
  @override
  Widget build(BuildContext context) => _Card(
    radius: AppRadii.card,
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: Color(0xFFEDE6DA)),
          _ProgressRow(item: items[i]),
        ],
      ],
    ),
  );
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.item});
  final _ListItem item;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: item.onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEFE8F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(item.icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(item.label, style: AppTextStyles.body)),
          Text(
            '›',
            style: AppTextStyles.title.copyWith(
              color: AppColors.brandPurple,
              fontSize: 24,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Challenge extends StatelessWidget {
  const _Challenge({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppRadii.card),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardOrange.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Row(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 34)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Défi de la semaine',
                  style: AppTextStyles.title.copyWith(fontSize: 19),
                ),
                Text(
                  'Relève-le et gagne de l’XP',
                  style: AppTextStyles.caption.copyWith(color: AppColors.ink),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.brandPurple,
              shape: BoxShape.circle,
            ),
            child: Text(
              '→',
              style: AppTextStyles.title.copyWith(color: AppColors.surface),
            ),
          ),
        ],
      ),
    ),
  );
}

class _DashboardNavigation extends StatelessWidget {
  const _DashboardNavigation();
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Nav('🏠', 'Accueil', () => context.go(AppRoutes.home), active: true),
          _Nav('📚', 'Leçons', () => context.push(AppRoutes.lessonCatalog)),
          _Nav('💻', 'Code', () => context.push(AppRoutes.codePlayground)),
          _Nav('🏅', 'Badges', () => context.push(AppRoutes.badges)),
        ],
      ),
    ),
  );
}

class _Nav extends StatelessWidget {
  const _Nav(this.icon, this.label, this.onTap, {this.active = false});
  final String icon, label;
  final VoidCallback onTap;
  final bool active;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(99),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.brandPurple : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11,
              color: active ? AppColors.surface : const Color(0xFFB9B3CF),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    required this.radius,
    required this.padding,
  });
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.ink, width: 2),
    ),
    child: child,
  );
}

class _Error extends StatelessWidget {
  const _Error(this.message);
  final String message;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(message, style: AppTextStyles.body));
}
