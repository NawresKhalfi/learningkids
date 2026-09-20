import 'package:flutter/widgets.dart';

import 'app_language.dart';

/// Resolves the phone's locale to a supported [AppLanguage].
///
/// Pure function so it can be unit tested without a widget tree. Falls back
/// to [AppLanguage.french] since it is the only supported language today.
AppLanguage resolveAppLanguage(Locale? deviceLocale) {
  if (deviceLocale == null) {
    return AppLanguage.french;
  }
  for (final language in AppLanguage.values) {
    if (language.locale.languageCode == deviceLocale.languageCode) {
      return language;
    }
  }
  return AppLanguage.french;
}
