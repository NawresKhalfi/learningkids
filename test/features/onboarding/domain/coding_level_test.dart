import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';

void main() {
  test('every level has a distinct, non-empty short label', () {
    final labels = CodingLevel.values.map(codingLevelShortLabel).toSet();
    expect(labels, hasLength(CodingLevel.values.length));
    expect(labels.every((label) => label.isNotEmpty), isTrue);
  });
}
