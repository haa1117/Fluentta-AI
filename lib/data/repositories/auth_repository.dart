import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/auth_deep_link_config.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialSignInResult {
  const SocialSignInResult({required this.isNewUser});

  final bool isNewUser;
}

class AuthRepository {
  AuthRepository(this._localStorage, this._userRepository) {
    _resetEmail = _localStorage.pendingResetEmail;
  }

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const String _webClientId =
      '254450330965-bje37p5lscjfkfvobfivf22klqsnhmmg.apps.googleusercontent.com';

  String? _resetEmail;
  String? _resetOobCode;
  bool _pendingPasswordResetNavigation = false;
  bool _launchDirectToPasswordReset = false;
  final ValueNotifier<int> passwordResetSignal = ValueNotifier(0);
  final ValueNotifier<int> passwordResetCompleteSignal = ValueNotifier(0);

  UserRepository get userRepository => _userRepository;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get resetEmail => _resetEmail;
  String? get resetOobCode => _resetOobCode;
  bool get shouldOpenPasswordResetScreen =>
      _pendingPasswordResetNavigation && hasVerifiedResetCode;
  bool get hasVerifiedResetCode =>
      _resetOobCode != null && _resetOobCode!.isNotEmpty;
  bool get shouldLaunchDirectToPasswordReset => _launchDirectToPasswordReset;

  void markPendingPasswordResetNavigation() {
    _pendingPasswordResetNavigation = true;
  }

  void markDirectPasswordResetLaunch() {
    _launchDirectToPasswordReset = true;
    markPendingPasswordResetNavigation();
  }

  void consumePendingPasswordResetNavigation() {
    _pendingPasswordResetNavigation = false;
    _launchDirectToPasswordReset = false;
  }

  void completePasswordResetFlow() {
    consumePendingPasswordResetNavigation();
    passwordResetCompleteSignal.value++;
  }

  /// Clears stale reset state when the app is opened normally (not via link).
  Future<void> discardPersistedPasswordResetLaunch() async {
    _resetOobCode = null;
    _pendingPasswordResetNavigation = false;
    _launchDirectToPasswordReset = false;
    await _localStorage.clearPendingResetOobCode();
  }

  Future<void> initializeGoogleSignIn() async {
    if (kIsWeb) return;
    await _googleSignIn.initialize(serverClientId: _webClientId);
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _persistUser(
      credential.user,
      authProvider: 'email',
    );
    return credential;
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Account created but user session is unavailable.',
      );
    }

    await user.updateDisplayName(fullName.trim());
    await user.reload();

    final refreshedUser = _auth.currentUser!;
    await refreshedUser.getIdToken(true);

    await _localStorage.saveUserSession(
      uid: refreshedUser.uid,
      email: refreshedUser.email ?? email.trim(),
      displayName: fullName.trim(),
    );

    await _userRepository.createUserProfile(
      user: refreshedUser,
      fullName: fullName.trim(),
      authProvider: 'email',
    );

    return credential;
  }

  Future<SocialSignInResult?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(provider);
      await _persistUser(credential.user, authProvider: 'google');
      return SocialSignInResult(
        isNewUser: credential.additionalUserInfo?.isNewUser ?? false,
      );
    }

    await _googleSignIn.signOut();
    try {
      final googleUser = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );

      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Google sign-in failed. Missing ID token.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await _persistUser(userCredential.user, authProvider: 'google');
      return SocialSignInResult(
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      );
    } on GoogleSignInException {
      return null;
    }
  }

  Future<SocialSignInResult> signInWithApple() async {
    final provider = AppleAuthProvider();
    provider.addScope('email');
    provider.addScope('name');

    final credential = kIsWeb
        ? await _auth.signInWithPopup(provider)
        : await _auth.signInWithProvider(provider);

    await _persistUser(credential.user, authProvider: 'apple');
    return SocialSignInResult(
      isNewUser: credential.additionalUserInfo?.isNewUser ?? false,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();
    _resetEmail = trimmedEmail;
    _resetOobCode = null;
    await _localStorage.setPendingResetEmail(trimmedEmail);
    await _localStorage.clearPendingResetOobCode();

    await _auth.sendPasswordResetEmail(
      email: trimmedEmail,
      actionCodeSettings: ActionCodeSettings(
        url: AuthDeepLinkConfig.continueUrl,
        handleCodeInApp: true,
        androidPackageName: AuthDeepLinkConfig.androidPackageName,
        androidInstallApp: true,
        androidMinimumVersion: '21',
        iOSBundleId: AuthDeepLinkConfig.iOSBundleId,
      ),
    );
  }

  Future<void> handlePasswordResetLink({required String oobCode}) async {
    await verifyPasswordResetCode(oobCode);
    markDirectPasswordResetLaunch();
    _notifyPasswordResetReady();
  }

  void _notifyPasswordResetReady() {
    passwordResetSignal.value++;
  }

  Future<void> verifyPasswordResetCode(String code) async {
    await _auth.verifyPasswordResetCode(code);
    _resetOobCode = code;
    await _localStorage.setPendingResetOobCode(code);
  }

  void setResetOobCode(String code) {
    _resetOobCode = code;
    _localStorage.setPendingResetOobCode(code);
  }

  Future<void> confirmPasswordReset({
    required String newPassword,
    String? code,
  }) async {
    final resetCode =
        code ?? _resetOobCode ?? _localStorage.pendingResetOobCode;

    if (resetCode != null && resetCode.isNotEmpty) {
      await _auth.confirmPasswordReset(
        code: resetCode,
        newPassword: newPassword,
      );
      await _clearResetState();
      return;
    }

    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
      await _clearResetState();
      return;
    }

    throw FirebaseAuthException(
      code: 'invalid-action-code',
      message: 'Please open the reset link from your email first.',
    );
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // Continue clearing local session even if Firebase sign-out fails.
    }

    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // User may have signed in with email/password only.
      }
    }

    await _clearLocalSession();
    await _clearResetState();
  }

  Future<void> _clearLocalSession() async {
    await _localStorage.clearUserSession();
    if (!kIsWeb) {
      AdMobService.instance.refreshAfterEntitlementsChange();
    }
  }

  Future<void> _persistUser(
    User? user, {
    required String authProvider,
    String? fullName,
  }) async {
    if (user == null) return;

    await user.getIdToken(true);

    await _localStorage.saveUserSession(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? fullName ?? '',
    );

    await _userRepository.syncUserFromAuth(
      user: user,
      authProvider: authProvider,
      fullName: fullName,
    );
    await _userRepository.syncSetupFromFirestore(user.uid);
  }

  Future<void> _clearResetState() async {
    _resetEmail = null;
    _resetOobCode = null;
    await _localStorage.clearPendingReset();
  }

  Future<void> syncCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _localStorage.saveUserSession(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
      await _userRepository.syncSetupFromFirestore(user.uid);
      await _userRepository.syncUserFromAuth(
        user: user,
        authProvider: _resolveAuthProvider(user),
      );
    } else {
      await _clearLocalSession();
    }
  }

  String _resolveAuthProvider(User user) {
    final providerId = user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'password';

    if (providerId.contains('google')) return 'google';
    if (providerId.contains('apple')) return 'apple';
    return 'email';
  }

  bool get canChangePassword {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((info) => info.providerId == 'password');
  }

  Future<void> updateProfileName(String fullName) async {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-name',
        message: 'Please enter your first name.',
      );
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed-in user found.',
      );
    }

    await user.updateDisplayName(trimmed);
    await user.reload();

    await _localStorage.saveUserSession(
      uid: user.uid,
      email: user.email ?? '',
      displayName: trimmed,
    );

    await _userRepository.updateFullName(uid: user.uid, fullName: trimmed);
  }

  Future<void> updatePasswordWithCurrent({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed-in user found.',
      );
    }

    if (!canChangePassword) {
      throw FirebaseAuthException(
        code: 'password-change-unavailable',
        message: 'Password change is not available for this account.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<void> deleteAccount({String? currentPassword}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed-in user found.',
      );
    }

    if (canChangePassword) {
      final password = currentPassword?.trim() ?? '';
      if (password.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Please enter your current password.',
        );
      }

      final email = user.email;
      if (email == null || email.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'No email is linked to this account.',
        );
      }

      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
        ),
      );
    }

    final uid = user.uid;
    await _userRepository.deleteUserAccount(uid);
    await user.delete();

    if (!kIsWeb) {
      try {
        await _googleSignIn.signOut();
      } catch (_) {
        // User may have signed in with email/password only.
      }
    }

    await _clearLocalSession();
    await _clearResetState();
  }
}
