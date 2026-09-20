import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';
import 'package:learningkids/features/admin/data/moderation_repository.dart';
import 'package:learningkids/features/admin/domain/moderation_report.dart';
import 'package:learningkids/features/admin/presentation/screens/moderation_queue_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

import '../../../../support/pump_localized_widget.dart';

void main() {
  testWidgets('shows an empty state with no pending reports', (tester) async {
    await pumpLocalizedWidget(
      tester,
      const ModerationQueueScreen(),
      overrides: [
        moderationRepositoryProvider.overrideWithValue(ModerationRepository(firestore: FakeFirebaseFirestore())),
        adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: FakeFirebaseFirestore())),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ModerationQueueScreen)));

    expect(find.text(l10n.adminModerationQueueEmpty), findsOneWidget);
  });

  testWidgets('approving a report removes it from the queue', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final moderationRepository = ModerationRepository(firestore: firestore);
    await moderationRepository.reportProject(
      ModerationReport(
        id: '',
        projectId: 'p1',
        ownerUid: 'kid-2',
        projectTitle: 'Mon site',
        reporterUid: 'kid-1',
        reason: 'Contenu inapproprié',
        status: ModerationStatus.pending,
        createdAt: DateTime.now(),
      ),
    );

    await pumpLocalizedWidget(
      tester,
      const ModerationQueueScreen(),
      overrides: [
        moderationRepositoryProvider.overrideWithValue(moderationRepository),
        adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: firestore)),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ModerationQueueScreen)));

    expect(find.text('Mon site'), findsOneWidget);

    await tester.tap(find.text(l10n.adminModerationApprove));
    await tester.pumpAndSettle();

    expect(find.text('Mon site'), findsNothing);
    expect(find.text(l10n.adminModerationQueueEmpty), findsOneWidget);
  });

  testWidgets('rejecting a report unpublishes the project', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').set({'isPublished': true});
    final moderationRepository = ModerationRepository(firestore: firestore);
    await moderationRepository.reportProject(
      ModerationReport(
        id: '',
        projectId: 'p1',
        ownerUid: 'kid-2',
        projectTitle: 'Mon site',
        reporterUid: 'kid-1',
        reason: 'Contenu inapproprié',
        status: ModerationStatus.pending,
        createdAt: DateTime.now(),
      ),
    );

    await pumpLocalizedWidget(
      tester,
      const ModerationQueueScreen(),
      overrides: [
        moderationRepositoryProvider.overrideWithValue(moderationRepository),
        adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: firestore)),
      ],
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(ModerationQueueScreen)));

    await tester.tap(find.text(l10n.adminModerationReject));
    await tester.pumpAndSettle();

    final project = await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').get();
    expect(project.data()!['isPublished'], isFalse);
    expect(find.text('Mon site'), findsNothing);
  });
}
