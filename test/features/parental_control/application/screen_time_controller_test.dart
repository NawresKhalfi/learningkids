import 'package:fake_async/fake_async.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/parental_control/application/screen_time_controller.dart';
import 'package:learningkids/features/parental_control/data/parental_control_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'credits one minute per foreground tick and stops while backgrounded (US09)',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = LocalPreferences(await SharedPreferences.getInstance());
      await prefs.setOnboardingCompleted('kid-1', true);
      final firestore = FakeFirebaseFirestore();
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
      );

      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              AuthRepository(firebaseAuth: mockAuth),
            ),
            parentalControlRepositoryProvider.overrideWithValue(
              ParentalControlRepository(firestore: firestore),
            ),
            localPreferencesProvider.overrideWithValue(prefs),
          ],
        );
        addTearDown(container.dispose);

        container.read(screenTimeControllerProvider);
        async.flushMicrotasks();
        expect(
          container
              .read(screenTimeControllerProvider)
              .valueOrNull
              ?.todayMinutes,
          0,
        );

        async.elapse(const Duration(minutes: 1));
        expect(
          container
              .read(screenTimeControllerProvider)
              .valueOrNull
              ?.todayMinutes,
          1,
        );

        final notifier = container.read(screenTimeControllerProvider.notifier);
        notifier.setForeground(false);
        async.elapse(const Duration(minutes: 3));
        expect(
          container
              .read(screenTimeControllerProvider)
              .valueOrNull
              ?.todayMinutes,
          1,
          reason: 'backgrounded time should not be credited',
        );

        notifier.setForeground(true);
        async.elapse(const Duration(minutes: 1));
        expect(
          container
              .read(screenTimeControllerProvider)
              .valueOrNull
              ?.todayMinutes,
          2,
        );
      });
    },
  );

  test(
    'grantExtraTimeToday bypasses an already-reached limit for the rest of the day',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = LocalPreferences(await SharedPreferences.getInstance());
      await prefs.setOnboardingCompleted('kid-1', true);
      final firestore = FakeFirebaseFirestore();
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
      );
      final repository = ParentalControlRepository(firestore: firestore);
      await repository.setDailyLimit('kid-1', 5);
      await repository.incrementTodayMinutes('kid-1', 5);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(firebaseAuth: mockAuth),
          ),
          parentalControlRepositoryProvider.overrideWithValue(repository),
          localPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final snapshot = await container.read(
        screenTimeControllerProvider.future,
      );
      expect(snapshot.isLimitReached, isTrue);

      await container
          .read(screenTimeControllerProvider.notifier)
          .grantExtraTimeToday();

      expect(
        container
            .read(screenTimeControllerProvider)
            .valueOrNull
            ?.isLimitReached,
        isFalse,
      );
    },
  );
}
