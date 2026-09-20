import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// The admin back-office entry hub (EP12) — reachable only from
/// `ProfileScreen`, and only shown there once `isAdminProvider` is true
/// (`admins/{uid}` seeded from the Firebase console; see
/// `docs/FEATURES.md` for why there's no in-app way to grant this).
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminHomeTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: l10n.adminModerationQueueTitle,
                onPressed: () => context.push(AppRoutes.adminModerationQueue),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: l10n.adminAccountsTitle,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.push(AppRoutes.adminAccounts),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
