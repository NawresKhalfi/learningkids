import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/settings/domain/app_language.dart';

void main() {
  test('storageKey/locale mapping is correct for every option', () {
    expect(AppLanguage.system.storageKey, 'system');
    expect(AppLanguage.system.locale, isNull);

    expect(AppLanguage.french.storageKey, 'fr');
    expect(AppLanguage.french.locale, const Locale('fr'));

    expect(AppLanguage.english.storageKey, 'en');
    expect(AppLanguage.english.locale, const Locale('en'));
  });

  test('fromStorageKey round-trips every value and defaults to system for an unknown key', () {
    for (final language in AppLanguage.values) {
      expect(AppLanguageX.fromStorageKey(language.storageKey), language);
    }
    expect(AppLanguageX.fromStorageKey('not-a-language'), AppLanguage.system);
  });
}
