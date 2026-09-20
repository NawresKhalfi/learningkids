import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/data/admin_repository.dart';

void main() {
  test('watchIsAdmin is false until an admins/{uid} doc exists', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = AdminRepository(firestore: firestore);

    expect(await repository.watchIsAdmin('kid-1').first, isFalse);

    await firestore.collection('admins').doc('kid-1').set({});

    expect(await repository.watchIsAdmin('kid-1').first, isTrue);
  });

  test('watchAccountDirectory lists every mirrored account', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('accountDirectory').doc('kid-1').set({'pseudo': 'Léo', 'avatarId': 'fox'});
    await firestore.collection('accountDirectory').doc('kid-2').set({'pseudo': 'Nora', 'avatarId': 'cat'});
    final repository = AdminRepository(firestore: firestore);

    final accounts = await repository.watchAccountDirectory().first;

    expect(accounts.map((a) => a.uid), containsAll(['kid-1', 'kid-2']));
  });

  test('setAccountSuspended then isAccountSuspended reflects the change (US63)', () async {
    final repository = AdminRepository(firestore: FakeFirebaseFirestore());
    expect(await repository.isAccountSuspended('kid-1'), isFalse);

    await repository.setAccountSuspended('kid-1', true);
    expect(await repository.isAccountSuspended('kid-1'), isTrue);

    await repository.setAccountSuspended('kid-1', false);
    expect(await repository.isAccountSuspended('kid-1'), isFalse);
  });

  test('watchOwnSuspendedStatus reflects a single account\'s flag without querying the whole collection', () async {
    final repository = AdminRepository(firestore: FakeFirebaseFirestore());

    expect(await repository.watchOwnSuspendedStatus('kid-1').first, isFalse);

    await repository.setAccountSuspended('kid-1', true);

    expect(await repository.watchOwnSuspendedStatus('kid-1').first, isTrue);
  });

  test('watchSuspendedStatuses maps every accountStatus doc', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = AdminRepository(firestore: firestore);
    await repository.setAccountSuspended('kid-1', true);
    await repository.setAccountSuspended('kid-2', false);

    final statuses = await repository.watchSuspendedStatuses().first;

    expect(statuses['kid-1'], isTrue);
    expect(statuses['kid-2'], isFalse);
  });

  test('setSupportNotes then fetchSupportNotes round-trips', () async {
    final repository = AdminRepository(firestore: FakeFirebaseFirestore());
    expect(await repository.fetchSupportNotes('kid-1'), isNull);

    await repository.setSupportNotes('kid-1', 'Called the parent on 2026-03-01.');

    expect(await repository.fetchSupportNotes('kid-1'), 'Called the parent on 2026-03-01.');
  });

  test('unpublishProject sets isPublished to false on the owner\'s project', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').set({'isPublished': true});
    final repository = AdminRepository(firestore: firestore);

    await repository.unpublishProject('kid-2', 'p1');

    final doc = await firestore.collection('users').doc('kid-2').collection('projects').doc('p1').get();
    expect(doc.data()!['isPublished'], isFalse);
  });
}
