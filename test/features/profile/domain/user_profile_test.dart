import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/learning_goal.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';

void main() {
  final profile = UserProfile(
    uid: 'uid-1',
    pseudo: 'Léo',
    avatar: Avatar.panda,
    ageRange: AgeRange.sevenToNine,
    codingLevel: CodingLevel.someBasics,
    goals: {LearningGoal.website, LearningGoal.game},
    recommendedPath: RecommendedPath.frontEnd,
    consentGivenAt: DateTime.utc(2026, 1, 1),
  );

  test('toMap/fromMap round-trips every field', () {
    final restored = UserProfile.fromMap(profile.uid, profile.toMap());

    expect(restored.uid, profile.uid);
    expect(restored.pseudo, profile.pseudo);
    expect(restored.avatar, profile.avatar);
    expect(restored.ageRange, profile.ageRange);
    expect(restored.codingLevel, profile.codingLevel);
    expect(restored.goals, profile.goals);
    expect(restored.recommendedPath, profile.recommendedPath);
    expect(restored.portfolioPublic, isFalse);
  });

  test(
    'portfolioPublic defaults to false and round-trips once enabled (US40)',
    () {
      expect(profile.portfolioPublic, isFalse);

      final public = profile.copyWith(portfolioPublic: true);
      final restored = UserProfile.fromMap(public.uid, public.toMap());

      expect(restored.portfolioPublic, isTrue);
    },
  );

  test('fromMap falls back to sane defaults for missing fields', () {
    final restored = UserProfile.fromMap('uid-2', const {});

    expect(restored.pseudo, '');
    expect(restored.avatar, Avatar.fox);
    expect(restored.ageRange, AgeRange.sevenToNine);
    expect(restored.codingLevel, CodingLevel.beginner);
    expect(restored.goals, isEmpty);
    expect(restored.recommendedPath, RecommendedPath.discovery);
  });

  test(
    'a legacy full-stack recommendation with a mobile goal opens mobile',
    () {
      final restored = UserProfile.fromMap('uid-mobile', {
        ...profile.toMap(),
        'goals': [LearningGoal.mobileApp.name],
        'recommendedPath': RecommendedPath.fullStack.name,
      });

      expect(restored.recommendedPath, RecommendedPath.mobile);
    },
  );

  test(
    'a legacy full-stack recommendation with a website goal opens front-end',
    () {
      final restored = UserProfile.fromMap('uid-web', {
        ...profile.toMap(),
        'goals': [LearningGoal.website.name],
        'recommendedPath': RecommendedPath.fullStack.name,
      });

      expect(restored.recommendedPath, RecommendedPath.frontEnd);
    },
  );

  test('copyWith only changes pseudo/avatar', () {
    final updated = profile.copyWith(pseudo: 'Emma', avatar: Avatar.owl);

    expect(updated.pseudo, 'Emma');
    expect(updated.avatar, Avatar.owl);
    expect(updated.ageRange, profile.ageRange);
    expect(updated.recommendedPath, profile.recommendedPath);
  });
}
