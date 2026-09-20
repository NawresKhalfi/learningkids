import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import '../data/admin_repository.dart';
import '../data/moderation_repository.dart';
import '../domain/account_summary.dart';
import '../domain/moderation_report.dart';

/// Whether the signed-in user is an admin (EP12) — false while signed out
/// or before `admins/{uid}` has been seeded for them (see
/// `AdminRepository`).
final isAdminProvider = StreamProvider<bool>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(false);
  return ref.watch(adminRepositoryProvider).watchIsAdmin(uid);
});

/// Whether the signed-in learner's own account has been suspended
/// (EP12/US63) — checked by the router to show the blocking screen.
final isAccountSuspendedProvider = StreamProvider<bool>((ref) {
  final uid = ref.watch(authStateChangesProvider).valueOrNull?.uid;
  if (uid == null) return Stream.value(false);
  return ref.watch(adminRepositoryProvider).watchOwnSuspendedStatus(uid);
});

final _accountDirectoryProvider = StreamProvider<List<AccountSummary>>(
  (ref) => ref.watch(adminRepositoryProvider).watchAccountDirectory(),
);

final _suspendedStatusesProvider = StreamProvider<Map<String, bool>>(
  (ref) => ref.watch(adminRepositoryProvider).watchSuspendedStatuses(),
);

/// The account list for US63, joining the identity mirror with the
/// suspension flag — two flat collections combined client-side since
/// there's no backend to join them server-side.
final adminAccountsProvider = Provider<AsyncValue<List<AccountSummary>>>((ref) {
  final directory = ref.watch(_accountDirectoryProvider);
  final statuses = ref.watch(_suspendedStatusesProvider);
  return directory.whenData((accounts) {
    final statusByUid = statuses.valueOrNull ?? const {};
    return [for (final account in accounts) account.copyWith(isSuspended: statusByUid[account.uid] ?? false)];
  });
});

/// The pending moderation queue for US61.
final moderationQueueProvider = StreamProvider<List<ModerationReport>>(
  (ref) => ref.watch(moderationRepositoryProvider).watchPending(),
);

class ModerationController extends Notifier<void> {
  @override
  void build() {}

  Future<void> reportProject({required String projectId, required String ownerUid, required String projectTitle, required String reason}) async {
    final reporterUid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (reporterUid == null) return;
    await ref.read(moderationRepositoryProvider).reportProject(
      ModerationReport(
        id: '',
        projectId: projectId,
        ownerUid: ownerUid,
        projectTitle: projectTitle,
        reporterUid: reporterUid,
        reason: reason,
        status: ModerationStatus.pending,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Dismisses the report — the content is fine, it stays published.
  Future<void> approveReport(String reportId) =>
      ref.read(moderationRepositoryProvider).setStatus(reportId, ModerationStatus.approved);

  /// Unpublishes the reported project and closes the report.
  Future<void> rejectReport(ModerationReport report) async {
    await ref.read(adminRepositoryProvider).unpublishProject(report.ownerUid, report.projectId);
    await ref.read(moderationRepositoryProvider).setStatus(report.id, ModerationStatus.rejected);
  }
}

final moderationControllerProvider = NotifierProvider<ModerationController, void>(ModerationController.new);

class AdminAccountController extends Notifier<void> {
  @override
  void build() {}

  Future<void> setAccountSuspended(String uid, bool isSuspended) =>
      ref.read(adminRepositoryProvider).setAccountSuspended(uid, isSuspended);

  Future<String?> fetchSupportNotes(String uid) => ref.read(adminRepositoryProvider).fetchSupportNotes(uid);

  Future<void> setSupportNotes(String uid, String notes) =>
      ref.read(adminRepositoryProvider).setSupportNotes(uid, notes);
}

final adminAccountControllerProvider = NotifierProvider<AdminAccountController, void>(AdminAccountController.new);
