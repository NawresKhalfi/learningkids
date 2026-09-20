import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/settings/domain/text_scale_option.dart';

void main() {
  test('factors are strictly increasing from small to extra large', () {
    expect(TextScaleOption.small.factor, lessThan(TextScaleOption.normal.factor));
    expect(TextScaleOption.normal.factor, 1.0);
    expect(TextScaleOption.normal.factor, lessThan(TextScaleOption.large.factor));
    expect(TextScaleOption.large.factor, lessThan(TextScaleOption.extraLarge.factor));
  });

  test('fromStorageKey round-trips every value and defaults to normal for an unknown key', () {
    for (final option in TextScaleOption.values) {
      expect(TextScaleOptionX.fromStorageKey(option.name), option);
    }
    expect(TextScaleOptionX.fromStorageKey('not-an-option'), TextScaleOption.normal);
  });
}
