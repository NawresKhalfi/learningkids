import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../../profile/application/profile_controller.dart';
import '../data/shared_snippet_repository.dart';
import '../domain/programming_language.dart';
import '../domain/shared_snippet.dart';

/// Fetches a shared snippet by its id (EP10/US55). `.family` + `autoDispose`
/// since a viewed snippet is a one-off lookup, not state to keep warm.
final sharedSnippetProvider = FutureProvider.autoDispose.family<SharedSnippet?, String>(
  (ref, id) => ref.watch(sharedSnippetRepositoryProvider).fetchSnippet(id),
);

class SharedSnippetController extends Notifier<void> {
  @override
  void build() {}

  Future<String> shareSnippet({required ProgrammingLanguage language, required String code}) async {
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (uid == null) throw StateError('Cannot share a snippet while signed out.');
    final profile = await ref.read(currentProfileProvider.future);
    final snippet = SharedSnippet(
      id: '',
      ownerUid: uid,
      pseudo: profile?.pseudo ?? '',
      language: language,
      code: code,
      createdAt: DateTime.now(),
    );
    return ref.read(sharedSnippetRepositoryProvider).shareSnippet(snippet);
  }
}

final sharedSnippetControllerProvider = NotifierProvider<SharedSnippetController, void>(SharedSnippetController.new);
