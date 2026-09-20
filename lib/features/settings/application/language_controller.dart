import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_preferences.dart';
import '../domain/app_language.dart';

class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguageX.fromStorageKey(ref.read(localPreferencesProvider).appLanguage);

  Future<void> setLanguage(AppLanguage language) async {
    await ref.read(localPreferencesProvider).setAppLanguage(language.storageKey);
    state = language;
  }
}

final languageControllerProvider = NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);

/// `null` means "follow the device locale" — passed straight to
/// `MaterialApp.router(locale: ...)`.
final appLocaleProvider = Provider<Locale?>((ref) => ref.watch(languageControllerProvider).locale);
