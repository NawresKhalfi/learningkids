import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'LearningKids'**
  String get appName;

  /// No description provided for @welcomeTaglineLead.
  ///
  /// In fr, this message translates to:
  /// **'Enfin, coder devient'**
  String get welcomeTaglineLead;

  /// No description provided for @welcomeTaglineHighlight.
  ///
  /// In fr, this message translates to:
  /// **'VRAIMENT amusant'**
  String get welcomeTaglineHighlight;

  /// No description provided for @welcomeCta.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get welcomeCta;

  /// No description provided for @commonOr.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get commonOr;

  /// No description provided for @commonContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// No description provided for @commonSomethingWentWrong.
  ///
  /// In fr, this message translates to:
  /// **'Un souci est survenu. Réessaie.'**
  String get commonSomethingWentWrong;

  /// No description provided for @commonNoInternet.
  ///
  /// In fr, this message translates to:
  /// **'Vérifie ta connexion internet et réessaie.'**
  String get commonNoInternet;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @onboardingErrorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'La connexion a été coupée. Vérifie ton internet puis réessaie.'**
  String get onboardingErrorNetwork;

  /// No description provided for @onboardingErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde a échoué. Réessaie dans un instant.'**
  String get onboardingErrorGeneric;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authContinueWithGoogle;

  /// No description provided for @signUpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signUpTitle;

  /// No description provided for @signUpEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get signUpEmailLabel;

  /// No description provided for @signUpPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get signUpPasswordLabel;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @signUpSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get signUpSubmit;

  /// No description provided for @signUpAlreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Tu as déjà un compte ?'**
  String get signUpAlreadyHaveAccount;

  /// No description provided for @signUpLoginLink.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signUpLoginLink;

  /// No description provided for @signUpErrorEmailInUse.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet e-mail.'**
  String get signUpErrorEmailInUse;

  /// No description provided for @signUpErrorInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Cette adresse e-mail n\'est pas valide.'**
  String get signUpErrorInvalidEmail;

  /// No description provided for @signUpErrorWeakPassword.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un mot de passe d\'au moins 6 caractères.'**
  String get signUpErrorWeakPassword;

  /// No description provided for @signUpErrorPasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get signUpErrorPasswordMismatch;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get loginPasswordLabel;

  /// No description provided for @loginSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginSubmit;

  /// No description provided for @loginForgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUpLink.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get loginSignUpLink;

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @loginErrorTooManyRequests.
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessaie dans quelques minutes.'**
  String get loginErrorTooManyRequests;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entre ton e-mail, on t\'envoie un lien pour le réinitialiser.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordBackToLogin.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la connexion'**
  String get forgotPasswordBackToLogin;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In fr, this message translates to:
  /// **'E-mail envoyé ! Vérifie ta boîte de réception.'**
  String get forgotPasswordSuccess;

  /// No description provided for @onboardingConsentMessage.
  ///
  /// In fr, this message translates to:
  /// **'Avant de commencer, un mot pour le parent ou le tuteur qui accompagne cette inscription !'**
  String get onboardingConsentMessage;

  /// No description provided for @onboardingConsentBody.
  ///
  /// In fr, this message translates to:
  /// **'LearningKids conserve uniquement le prénom, les objectifs d\'apprentissage et le temps d\'utilisation quotidien (pour le contrôle parental). Aucune publicité, aucune revente de données. Le compte et toutes ses données peuvent être supprimés à tout moment depuis le profil.'**
  String get onboardingConsentBody;

  /// No description provided for @onboardingConsentAccept.
  ///
  /// In fr, this message translates to:
  /// **'J\'accepte, je suis le parent ou le tuteur'**
  String get onboardingConsentAccept;

  /// No description provided for @onboardingMascotName.
  ///
  /// In fr, this message translates to:
  /// **'Byte'**
  String get onboardingMascotName;

  /// No description provided for @onboardingAskName.
  ///
  /// In fr, this message translates to:
  /// **'Salut ! Moi c\'est Byte, ton copain de code.\nComment tu t\'appelles ?'**
  String get onboardingAskName;

  /// No description provided for @onboardingNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ton prénom'**
  String get onboardingNameHint;

  /// No description provided for @onboardingAskAge.
  ///
  /// In fr, this message translates to:
  /// **'Ravi de te rencontrer, {name} !\nQuel âge as-tu ?'**
  String onboardingAskAge(String name);

  /// No description provided for @onboardingAge4to6.
  ///
  /// In fr, this message translates to:
  /// **'4-6 ans'**
  String get onboardingAge4to6;

  /// No description provided for @onboardingAge7to9.
  ///
  /// In fr, this message translates to:
  /// **'7-9 ans'**
  String get onboardingAge7to9;

  /// No description provided for @onboardingAge10to12.
  ///
  /// In fr, this message translates to:
  /// **'10-12 ans'**
  String get onboardingAge10to12;

  /// No description provided for @onboardingAge13plus.
  ///
  /// In fr, this message translates to:
  /// **'13 ans et +'**
  String get onboardingAge13plus;

  /// No description provided for @onboardingLevelTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton apprentissage commence ici !'**
  String get onboardingLevelTitle;

  /// No description provided for @onboardingProgramTitle.
  ///
  /// In fr, this message translates to:
  /// **'Des bases à l\'avancé'**
  String get onboardingProgramTitle;

  /// No description provided for @onboardingProgramBody.
  ///
  /// In fr, this message translates to:
  /// **'Chaque parcours commence avec les bases, puis te guide pas à pas vers des cours et des projets très avancés.'**
  String get onboardingProgramBody;

  /// No description provided for @onboardingLevelBeginner.
  ///
  /// In fr, this message translates to:
  /// **'Jamais, je débute'**
  String get onboardingLevelBeginner;

  /// No description provided for @onboardingLevelSomeBasics.
  ///
  /// In fr, this message translates to:
  /// **'Un peu, je connais les bases'**
  String get onboardingLevelSomeBasics;

  /// No description provided for @onboardingLevelComfortable.
  ///
  /// In fr, this message translates to:
  /// **'Oui, je code déjà des projets'**
  String get onboardingLevelComfortable;

  /// No description provided for @onboardingGoalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Que veux-tu créer avec le code ?'**
  String get onboardingGoalsTitle;

  /// No description provided for @onboardingGoalsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tu peux choisir plusieurs réponses.'**
  String get onboardingGoalsSubtitle;

  /// No description provided for @onboardingGoalWebsite.
  ///
  /// In fr, this message translates to:
  /// **'Un site web'**
  String get onboardingGoalWebsite;

  /// No description provided for @onboardingGoalGame.
  ///
  /// In fr, this message translates to:
  /// **'Un jeu vidéo'**
  String get onboardingGoalGame;

  /// No description provided for @onboardingGoalApp.
  ///
  /// In fr, this message translates to:
  /// **'Une application mobile'**
  String get onboardingGoalApp;

  /// No description provided for @onboardingGoalAi.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre l\'intelligence artificielle'**
  String get onboardingGoalAi;

  /// No description provided for @onboardingGoalsSubmit.
  ///
  /// In fr, this message translates to:
  /// **'C\'est parti !'**
  String get onboardingGoalsSubmit;

  /// No description provided for @onboardingGoalsErrorEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Choisis au moins un objectif pour continuer.'**
  String get onboardingGoalsErrorEmpty;

  /// No description provided for @onboardingLoadingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Je prépare ton programme personnalisé...'**
  String get onboardingLoadingMessage;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Salut, {name} !'**
  String homeGreeting(String name);

  /// No description provided for @homeRecommendedPathLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton parcours recommandé'**
  String get homeRecommendedPathLabel;

  /// No description provided for @homeProfileTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get homeProfileTooltip;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get profileEditProfile;

  /// No description provided for @profileAccountSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres du compte'**
  String get profileAccountSettings;

  /// No description provided for @profileNotificationSettings.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get profileNotificationSettings;

  /// No description provided for @profileLanguageSettings.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profileLanguageSettings;

  /// No description provided for @profileAccessibilitySettings.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité'**
  String get profileAccessibilitySettings;

  /// No description provided for @profileParentSpace.
  ///
  /// In fr, this message translates to:
  /// **'Espace parent'**
  String get profileParentSpace;

  /// No description provided for @profileLogOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get profileLogOut;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ton compte ?'**
  String get profileDeleteConfirmTitle;

  /// No description provided for @profileDeleteConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est définitive. Toutes tes données seront supprimées.'**
  String get profileDeleteConfirmBody;

  /// No description provided for @profileDeleteConfirmCta.
  ///
  /// In fr, this message translates to:
  /// **'Oui, supprimer'**
  String get profileDeleteConfirmCta;

  /// No description provided for @profileDeleteReauthRequired.
  ///
  /// In fr, this message translates to:
  /// **'Reconnecte-toi pour confirmer la suppression de ton compte.'**
  String get profileDeleteReauthRequired;

  /// No description provided for @editProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfileTitle;

  /// No description provided for @editProfilePseudoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pseudo'**
  String get editProfilePseudoLabel;

  /// No description provided for @editProfileChooseAvatar.
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton avatar'**
  String get editProfileChooseAvatar;

  /// No description provided for @editProfileSaved.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour !'**
  String get editProfileSaved;

  /// No description provided for @editProfileErrorEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ton pseudo ne peut pas être vide.'**
  String get editProfileErrorEmpty;

  /// No description provided for @parentGateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Espace parent'**
  String get parentGateTitle;

  /// No description provided for @parentGateGrantExtraTitle.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer plus de temps'**
  String get parentGateGrantExtraTitle;

  /// No description provided for @parentGateEnterPinPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Un parent est présent ? Entre le code PIN pour continuer.'**
  String get parentGateEnterPinPrompt;

  /// No description provided for @parentGateCreatePinPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Crée un code PIN à 4 chiffres pour protéger l\'Espace parent.'**
  String get parentGateCreatePinPrompt;

  /// No description provided for @parentGateConfirmPinPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Confirme le code PIN.'**
  String get parentGateConfirmPinPrompt;

  /// No description provided for @parentGatePinHint.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get parentGatePinHint;

  /// No description provided for @parentGateSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get parentGateSubmit;

  /// No description provided for @parentGateErrorWrongPin.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN incorrect.'**
  String get parentGateErrorWrongPin;

  /// No description provided for @parentGateErrorInvalidFormat.
  ///
  /// In fr, this message translates to:
  /// **'Le code doit contenir 4 chiffres.'**
  String get parentGateErrorInvalidFormat;

  /// No description provided for @parentGateErrorMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les deux codes ne correspondent pas.'**
  String get parentGateErrorMismatch;

  /// No description provided for @parentDashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Espace parent'**
  String get parentDashboardTitle;

  /// No description provided for @parentDashboardUsageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Temps d\'utilisation (7 derniers jours)'**
  String get parentDashboardUsageTitle;

  /// No description provided for @parentDashboardTodayMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui : {minutes} min'**
  String parentDashboardTodayMinutes(int minutes);

  /// No description provided for @parentDashboardLimitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Limite quotidienne'**
  String get parentDashboardLimitTitle;

  /// No description provided for @parentDashboardLimitNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune limite définie'**
  String get parentDashboardLimitNone;

  /// No description provided for @parentDashboardLimitSet.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} minutes par jour'**
  String parentDashboardLimitSet(int minutes);

  /// No description provided for @parentDashboardLimitEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la limite'**
  String get parentDashboardLimitEdit;

  /// No description provided for @parentDashboardLimitDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Limite quotidienne (minutes)'**
  String get parentDashboardLimitDialogTitle;

  /// No description provided for @parentDashboardLimitDialogHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : 30'**
  String get parentDashboardLimitDialogHint;

  /// No description provided for @parentDashboardLimitRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer la limite'**
  String get parentDashboardLimitRemove;

  /// No description provided for @parentDashboardLessonsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Leçons terminées'**
  String get parentDashboardLessonsTitle;

  /// No description provided for @parentDashboardLessonsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} leçons terminées au total'**
  String parentDashboardLessonsCount(int count);

  /// No description provided for @parentDashboardBadgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Badges obtenus'**
  String get parentDashboardBadgesTitle;

  /// No description provided for @parentDashboardBadgesCount.
  ///
  /// In fr, this message translates to:
  /// **'{unlocked} badges débloqués sur {total}'**
  String parentDashboardBadgesCount(int unlocked, int total);

  /// No description provided for @parentDashboardLeaderboardToggle.
  ///
  /// In fr, this message translates to:
  /// **'Classement public'**
  String get parentDashboardLeaderboardToggle;

  /// No description provided for @parentDashboardLeaderboardOn.
  ///
  /// In fr, this message translates to:
  /// **'Ton enfant apparaît dans le classement public avec son pseudo.'**
  String get parentDashboardLeaderboardOn;

  /// No description provided for @parentDashboardLeaderboardOff.
  ///
  /// In fr, this message translates to:
  /// **'Ton enfant n\'apparaît pas dans le classement public.'**
  String get parentDashboardLeaderboardOff;

  /// No description provided for @parentDashboardChangePin.
  ///
  /// In fr, this message translates to:
  /// **'Changer le code PIN'**
  String get parentDashboardChangePin;

  /// No description provided for @screenTimeLimitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pause bien méritée !'**
  String get screenTimeLimitTitle;

  /// No description provided for @screenTimeLimitMessage.
  ///
  /// In fr, this message translates to:
  /// **'Tu as atteint ton temps d\'écran pour aujourd\'hui. On se retrouve demain pour coder à nouveau !'**
  String get screenTimeLimitMessage;

  /// No description provided for @screenTimeLimitParentAction.
  ///
  /// In fr, this message translates to:
  /// **'Je suis un parent, débloquer du temps'**
  String get screenTimeLimitParentAction;

  /// No description provided for @homeSeeAllPaths.
  ///
  /// In fr, this message translates to:
  /// **'Voir tous les parcours'**
  String get homeSeeAllPaths;

  /// No description provided for @pathsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes parcours'**
  String get pathsTitle;

  /// No description provided for @pathsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisis un ou plusieurs parcours à suivre en parallèle.'**
  String get pathsSubtitle;

  /// No description provided for @pathsActiveLabel.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get pathsActiveLabel;

  /// No description provided for @pathsActivateCta.
  ///
  /// In fr, this message translates to:
  /// **'Commencer ce parcours'**
  String get pathsActivateCta;

  /// No description provided for @pathsOpenCta.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la roadmap'**
  String get pathsOpenCta;

  /// No description provided for @roadmapModuleLockedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Termine d\'abord : {titles}'**
  String roadmapModuleLockedMessage(String titles);

  /// No description provided for @roadmapViewCertificate.
  ///
  /// In fr, this message translates to:
  /// **'Voir mon certificat 🎓'**
  String get roadmapViewCertificate;

  /// No description provided for @lessonIntroDuration.
  ///
  /// In fr, this message translates to:
  /// **'Environ {minutes} min'**
  String lessonIntroDuration(int minutes);

  /// No description provided for @lessonIntroOutlineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce que tu vas apprendre'**
  String get lessonIntroOutlineTitle;

  /// No description provided for @lessonIntroStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get lessonIntroStart;

  /// No description provided for @lessonIntroResume.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get lessonIntroResume;

  /// No description provided for @lessonIntroReread.
  ///
  /// In fr, this message translates to:
  /// **'Revoir cette leçon'**
  String get lessonIntroReread;

  /// No description provided for @lessonStepProgress.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current}/{total}'**
  String lessonStepProgress(int current, int total);

  /// No description provided for @lessonPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get lessonPrevious;

  /// No description provided for @lessonNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get lessonNext;

  /// No description provided for @lessonRecapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get lessonRecapTitle;

  /// No description provided for @lessonStartQuiz.
  ///
  /// In fr, this message translates to:
  /// **'Faire le quiz'**
  String get lessonStartQuiz;

  /// No description provided for @lessonSkipQuizAlreadyDone.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la roadmap'**
  String get lessonSkipQuizAlreadyDone;

  /// No description provided for @quizQuestionProgress.
  ///
  /// In fr, this message translates to:
  /// **'Question {current}/{total}'**
  String quizQuestionProgress(int current, int total);

  /// No description provided for @quizNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get quizNext;

  /// No description provided for @quizFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get quizFinish;

  /// No description provided for @quizReviewLesson.
  ///
  /// In fr, this message translates to:
  /// **'Revoir la leçon'**
  String get quizReviewLesson;

  /// No description provided for @lessonCompletedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bravo !'**
  String get lessonCompletedTitle;

  /// No description provided for @lessonCompletedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Tu as terminé cette leçon avec {score}/{total} bonnes réponses.'**
  String lessonCompletedMessage(int score, int total);

  /// No description provided for @lessonCompletedBackToRoadmap.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la roadmap'**
  String get lessonCompletedBackToRoadmap;

  /// No description provided for @lessonTryPracticalExercise.
  ///
  /// In fr, this message translates to:
  /// **'Essayer en pratique'**
  String get lessonTryPracticalExercise;

  /// No description provided for @homeSeeLessonCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Explorer le catalogue de leçons'**
  String get homeSeeLessonCatalog;

  /// No description provided for @lessonCatalogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue de leçons'**
  String get lessonCatalogTitle;

  /// No description provided for @lessonCatalogFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get lessonCatalogFilterAll;

  /// No description provided for @homeOpenPlayground.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir l\'espace de code'**
  String get homeOpenPlayground;

  /// No description provided for @playgroundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Espace de code'**
  String get playgroundTitle;

  /// No description provided for @playgroundRun.
  ///
  /// In fr, this message translates to:
  /// **'Exécuter'**
  String get playgroundRun;

  /// No description provided for @playgroundConsolePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Appuie sur Exécuter pour voir le résultat ici.'**
  String get playgroundConsolePlaceholder;

  /// No description provided for @playgroundConsoleNoOutput.
  ///
  /// In fr, this message translates to:
  /// **'Ton code ne montre rien pour l\'instant. Essaie d\'ajouter un print ou un console.log !'**
  String get playgroundConsoleNoOutput;

  /// No description provided for @playgroundErrorGenericType.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get playgroundErrorGenericType;

  /// No description provided for @playgroundErrorAtLine.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {line} : {type} — {message}'**
  String playgroundErrorAtLine(int line, String type, String message);

  /// No description provided for @playgroundOpenAssistant.
  ///
  /// In fr, this message translates to:
  /// **'Demander à l\'assistant'**
  String get playgroundOpenAssistant;

  /// No description provided for @playgroundShareSnippet.
  ///
  /// In fr, this message translates to:
  /// **'Partager avec un ami'**
  String get playgroundShareSnippet;

  /// No description provided for @playgroundShareMessage.
  ///
  /// In fr, this message translates to:
  /// **'Regarde mon code LearningKids ! Entre ce code dans l\'app : {id}'**
  String playgroundShareMessage(String id);

  /// No description provided for @playgroundShareFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de partager le code pour le moment. Réessaie dans un instant.'**
  String get playgroundShareFailed;

  /// No description provided for @playgroundViewSharedSnippet.
  ///
  /// In fr, this message translates to:
  /// **'Voir un code partagé'**
  String get playgroundViewSharedSnippet;

  /// No description provided for @playgroundSnippetCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Code du snippet'**
  String get playgroundSnippetCodeHint;

  /// No description provided for @sharedSnippetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code partagé'**
  String get sharedSnippetTitle;

  /// No description provided for @sharedSnippetNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Ce code partagé est introuvable.'**
  String get sharedSnippetNotFound;

  /// No description provided for @sharedSnippetBy.
  ///
  /// In fr, this message translates to:
  /// **'Code de {pseudo} · {language}'**
  String sharedSnippetBy(String pseudo, String language);

  /// No description provided for @assistantTitle.
  ///
  /// In fr, this message translates to:
  /// **'Assistant IA'**
  String get assistantTitle;

  /// No description provided for @assistantActionExplain.
  ///
  /// In fr, this message translates to:
  /// **'Expliquer ce code'**
  String get assistantActionExplain;

  /// No description provided for @assistantActionFindBug.
  ///
  /// In fr, this message translates to:
  /// **'Trouver l\'erreur'**
  String get assistantActionFindBug;

  /// No description provided for @assistantActionImprove.
  ///
  /// In fr, this message translates to:
  /// **'Améliorer mon code'**
  String get assistantActionImprove;

  /// No description provided for @assistantEmptyState.
  ///
  /// In fr, this message translates to:
  /// **'Choisis une action ci-dessus ou pose une question sur ton code !'**
  String get assistantEmptyState;

  /// No description provided for @assistantInputHint.
  ///
  /// In fr, this message translates to:
  /// **'Pose ta question ici…'**
  String get assistantInputHint;

  /// No description provided for @assistantSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get assistantSend;

  /// No description provided for @assistantSuggestionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code proposé :'**
  String get assistantSuggestionLabel;

  /// No description provided for @assistantAccept.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get assistantAccept;

  /// No description provided for @assistantReject.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer'**
  String get assistantReject;

  /// No description provided for @assistantErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'L\'assistant n\'a pas pu répondre, réessaie dans un instant.'**
  String get assistantErrorGeneric;

  /// No description provided for @homeOpenProjects.
  ///
  /// In fr, this message translates to:
  /// **'Mes projets'**
  String get homeOpenProjects;

  /// No description provided for @myProjectsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes projets'**
  String get myProjectsTitle;

  /// No description provided for @myProjectsNewProject.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau projet'**
  String get myProjectsNewProject;

  /// No description provided for @myProjectsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Tu n\'as pas encore de projet. Crée-en un à partir d\'un modèle guidé !'**
  String get myProjectsEmpty;

  /// No description provided for @myProjectsPublishedBadge.
  ///
  /// In fr, this message translates to:
  /// **'publié'**
  String get myProjectsPublishedBadge;

  /// No description provided for @projectTemplatesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modèles de projets'**
  String get projectTemplatesTitle;

  /// No description provided for @projectEditorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon projet'**
  String get projectEditorTitle;

  /// No description provided for @projectRenameTitle.
  ///
  /// In fr, this message translates to:
  /// **'Renommer le projet'**
  String get projectRenameTitle;

  /// No description provided for @projectCategoryPickerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une catégorie'**
  String get projectCategoryPickerTitle;

  /// No description provided for @projectDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ce projet ? Cette action est définitive.'**
  String get projectDeleteConfirmTitle;

  /// No description provided for @projectDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get projectDeleteConfirm;

  /// No description provided for @projectFeedbackAction.
  ///
  /// In fr, this message translates to:
  /// **'Avis de l\'IA'**
  String get projectFeedbackAction;

  /// No description provided for @projectFeedbackTitle.
  ///
  /// In fr, this message translates to:
  /// **'Avis de l\'assistant IA'**
  String get projectFeedbackTitle;

  /// No description provided for @projectFeedbackEmpty.
  ///
  /// In fr, this message translates to:
  /// **'L\'assistant analyse ton projet…'**
  String get projectFeedbackEmpty;

  /// No description provided for @projectPublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier dans mon portfolio'**
  String get projectPublish;

  /// No description provided for @projectUnpublish.
  ///
  /// In fr, this message translates to:
  /// **'Retirer du portfolio'**
  String get projectUnpublish;

  /// No description provided for @portfolioTitle.
  ///
  /// In fr, this message translates to:
  /// **'Portfolio'**
  String get portfolioTitle;

  /// No description provided for @portfolioEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun projet publié pour l\'instant.'**
  String get portfolioEmpty;

  /// No description provided for @portfolioPublicToggle.
  ///
  /// In fr, this message translates to:
  /// **'Portfolio public'**
  String get portfolioPublicToggle;

  /// No description provided for @portfolioPublicOn.
  ///
  /// In fr, this message translates to:
  /// **'N\'importe qui avec ton code peut voir ton portfolio.'**
  String get portfolioPublicOn;

  /// No description provided for @portfolioPublicOff.
  ///
  /// In fr, this message translates to:
  /// **'Ton portfolio est privé : personne ne peut le voir.'**
  String get portfolioPublicOff;

  /// No description provided for @portfolioShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager mon code'**
  String get portfolioShare;

  /// No description provided for @portfolioShareMessage.
  ///
  /// In fr, this message translates to:
  /// **'Regarde mon portfolio LearningKids ! Entre ce code dans l\'app : {uid}'**
  String portfolioShareMessage(String uid);

  /// No description provided for @portfolioViewFriend.
  ///
  /// In fr, this message translates to:
  /// **'Voir le portfolio d\'un ami'**
  String get portfolioViewFriend;

  /// No description provided for @portfolioFriendCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Code de ton ami'**
  String get portfolioFriendCodeHint;

  /// No description provided for @portfolioReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signaler ce projet'**
  String get portfolioReportTitle;

  /// No description provided for @portfolioReportReasonHint.
  ///
  /// In fr, this message translates to:
  /// **'Explique en quelques mots le problème'**
  String get portfolioReportReasonHint;

  /// No description provided for @portfolioReportSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get portfolioReportSubmit;

  /// No description provided for @portfolioReportSent.
  ///
  /// In fr, this message translates to:
  /// **'Signalement envoyé, merci de nous avoir prévenus.'**
  String get portfolioReportSent;

  /// No description provided for @homeOpenBadges.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes badges'**
  String get homeOpenBadges;

  /// No description provided for @homeOpenLeaderboard.
  ///
  /// In fr, this message translates to:
  /// **'Voir le classement'**
  String get homeOpenLeaderboard;

  /// No description provided for @homeOpenChallenge.
  ///
  /// In fr, this message translates to:
  /// **'Défi de la semaine'**
  String get homeOpenChallenge;

  /// No description provided for @streakDaysCount.
  ///
  /// In fr, this message translates to:
  /// **'🔥 {days} jours de suite'**
  String streakDaysCount(int days);

  /// No description provided for @streakAtRiskWarning.
  ///
  /// In fr, this message translates to:
  /// **'Ton streak est en danger ! Apprends aujourd\'hui pour le garder.'**
  String get streakAtRiskWarning;

  /// No description provided for @levelLabel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level} · {xpIntoLevel}/{xpPerLevel} XP'**
  String levelLabel(int level, int xpIntoLevel, int xpPerLevel);

  /// No description provided for @badgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes badges'**
  String get badgesTitle;

  /// No description provided for @leaderboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get leaderboardTitle;

  /// No description provided for @leaderboardEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Personne n\'a encore de score. Sois le·la premier·ère !'**
  String get leaderboardEmpty;

  /// No description provided for @challengeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Défi de la semaine'**
  String get challengeTitle;

  /// No description provided for @challengeMarkCompleted.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai relevé le défi !'**
  String get challengeMarkCompleted;

  /// No description provided for @challengeCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Défi relevé cette semaine ✅'**
  String get challengeCompleted;

  /// No description provided for @challengeLeaderboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Qui a relevé le défi ?'**
  String get challengeLeaderboardTitle;

  /// No description provided for @challengeLeaderboardEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Personne n\'a encore relevé le défi cette semaine. Sois le·la premier·ère !'**
  String get challengeLeaderboardEmpty;

  /// No description provided for @gitSimulatorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulateur Git'**
  String get gitSimulatorTitle;

  /// No description provided for @gitSimulatorTryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Ce n\'est pas la bonne commande, essaie encore !'**
  String get gitSimulatorTryAgain;

  /// No description provided for @gitSimulatorFinished.
  ///
  /// In fr, this message translates to:
  /// **'Bravo, tu as terminé le scénario Git !'**
  String get gitSimulatorFinished;

  /// No description provided for @gitSimulatorRestart.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get gitSimulatorRestart;

  /// No description provided for @certificateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon certificat'**
  String get certificateTitle;

  /// No description provided for @certificateHeading.
  ///
  /// In fr, this message translates to:
  /// **'Certificat de réussite'**
  String get certificateHeading;

  /// No description provided for @certificateBody.
  ///
  /// In fr, this message translates to:
  /// **'a terminé avec succès le parcours « {pathTitle} ».'**
  String certificateBody(String pathTitle);

  /// No description provided for @certificateShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager mon certificat'**
  String get certificateShare;

  /// No description provided for @homeOpenDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Mon tableau de bord'**
  String get homeOpenDashboard;

  /// No description provided for @dashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma progression'**
  String get dashboardTitle;

  /// No description provided for @dashboardLessonsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'{count} leçons terminées'**
  String dashboardLessonsCompleted(int count);

  /// No description provided for @dashboardWeeklySummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get dashboardWeeklySummaryTitle;

  /// No description provided for @dashboardWeeklySummaryBody.
  ///
  /// In fr, this message translates to:
  /// **'{lessons} leçons terminées, {xp} XP gagnés et {projects} projets publiés.'**
  String dashboardWeeklySummaryBody(int lessons, int xp, int projects);

  /// No description provided for @dashboardGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton objectif'**
  String get dashboardGoalTitle;

  /// No description provided for @dashboardPathsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes parcours'**
  String get dashboardPathsTitle;

  /// No description provided for @dashboardModulesCount.
  ///
  /// In fr, this message translates to:
  /// **'{completed}/{total} modules'**
  String dashboardModulesCount(int completed, int total);

  /// No description provided for @dashboardSkillsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes compétences'**
  String get dashboardSkillsTitle;

  /// No description provided for @dashboardWeakModulesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notions à retravailler'**
  String get dashboardWeakModulesTitle;

  /// No description provided for @dashboardWeakModulesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ces leçons ont eu un score de quiz un peu faible — un petit rappel ne fera pas de mal !'**
  String get dashboardWeakModulesSubtitle;

  /// No description provided for @dashboardWeakModuleScore.
  ///
  /// In fr, this message translates to:
  /// **'Score : {correct}/{total}'**
  String dashboardWeakModuleScore(int correct, int total);

  /// No description provided for @dashboardReview.
  ///
  /// In fr, this message translates to:
  /// **'Revoir'**
  String get dashboardReview;

  /// No description provided for @dashboardUsageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Temps d\'apprentissage (7 derniers jours)'**
  String get dashboardUsageTitle;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsDailyReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get notificationSettingsDailyReminder;

  /// No description provided for @notificationSettingsDailyReminderSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une notification pour penser à t\'entraîner et garder ton streak.'**
  String get notificationSettingsDailyReminderSubtitle;

  /// No description provided for @notificationSettingsChangeTime.
  ///
  /// In fr, this message translates to:
  /// **'Changer l\'heure ({time})'**
  String notificationSettingsChangeTime(String time);

  /// No description provided for @notificationSettingsRewards.
  ///
  /// In fr, this message translates to:
  /// **'Notifications de récompenses'**
  String get notificationSettingsRewards;

  /// No description provided for @notificationSettingsRewardsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une notification quand tu débloques un badge, un certificat ou un niveau.'**
  String get notificationSettingsRewardsSubtitle;

  /// No description provided for @notificationSettingsPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications sont désactivées pour LearningKids dans les réglages de ton appareil.'**
  String get notificationSettingsPermissionDenied;

  /// No description provided for @accountSuspendedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte suspendu'**
  String get accountSuspendedTitle;

  /// No description provided for @accountSuspendedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ton compte a été temporairement suspendu. Contacte le support si tu penses que c\'est une erreur.'**
  String get accountSuspendedMessage;

  /// No description provided for @adminHomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Back-office'**
  String get adminHomeTitle;

  /// No description provided for @adminModerationQueueTitle.
  ///
  /// In fr, this message translates to:
  /// **'File de modération'**
  String get adminModerationQueueTitle;

  /// No description provided for @adminModerationQueueEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement en attente.'**
  String get adminModerationQueueEmpty;

  /// No description provided for @adminModerationQueueReason.
  ///
  /// In fr, this message translates to:
  /// **'Motif : {reason}'**
  String adminModerationQueueReason(String reason);

  /// No description provided for @adminModerationApprove.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get adminModerationApprove;

  /// No description provided for @adminModerationReject.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter'**
  String get adminModerationReject;

  /// No description provided for @adminAccountsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comptes'**
  String get adminAccountsTitle;

  /// No description provided for @adminAccountsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte pour l\'instant.'**
  String get adminAccountsEmpty;

  /// No description provided for @adminAccountsSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get adminAccountsSuspended;

  /// No description provided for @adminAccountsSupportNotes.
  ///
  /// In fr, this message translates to:
  /// **'Note de support'**
  String get adminAccountsSupportNotes;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsSystem.
  ///
  /// In fr, this message translates to:
  /// **'Suivre l\'appareil'**
  String get languageSettingsSystem;

  /// No description provided for @languageSettingsFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageSettingsFrench;

  /// No description provided for @languageSettingsEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get languageSettingsEnglish;

  /// No description provided for @accessibilitySettingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accessibilité'**
  String get accessibilitySettingsTitle;

  /// No description provided for @accessibilityTextSizeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte'**
  String get accessibilityTextSizeTitle;

  /// No description provided for @accessibilityTextSizeSmall.
  ///
  /// In fr, this message translates to:
  /// **'Petite'**
  String get accessibilityTextSizeSmall;

  /// No description provided for @accessibilityTextSizeNormal.
  ///
  /// In fr, this message translates to:
  /// **'Normale'**
  String get accessibilityTextSizeNormal;

  /// No description provided for @accessibilityTextSizeLarge.
  ///
  /// In fr, this message translates to:
  /// **'Grande'**
  String get accessibilityTextSizeLarge;

  /// No description provided for @accessibilityTextSizeExtraLarge.
  ///
  /// In fr, this message translates to:
  /// **'Très grande'**
  String get accessibilityTextSizeExtraLarge;

  /// No description provided for @accessibilityReadAloudStart.
  ///
  /// In fr, this message translates to:
  /// **'Lire à voix haute'**
  String get accessibilityReadAloudStart;

  /// No description provided for @accessibilityReadAloudStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter la lecture'**
  String get accessibilityReadAloudStop;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
