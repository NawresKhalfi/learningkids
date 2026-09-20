import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/core/storage/local_preferences.dart';
import 'package:learningkids/features/gamification/domain/badge_definition.dart';
import 'package:learningkids/features/notifications/application/reward_notifier.dart';
import 'package:learningkids/features/notifications/data/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_notification_service.dart';

void main() {
  late FakeNotificationService fakeService;
  late ProviderContainer container;

  Future<void> buildContainer() async {
    fakeService = FakeNotificationService();
    container = ProviderContainer(
      overrides: [
        localPreferencesProvider.overrideWithValue(LocalPreferences(await SharedPreferences.getInstance())),
        notificationServiceProvider.overrideWithValue(fakeService),
      ],
    );
    addTearDown(container.dispose);
  }

  final badge = BadgeDefinition(id: 'first-lesson', title: 'Premiers pas', description: '', emoji: '🎉', isUnlocked: (_) => true);

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('notifyBadgeUnlocked shows a notification when rewards are enabled (US58)', () async {
    await buildContainer();

    await container.read(rewardNotifierProvider).notifyBadgeUnlocked(badge);

    expect(fakeService.shownRewards, hasLength(1));
    expect(fakeService.shownRewards.single.body, 'Premiers pas');
  });

  test('notifyLevelUp and notifyCertificateUnlocked also show a notification', () async {
    await buildContainer();

    await container.read(rewardNotifierProvider).notifyLevelUp(3);
    await container.read(rewardNotifierProvider).notifyCertificateUnlocked('Python');

    expect(fakeService.shownRewards, hasLength(2));
  });

  test('nothing fires once the learner disabled reward notifications (US59)', () async {
    await buildContainer();
    await container.read(localPreferencesProvider).setRewardNotificationsEnabled(false);

    await container.read(rewardNotifierProvider).notifyBadgeUnlocked(badge);

    expect(fakeService.shownRewards, isEmpty);
  });
}
