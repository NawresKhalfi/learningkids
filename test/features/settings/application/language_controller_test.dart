import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/settings/application/language_controller.dart';
import 'package:learningkids/features/settings/domain/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance()))],
    );
    addTearDown(container.dispose);
  });

  test('defaults to system and appLocaleProvider resolves to null (follow device)', () {
    expect(container.read(languageControllerProvider), AppLanguage.system);
    expect(container.read(appLocaleProvider), isNull);
  });

  test('setLanguage persists the choice and updates appLocaleProvider', () async {
    await container.read(languageControllerProvider.notifier).setLanguage(AppLanguage.english);

    expect(container.read(languageControllerProvider), AppLanguage.english);
    expect(container.read(appLocaleProvider), const Locale('en'));
    expect(container.read(localPreferencesProvider).appLanguage, 'en');
  });
}
