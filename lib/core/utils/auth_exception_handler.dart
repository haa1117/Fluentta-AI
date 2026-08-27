import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class AuthExceptionHandler {
  AuthExceptionHandler._();

  static String getMessage(Object error, AppLocalizations l10n) {
    if (error is FirebaseAuthException) {
      return _authMessage(error, l10n);
    }
    if (error is FirebaseException) {
      return _firestoreMessage(error, l10n);
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  static String _firestoreMessage(FirebaseException error, AppLocalizations l10n) {
    switch (error.code) {
      case 'permission-denied':
        return l10n.authErrorPermissionDenied;
      case 'unavailable':
        return l10n.authErrorUnavailable;
      case 'not-found':
        return l10n.authErrorNotFound;
      default:
        return error.message ?? l10n.authErrorSaveFailed;
    }
  }

  static String _authMessage(FirebaseAuthException error, AppLocalizations l10n) {
    if (error.message == 'Please fill in all fields.') {
      return l10n.authErrorFillAllFields;
    }
    if (error.message == 'Password must be at least 8 characters.') {
      return l10n.authErrorPasswordMinEight;
    }

    switch (error.code) {
      case 'invalid-email':
        return l10n.authErrorInvalidEmail;
      case 'invalid-name':
        return l10n.authErrorNameRequired;
      case 'user-disabled':
        return l10n.authErrorUserDisabled;
      case 'user-not-found':
        return l10n.authErrorUserNotFound;
      case 'wrong-password':
        return l10n.authErrorWrongPassword;
      case 'email-already-in-use':
        return l10n.authErrorEmailInUse;
      case 'weak-password':
        return l10n.authErrorWeakPassword;
      case 'invalid-credential':
        return l10n.authErrorInvalidCredential;
      case 'too-many-requests':
        return l10n.authErrorTooManyRequests;
      case 'network-request-failed':
        return l10n.authErrorNetwork;
      case 'operation-not-allowed':
        return l10n.authErrorOperationNotAllowed;
      case 'password-change-unavailable':
        return l10n.passwordChangeUnavailable;
      case 'invalid-verification-code':
        return l10n.authErrorInvalidVerificationCode;
      case 'expired-action-code':
        return l10n.authErrorExpiredActionCode;
      case 'invalid-action-code':
        return l10n.authErrorInvalidActionCode;
      case 'requires-recent-login':
        return l10n.authErrorRequiresRecentLogin;
      default:
        return error.message ?? l10n.authErrorGeneric;
    }
  }
}
