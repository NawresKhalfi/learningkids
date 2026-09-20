import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/data/moderation_repository.dart';
import 'package:learningkids/features/admin/domain/moderation_report.dart';

void main() {
  ModerationReport buildReport({String id = ''}) => ModerationReport(
    id: id,
    projectId: 'p1',
    ownerUid: 'kid-2',
    projectTitle: 'Mon site',
    reporterUid: 'kid-1',
    reason: 'Contenu inapproprié',
    status: ModerationStatus.pending,
    createdAt: DateTime.now(),
  );

  test('reportProject then watchPending lists it', () async {
    final repository = ModerationRepository(firestore: FakeFirebaseFirestore());

    await repository.reportProject(buildReport());

    final pending = await repository.watchPending().first;
    expect(pending, hasLength(1));
    expect(pending.single.projectTitle, 'Mon site');
  });

  test('setStatus removes a report from the pending queue', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = ModerationRepository(firestore: firestore);
    await repository.reportProject(buildReport());
    final reportId = (await firestore.collection('moderationReports').get()).docs.single.id;

    await repository.setStatus(reportId, ModerationStatus.approved);

    expect(await repository.watchPending().first, isEmpty);
  });
}
