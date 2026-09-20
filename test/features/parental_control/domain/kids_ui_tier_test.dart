import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/parental_control/domain/kids_ui_tier.dart';

void main() {
  test('the youngest bracket resolves to the young tier', () {
    expect(resolveKidsUiTier(AgeRange.fourToSix), KidsUiTier.young);
  });

  test('every other bracket resolves to the standard tier', () {
    expect(resolveKidsUiTier(AgeRange.sevenToNine), KidsUiTier.standard);
    expect(resolveKidsUiTier(AgeRange.tenToTwelve), KidsUiTier.standard);
    expect(resolveKidsUiTier(AgeRange.thirteenPlus), KidsUiTier.standard);
  });
}
