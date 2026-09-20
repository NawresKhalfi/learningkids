import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/auth_failure.dart';

/// Maps an [AuthFailure] to a French, kid-friendly message. `isSignUp`
/// disambiguates codes Firebase reuses with a different meaning per flow
/// (e.g. `invalid-credential` reads as "wrong password" only on login).
String? signUpFailureMessage(AppLocalizations l10n, AuthFailure? failure) {
  switch (failure) {
    case null:
      return null;
    case AuthFailure.emailAlreadyInUse:
      return l10n.signUpErrorEmailInUse;
    case AuthFailure.invalidEmail:
      return l10n.signUpErrorInvalidEmail;
    case AuthFailure.weakPassword:
      return l10n.signUpErrorWeakPassword;
    case AuthFailure.network:
      return l10n.commonNoInternet;
    case AuthFailure.cancelled:
      return null;
    default:
      return l10n.commonSomethingWentWrong;
  }
}

String? loginFailureMessage(AppLocalizations l10n, AuthFailure? failure) {
  switch (failure) {
    case null:
      return null;
    case AuthFailure.invalidCredentials:
    case AuthFailure.invalidEmail:
      return l10n.loginErrorInvalidCredentials;
    case AuthFailure.tooManyRequests:
      return l10n.loginErrorTooManyRequests;
    case AuthFailure.network:
      return l10n.commonNoInternet;
    case AuthFailure.cancelled:
      return null;
    default:
      return l10n.commonSomethingWentWrong;
  }
}
