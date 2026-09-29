/// Central catalogue of route paths so screens never hard-code a path
/// string when navigating.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const signUp = '/sign-up';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';

  static const onboardingConsent = '/onboarding/consent';
  static const onboardingName = '/onboarding/name';
  static const onboardingAge = '/onboarding/age';
  static const onboardingLevel = '/onboarding/level';
  static const onboardingGoals = '/onboarding/goals';
  static const onboardingLoading = '/onboarding/loading';

  static const home = '/home';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';

  static const parentGate = '/parent-space/gate';
  static const parentDashboard = '/parent-space/dashboard';
  static const screenTimeLimit = '/screen-time-limit';

  static const paths = '/paths';
  static const lessonCatalog = '/lessons';
  static const roadmapPattern = '/paths/:pathId';
  static const moduleDetailPattern = '/paths/:pathId/modules/:moduleId';

  static String roadmap(String pathId) => '/paths/$pathId';
  static String moduleDetail(String pathId, String moduleId) =>
      '/paths/$pathId/modules/$moduleId';
  static String lessonCatalogFor(String pathId) =>
      '$lessonCatalog?path=$pathId';
  static String lessonCatalogForPaths(Iterable<String> pathIds) =>
      '$lessonCatalog?paths=${pathIds.join(',')}';

  static const codePlayground = '/code-playground';
  static String codePlaygroundFor(String pathId) =>
      '$codePlayground?path=$pathId';
  static String codePlaygroundForPaths(Iterable<String> pathIds) =>
      '$codePlayground?paths=${pathIds.join(',')}';
  static const codeAssistant = '/code-assistant';
  static const gitSimulator = '/git-simulator';

  static const sharedSnippetViewPattern = '/shared-snippet/:snippetId';
  static String sharedSnippetView(String snippetId) =>
      '/shared-snippet/$snippetId';

  static const challenge = '/challenge';

  static const myProjects = '/projects';
  static const projectTemplates = '/projects/templates';
  static String myProjectsFor(String pathId) => '$myProjects?path=$pathId';
  static String myProjectsForPaths(Iterable<String> pathIds) =>
      '$myProjects?paths=${pathIds.join(',')}';
  static String projectTemplatesFor(String pathId) =>
      '$projectTemplates?path=$pathId';
  static String projectTemplatesForPaths(Iterable<String> pathIds) =>
      '$projectTemplates?paths=${pathIds.join(',')}';
  static const projectDetailPattern = '/projects/:projectId';
  static const portfolio = '/portfolio';
  static const portfolioForPattern = '/portfolio/:ownerUid';

  static String projectDetail(String projectId) => '/projects/$projectId';
  static String portfolioFor(String ownerUid) => '/portfolio/$ownerUid';

  static const badges = '/badges';
  static const leaderboard = '/leaderboard';
  static const certificatePattern = '/certificate/:pathId';

  static String certificate(String pathId) => '/certificate/$pathId';

  static const dashboard = '/dashboard';

  static const notificationSettings = '/notification-settings';

  static const accountSuspended = '/account-suspended';
  static const adminHome = '/admin';
  static const adminModerationQueue = '/admin/moderation';
  static const adminAccounts = '/admin/accounts';

  static const languageSettings = '/language-settings';
  static const accessibilitySettings = '/accessibility-settings';
}
