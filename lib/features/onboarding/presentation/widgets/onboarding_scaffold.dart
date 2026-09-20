import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../core/widgets/speech_bubble.dart';

/// Shared layout for the onboarding chat steps: Byte the mascot with a
/// speech bubble above, then the step's own content (an input, options...).
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.message,
    required this.content,
  });

  final String message;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: SpeechBubble(message: message)),
                  const SizedBox(width: AppSpacing.sm),
                  const MascotByte(size: 90),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
