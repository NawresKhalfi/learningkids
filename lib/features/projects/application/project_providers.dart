import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../gamification/application/gamification_providers.dart';
import '../data/project_repository.dart';
import '../domain/project.dart';
import '../domain/project_category.dart';
import '../domain/project_template.dart';

/// The signed-in learner's own projects (drafts and published), newest
/// first (US38/US39/US41).
final myProjectsProvider = StreamProvider<List<Project>>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(projectRepositoryProvider).watchProjects(uid);
});

/// Someone else's published portfolio, looked up by the in-app share code
/// (their uid) — see `PortfolioScreen` (US40).
final portfolioProvider = StreamProvider.family<List<Project>, String>((ref, ownerUid) {
  return ref.watch(projectRepositoryProvider).watchPublicPortfolio(ownerUid);
});

/// A single project by id, for the editor screen.
final projectByIdProvider = StreamProvider.family<Project?, String>((ref, projectId) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(projectRepositoryProvider).watchProject(uid, projectId);
});

class ProjectsController extends Notifier<void> {
  @override
  void build() {}

  String? get _uid => ref.read(authRepositoryProvider).currentUser?.uid;

  Future<String> createFromTemplate(ProjectTemplate template) async {
    final uid = _uid;
    if (uid == null) throw StateError('Cannot create a project while signed out.');
    final project = Project(
      id: '',
      title: template.title,
      language: template.language,
      category: template.category,
      code: template.starterCode,
      createdAt: DateTime.now(),
    );
    return ref.read(projectRepositoryProvider).createProject(uid, project);
  }

  Future<void> _update(Project updated) async {
    final uid = _uid;
    if (uid == null) return;
    await ref.read(projectRepositoryProvider).updateProject(uid, updated);
  }

  Future<void> updateCode(Project project, String code) => _update(project.copyWith(code: code));

  Future<void> rename(Project project, String title) => _update(project.copyWith(title: title));

  Future<void> setCategory(Project project, ProjectCategory category) =>
      _update(project.copyWith(category: category));

  /// Adds the project to the learner's portfolio (US39). Whether anyone
  /// else can actually see it also depends on `UserProfile.portfolioPublic`
  /// (US40) — publishing a project and making the portfolio public are
  /// deliberately separate steps. Awards XP/badge progress (EP08) only the
  /// first time this project is published.
  Future<void> publish(Project project, {String? thumbnailBase64}) async {
    final wasAlreadyPublished = project.isPublished;
    await _update(project.copyWith(isPublished: true, thumbnailBase64: thumbnailBase64));
    if (!wasAlreadyPublished) {
      await ref.read(gamificationControllerProvider.notifier).recordProjectPublished();
    }
  }

  Future<void> unpublish(Project project) => _update(project.copyWith(isPublished: false));

  Future<void> delete(Project project) async {
    final uid = _uid;
    if (uid == null) return;
    await ref.read(projectRepositoryProvider).deleteProject(uid, project.id);
  }
}

final projectsControllerProvider = NotifierProvider<ProjectsController, void>(ProjectsController.new);
