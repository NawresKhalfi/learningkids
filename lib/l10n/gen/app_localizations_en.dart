// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LearningKids';

  @override
  String get welcomeTaglineLead => 'Finally, coding becomes';

  @override
  String get welcomeTaglineHighlight => 'REALLY fun';

  @override
  String get welcomeCta => 'Get started';

  @override
  String get commonOr => 'or';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSomethingWentWrong => 'Something went wrong. Try again.';

  @override
  String get commonNoInternet =>
      'Check your internet connection and try again.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get onboardingErrorNetwork =>
      'Your connection dropped. Check your internet and try again.';

  @override
  String get onboardingErrorGeneric =>
      'Saving failed. Please try again in a moment.';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get signUpEmailLabel => 'Email address';

  @override
  String get signUpPasswordLabel => 'Password';

  @override
  String get signUpConfirmPasswordLabel => 'Confirm password';

  @override
  String get signUpSubmit => 'Create my account';

  @override
  String get signUpAlreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpLoginLink => 'Log in';

  @override
  String get signUpErrorEmailInUse =>
      'An account already exists with this email.';

  @override
  String get signUpErrorInvalidEmail => 'This email address isn\'t valid.';

  @override
  String get signUpErrorWeakPassword =>
      'Choose a password with at least 6 characters.';

  @override
  String get signUpErrorPasswordMismatch => 'The passwords don\'t match.';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginEmailLabel => 'Email address';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginSubmit => 'Log in';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginNoAccount => 'Don\'t have an account yet?';

  @override
  String get loginSignUpLink => 'Sign up';

  @override
  String get loginErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get loginErrorTooManyRequests =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a link to reset it.';

  @override
  String get forgotPasswordEmailLabel => 'Email address';

  @override
  String get forgotPasswordSubmit => 'Send the link';

  @override
  String get forgotPasswordBackToLogin => 'Back to login';

  @override
  String get forgotPasswordSuccess => 'Email sent! Check your inbox.';

  @override
  String get onboardingConsentMessage =>
      'Before we start, a word for the parent or guardian setting up this account!';

  @override
  String get onboardingConsentBody =>
      'LearningKids only keeps the first name, age range, learning goals and daily usage time (for parental controls). No ads, no selling data. The account and all its data can be deleted at any time from the profile.';

  @override
  String get onboardingConsentAccept => 'I agree, I am the parent or guardian';

  @override
  String get onboardingMascotName => 'Byte';

  @override
  String get onboardingAskName =>
      'Hi! I\'m Byte, your coding buddy.\nWhat\'s your name?';

  @override
  String get onboardingNameHint => 'Your first name';

  @override
  String onboardingAskAge(String name) {
    return 'Nice to meet you, $name!\nHow old are you?';
  }

  @override
  String get onboardingAge4to6 => '4-6 years old';

  @override
  String get onboardingAge7to9 => '7-9 years old';

  @override
  String get onboardingAge10to12 => '10-12 years old';

  @override
  String get onboardingAge13plus => '13 and up';

  @override
  String get onboardingLevelTitle => 'Have you already tried coding?';

  @override
  String get onboardingLevelBeginner => 'Never, I\'m a beginner';

  @override
  String get onboardingLevelSomeBasics => 'A little, I know the basics';

  @override
  String get onboardingLevelComfortable => 'Yes, I already build projects';

  @override
  String get onboardingGoalsTitle => 'What do you want to create with code?';

  @override
  String get onboardingGoalsSubtitle => 'You can choose several answers.';

  @override
  String get onboardingGoalWebsite => 'A website';

  @override
  String get onboardingGoalGame => 'A video game';

  @override
  String get onboardingGoalApp => 'A mobile app';

  @override
  String get onboardingGoalAi => 'Understand artificial intelligence';

  @override
  String get onboardingGoalsSubmit => 'Let\'s go!';

  @override
  String get onboardingGoalsErrorEmpty =>
      'Choose at least one goal to continue.';

  @override
  String get onboardingLoadingMessage =>
      'Preparing your personalized program...';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get homeRecommendedPathLabel => 'Your recommended path';

  @override
  String get homeProfileTooltip => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEditProfile => 'Edit profile';

  @override
  String get profileAccountSettings => 'Account settings';

  @override
  String get profileNotificationSettings => 'Notifications';

  @override
  String get profileLanguageSettings => 'Language';

  @override
  String get profileAccessibilitySettings => 'Accessibility';

  @override
  String get profileParentSpace => 'Parent space';

  @override
  String get profileLogOut => 'Log out';

  @override
  String get profileDeleteAccount => 'Delete my account';

  @override
  String get profileDeleteConfirmTitle => 'Delete your account?';

  @override
  String get profileDeleteConfirmBody =>
      'This action is permanent. All your data will be deleted.';

  @override
  String get profileDeleteConfirmCta => 'Yes, delete';

  @override
  String get profileDeleteReauthRequired =>
      'Log back in to confirm deleting your account.';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfilePseudoLabel => 'Nickname';

  @override
  String get editProfileChooseAvatar => 'Choose your avatar';

  @override
  String get editProfileSaved => 'Profile updated!';

  @override
  String get editProfileErrorEmpty => 'Your nickname can\'t be empty.';

  @override
  String get parentGateTitle => 'Parent space';

  @override
  String get parentGateGrantExtraTitle => 'Unlock more time';

  @override
  String get parentGateEnterPinPrompt =>
      'Is a parent here? Enter the PIN code to continue.';

  @override
  String get parentGateCreatePinPrompt =>
      'Create a 4-digit PIN code to protect the Parent space.';

  @override
  String get parentGateConfirmPinPrompt => 'Confirm the PIN code.';

  @override
  String get parentGatePinHint => 'PIN code';

  @override
  String get parentGateSubmit => 'Confirm';

  @override
  String get parentGateErrorWrongPin => 'Incorrect PIN code.';

  @override
  String get parentGateErrorInvalidFormat => 'The code must have 4 digits.';

  @override
  String get parentGateErrorMismatch => 'The two codes don\'t match.';

  @override
  String get parentDashboardTitle => 'Parent space';

  @override
  String get parentDashboardUsageTitle => 'Usage time (last 7 days)';

  @override
  String parentDashboardTodayMinutes(int minutes) {
    return 'Today: $minutes min';
  }

  @override
  String get parentDashboardLimitTitle => 'Daily limit';

  @override
  String get parentDashboardLimitNone => 'No limit set';

  @override
  String parentDashboardLimitSet(int minutes) {
    return '$minutes minutes per day';
  }

  @override
  String get parentDashboardLimitEdit => 'Edit the limit';

  @override
  String get parentDashboardLimitDialogTitle => 'Daily limit (minutes)';

  @override
  String get parentDashboardLimitDialogHint => 'E.g.: 30';

  @override
  String get parentDashboardLimitRemove => 'Remove the limit';

  @override
  String get parentDashboardLessonsTitle => 'Lessons completed';

  @override
  String parentDashboardLessonsCount(int count) {
    return '$count lessons completed in total';
  }

  @override
  String get parentDashboardBadgesTitle => 'Badges earned';

  @override
  String parentDashboardBadgesCount(int unlocked, int total) {
    return '$unlocked badges unlocked out of $total';
  }

  @override
  String get parentDashboardLeaderboardToggle => 'Public leaderboard';

  @override
  String get parentDashboardLeaderboardOn =>
      'Your child appears on the public leaderboard with their nickname.';

  @override
  String get parentDashboardLeaderboardOff =>
      'Your child doesn\'t appear on the public leaderboard.';

  @override
  String get parentDashboardChangePin => 'Change the PIN code';

  @override
  String get screenTimeLimitTitle => 'Well-deserved break!';

  @override
  String get screenTimeLimitMessage =>
      'You\'ve reached your screen time for today. See you tomorrow to code again!';

  @override
  String get screenTimeLimitParentAction => 'I\'m a parent, unlock more time';

  @override
  String get homeSeeAllPaths => 'See all paths';

  @override
  String get pathsTitle => 'My paths';

  @override
  String get pathsSubtitle =>
      'Choose one or more paths to follow at the same time.';

  @override
  String get pathsActiveLabel => 'Active';

  @override
  String get pathsActivateCta => 'Start this path';

  @override
  String get pathsOpenCta => 'Open the roadmap';

  @override
  String roadmapModuleLockedMessage(String titles) {
    return 'Finish first: $titles';
  }

  @override
  String get roadmapViewCertificate => 'See my certificate 🎓';

  @override
  String lessonIntroDuration(int minutes) {
    return 'About $minutes min';
  }

  @override
  String get lessonIntroOutlineTitle => 'What you\'ll learn';

  @override
  String get lessonIntroStart => 'Start';

  @override
  String get lessonIntroResume => 'Continue';

  @override
  String get lessonIntroReread => 'Review this lesson';

  @override
  String lessonStepProgress(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get lessonPrevious => 'Previous';

  @override
  String get lessonNext => 'Next';

  @override
  String get lessonRecapTitle => 'Recap';

  @override
  String get lessonStartQuiz => 'Take the quiz';

  @override
  String get lessonSkipQuizAlreadyDone => 'Back to the roadmap';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Question $current/$total';
  }

  @override
  String get quizNext => 'Next';

  @override
  String get quizFinish => 'Finish';

  @override
  String get quizReviewLesson => 'Review the lesson';

  @override
  String get lessonCompletedTitle => 'Well done!';

  @override
  String lessonCompletedMessage(int score, int total) {
    return 'You finished this lesson with $score/$total correct answers.';
  }

  @override
  String get lessonCompletedBackToRoadmap => 'Back to the roadmap';

  @override
  String get lessonTryPracticalExercise => 'Try it hands-on';

  @override
  String get homeSeeLessonCatalog => 'Explore the lesson catalog';

  @override
  String get lessonCatalogTitle => 'Lesson catalog';

  @override
  String get lessonCatalogFilterAll => 'All';

  @override
  String get homeOpenPlayground => 'Open the code playground';

  @override
  String get playgroundTitle => 'Code playground';

  @override
  String get playgroundRun => 'Run';

  @override
  String get playgroundConsolePlaceholder =>
      'Press Run to see the result here.';

  @override
  String get playgroundConsoleNoOutput =>
      'Your code doesn\'t show anything yet. Try adding a print or a console.log!';

  @override
  String get playgroundErrorGenericType => 'Error';

  @override
  String playgroundErrorAtLine(int line, String type, String message) {
    return 'Line $line: $type — $message';
  }

  @override
  String get playgroundOpenAssistant => 'Ask the assistant';

  @override
  String get playgroundShareSnippet => 'Share with a friend';

  @override
  String playgroundShareMessage(String id) {
    return 'Check out my LearningKids code! Enter this code in the app: $id';
  }

  @override
  String get playgroundShareFailed =>
      'We couldn\'t share the code right now. Please try again in a moment.';

  @override
  String get playgroundViewSharedSnippet => 'View a shared code';

  @override
  String get playgroundSnippetCodeHint => 'Snippet code';

  @override
  String get sharedSnippetTitle => 'Shared code';

  @override
  String get sharedSnippetNotFound => 'This shared code couldn\'t be found.';

  @override
  String sharedSnippetBy(String pseudo, String language) {
    return 'Code by $pseudo · $language';
  }

  @override
  String get assistantTitle => 'AI Assistant';

  @override
  String get assistantActionExplain => 'Explain this code';

  @override
  String get assistantActionFindBug => 'Find the bug';

  @override
  String get assistantActionImprove => 'Improve my code';

  @override
  String get assistantEmptyState =>
      'Pick an action above or ask a question about your code!';

  @override
  String get assistantInputHint => 'Type your question here…';

  @override
  String get assistantSend => 'Send';

  @override
  String get assistantSuggestionLabel => 'Suggested code:';

  @override
  String get assistantAccept => 'Apply';

  @override
  String get assistantReject => 'Dismiss';

  @override
  String get assistantErrorGeneric =>
      'The assistant couldn\'t answer, try again in a moment.';

  @override
  String get homeOpenProjects => 'My projects';

  @override
  String get myProjectsTitle => 'My projects';

  @override
  String get myProjectsNewProject => 'New project';

  @override
  String get myProjectsEmpty =>
      'You don\'t have any projects yet. Create one from a guided template!';

  @override
  String get myProjectsPublishedBadge => 'published';

  @override
  String get projectTemplatesTitle => 'Project templates';

  @override
  String get projectEditorTitle => 'My project';

  @override
  String get projectRenameTitle => 'Rename project';

  @override
  String get projectCategoryPickerTitle => 'Choose a category';

  @override
  String get projectDeleteConfirmTitle =>
      'Delete this project? This action is permanent.';

  @override
  String get projectDeleteConfirm => 'Delete';

  @override
  String get projectFeedbackAction => 'AI feedback';

  @override
  String get projectFeedbackTitle => 'Assistant feedback';

  @override
  String get projectFeedbackEmpty => 'The assistant is analyzing your project…';

  @override
  String get projectPublish => 'Publish to my portfolio';

  @override
  String get projectUnpublish => 'Remove from portfolio';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get portfolioEmpty => 'No projects published yet.';

  @override
  String get portfolioPublicToggle => 'Public portfolio';

  @override
  String get portfolioPublicOn =>
      'Anyone with your code can see your portfolio.';

  @override
  String get portfolioPublicOff =>
      'Your portfolio is private: no one can see it.';

  @override
  String get portfolioShare => 'Share my code';

  @override
  String portfolioShareMessage(String uid) {
    return 'Check out my LearningKids portfolio! Enter this code in the app: $uid';
  }

  @override
  String get portfolioViewFriend => 'View a friend\'s portfolio';

  @override
  String get portfolioFriendCodeHint => 'Your friend\'s code';

  @override
  String get portfolioReportTitle => 'Report this project';

  @override
  String get portfolioReportReasonHint => 'Explain the issue in a few words';

  @override
  String get portfolioReportSubmit => 'Send';

  @override
  String get portfolioReportSent => 'Report sent, thanks for letting us know.';

  @override
  String get homeOpenBadges => 'See my badges';

  @override
  String get homeOpenLeaderboard => 'See the leaderboard';

  @override
  String get homeOpenChallenge => 'Weekly challenge';

  @override
  String streakDaysCount(int days) {
    return '🔥 $days days in a row';
  }

  @override
  String get streakAtRiskWarning =>
      'Your streak is at risk! Learn something today to keep it.';

  @override
  String levelLabel(int level, int xpIntoLevel, int xpPerLevel) {
    return 'Level $level · $xpIntoLevel/$xpPerLevel XP';
  }

  @override
  String get badgesTitle => 'My badges';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String get leaderboardEmpty => 'No one has a score yet. Be the first!';

  @override
  String get challengeTitle => 'Weekly challenge';

  @override
  String get challengeMarkCompleted => 'I completed the challenge!';

  @override
  String get challengeCompleted => 'Challenge completed this week ✅';

  @override
  String get challengeLeaderboardTitle => 'Who completed the challenge?';

  @override
  String get challengeLeaderboardEmpty =>
      'No one has completed the challenge yet this week. Be the first!';

  @override
  String get gitSimulatorTitle => 'Git simulator';

  @override
  String get gitSimulatorTryAgain =>
      'That\'s not the right command, try again!';

  @override
  String get gitSimulatorFinished =>
      'Well done, you finished the Git scenario!';

  @override
  String get gitSimulatorRestart => 'Restart';

  @override
  String get certificateTitle => 'My certificate';

  @override
  String get certificateHeading => 'Certificate of completion';

  @override
  String certificateBody(String pathTitle) {
    return 'successfully completed the « $pathTitle » path.';
  }

  @override
  String get certificateShare => 'Share my certificate';

  @override
  String get homeOpenDashboard => 'My dashboard';

  @override
  String get dashboardTitle => 'My progress';

  @override
  String dashboardLessonsCompleted(int count) {
    return '$count lessons completed';
  }

  @override
  String get dashboardWeeklySummaryTitle => 'This week';

  @override
  String dashboardWeeklySummaryBody(int lessons, int xp, int projects) {
    return '$lessons lessons completed, $xp XP earned and $projects projects published.';
  }

  @override
  String get dashboardGoalTitle => 'Your goal';

  @override
  String get dashboardPathsTitle => 'Your paths';

  @override
  String dashboardModulesCount(int completed, int total) {
    return '$completed/$total modules';
  }

  @override
  String get dashboardSkillsTitle => 'Your skills';

  @override
  String get dashboardWeakModulesTitle => 'Topics to revisit';

  @override
  String get dashboardWeakModulesSubtitle =>
      'These lessons had a somewhat low quiz score — a quick refresher won\'t hurt!';

  @override
  String dashboardWeakModuleScore(int correct, int total) {
    return 'Score: $correct/$total';
  }

  @override
  String get dashboardReview => 'Review';

  @override
  String get dashboardUsageTitle => 'Learning time (last 7 days)';

  @override
  String get notificationSettingsTitle => 'Notifications';

  @override
  String get notificationSettingsDailyReminder => 'Daily reminder';

  @override
  String get notificationSettingsDailyReminderSubtitle =>
      'A notification to remind you to practice and keep your streak.';

  @override
  String notificationSettingsChangeTime(String time) {
    return 'Change the time ($time)';
  }

  @override
  String get notificationSettingsRewards => 'Reward notifications';

  @override
  String get notificationSettingsRewardsSubtitle =>
      'A notification when you unlock a badge, a certificate or a level.';

  @override
  String get notificationSettingsPermissionDenied =>
      'Notifications are disabled for LearningKids in your device settings.';

  @override
  String get accountSuspendedTitle => 'Account suspended';

  @override
  String get accountSuspendedMessage =>
      'Your account has been temporarily suspended. Contact support if you think this is a mistake.';

  @override
  String get adminHomeTitle => 'Back office';

  @override
  String get adminModerationQueueTitle => 'Moderation queue';

  @override
  String get adminModerationQueueEmpty => 'No pending reports.';

  @override
  String adminModerationQueueReason(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get adminModerationApprove => 'Approve';

  @override
  String get adminModerationReject => 'Reject';

  @override
  String get adminAccountsTitle => 'Accounts';

  @override
  String get adminAccountsEmpty => 'No accounts yet.';

  @override
  String get adminAccountsSuspended => 'Suspended';

  @override
  String get adminAccountsSupportNotes => 'Support note';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageSettingsSystem => 'Follow device';

  @override
  String get languageSettingsFrench => 'Français';

  @override
  String get languageSettingsEnglish => 'English';

  @override
  String get accessibilitySettingsTitle => 'Accessibility';

  @override
  String get accessibilityTextSizeTitle => 'Text size';

  @override
  String get accessibilityTextSizeSmall => 'Small';

  @override
  String get accessibilityTextSizeNormal => 'Normal';

  @override
  String get accessibilityTextSizeLarge => 'Large';

  @override
  String get accessibilityTextSizeExtraLarge => 'Extra large';

  @override
  String get accessibilityReadAloudStart => 'Read aloud';

  @override
  String get accessibilityReadAloudStop => 'Stop reading';
}
