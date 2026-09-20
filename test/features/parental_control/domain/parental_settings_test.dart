import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/parental_control/domain/parental_settings.dart';

void main() {
  test('hasPin reflects whether a pinHash is set', () {
    expect(const ParentalSettings().hasPin, isFalse);
    expect(const ParentalSettings(pinHash: 'abc').hasPin, isTrue);
  });

  test('toMap/fromMap round-trips both fields', () {
    const settings = ParentalSettings(pinHash: 'abc', dailyLimitMinutes: 30);
    final restored = ParentalSettings.fromMap(settings.toMap());

    expect(restored.pinHash, 'abc');
    expect(restored.dailyLimitMinutes, 30);
  });

  test('fromMap defaults to an empty settings object', () {
    final restored = ParentalSettings.fromMap(null);
    expect(restored.hasPin, isFalse);
    expect(restored.dailyLimitMinutes, isNull);
  });
}
