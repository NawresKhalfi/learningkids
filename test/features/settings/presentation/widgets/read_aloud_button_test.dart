import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/settings/data/tts_service.dart';
import 'package:learningkids/features/settings/presentation/widgets/read_aloud_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/fake_tts_service.dart';
import '../../../../support/pump_localized_widget.dart';

void main() {
  Future<FakeTtsService> pump(WidgetTester tester, {String text = 'Bonjour le monde'}) async {
    SharedPreferences.setMockInitialValues({});
    final fakeTts = FakeTtsService();
    await pumpLocalizedWidget(
      tester,
      ReadAloudButton(text: text),
      overrides: [
        localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
        ttsServiceProvider.overrideWithValue(fakeTts),
      ],
    );
    return fakeTts;
  }

  testWidgets('tapping speaks the given text in French by default (US64/US66)', (tester) async {
    final fakeTts = await pump(tester, text: 'Bonjour le monde');

    await tester.tap(find.byType(ReadAloudButton));
    await tester.pumpAndSettle();

    expect(fakeTts.lastLanguage, 'fr-FR');
    expect(fakeTts.lastSpokenText, 'Bonjour le monde');
    expect(fakeTts.isSpeaking, isTrue);
  });

  testWidgets('tapping again while speaking stops it and reverts the icon', (tester) async {
    final fakeTts = await pump(tester);

    await tester.tap(find.byType(ReadAloudButton));
    await tester.pumpAndSettle();
    expect(fakeTts.isSpeaking, isTrue);

    await tester.tap(find.byType(ReadAloudButton));
    await tester.pumpAndSettle();

    expect(fakeTts.isSpeaking, isFalse);
    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
  });

  testWidgets('the icon reverts to play once speech completes on its own', (tester) async {
    final fakeTts = await pump(tester);

    await tester.tap(find.byType(ReadAloudButton));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.stop_circle_outlined), findsOneWidget);

    fakeTts.completeSpeaking();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.volume_up_outlined), findsOneWidget);
  });
}
