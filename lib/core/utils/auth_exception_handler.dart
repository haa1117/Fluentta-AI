import 'package:firebase_auth/firebase_auth.dart';

class AuthExceptionHandler {
  AuthExceptionHandler._();

  static String getMessage(Object error) {
    if (error is FirebaseAuthException) {
      return _authMessage(error);
    }
    if (error is FirebaseException) {
      return _firestoreMessage(error);
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  static String _firestoreMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Could not save profile. Enable Firestore and deploy security rules in Firebase Console.';
      case 'unavailable':
        return 'Firestore is unavailable. Check your internet connection.';
      case 'not-found':
        return 'Firestore database not found. Create it in Firebase Console.';
      default:
        return error.message ?? 'Failed to save user data. Please try again.';
    }
  }

  static String _authMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-verification-code':
        return 'Invalid verification code.';
      case 'expired-action-code':
        return 'This reset link has expired. Request a new one.';
      case 'invalid-action-code':
        return 'Invalid reset code. Please request a new one.';
      case 'requires-recent-login':
        return 'Please sign in again to update your password.';
      default:
        return error.message ?? 'Something went wrong. Please try again.';
    }
  }
}
