import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/parental_control/application/parental_control_controller.dart';
import 'package:learningkids/features/parental_control/data/parental_control_repository.dart';
import 'package:learningkids/features/parental_control/domain/parent_pin.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        parentalControlRepositoryProvider.overrideWithValue(
          ParentalControlRepository(firestore: FakeFirebaseFirestore()),
        ),
      ],
    );
    addTearDown(container.dispose);
    // Let the auth stream resolve before any test reads a provider that
    // depends on it via `.future` — otherwise that read captures a build
    // that gets superseded once auth resolves and never completes on its
    // own (see the same fix in profile_controller_test.dart).
    await container.read(authStateChangesProvider.future);
  });

  test('verifyPin is false when no PIN has ever been created', () async {
    await container.read(parentalSettingsProvider.future);
    final notifier = container.read(parentalControlControllerProvider.notifier);
    expect(notifier.verifyPin('1234'), isFalse);
  });

  test('createOrChangePin then verifyPin accepts the right code and rejects others', () async {
    final notifier = container.read(parentalControlControllerProvider.notifier);

    await notifier.createOrChangePin('4242');
    // Re-read so parentalSettingsProvider observes the write we just made.
    await container.read(parentalSettingsProvider.future);

    expect(notifier.verifyPin('4242'), isTrue);
    expect(notifier.verifyPin('0000'), isFalse);
  });

  test('changing the PIN invalidates the old one', () async {
    final notifier = container.read(parentalControlControllerProvider.notifier);

    await notifier.createOrChangePin('1111');
    await container.read(parentalSettingsProvider.future);
    await notifier.createOrChangePin('2222');
    await container.read(parentalSettingsProvider.future);

    expect(notifier.verifyPin('1111'), isFalse);
    expect(notifier.verifyPin('2222'), isTrue);
  });

  test('setDailyLimitMinutes then clearDailyLimit round-trip through the provider', () async {
    final notifier = container.read(parentalControlControllerProvider.notifier);

    await notifier.setDailyLimitMinutes(45);
    var settings = await container.read(parentalSettingsProvider.future);
    expect(settings.dailyLimitMinutes, 45);

    await notifier.clearDailyLimit();
    settings = await container.read(parentalSettingsProvider.future);
    expect(settings.dailyLimitMinutes, isNull);
  });

  test('the stored PIN hash is salted with the uid, not stored in plain text', () async {
    final notifier = container.read(parentalControlControllerProvider.notifier);
    await notifier.createOrChangePin('4242');

    final settings = await container.read(parentalSettingsProvider.future);
    expect(settings.pinHash, isNot('4242'));
    expect(settings.pinHash, hashParentPin('4242', 'kid-1'));
  });
}
