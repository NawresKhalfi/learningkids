import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../admin/application/admin_providers.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../auth/data/auth_repository.dart';
import '../../application/profile_controller.dart';
import '../widgets/delete_account_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteAccountDialog(context);
    if (!confirmed) return;
    final failure = await ref
        .read(profileControllerProvider.notifier)
        .deleteAccount();
    if (!context.mounted || failure == null) return;
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.profileDeleteReauthRequired)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final email = ref.watch(authStateChangesProvider).valueOrNull?.email;
    final isLoading = ref.watch(profileControllerProvider).isLoading;
    final isAdmin = ref.watch(isAdminProvider).valueOrNull ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (profile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color:
                          profile?.avatar.palette.surface ??
                          AppColors.cardBlue.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.ink, width: 3),
                    ),
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    child: profile?.avatarImageBase64 == null
                        ? Text(
                            profile?.avatar.emoji ?? '🙂',
                            style: const TextStyle(fontSize: 44),
                          )
                        : Image.memory(
                            base64Decode(profile!.avatarImageBase64!),
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(profile?.pseudo ?? '', style: AppTextStyles.headline),
                  if (email != null)
                    Text(email, style: AppTextStyles.bodyMuted),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: l10n.profileEditProfile,
                    variant: AppButtonVariant.outline,
                    onPressed: () => context.push(AppRoutes.editProfile),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.profileNotificationSettings,
                    variant: AppButtonVariant.outline,
                    onPressed: () =>
                        context.push(AppRoutes.notificationSettings),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.profileAccessibilitySettings,
                    variant: AppButtonVariant.outline,
                    onPressed: () =>
                        context.push(AppRoutes.accessibilitySettings),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: l10n.adminHomeTitle,
                      variant: AppButtonVariant.outline,
                      onPressed: () => context.push(AppRoutes.adminHome),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: l10n.profileLogOut,
                    variant: AppButtonVariant.secondary,
                    isLoading: isLoading,
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).signOut(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => _handleDelete(context, ref),
                    child: Text(
                      l10n.profileDeleteAccount,
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
