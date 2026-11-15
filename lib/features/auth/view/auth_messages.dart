import 'package:cospace_customer/features/auth/model/auth_failure.dart';
import 'package:cospace_customer/l10n/app_localizations.dart';

/// Maps an authentication failure to the current locale.
String authFailureMessage(AppLocalizations l10n, AuthFailureCode code) {
  switch (code) {
    case AuthFailureCode.invalidEmail:
      return l10n.invalidEmail;
    case AuthFailureCode.weakPassword:
      return l10n.invalidPassword;
    case AuthFailureCode.emptyName:
      return l10n.fieldRequired;
    case AuthFailureCode.invalidPhone:
      return l10n.invalidPhone;
    case AuthFailureCode.invalidCredentials:
      return l10n.invalidCredentials;
    case AuthFailureCode.emailAlreadyInUse:
      return l10n.emailAlreadyInUse;
    case AuthFailureCode.userDisabled:
      return l10n.userDisabled;
    case AuthFailureCode.tooManyRequests:
      return l10n.tooManyRequests;
    case AuthFailureCode.network:
      return l10n.networkError;
    case AuthFailureCode.unknown:
      return l10n.authFailed;
  }
}
