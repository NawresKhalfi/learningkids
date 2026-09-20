import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

/// Wraps [child] with the [ProviderScope]/`MaterialApp` boilerplate every
/// screen test needs (localization delegates, theme-free defaults) and
/// pumps it.
Future<void> pumpLocalizedWidget(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        // Pinned to French (the template locale — see `agent.md`) rather
        // than left to resolve from the test harness's platform locale:
        // since EP13/US64 added English as a second supported locale,
        // leaving this unset would make tests resolve to whatever locale
        // the test runner reports, silently changing which strings every
        // existing `find.text(...)` assertion needs to match.
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}
