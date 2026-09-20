import 'package:flutter/widgets.dart';

/// A language the app can be displayed in.
///
/// Only French is supported for now (see `agent.md`: multi-langue is EP13,
/// not yet implemented). Add new entries here in lockstep with new
/// `lib/l10n/arb/app_<code>.arb` files.
enum AppLanguage {
  french(Locale('fr'));

  const AppLanguage(this.locale);

  final Locale locale;
}
