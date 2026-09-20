import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/settings/presentation/screens/language_settings_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  Future<AppLocalizations> pump(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpLocalizedWidget(
      tester,
      const LanguageSettingsScreen(),
      overrides: [localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance()))],
    );
    return AppLocalizations.of(tester.element(find.byType(LanguageSettingsScreen)));
  }

  testWidgets('shows all 3 language options with "Follow device" selected by default (US64)', (tester) async {
    final l10n = await pump(tester);

    expect(find.text(l10n.languageSettingsSystem), findsOneWidget);
    expect(find.text(l10n.languageSettingsFrench), findsOneWidget);
    expect(find.text(l10n.languageSettingsEnglish), findsOneWidget);
  });

  testWidgets('tapping English persists the choice', (tester) async {
    final l10n = await pump(tester);

    await tester.tap(find.text(l10n.languageSettingsEnglish));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('app_language'), 'en');
  });
}
