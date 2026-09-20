import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';

void main() {
  final createdAt = DateTime.utc(2026, 1, 15, 10);
  final project = Project(
    id: 'p1',
    title: 'Mon jeu',
    language: ProgrammingLanguage.python,
    category: ProjectCategory.game,
    code: "print('salut')",
    createdAt: createdAt,
  );

  test('toMap/fromMap round-trips a draft project', () {
    final restored = Project.fromMap(project.id, project.toMap());

    expect(restored.title, project.title);
    expect(restored.language, ProgrammingLanguage.python);
    expect(restored.category, ProjectCategory.game);
    expect(restored.code, project.code);
    expect(restored.createdAt, createdAt);
    expect(restored.isPublished, isFalse);
    expect(restored.thumbnailBase64, isNull);
  });

  test('toMap/fromMap round-trips a published project with a thumbnail', () {
    final published = project.copyWith(isPublished: true, thumbnailBase64: 'aGVsbG8=');
    final restored = Project.fromMap(published.id, published.toMap());

    expect(restored.isPublished, isTrue);
    expect(restored.thumbnailBase64, 'aGVsbG8=');
  });

  test('copyWith only overrides the given fields', () {
    final renamed = project.copyWith(title: 'Nouveau nom');

    expect(renamed.title, 'Nouveau nom');
    expect(renamed.id, project.id);
    expect(renamed.language, project.language);
    expect(renamed.category, project.category);
    expect(renamed.code, project.code);
  });
}
