import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/comic_title.dart';
import '../../../../core/widgets/mascot_byte.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Branding splash shown for a beat while `app_router.dart`'s redirect logic
/// resolves the auth/onboarding state and sends the user to the right place.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotByte(size: 120),
            const SizedBox(height: 24),
            ComicTitle(l10n.appName, fontSize: 36),
          ],
        ),
      ),
    );
  }
}
