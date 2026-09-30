import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/gamification/data/gamification_repository.dart';
import 'package:learningkids/features/learning_path/application/learning_progress_controller.dart';
import 'package:learningkids/features/learning_path/data/learning_progress_repository.dart';
import 'package:learningkids/features/learning_path/domain/curriculum.dart';
import 'package:learningkids/features/learning_path/domain/learning_path.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_notification_service.dart';
import '../../../support/notification_overrides.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    final mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
    );
    final firestore = FakeFirebaseFirestore();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepository(firebaseAuth: mockAuth),
        ),
        learningProgressRepositoryProvider.overrideWithValue(
          LearningProgressRepository(firestore: firestore),
        ),
        gamificationRepositoryProvider.overrideWithValue(
          GamificationRepository(firestore: firestore),
        ),
        profileRepositoryProvider.overrideWithValue(
          ProfileRepository(firestore: firestore),
        ),
        ...await disabledNotificationOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authStateChangesProvider.future);
  });

  test(
    'activatePath then learningProgressProvider reflects the active path',
    () async {
      await container
          .read(learningProgressControllerProvider.notifier)
          .activatePath(LearningPath.frontEnd);

      final progress = await container.read(learningProgressProvider.future);
      expect(progress.isActive(LearningPath.frontEnd), isTrue);
    },
  );

  test('markModuleCompleted updates the per-path completed set', () async {
    final notifier = container.read(
      learningProgressControllerProvider.notifier,
    );
    await notifier.activatePath(LearningPath.python);
    await notifier.markModuleCompleted(LearningPath.python, 'python-1');

    final progress = await container.read(learningProgressProvider.future);
    expect(progress.completedIdsFor(LearningPath.python), {'python-1'});
  });

  test(
    'markModuleCompleted threads the quiz score through (EP09/US51)',
    () async {
      final notifier = container.read(
        learningProgressControllerProvider.notifier,
      );
      await notifier.activatePath(LearningPath.python);
      await notifier.markModuleCompleted(
        LearningPath.python,
        'python-1',
        correctAnswers: 1,
      );

      final progress = await container.read(learningProgressProvider.future);
      expect(progress.quizScoreFor('python-1'), 1);
    },
  );

  test('deactivatePath removes it from the active set', () async {
    final notifier = container.read(
      learningProgressControllerProvider.notifier,
    );
    await notifier.activatePath(LearningPath.backend);
    await notifier.deactivatePath(LearningPath.backend);

    final progress = await container.read(learningProgressProvider.future);
    expect(progress.isActive(LearningPath.backend), isFalse);
  });

  test(
    'completing the last module of a path fires a certificate reward notification (EP11/US58)',
    () async {
      SharedPreferences.setMockInitialValues({});
      final mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'),
      );
      final firestore = FakeFirebaseFirestore();
      final fakeNotificationService = FakeNotificationService();
      final localContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            AuthRepository(firebaseAuth: mockAuth),
          ),
          learningProgressRepositoryProvider.overrideWithValue(
            LearningProgressRepository(firestore: firestore),
          ),
          gamificationRepositoryProvider.overrideWithValue(
            GamificationRepository(firestore: firestore),
          ),
          profileRepositoryProvider.overrideWithValue(
            ProfileRepository(firestore: firestore),
          ),
          localPreferencesProvider.overrideWithValue(
            LocalPreferences(await SharedPreferences.getInstance()),
          ),
          notificationServiceProvider.overrideWithValue(
            fakeNotificationService,
          ),
        ],
      );
      addTearDown(localContainer.dispose);
      await localContainer.read(authStateChangesProvider.future);

      final notifier = localContainer.read(
        learningProgressControllerProvider.notifier,
      );
      await notifier.activatePath(LearningPath.python);
      for (final moduleId in curriculumFor(
        LearningPath.python,
      ).map((module) => module.id).take(22)) {
        await notifier.markModuleCompleted(LearningPath.python, moduleId);
      }
      expect(
        fakeNotificationService.shownRewards.any(
          (r) => r.title.contains('Certificat'),
        ),
        isFalse,
        reason: 'the path is not complete yet',
      );

      await notifier.markModuleCompleted(LearningPath.python, 'python-23');

      expect(
        fakeNotificationService.shownRewards.any(
          (r) => r.title.contains('Certificat'),
        ),
        isTrue,
      );
    },
  );

  test(
    'saveLessonStep persists the reading position for resume (US25)',
    () async {
      await container
          .read(learningProgressControllerProvider.notifier)
          .saveLessonStep('frontend-2', 2);

      final progress = await container.read(learningProgressProvider.future);
      expect(progress.stepIndexFor('frontend-2'), 2);
    },
  );
}
