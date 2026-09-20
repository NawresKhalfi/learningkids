import 'package:flutter/widgets.dart';

/// The app's display language (EP13/US64). `system` means "follow the
/// device's own locale" — resolved by passing `null` to
/// `MaterialApp.router(locale: ...)`, which falls back to Flutter's normal
/// locale-resolution logic against `AppLocalizations.supportedLocales`.
enum AppLanguage { system, french, english }

extension AppLanguageX on AppLanguage {
  String get storageKey => switch (this) {
    AppLanguage.system => 'system',
    AppLanguage.french => 'fr',
    AppLanguage.english => 'en',
  };

  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.french => const Locale('fr'),
    AppLanguage.english => const Locale('en'),
  };

  static AppLanguage fromStorageKey(String key) =>
      AppLanguage.values.firstWhere((language) => language.storageKey == key, orElse: () => AppLanguage.system);
}
