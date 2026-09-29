import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/application/admin_providers.dart';
import '../../features/admin/presentation/screens/account_management_screen.dart';
import '../../features/admin/presentation/screens/account_suspended_screen.dart';
import '../../features/admin/presentation/screens/admin_home_screen.dart';
import '../../features/admin/presentation/screens/moderation_queue_screen.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/code_playground/presentation/screens/code_playground_screen.dart';
import '../../features/code_playground/presentation/screens/shared_snippet_view_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/gamification/presentation/screens/badges_screen.dart';
import '../../features/gamification/presentation/screens/certificate_screen.dart';
import '../../features/gamification/presentation/screens/challenge_screen.dart';
import '../../features/gamification/presentation/screens/leaderboard_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/learning_path/domain/learning_path.dart';
import '../../features/learning_path/presentation/screens/git_simulator_screen.dart';
import '../../features/learning_path/presentation/screens/lesson_catalog_screen.dart';
import '../../features/learning_path/presentation/screens/lesson_player_screen.dart';
import '../../features/learning_path/presentation/screens/paths_screen.dart';
import '../../features/learning_path/presentation/screens/roadmap_screen.dart';
import '../../features/notifications/presentation/screens/notification_settings_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_age_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_consent_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_goals_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_level_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_loading_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_name_screen.dart';
import '../../features/parental_control/application/screen_time_controller.dart';
import '../../features/parental_control/presentation/screens/parent_dashboard_screen.dart';
import '../../features/parental_control/presentation/screens/parent_gate_screen.dart';
import '../../features/parental_control/presentation/screens/screen_time_limit_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/projects/presentation/screens/my_projects_screen.dart';
import '../../features/projects/presentation/screens/portfolio_screen.dart';
import '../../features/projects/presentation/screens/project_editor_screen.dart';
import '../../features/projects/presentation/screens/project_templates_screen.dart';
import '../../features/settings/presentation/screens/accessibility_settings_screen.dart';
import '../../features/settings/presentation/screens/language_settings_screen.dart';
import '../../features/welcome/presentation/screens/splash_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../storage/local_preferences.dart';
import 'app_routes.dart';

const _authRoutes = {
  AppRoutes.welcome,
  AppRoutes.signUp,
  AppRoutes.login,
  AppRoutes.forgotPassword,
};

/// Routes still reachable once the daily screen-time limit is hit — the
/// blocking screen itself and the parent PIN flow it links to.
const _screenTimeExemptRoutes = {
  AppRoutes.screenTimeLimit,
  AppRoutes.parentGate,
  AppRoutes.parentDashboard,
};

final routerProvider = Provider<GoRouter>((ref) {
  final refreshStream = GoRouterRefreshStream(
    ref.watch(authRepositoryProvider).authStateChanges(),
  );
  ref.onDispose(refreshStream.dispose);
  // Screen time ticks (and limit/PIN changes) don't come from navigation,
  // so the redirect above wouldn't otherwise re-run when they happen.
  ref.listen(screenTimeControllerProvider, (_, _) => refreshStream.ping());
  // Same for a suspension being lifted/applied by an admin (EP12/US63).
  ref.listen(isAccountSuspendedProvider, (_, _) => refreshStream.ping());

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshStream,
    redirect: (context, state) => _redirect(ref, state.matchedLocation),
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(path: AppRoutes.signUp, builder: (_, _) => const SignUpScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingConsent,
        builder: (_, _) => const OnboardingConsentScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingName,
        builder: (_, _) => const OnboardingNameScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingAge,
        builder: (_, _) => const OnboardingAgeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingLevel,
        builder: (_, _) => const OnboardingLevelScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingGoals,
        builder: (_, _) => const OnboardingGoalsScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingLoading,
        builder: (_, _) => const OnboardingLoadingScreen(),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (_, _) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.parentGate,
        // `extra` carries a pre-built ParentGateScreen when the caller
        // needs a non-default action/forceCreatePin (see
        // `parent_dashboard_screen.dart` and `screen_time_limit_screen.dart`).
        builder: (_, state) =>
            state.extra as Widget? ?? const ParentGateScreen(),
      ),
      GoRoute(
        path: AppRoutes.parentDashboard,
        builder: (_, _) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.screenTimeLimit,
        builder: (_, _) => const ScreenTimeLimitScreen(),
      ),
      GoRoute(path: AppRoutes.paths, builder: (_, _) => const PathsScreen()),
      GoRoute(
        path: AppRoutes.roadmapPattern,
        builder: (_, state) => RoadmapScreen(path: _pathFromParam(state)),
      ),
      GoRoute(
        path: AppRoutes.moduleDetailPattern,
        builder: (_, state) => LessonPlayerScreen(
          path: _pathFromParam(state),
          moduleId: state.pathParameters['moduleId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.lessonCatalog,
        builder: (_, state) =>
            LessonCatalogScreen(paths: _pathsFromQuery(state)),
      ),
      GoRoute(
        path: AppRoutes.codePlayground,
        builder: (_, state) =>
            CodePlaygroundScreen(paths: _pathsFromQuery(state)),
      ),
      GoRoute(
        // `extra` always carries a pre-built CodeAssistantScreen (language +
        // current code) from the Code Playground — see
        // `code_playground_screen.dart`.
        path: AppRoutes.codeAssistant,
        builder: (_, state) => state.extra! as Widget,
      ),
      GoRoute(
        path: AppRoutes.myProjects,
        builder: (_, state) => MyProjectsScreen(paths: _pathsFromQuery(state)),
      ),
      // Declared before the `:projectId` pattern below so the literal
      // `/projects/templates` segment always wins the match.
      GoRoute(
        path: AppRoutes.projectTemplates,
        builder: (_, state) =>
            ProjectTemplatesScreen(paths: _pathsFromQuery(state)),
      ),
      GoRoute(
        path: AppRoutes.projectDetailPattern,
        builder: (_, state) =>
            ProjectEditorScreen(projectId: state.pathParameters['projectId']!),
      ),
      GoRoute(
        path: AppRoutes.portfolio,
        builder: (_, _) => const PortfolioScreen(),
      ),
      GoRoute(
        path: AppRoutes.portfolioForPattern,
        builder: (_, state) =>
            PortfolioScreen(ownerUid: state.pathParameters['ownerUid']),
      ),
      GoRoute(path: AppRoutes.badges, builder: (_, _) => const BadgesScreen()),
      GoRoute(
        path: AppRoutes.leaderboard,
        builder: (_, _) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.challenge,
        builder: (_, _) => const ChallengeScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, _) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.certificatePattern,
        builder: (_, state) => CertificateScreen(path: _pathFromParam(state)),
      ),
      GoRoute(
        path: AppRoutes.gitSimulator,
        builder: (_, _) => const GitSimulatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.sharedSnippetViewPattern,
        builder: (_, state) => SharedSnippetViewScreen(
          snippetId: state.pathParameters['snippetId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.accountSuspended,
        builder: (_, _) => const AccountSuspendedScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminHome,
        builder: (_, _) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminModerationQueue,
        builder: (_, _) => const ModerationQueueScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminAccounts,
        builder: (_, _) => const AccountManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSettings,
        builder: (_, _) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.accessibilitySettings,
        builder: (_, _) => const AccessibilitySettingsScreen(),
      ),
    ],
  );
});

LearningPath _pathFromParam(GoRouterState state) {
  final id = state.pathParameters['pathId'];
  return LearningPath.values.firstWhere((path) => path.name == id);
}

Set<LearningPath>? _pathsFromQuery(GoRouterState state) {
  final ids =
      state.uri.queryParameters['paths']?.split(',') ??
      [state.uri.queryParameters['path']].nonNulls;
  final paths = ids
      .map(
        (id) =>
            LearningPath.values.where((path) => path.name == id).firstOrNull,
      )
      .nonNulls
      .toSet();
  return paths.isEmpty ? null : paths;
}

String? _redirect(Ref ref, String location) {
  final authState = ref.read(authStateChangesProvider);
  if (authState.isLoading) {
    return location == AppRoutes.splash ? null : AppRoutes.splash;
  }

  final isLoggedIn = authState.valueOrNull != null;
  final isAuthRoute = _authRoutes.contains(location);
  final isOnboardingRoute = location.startsWith('/onboarding');

  if (!isLoggedIn) {
    return isAuthRoute ? null : AppRoutes.welcome;
  }

  final hasOnboarded = ref
      .read(localPreferencesProvider)
      .hasCompletedOnboarding;
  if (!hasOnboarded) {
    return isOnboardingRoute ? null : AppRoutes.onboardingConsent;
  }

  final isSuspended = ref.read(isAccountSuspendedProvider).valueOrNull ?? false;
  if (isSuspended && location != AppRoutes.accountSuspended) {
    return AppRoutes.accountSuspended;
  }

  final mustLeave =
      isAuthRoute || isOnboardingRoute || location == AppRoutes.splash;
  if (mustLeave) return AppRoutes.home;

  final isLimitReached =
      ref.read(screenTimeControllerProvider).valueOrNull?.isLimitReached ??
      false;
  if (isLimitReached && !_screenTimeExemptRoutes.contains(location)) {
    return AppRoutes.screenTimeLimit;
  }

  return null;
}

/// Bridges a [Stream] (here, Firebase's auth state changes) to go_router's
/// [Listenable]-based `refreshListenable`, so a sign-in/out re-evaluates
/// [_redirect] even if it didn't originate from in-app navigation.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  /// Lets other in-app state changes (e.g. a screen-time tick) force a
  /// redirect re-evaluation the same way a stream event would.
  void ping() => notifyListeners();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
