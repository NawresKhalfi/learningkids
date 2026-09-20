import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/option_button.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/accessibility_controller.dart';
import '../../domain/text_scale_option.dart';

/// US66's font-size slice — the "lecture vocale" slice lives directly on
/// `LessonPlayerScreen` (`ReadAloudButton`), since it only makes sense in
/// the context of a specific piece of text. "Contraste" is deferred for
/// the same reason as EP13's dark mode (US65): the app's colours are
/// static tokens, not a dynamic theme — see `docs/FEATURES.md`.
class AccessibilitySettingsScreen extends ConsumerWidget {
  const AccessibilitySettingsScreen({super.key});

  String _labelFor(AppLocalizations l10n, TextScaleOption option) => switch (option) {
    TextScaleOption.small => l10n.accessibilityTextSizeSmall,
    TextScaleOption.normal => l10n.accessibilityTextSizeNormal,
    TextScaleOption.large => l10n.accessibilityTextSizeLarge,
    TextScaleOption.extraLarge => l10n.accessibilityTextSizeExtraLarge,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(textScaleControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessibilitySettingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(l10n.accessibilityTextSizeTitle, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            for (final option in TextScaleOption.values) ...[
              OptionButton(
                label: _labelFor(l10n, option),
                isSelected: selected == option,
                onTap: () => ref.read(textScaleControllerProvider.notifier).setOption(option),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}
