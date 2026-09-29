import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/parental_control/presentation/widgets/screen_time_ticker_observer.dart';
import 'features/settings/application/accessibility_controller.dart';
import 'l10n/gen/app_localizations.dart';

class LearningKidsApp extends ConsumerWidget {
  const LearningKidsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final textScaleFactor = ref.watch(textScaleFactorProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      // The application is French-only for now. This deliberately ignores
      // the device locale and any legacy persisted language preference.
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScaleFactor)),
        child: ScreenTimeTickerObserver(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
