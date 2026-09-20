import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/application/admin_providers.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';
import 'package:learningkids/features/admin/data/moderation_repository.dart';
import 'package:learningkids/features/admin/domain/moderation_report.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProviderContainer container;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        adminRepositoryProvider.overrideWithValue(AdminRepository(firestore: firestore)),
        moderationRepositoryProvider.overrideWithValue(ModerationRepository(firestore: firestore)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authStateChangesProvider.future);
  });

  test('isAdminProvider is false until admins/{uid} exists', () async {
    expect(await container.read(isAdminProvider.future), isFalse);

    container.listen(isAdminProvider, (_, _) {}, fireImmediately: true);
    await firestore.collection('admins').doc('kid-1').set({});
    await Future<void>.delayed(Duration.zero);

    expect(container.read(isAdminProvider).value, isTrue);
  });

  test('isAccountSuspendedProvider reflects accountStatus/{myUid} (US63)', () async {
    expect(await container.read(isAccountSuspendedProvider.future), isFalse);

    container.listen(isAccountSuspendedProvider, (_, _) {}, fireImmediately: true);
    await container.read(adminRepositoryProvider).setAccountSuspended('kid-1', true);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(isAccountSuspendedProvider).value, isTrue);
  });

  test('adminAccountsProvider joins the directory with suspension status', () async {
    await firestore.collection('accountDirectory').doc('kid-2').set({'pseudo': 'Nora', 'avatarId': 'cat'});
    await container.read(adminRepositoryProvider).setAccountSuspended('kid-2', true);

    container.listen(adminAccountsProvider, (_, _) {}, fireImmediately: true);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final accounts = container.read(adminAccountsProvider).value ?? [];
    final nora = accounts.firstWhere((a) => a.uid == 'kid-2');
    expect(nora.isSuspended, isTrue);
  });

  test('ModerationController.reportProject then approveReport clears the queue', () async {
    await container
        .read(moderationControllerProvider.notifier)
        .reportProject(projectId: 'p1', ownerUid: 'kid-2', projectTitle: 'Mon site', reason: 'x');

    final pending = await container.read(moderationRepositoryProvider).watchPending().first;
    expect(pending, hasLength(1));

    await container.read(moderationControllerProvider.notifier).approveReport(pending.single.id);

    expect(await container.read(moderationRepositoryProvider).watchPending().first, isEmpty);
  });

  test('ModerationController.rejectReport unpublishes the project and closes the report', () async {
    await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').set({'isPublished': true});
    final report = ModerationReport(
      id: '',
      projectId: 'p1',
      ownerUid: 'kid-2',
      projectTitle: 'Mon site',
      reporterUid: 'kid-1',
      reason: 'x',
      status: ModerationStatus.pending,
      createdAt: DateTime.now(),
    );
    await container.read(moderationRepositoryProvider).reportProject(report);
    final stored = (await container.read(moderationRepositoryProvider).watchPending().first).single;

    await container.read(moderationControllerProvider.notifier).rejectReport(stored);

    final project = await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').get();
    expect(project.data()!['isPublished'], isFalse);
    expect(await container.read(moderationRepositoryProvider).watchPending().first, isEmpty);
  });

  test('AdminAccountController suspends/unsuspends and stores support notes', () async {
    await container.read(adminAccountControllerProvider.notifier).setAccountSuspended('kid-2', true);
    expect(await container.read(adminRepositoryProvider).isAccountSuspended('kid-2'), isTrue);

    await container.read(adminAccountControllerProvider.notifier).setSupportNotes('kid-2', 'Parent contacted.');
    expect(await container.read(adminAccountControllerProvider.notifier).fetchSupportNotes('kid-2'), 'Parent contacted.');
  });
}
