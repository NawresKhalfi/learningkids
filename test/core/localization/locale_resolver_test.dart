import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/localization/app_language.dart';
import 'package:learningkids/core/localization/locale_resolver.dart';

void main() {
  group('resolveAppLanguage', () {
    test('falls back to French when the device locale is null', () {
      expect(resolveAppLanguage(null), AppLanguage.french);
    });

    test('resolves a matching supported locale', () {
      expect(resolveAppLanguage(const Locale('fr')), AppLanguage.french);
      expect(resolveAppLanguage(const Locale('fr', 'FR')), AppLanguage.french);
    });

    test('falls back to French for an unsupported locale', () {
      expect(resolveAppLanguage(const Locale('de')), AppLanguage.french);
    });
  });
}
