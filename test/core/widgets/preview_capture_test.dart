import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/widgets/preview_capture.dart';

void main() {
  test('decodeThumbnail returns null when there is nothing stored', () {
    expect(decodeThumbnail(null), isNull);
  });

  test('decodeThumbnail decodes a stored base64 thumbnail', () {
    final bytes = base64Encode([1, 2, 3]);
    expect(decodeThumbnail(bytes), [1, 2, 3]);
  });

  test('decodeThumbnail returns null for corrupted data instead of throwing', () {
    expect(decodeThumbnail('not valid base64!!'), isNull);
  });
}
