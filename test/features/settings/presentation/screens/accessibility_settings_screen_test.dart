import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/settings/presentation/screens/accessibility_settings_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  Future<AppLocalizations> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLocalizedWidget(
      tester,
      const AccessibilitySettingsScreen(),
      overrides: [localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance()))],
    );
    return AppLocalizations.of(tester.element(find.byType(AccessibilitySettingsScreen)));
  }

  testWidgets('shows all 4 text-size options (US66)', (tester) async {
    final l10n = await pump(tester);

    expect(find.text(l10n.accessibilityTextSizeSmall), findsOneWidget);
    expect(find.text(l10n.accessibilityTextSizeNormal), findsOneWidget);
    expect(find.text(l10n.accessibilityTextSizeLarge), findsOneWidget);
    expect(find.text(l10n.accessibilityTextSizeExtraLarge), findsOneWidget);
  });

  testWidgets('tapping a text size persists the choice', (tester) async {
    final l10n = await pump(tester);

    await tester.tap(find.text(l10n.accessibilityTextSizeLarge));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('text_scale_option'), 'large');
  });
}
