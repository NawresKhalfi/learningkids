import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/language_controller.dart';
import '../../domain/app_language.dart';

/// US64: pick the app's display language, or follow the device's own.
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  String _labelFor(AppLocalizations l10n, AppLanguage language) => switch (language) {
    AppLanguage.system => l10n.languageSettingsSystem,
    AppLanguage.french => l10n.languageSettingsFrench,
    AppLanguage.english => l10n.languageSettingsEnglish,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(languageControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languageSettingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final language in AppLanguage.values) ...[
              OptionButton(
                label: _labelFor(l10n, language),
                isSelected: selected == language,
                onTap: () => ref.read(languageControllerProvider.notifier).setLanguage(language),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
