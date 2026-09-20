/// A report against a shared portfolio project (EP12/US61) — the only
/// user-shared content this app has (there is no comments feature to
/// moderate). Created by any signed-in learner viewing someone else's
/// portfolio; reviewed by an admin via the moderation queue.
enum ModerationStatus { pending, approved, rejected }

class ModerationReport {
  const ModerationReport({
    required this.id,
    required this.projectId,
    required this.ownerUid,
    required this.projectTitle,
    required this.reporterUid,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String projectId;
  final String ownerUid;
  final String projectTitle;
  final String reporterUid;
  final String reason;
  final ModerationStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'projectId': projectId,
    'ownerUid': ownerUid,
    'projectTitle': projectTitle,
    'reporterUid': reporterUid,
    'reason': reason,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  static ModerationReport fromMap(String id, Map<String, dynamic> map) => ModerationReport(
    id: id,
    projectId: map['projectId'] as String? ?? '',
    ownerUid: map['ownerUid'] as String? ?? '',
    projectTitle: map['projectTitle'] as String? ?? '',
    reporterUid: map['reporterUid'] as String? ?? '',
    reason: map['reason'] as String? ?? '',
    status: ModerationStatus.values.firstWhere(
      (value) => value.name == map['status'],
      orElse: () => ModerationStatus.pending,
    ),
    createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
  );
}
