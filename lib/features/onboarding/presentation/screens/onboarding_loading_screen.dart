import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/local_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../core/widgets/speech_bubble.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/onboarding_controller.dart';

/// Plays a short fake-progress animation while the profile created from the
/// onboarding answers is actually saved to Firestore in the background.
class OnboardingLoadingScreen extends ConsumerStatefulWidget {
  const OnboardingLoadingScreen({super.key});

  @override
  ConsumerState<OnboardingLoadingScreen> createState() =>
      _OnboardingLoadingScreenState();
}

class _OnboardingLoadingScreenState extends ConsumerState<OnboardingLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    _submit();
  }

  Future<void> _submit() async {
    setState(() => _hasError = false);
    try {
      await Future.wait([
        ref.read(onboardingControllerProvider.notifier).submit(),
        Future.delayed(const Duration(milliseconds: 1800)),
      ]);
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (error) {
      if (!mounted) return;

      if (error is StateError &&
          error.message.toLowerCase().contains('signed out')) {
        context.go(AppRoutes.welcome);
        return;
      }

      if (ref.read(localPreferencesProvider).hasCompletedOnboarding) {
        context.go(AppRoutes.home);
        return;
      }

      debugPrint('Onboarding submission failed: $error');
      setState(() => _hasError = true);
    }
  }

  String _errorMessage(AppLocalizations l10n, Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('network') ||
        message.contains('socket') ||
        message.contains('connection')) {
      return l10n.onboardingErrorNetwork;
    }
    return l10n.onboardingErrorGeneric;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: _controller.value,
                          strokeWidth: 10,
                          backgroundColor: AppColors.cardBlue.surface,
                          valueColor: const AlwaysStoppedAnimation(AppColors.brandBlue),
                        ),
                        Text(
                          '${(_controller.value * 100).round()}%',
                          style: AppTextStyles.headline,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              if (_hasError) ...[
                Text(
                  _errorMessage(l10n, Exception('fallback')),
                  style: AppTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(label: l10n.commonRetry, onPressed: _submit),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SpeechBubble(message: l10n.onboardingLoadingMessage),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const MascotByte(size: 90),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
