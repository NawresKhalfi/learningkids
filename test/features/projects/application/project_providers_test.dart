import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/projects/application/project_providers.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';
import 'package:learningkids/features/projects/domain/project_template.dart';

import '../../../support/notification_overrides.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;

  const template = ProjectTemplate(
    id: 't1',
    title: 'Mon modèle',
    description: 'desc',
    language: ProgrammingLanguage.python,
    level: CodingLevel.beginner,
    category: ProjectCategory.game,
    starterCode: "print('hi')",
  );

  // Verifying through the repository directly (rather than re-reading
  // `myProjectsProvider.future` after it's already resolved once) avoids
  // the StreamProvider staleness pitfall: `.future` resolves with the
  // *current* value once already alive, not the next one.
  ProjectRepository repository() => ProjectRepository(firestore: firestore);

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        projectRepositoryProvider.overrideWithValue(repository()),
        gamificationRepositoryProvider.overrideWithValue(GamificationRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
        ...await disabledNotificationOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authStateChangesProvider.future);
  });

  test('createFromTemplate copies the template into a new project (US38)', () async {
    final id = await container.read(projectsControllerProvider.notifier).createFromTemplate(template);
    final project = await repository().fetchProject('kid-1', id);

    expect(project, isNotNull);
    expect(project!.title, template.title);
    expect(project.code, template.starterCode);
    expect(project.category, template.category);
    expect(project.language, template.language);
    expect(project.isPublished, isFalse);
  });

  test('updateCode/rename/setCategory update the project (US38/US41)', () async {
    final controller = container.read(projectsControllerProvider.notifier);
    final id = await controller.createFromTemplate(template);
    final created = (await repository().fetchProject('kid-1', id))!;

    await controller.updateCode(created, 'print("changed")');
    final afterCode = (await repository().fetchProject('kid-1', id))!;
    await controller.rename(afterCode, 'Nouveau nom');
    final afterRename = (await repository().fetchProject('kid-1', id))!;
    await controller.setCategory(afterRename, ProjectCategory.tool);

    final result = await repository().fetchProject('kid-1', id);
    expect(result!.code, 'print("changed")');
    expect(result.title, 'Nouveau nom');
    expect(result.category, ProjectCategory.tool);
  });

  test('publish then unpublish toggles visibility in the portfolio (US39)', () async {
    final controller = container.read(projectsControllerProvider.notifier);
    final id = await controller.createFromTemplate(template);
    final created = (await repository().fetchProject('kid-1', id))!;

    await controller.publish(created, thumbnailBase64: 'aGVsbG8=');
    var portfolio = await repository().watchPublicPortfolio('kid-1').first;
    expect(portfolio, hasLength(1));
    expect(portfolio.single.thumbnailBase64, 'aGVsbG8=');

    final published = (await repository().fetchProject('kid-1', id))!;
    await controller.unpublish(published);
    portfolio = await repository().watchPublicPortfolio('kid-1').first;
    expect(portfolio, isEmpty);
  });

  test('delete removes the project entirely', () async {
    final controller = container.read(projectsControllerProvider.notifier);
    final id = await controller.createFromTemplate(template);
    final created = (await repository().fetchProject('kid-1', id))!;

    await controller.delete(created);

    final projects = await repository().watchProjects('kid-1').first;
    expect(projects, isEmpty);
  });
}
