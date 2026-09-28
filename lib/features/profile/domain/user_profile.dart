import '../../onboarding/domain/age_range.dart';
import '../../onboarding/domain/coding_level.dart';
import '../../onboarding/domain/learning_goal.dart';
import '../../onboarding/domain/recommended_path.dart';
import 'avatar.dart';

/// The `users/{uid}` Firestore document: identity plus the answers
/// collected during onboarding (US03/US04/US05).
class UserProfile {
  const UserProfile({
    required this.uid,
    required this.pseudo,
    required this.avatar,
    required this.ageRange,
    required this.codingLevel,
    required this.goals,
    required this.recommendedPath,
    required this.consentGivenAt,
    this.portfolioPublic = false,
  });

  final String uid;
  final String pseudo;
  final Avatar avatar;
  final AgeRange ageRange;
  final CodingLevel codingLevel;
  final Set<LearningGoal> goals;
  final RecommendedPath recommendedPath;

  /// Whether this learner's published projects (EP07/US40) can be viewed
  /// by someone else who has their share code — off by default, so a
  /// portfolio is private until the learner explicitly opts in.
  final bool portfolioPublic;

  /// When the parent/guardian accepted the data-collection notice shown
  /// before onboarding starts (US12) — kept as a record, not a gate: the
  /// app never re-checks it after account creation.
  final DateTime consentGivenAt;

  UserProfile copyWith({
    String? pseudo,
    Avatar? avatar,
    bool? portfolioPublic,
  }) => UserProfile(
    uid: uid,
    pseudo: pseudo ?? this.pseudo,
    avatar: avatar ?? this.avatar,
    ageRange: ageRange,
    codingLevel: codingLevel,
    goals: goals,
    recommendedPath: recommendedPath,
    consentGivenAt: consentGivenAt,
    portfolioPublic: portfolioPublic ?? this.portfolioPublic,
  );

  Map<String, dynamic> toMap() => {
    'pseudo': pseudo,
    'avatarId': avatar.name,
    'ageRange': ageRange.name,
    'codingLevel': codingLevel.name,
    'goals': goals.map((goal) => goal.name).toList(),
    'recommendedPath': recommendedPath.name,
    'consentGivenAt': consentGivenAt.toIso8601String(),
    'portfolioPublic': portfolioPublic,
  };

  static UserProfile fromMap(String uid, Map<String, dynamic> map) {
    final goals = ((map['goals'] as List<dynamic>?) ?? [])
        .map((id) => LearningGoal.values.firstWhere((g) => g.name == id))
        .toSet();
    final storedRecommendedPath = RecommendedPath.values.firstWhere(
      (value) => value.name == map['recommendedPath'],
      orElse: () => RecommendedPath.discovery,
    );
    return UserProfile(
      uid: uid,
      pseudo: map['pseudo'] as String? ?? '',
      avatar: Avatar.fromId(map['avatarId'] as String?),
      ageRange: AgeRange.values.firstWhere(
        (value) => value.name == map['ageRange'],
        orElse: () => AgeRange.sevenToNine,
      ),
      codingLevel: CodingLevel.values.firstWhere(
        (value) => value.name == map['codingLevel'],
        orElse: () => CodingLevel.beginner,
      ),
      goals: goals,
      // Profiles created before the mobile path existed may still store
      // `fullStack`; their explicit mobile goal is more accurate.
      recommendedPath: goals.contains(LearningGoal.mobileApp)
          ? RecommendedPath.mobile
          : storedRecommendedPath,
      consentGivenAt:
          DateTime.tryParse(map['consentGivenAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      portfolioPublic: map['portfolioPublic'] as bool? ?? false,
    );
  }
}
