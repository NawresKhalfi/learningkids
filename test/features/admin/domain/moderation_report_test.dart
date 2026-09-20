import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/domain/moderation_report.dart';

void main() {
  test('toMap/fromMap round-trip preserves every field', () {
    final report = ModerationReport(
      id: 'r1',
      projectId: 'p1',
      ownerUid: 'kid-2',
      projectTitle: 'Mon site',
      reporterUid: 'kid-1',
      reason: 'Contenu inapproprié',
      status: ModerationStatus.pending,
      createdAt: DateTime.utc(2026, 3, 1, 10),
    );

    final restored = ModerationReport.fromMap(report.id, report.toMap());

    expect(restored.id, report.id);
    expect(restored.projectId, report.projectId);
    expect(restored.ownerUid, report.ownerUid);
    expect(restored.projectTitle, report.projectTitle);
    expect(restored.reporterUid, report.reporterUid);
    expect(restored.reason, report.reason);
    expect(restored.status, report.status);
    expect(restored.createdAt, report.createdAt);
  });

  test('fromMap defaults to pending for an unknown status string', () {
    final report = ModerationReport.fromMap('r1', {
      'projectId': 'p1',
      'ownerUid': 'kid-2',
      'projectTitle': 'Mon site',
      'reporterUid': 'kid-1',
      'reason': 'x',
      'status': 'not-a-status',
      'createdAt': DateTime.utc(2026).toIso8601String(),
    });

    expect(report.status, ModerationStatus.pending);
  });
}
