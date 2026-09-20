import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../data/code_snippet_repository.dart';
import '../domain/programming_language.dart';

/// The learner's saved code for one language, falling back to friendly
/// starter content the first time (no doc saved yet).
final codeSnippetProvider = StreamProvider.family<String, ProgrammingLanguage>((ref, language) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(starterCodeFor(language));
  return ref
      .watch(codeSnippetRepositoryProvider)
      .watchCode(uid, language)
      .map((code) => code ?? starterCodeFor(language));
});

/// Saves a snippet ~800ms after the learner stops typing (US30): often
/// enough to never lose real work, without writing on every keystroke.
class CodeSnippetController extends Notifier<void> {
  Timer? _debounce;

  @override
  void build() {
    ref.onDispose(() => _debounce?.cancel());
  }

  void onCodeChanged(ProgrammingLanguage language, String code) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      final uid = ref.read(authRepositoryProvider).currentUser?.uid;
      if (uid == null) return;
      ref.read(codeSnippetRepositoryProvider).saveCode(uid, language, code);
    });
  }
}

final codeSnippetControllerProvider =
    NotifierProvider<CodeSnippetController, void>(CodeSnippetController.new);
