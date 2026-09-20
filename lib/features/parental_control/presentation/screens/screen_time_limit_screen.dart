import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../core/widgets/speech_bubble.dart';
import '../../../../l10n/gen/app_localizations.dart';
import 'parent_gate_screen.dart';

/// Blocks the app once the parent-set daily limit is reached (US09). The
/// only way out is either a new day (redirect logic re-checks on next
/// launch) or a parent confirming their PIN to grant extra time today.
class ScreenTimeLimitScreen extends StatelessWidget {
  const ScreenTimeLimitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Text(
                l10n.screenTimeLimitTitle,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              const MascotByte(size: 140),
              const SizedBox(height: AppSpacing.lg),
              SpeechBubble(message: l10n.screenTimeLimitMessage, color: AppColors.cardBlue.surface),
              const Spacer(),
              AppButton(
                label: l10n.screenTimeLimitParentAction,
                variant: AppButtonVariant.outline,
                onPressed: () => context.push(
                  AppRoutes.parentGate,
                  extra: const ParentGateScreen(action: ParentGateAction.grantExtraTime),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
