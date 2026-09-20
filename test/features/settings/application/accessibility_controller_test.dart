import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/settings/application/accessibility_controller.dart';
import 'package:learningkids/features/settings/domain/text_scale_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance()))],
    );
    addTearDown(container.dispose);
  });

  test('defaults to normal and textScaleFactorProvider resolves to 1.0', () {
    expect(container.read(textScaleControllerProvider), TextScaleOption.normal);
    expect(container.read(textScaleFactorProvider), 1.0);
  });

  test('setOption persists the choice and updates textScaleFactorProvider', () async {
    await container.read(textScaleControllerProvider.notifier).setOption(TextScaleOption.large);

    expect(container.read(textScaleControllerProvider), TextScaleOption.large);
    expect(container.read(textScaleFactorProvider), TextScaleOption.large.factor);
    expect(container.read(localPreferencesProvider).textScaleOption, 'large');
  });
}
