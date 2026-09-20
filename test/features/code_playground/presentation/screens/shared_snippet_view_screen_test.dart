import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/code_playground/data/shared_snippet_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/code_playground/domain/shared_snippet.dart';
import 'package:learningkids/features/code_playground/presentation/screens/shared_snippet_view_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows the shared code once it loads', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final repository = SharedSnippetRepository(firestore: firestore);
    final id = await repository.shareSnippet(
      SharedSnippet(
        id: '',
        ownerUid: 'kid-1',
        pseudo: 'Léo',
        language: ProgrammingLanguage.python,
        code: "print('hello')",
        createdAt: DateTime.utc(2026, 3, 1),
      ),
    );

    await pumpLocalizedWidget(
      tester,
      SharedSnippetViewScreen(snippetId: id),
      overrides: [sharedSnippetRepositoryProvider.overrideWithValue(repository)],
    );

    expect(find.text("print('hello')"), findsOneWidget);
  });

  testWidgets('shows a not-found message for an unknown code', (tester) async {
    final repository = SharedSnippetRepository(firestore: FakeFirebaseFirestore());

    await pumpLocalizedWidget(
      tester,
      const SharedSnippetViewScreen(snippetId: 'does-not-exist'),
      overrides: [sharedSnippetRepositoryProvider.overrideWithValue(repository)],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(SharedSnippetViewScreen)));

    expect(find.text(l10n.sharedSnippetNotFound), findsOneWidget);
  });
}
