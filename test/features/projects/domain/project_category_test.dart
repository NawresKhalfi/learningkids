import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';

void main() {
  test('every category has a distinct, non-empty label (US41)', () {
    final labels = ProjectCategory.values.map(projectCategoryLabel).toSet();
    expect(labels, hasLength(ProjectCategory.values.length));
    expect(labels.every((label) => label.isNotEmpty), isTrue);
  });
}
