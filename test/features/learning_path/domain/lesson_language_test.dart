import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/learning_path/domain/lesson_language.dart';

void main() {
  test('every language has a non-empty display label', () {
    for (final language in LessonLanguage.values) {
      expect(lessonLanguageLabel(language), isNotEmpty);
    }
  });

  test('labels are human-friendly, not the raw enum name', () {
    expect(lessonLanguageLabel(LessonLanguage.javascript), 'JavaScript');
    expect(lessonLanguageLabel(LessonLanguage.html), 'HTML');
  });
}
