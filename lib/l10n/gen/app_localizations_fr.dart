// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'LearningKids';

  @override
  String get welcomeTaglineLead => 'Enfin, coder devient';

  @override
  String get welcomeTaglineHighlight => 'VRAIMENT amusant';

  @override
  String get welcomeCta => 'Commencer';

  @override
  String get commonOr => 'ou';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSomethingWentWrong => 'Un souci est survenu. Réessaie.';

  @override
  String get commonNoInternet => 'Vérifie ta connexion internet et réessaie.';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get onboardingErrorNetwork =>
      'La connexion a été coupée. Vérifie ton internet puis réessaie.';

  @override
  String get onboardingErrorGeneric =>
      'La sauvegarde a échoué. Réessaie dans un instant.';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithApple => 'Continuer avec Apple';

  @override
  String get signUpTitle => 'Inscription';

  @override
  String get signUpEmailLabel => 'Adresse e-mail';

  @override
  String get signUpPasswordLabel => 'Mot de passe';

  @override
  String get signUpConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get signUpSubmit => 'Créer mon compte';

  @override
  String get signUpAlreadyHaveAccount => 'Tu as déjà un compte ?';

  @override
  String get signUpLoginLink => 'Se connecter';

  @override
  String get signUpErrorEmailInUse => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get signUpErrorInvalidEmail =>
      'Cette adresse e-mail n\'est pas valide.';

  @override
  String get signUpErrorWeakPassword =>
      'Choisis un mot de passe d\'au moins 6 caractères.';

  @override
  String get signUpErrorPasswordMismatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginEmailLabel => 'Adresse e-mail';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginSubmit => 'Se connecter';

  @override
  String get loginForgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginNoAccount => 'Pas encore de compte ?';

  @override
  String get loginSignUpLink => 'S\'inscrire';

  @override
  String get loginErrorInvalidCredentials =>
      'E-mail ou mot de passe incorrect.';

  @override
  String get loginErrorTooManyRequests =>
      'Trop de tentatives. Réessaie dans quelques minutes.';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordSubtitle =>
      'Entre ton e-mail, on t\'envoie un lien pour le réinitialiser.';

  @override
  String get forgotPasswordEmailLabel => 'Adresse e-mail';

  @override
  String get forgotPasswordSubmit => 'Envoyer le lien';

  @override
  String get forgotPasswordBackToLogin => 'Retour à la connexion';

  @override
  String get forgotPasswordSuccess =>
      'E-mail envoyé ! Vérifie ta boîte de réception.';

  @override
  String get onboardingConsentMessage =>
      'Avant de commencer, un mot pour le parent ou le tuteur qui accompagne cette inscription !';

  @override
  String get onboardingConsentBody =>
      'LearningKids conserve uniquement le prénom, la tranche d\'âge, les objectifs d\'apprentissage et le temps d\'utilisation quotidien (pour le contrôle parental). Aucune publicité, aucune revente de données. Le compte et toutes ses données peuvent être supprimés à tout moment depuis le profil.';

  @override
  String get onboardingConsentAccept =>
      'J\'accepte, je suis le parent ou le tuteur';

  @override
  String get onboardingMascotName => 'Byte';

  @override
  String get onboardingAskName =>
      'Salut ! Moi c\'est Byte, ton copain de code.\nComment tu t\'appelles ?';

  @override
  String get onboardingNameHint => 'Ton prénom';

  @override
  String onboardingAskAge(String name) {
    return 'Ravi de te rencontrer, $name !\nQuel âge as-tu ?';
  }

  @override
  String get onboardingAge4to6 => '4-6 ans';

  @override
  String get onboardingAge7to9 => '7-9 ans';

  @override
  String get onboardingAge10to12 => '10-12 ans';

  @override
  String get onboardingAge13plus => '13 ans et +';

  @override
  String get onboardingLevelTitle => 'As-tu déjà essayé de coder ?';

  @override
  String get onboardingLevelBeginner => 'Jamais, je débute';

  @override
  String get onboardingLevelSomeBasics => 'Un peu, je connais les bases';

  @override
  String get onboardingLevelComfortable => 'Oui, je code déjà des projets';

  @override
  String get onboardingGoalsTitle => 'Que veux-tu créer avec le code ?';

  @override
  String get onboardingGoalsSubtitle => 'Tu peux choisir plusieurs réponses.';

  @override
  String get onboardingGoalWebsite => 'Un site web';

  @override
  String get onboardingGoalGame => 'Un jeu vidéo';

  @override
  String get onboardingGoalApp => 'Une application mobile';

  @override
  String get onboardingGoalAi => 'Comprendre l\'intelligence artificielle';

  @override
  String get onboardingGoalsSubmit => 'C\'est parti !';

  @override
  String get onboardingGoalsErrorEmpty =>
      'Choisis au moins un objectif pour continuer.';

  @override
  String get onboardingLoadingMessage =>
      'Je prépare ton programme personnalisé...';

  @override
  String homeGreeting(String name) {
    return 'Salut, $name !';
  }

  @override
  String get homeRecommendedPathLabel => 'Ton parcours recommandé';

  @override
  String get homeProfileTooltip => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEditProfile => 'Modifier le profil';

  @override
  String get profileAccountSettings => 'Paramètres du compte';

  @override
  String get profileNotificationSettings => 'Notifications';

  @override
  String get profileLanguageSettings => 'Langue';

  @override
  String get profileAccessibilitySettings => 'Accessibilité';

  @override
  String get profileParentSpace => 'Espace parent';

  @override
  String get profileLogOut => 'Se déconnecter';

  @override
  String get profileDeleteAccount => 'Supprimer mon compte';

  @override
  String get profileDeleteConfirmTitle => 'Supprimer ton compte ?';

  @override
  String get profileDeleteConfirmBody =>
      'Cette action est définitive. Toutes tes données seront supprimées.';

  @override
  String get profileDeleteConfirmCta => 'Oui, supprimer';

  @override
  String get profileDeleteReauthRequired =>
      'Reconnecte-toi pour confirmer la suppression de ton compte.';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get editProfilePseudoLabel => 'Pseudo';

  @override
  String get editProfileChooseAvatar => 'Choisis ton avatar';

  @override
  String get editProfileSaved => 'Profil mis à jour !';

  @override
  String get editProfileErrorEmpty => 'Ton pseudo ne peut pas être vide.';

  @override
  String get parentGateTitle => 'Espace parent';

  @override
  String get parentGateGrantExtraTitle => 'Débloquer plus de temps';

  @override
  String get parentGateEnterPinPrompt =>
      'Un parent est présent ? Entre le code PIN pour continuer.';

  @override
  String get parentGateCreatePinPrompt =>
      'Crée un code PIN à 4 chiffres pour protéger l\'Espace parent.';

  @override
  String get parentGateConfirmPinPrompt => 'Confirme le code PIN.';

  @override
  String get parentGatePinHint => 'Code PIN';

  @override
  String get parentGateSubmit => 'Valider';

  @override
  String get parentGateErrorWrongPin => 'Code PIN incorrect.';

  @override
  String get parentGateErrorInvalidFormat =>
      'Le code doit contenir 4 chiffres.';

  @override
  String get parentGateErrorMismatch => 'Les deux codes ne correspondent pas.';

  @override
  String get parentDashboardTitle => 'Espace parent';

  @override
  String get parentDashboardUsageTitle =>
      'Temps d\'utilisation (7 derniers jours)';

  @override
  String parentDashboardTodayMinutes(int minutes) {
    return 'Aujourd\'hui : $minutes min';
  }

  @override
  String get parentDashboardLimitTitle => 'Limite quotidienne';

  @override
  String get parentDashboardLimitNone => 'Aucune limite définie';

  @override
  String parentDashboardLimitSet(int minutes) {
    return '$minutes minutes par jour';
  }

  @override
  String get parentDashboardLimitEdit => 'Modifier la limite';

  @override
  String get parentDashboardLimitDialogTitle => 'Limite quotidienne (minutes)';

  @override
  String get parentDashboardLimitDialogHint => 'Ex : 30';

  @override
  String get parentDashboardLimitRemove => 'Retirer la limite';

  @override
  String get parentDashboardLessonsTitle => 'Leçons terminées';

  @override
  String parentDashboardLessonsCount(int count) {
    return '$count leçons terminées au total';
  }

  @override
  String get parentDashboardBadgesTitle => 'Badges obtenus';

  @override
  String parentDashboardBadgesCount(int unlocked, int total) {
    return '$unlocked badges débloqués sur $total';
  }

  @override
  String get parentDashboardLeaderboardToggle => 'Classement public';

  @override
  String get parentDashboardLeaderboardOn =>
      'Ton enfant apparaît dans le classement public avec son pseudo.';

  @override
  String get parentDashboardLeaderboardOff =>
      'Ton enfant n\'apparaît pas dans le classement public.';

  @override
  String get parentDashboardChangePin => 'Changer le code PIN';

  @override
  String get screenTimeLimitTitle => 'Pause bien méritée !';

  @override
  String get screenTimeLimitMessage =>
      'Tu as atteint ton temps d\'écran pour aujourd\'hui. On se retrouve demain pour coder à nouveau !';

  @override
  String get screenTimeLimitParentAction =>
      'Je suis un parent, débloquer du temps';

  @override
  String get homeSeeAllPaths => 'Voir tous les parcours';

  @override
  String get pathsTitle => 'Mes parcours';

  @override
  String get pathsSubtitle =>
      'Choisis un ou plusieurs parcours à suivre en parallèle.';

  @override
  String get pathsActiveLabel => 'Actif';

  @override
  String get pathsActivateCta => 'Commencer ce parcours';

  @override
  String get pathsOpenCta => 'Ouvrir la roadmap';

  @override
  String roadmapModuleLockedMessage(String titles) {
    return 'Termine d\'abord : $titles';
  }

  @override
  String get roadmapViewCertificate => 'Voir mon certificat 🎓';

  @override
  String lessonIntroDuration(int minutes) {
    return 'Environ $minutes min';
  }

  @override
  String get lessonIntroOutlineTitle => 'Ce que tu vas apprendre';

  @override
  String get lessonIntroStart => 'Commencer';

  @override
  String get lessonIntroResume => 'Continuer';

  @override
  String get lessonIntroReread => 'Revoir cette leçon';

  @override
  String lessonStepProgress(int current, int total) {
    return 'Étape $current/$total';
  }

  @override
  String get lessonPrevious => 'Précédent';

  @override
  String get lessonNext => 'Suivant';

  @override
  String get lessonRecapTitle => 'Résumé';

  @override
  String get lessonStartQuiz => 'Faire le quiz';

  @override
  String get lessonSkipQuizAlreadyDone => 'Retour à la roadmap';

  @override
  String quizQuestionProgress(int current, int total) {
    return 'Question $current/$total';
  }

  @override
  String get quizNext => 'Suivant';

  @override
  String get quizFinish => 'Terminer';

  @override
  String get quizReviewLesson => 'Revoir la leçon';

  @override
  String get lessonCompletedTitle => 'Bravo !';

  @override
  String lessonCompletedMessage(int score, int total) {
    return 'Tu as terminé cette leçon avec $score/$total bonnes réponses.';
  }

  @override
  String get lessonCompletedBackToRoadmap => 'Retour à la roadmap';

  @override
  String get lessonTryPracticalExercise => 'Essayer en pratique';

  @override
  String get homeSeeLessonCatalog => 'Explorer le catalogue de leçons';

  @override
  String get lessonCatalogTitle => 'Catalogue de leçons';

  @override
  String get lessonCatalogFilterAll => 'Tout';

  @override
  String get homeOpenPlayground => 'Ouvrir l\'espace de code';

  @override
  String get playgroundTitle => 'Espace de code';

  @override
  String get playgroundRun => 'Exécuter';

  @override
  String get playgroundConsolePlaceholder =>
      'Appuie sur Exécuter pour voir le résultat ici.';

  @override
  String get playgroundConsoleNoOutput =>
      'Ton code ne montre rien pour l\'instant. Essaie d\'ajouter un print ou un console.log !';

  @override
  String get playgroundErrorGenericType => 'Erreur';

  @override
  String playgroundErrorAtLine(int line, String type, String message) {
    return 'Ligne $line : $type — $message';
  }

  @override
  String get playgroundOpenAssistant => 'Demander à l\'assistant';

  @override
  String get playgroundShareSnippet => 'Partager avec un ami';

  @override
  String playgroundShareMessage(String id) {
    return 'Regarde mon code LearningKids ! Entre ce code dans l\'app : $id';
  }

  @override
  String get playgroundShareFailed =>
      'Impossible de partager le code pour le moment. Réessaie dans un instant.';

  @override
  String get playgroundViewSharedSnippet => 'Voir un code partagé';

  @override
  String get playgroundSnippetCodeHint => 'Code du snippet';

  @override
  String get sharedSnippetTitle => 'Code partagé';

  @override
  String get sharedSnippetNotFound => 'Ce code partagé est introuvable.';

  @override
  String sharedSnippetBy(String pseudo, String language) {
    return 'Code de $pseudo · $language';
  }

  @override
  String get assistantTitle => 'Assistant IA';

  @override
  String get assistantActionExplain => 'Expliquer ce code';

  @override
  String get assistantActionFindBug => 'Trouver l\'erreur';

  @override
  String get assistantActionImprove => 'Améliorer mon code';

  @override
  String get assistantEmptyState =>
      'Choisis une action ci-dessus ou pose une question sur ton code !';

  @override
  String get assistantInputHint => 'Pose ta question ici…';

  @override
  String get assistantSend => 'Envoyer';

  @override
  String get assistantSuggestionLabel => 'Code proposé :';

  @override
  String get assistantAccept => 'Appliquer';

  @override
  String get assistantReject => 'Ignorer';

  @override
  String get assistantErrorGeneric =>
      'L\'assistant n\'a pas pu répondre, réessaie dans un instant.';

  @override
  String get homeOpenProjects => 'Mes projets';

  @override
  String get myProjectsTitle => 'Mes projets';

  @override
  String get myProjectsNewProject => 'Nouveau projet';

  @override
  String get myProjectsEmpty =>
      'Tu n\'as pas encore de projet. Crée-en un à partir d\'un modèle guidé !';

  @override
  String get myProjectsPublishedBadge => 'publié';

  @override
  String get projectTemplatesTitle => 'Modèles de projets';

  @override
  String get projectEditorTitle => 'Mon projet';

  @override
  String get projectRenameTitle => 'Renommer le projet';

  @override
  String get projectCategoryPickerTitle => 'Choisir une catégorie';

  @override
  String get projectDeleteConfirmTitle =>
      'Supprimer ce projet ? Cette action est définitive.';

  @override
  String get projectDeleteConfirm => 'Supprimer';

  @override
  String get projectFeedbackAction => 'Avis de l\'IA';

  @override
  String get projectFeedbackTitle => 'Avis de l\'assistant IA';

  @override
  String get projectFeedbackEmpty => 'L\'assistant analyse ton projet…';

  @override
  String get projectPublish => 'Publier dans mon portfolio';

  @override
  String get projectUnpublish => 'Retirer du portfolio';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get portfolioEmpty => 'Aucun projet publié pour l\'instant.';

  @override
  String get portfolioPublicToggle => 'Portfolio public';

  @override
  String get portfolioPublicOn =>
      'N\'importe qui avec ton code peut voir ton portfolio.';

  @override
  String get portfolioPublicOff =>
      'Ton portfolio est privé : personne ne peut le voir.';

  @override
  String get portfolioShare => 'Partager mon code';

  @override
  String portfolioShareMessage(String uid) {
    return 'Regarde mon portfolio LearningKids ! Entre ce code dans l\'app : $uid';
  }

  @override
  String get portfolioViewFriend => 'Voir le portfolio d\'un ami';

  @override
  String get portfolioFriendCodeHint => 'Code de ton ami';

  @override
  String get portfolioReportTitle => 'Signaler ce projet';

  @override
  String get portfolioReportReasonHint =>
      'Explique en quelques mots le problème';

  @override
  String get portfolioReportSubmit => 'Envoyer';

  @override
  String get portfolioReportSent =>
      'Signalement envoyé, merci de nous avoir prévenus.';

  @override
  String get homeOpenBadges => 'Voir mes badges';

  @override
  String get homeOpenLeaderboard => 'Voir le classement';

  @override
  String get homeOpenChallenge => 'Défi de la semaine';

  @override
  String streakDaysCount(int days) {
    return '🔥 $days jours de suite';
  }

  @override
  String get streakAtRiskWarning =>
      'Ton streak est en danger ! Apprends aujourd\'hui pour le garder.';

  @override
  String levelLabel(int level, int xpIntoLevel, int xpPerLevel) {
    return 'Niveau $level · $xpIntoLevel/$xpPerLevel XP';
  }

  @override
  String get badgesTitle => 'Mes badges';

  @override
  String get leaderboardTitle => 'Classement';

  @override
  String get leaderboardEmpty =>
      'Personne n\'a encore de score. Sois le·la premier·ère !';

  @override
  String get challengeTitle => 'Défi de la semaine';

  @override
  String get challengeMarkCompleted => 'J\'ai relevé le défi !';

  @override
  String get challengeCompleted => 'Défi relevé cette semaine ✅';

  @override
  String get challengeLeaderboardTitle => 'Qui a relevé le défi ?';

  @override
  String get challengeLeaderboardEmpty =>
      'Personne n\'a encore relevé le défi cette semaine. Sois le·la premier·ère !';

  @override
  String get gitSimulatorTitle => 'Simulateur Git';

  @override
  String get gitSimulatorTryAgain =>
      'Ce n\'est pas la bonne commande, essaie encore !';

  @override
  String get gitSimulatorFinished => 'Bravo, tu as terminé le scénario Git !';

  @override
  String get gitSimulatorRestart => 'Recommencer';

  @override
  String get certificateTitle => 'Mon certificat';

  @override
  String get certificateHeading => 'Certificat de réussite';

  @override
  String certificateBody(String pathTitle) {
    return 'a terminé avec succès le parcours « $pathTitle ».';
  }

  @override
  String get certificateShare => 'Partager mon certificat';

  @override
  String get homeOpenDashboard => 'Mon tableau de bord';

  @override
  String get dashboardTitle => 'Ma progression';

  @override
  String dashboardLessonsCompleted(int count) {
    return '$count leçons terminées';
  }

  @override
  String get dashboardWeeklySummaryTitle => 'Cette semaine';

  @override
  String dashboardWeeklySummaryBody(int lessons, int xp, int projects) {
    return '$lessons leçons terminées, $xp XP gagnés et $projects projets publiés.';
  }

  @override
  String get dashboardGoalTitle => 'Ton objectif';

  @override
  String get dashboardPathsTitle => 'Tes parcours';

  @override
  String dashboardModulesCount(int completed, int total) {
    return '$completed/$total modules';
  }

  @override
  String get dashboardSkillsTitle => 'Tes compétences';

  @override
  String get dashboardWeakModulesTitle => 'Notions à retravailler';

  @override
  String get dashboardWeakModulesSubtitle =>
      'Ces leçons ont eu un score de quiz un peu faible — un petit rappel ne fera pas de mal !';

  @override
  String dashboardWeakModuleScore(int correct, int total) {
    return 'Score : $correct/$total';
  }

  @override
  String get dashboardReview => 'Revoir';

  @override
  String get dashboardUsageTitle => 'Temps d\'apprentissage (7 derniers jours)';

  @override
  String get notificationSettingsTitle => 'Notifications';

  @override
  String get notificationSettingsDailyReminder => 'Rappel quotidien';

  @override
  String get notificationSettingsDailyReminderSubtitle =>
      'Une notification pour penser à t\'entraîner et garder ton streak.';

  @override
  String notificationSettingsChangeTime(String time) {
    return 'Changer l\'heure ($time)';
  }

  @override
  String get notificationSettingsRewards => 'Notifications de récompenses';

  @override
  String get notificationSettingsRewardsSubtitle =>
      'Une notification quand tu débloques un badge, un certificat ou un niveau.';

  @override
  String get notificationSettingsPermissionDenied =>
      'Les notifications sont désactivées pour LearningKids dans les réglages de ton appareil.';

  @override
  String get accountSuspendedTitle => 'Compte suspendu';

  @override
  String get accountSuspendedMessage =>
      'Ton compte a été temporairement suspendu. Contacte le support si tu penses que c\'est une erreur.';

  @override
  String get adminHomeTitle => 'Back-office';

  @override
  String get adminModerationQueueTitle => 'File de modération';

  @override
  String get adminModerationQueueEmpty => 'Aucun signalement en attente.';

  @override
  String adminModerationQueueReason(String reason) {
    return 'Motif : $reason';
  }

  @override
  String get adminModerationApprove => 'Accepter';

  @override
  String get adminModerationReject => 'Rejeter';

  @override
  String get adminAccountsTitle => 'Comptes';

  @override
  String get adminAccountsEmpty => 'Aucun compte pour l\'instant.';

  @override
  String get adminAccountsSuspended => 'Suspendu';

  @override
  String get adminAccountsSupportNotes => 'Note de support';

  @override
  String get languageSettingsTitle => 'Langue';

  @override
  String get languageSettingsSystem => 'Suivre l\'appareil';

  @override
  String get languageSettingsFrench => 'Français';

  @override
  String get languageSettingsEnglish => 'English';

  @override
  String get accessibilitySettingsTitle => 'Accessibilité';

  @override
  String get accessibilityTextSizeTitle => 'Taille du texte';

  @override
  String get accessibilityTextSizeSmall => 'Petite';

  @override
  String get accessibilityTextSizeNormal => 'Normale';

  @override
  String get accessibilityTextSizeLarge => 'Grande';

  @override
  String get accessibilityTextSizeExtraLarge => 'Très grande';

  @override
  String get accessibilityReadAloudStart => 'Lire à voix haute';

  @override
  String get accessibilityReadAloudStop => 'Arrêter la lecture';
}
