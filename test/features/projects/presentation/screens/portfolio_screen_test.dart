import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learningkids/features/admin/data/moderation_repository.dart';
import 'package:learningkids/features/auth/data/auth_repository.dart';
import 'package:learningkids/features/code_playground/domain/programming_language.dart';
import 'package:learningkids/features/profile/data/profile_repository.dart';
import 'package:learningkids/features/profile/domain/avatar.dart';
import 'package:learningkids/features/profile/domain/user_profile.dart';
import 'package:learningkids/features/onboarding/domain/age_range.dart';
import 'package:learningkids/features/onboarding/domain/coding_level.dart';
import 'package:learningkids/features/onboarding/domain/recommended_path.dart';
import 'package:learningkids/features/projects/data/project_repository.dart';
import 'package:learningkids/features/projects/domain/project.dart';
import 'package:learningkids/features/projects/domain/project_category.dart';
import 'package:learningkids/features/projects/presentation/screens/portfolio_screen.dart';
import 'package:learningkids/l10n/gen/app_localizations.dart';

void main() {
  Future<ProviderContainer> pumpPortfolio(
    WidgetTester tester, {
    required FakeFirebaseFirestore firestore,
    String? ownerUid,
  }) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final mockAuth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'kid-1', email: 'kid@example.com'));
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(AuthRepository(firebaseAuth: mockAuth)),
        projectRepositoryProvider.overrideWithValue(ProjectRepository(firestore: firestore)),
        profileRepositoryProvider.overrideWithValue(ProfileRepository(firestore: firestore)),
        moderationRepositoryProvider.overrideWithValue(ModerationRepository(firestore: firestore)),
      ],
    );
    addTearDown(container.dispose);

    await ProfileRepository(firestore: firestore).createInitialProfile(
      UserProfile(
        uid: 'kid-1',
        pseudo: 'Léo',
        avatar: Avatar.panda,
        ageRange: AgeRange.sevenToNine,
        codingLevel: CodingLevel.someBasics,
        goals: const {},
        recommendedPath: RecommendedPath.frontEnd,
        consentGivenAt: DateTime.utc(2026, 1, 1),
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: PortfolioScreen(ownerUid: ownerUid),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows an empty state before anything is published', (tester) async {
    await pumpPortfolio(tester, firestore: FakeFirebaseFirestore());

    expect(find.text('Aucun projet publié pour l\'instant.'), findsOneWidget);
  });

  testWidgets('lists only published projects, not drafts (US39)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final repository = ProjectRepository(firestore: firestore);
    await repository.createProject(
      'kid-1',
      Project(
        id: '',
        title: 'Brouillon',
        language: ProgrammingLanguage.python,
        category: ProjectCategory.game,
        code: 'code',
        createdAt: DateTime.now(),
      ),
    );
    await repository.createProject(
      'kid-1',
      Project(
        id: '',
        title: 'Projet publié',
        language: ProgrammingLanguage.html,
        category: ProjectCategory.website,
        code: 'code',
        createdAt: DateTime.now(),
        isPublished: true,
      ),
    );

    await pumpPortfolio(tester, firestore: firestore);

    expect(find.text('Projet publié'), findsOneWidget);
    expect(find.text('Brouillon'), findsNothing);
  });

  testWidgets('the public/private toggle updates the profile (US40)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await pumpPortfolio(tester, firestore: firestore);

    expect(find.text('Ton portfolio est privé : personne ne peut le voir.'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text("N'importe qui avec ton code peut voir ton portfolio."), findsOneWidget);
    final profile = await ProfileRepository(firestore: firestore).fetchProfile('kid-1');
    expect(profile!.portfolioPublic, isTrue);
  });

  testWidgets('someone else\'s portfolio view has no sharing controls', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await pumpPortfolio(tester, firestore: firestore, ownerUid: 'kid-2');

    expect(find.text('Portfolio public'), findsNothing);
    expect(find.text('Partager mon code'), findsNothing);
  });

  testWidgets('reporting a project on someone else\'s portfolio files a report (EP12/US61)', (tester) async {
    final firestore = FakeFirebaseFirestore();
    await ProjectRepository(firestore: firestore).createProject(
      'kid-2',
      Project(
        id: '',
        title: 'Projet signalé',
        language: ProgrammingLanguage.html,
        category: ProjectCategory.website,
        code: 'code',
        createdAt: DateTime.now(),
        isPublished: true,
      ),
    );

    await pumpPortfolio(tester, firestore: firestore, ownerUid: 'kid-2');
    final l10n = AppLocalizations.of(tester.element(find.byType(PortfolioScreen)));

    await tester.tap(find.byIcon(Icons.flag_outlined));
    await tester.pumpAndSettle();
    expect(find.text(l10n.portfolioReportTitle), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Contenu inapproprié');
    await tester.tap(find.text(l10n.portfolioReportSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.portfolioReportSent), findsOneWidget);
    final reports = await firestore.collection('moderationReports').get();
    expect(reports.docs, hasLength(1));
    expect(reports.docs.single.data()['reporterUid'], 'kid-1');
    expect(reports.docs.single.data()['ownerUid'], 'kid-2');
    expect(reports.docs.single.data()['reason'], 'Contenu inapproprié');
  });
}
