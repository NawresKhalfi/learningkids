import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../profile/domain/avatar.dart';
import '../../application/admin_providers.dart';
import '../../domain/account_summary.dart';

/// The account list (EP12/US63): suspend/unsuspend any learner's account
/// and leave an internal support note — the client-feasible slice of
/// "account management" this project can offer without a real backend
/// (no Admin SDK access, so a Firebase Auth account can't actually be
/// disabled from here; see `docs/FEATURES.md`).
class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final accountsAsync = ref.watch(adminAccountsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminAccountsTitle)),
      body: SafeArea(
        child: accountsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonSomethingWentWrong)),
          data: (accounts) {
            if (accounts.isEmpty) {
              return Center(child: Text(l10n.adminAccountsEmpty, style: AppTextStyles.bodyMuted));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: accounts.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) => _AccountCard(account: accounts[index]),
            );
          },
        ),
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.account});

  final AccountSummary account;

  Future<void> _editNotes(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: await ref.read(adminAccountControllerProvider.notifier).fetchSupportNotes(account.uid),
    );
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context);
    final notes = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminAccountsSupportNotes),
        content: TextField(controller: controller, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: Text(l10n.commonContinue)),
        ],
      ),
    );
    if (notes == null) return;
    await ref.read(adminAccountControllerProvider.notifier).setSupportNotes(account.uid, notes);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final avatar = Avatar.fromId(account.avatarId);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: account.isSuspended ? AppColors.cardOrange.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Row(
        children: [
          Text(avatar.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.pseudo, style: AppTextStyles.body),
                if (account.isSuspended) Text(l10n.adminAccountsSuspended, style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.note_alt_outlined),
            tooltip: l10n.adminAccountsSupportNotes,
            onPressed: () => _editNotes(context, ref),
          ),
          Switch(
            value: account.isSuspended,
            onChanged: (value) =>
                ref.read(adminAccountControllerProvider.notifier).setAccountSuspended(account.uid, value),
          ),
        ],
      ),
    );
  }
}
