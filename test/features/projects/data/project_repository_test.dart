import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';

void main() {
  late ProjectRepository repository;

  Project draft({String id = '', bool isPublished = false}) => Project(
    id: id,
    title: 'Mon jeu',
    language: ProgrammingLanguage.python,
    category: ProjectCategory.game,
    code: "print('salut')",
    createdAt: DateTime.utc(2026, 1, 1),
    isPublished: isPublished,
  );

  setUp(() {
    repository = ProjectRepository(firestore: FakeFirebaseFirestore());
  });

  test('watchProjects starts empty before anything is created', () async {
    final projects = await repository.watchProjects('uid-1').first;
    expect(projects, isEmpty);
  });

  test('createProject then fetchProject round-trips the project', () async {
    final id = await repository.createProject('uid-1', draft());
    final fetched = await repository.fetchProject('uid-1', id);

    expect(fetched, isNotNull);
    expect(fetched!.title, 'Mon jeu');
    expect(fetched.isPublished, isFalse);
  });

  test('updateProject persists changes to the same document', () async {
    final id = await repository.createProject('uid-1', draft());
    final fetched = (await repository.fetchProject('uid-1', id))!;

    await repository.updateProject('uid-1', fetched.copyWith(title: 'Nouveau titre'));

    final updated = await repository.fetchProject('uid-1', id);
    expect(updated!.title, 'Nouveau titre');
  });

  test('deleteProject removes it from watchProjects', () async {
    final id = await repository.createProject('uid-1', draft());
    await repository.deleteProject('uid-1', id);

    final projects = await repository.watchProjects('uid-1').first;
    expect(projects, isEmpty);
  });

  test('watchPublicPortfolio only returns published projects (US39)', () async {
    await repository.createProject('uid-1', draft(isPublished: false));
    await repository.createProject('uid-1', draft(isPublished: true));

    final portfolio = await repository.watchPublicPortfolio('uid-1').first;
    expect(portfolio, hasLength(1));
    expect(portfolio.single.isPublished, isTrue);
  });

  test('projects are scoped per learner', () async {
    await repository.createProject('uid-1', draft());

    final otherLearner = await repository.watchProjects('uid-2').first;
    expect(otherLearner, isEmpty);
  });
}
