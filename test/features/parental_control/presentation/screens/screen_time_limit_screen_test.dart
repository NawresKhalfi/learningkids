import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/parental_control/presentation/screens/screen_time_limit_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the blocking title, message and the parent action', (tester) async {
    await pumpLocalizedWidget(tester, const ScreenTimeLimitScreen());
    final l10n = AppLocalizations.of(tester.element(find.byType(ScreenTimeLimitScreen)));

    expect(find.text(l10n.screenTimeLimitTitle), findsOneWidget);
    expect(find.text(l10n.screenTimeLimitMessage), findsOneWidget);
    expect(find.text(l10n.screenTimeLimitParentAction), findsOneWidget);
  });
}
