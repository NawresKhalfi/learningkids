import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/projects/domain/project_templates_catalog.dart';

void main() {
  test('every template has real, non-placeholder starter code', () {
    for (final template in projectTemplatesCatalog) {
      expect(template.starterCode.trim(), isNotEmpty, reason: template.id);
      expect(template.starterCode.length, greaterThan(20), reason: template.id);
    }
  });

  test('template ids are globally unique', () {
    final ids = projectTemplatesCatalog.map((t) => t.id).toSet();
    expect(ids, hasLength(projectTemplatesCatalog.length));
  });

  test('the catalog is classée par langage (US38): every language is represented', () {
    final languages = projectTemplatesCatalog.map((t) => t.language).toSet();
    expect(languages, ProgrammingLanguage.values.toSet());
  });

  test('the catalog is classée par niveau (US38): more than one level is represented', () {
    final levels = projectTemplatesCatalog.map((t) => t.level).toSet();
    expect(levels.length, greaterThan(1));
    for (final level in CodingLevel.values) {
      expect(levels, contains(level), reason: 'no template at level $level');
    }
  });
}
