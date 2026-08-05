import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository(this._localStorage, this._userRepository);

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const String _webClientId =
      '254450330965-bje37p5lscjfkfvobfivf22klqsnhmmg.apps.googleusercontent.com';

  String? _resetEmail;
  String? _resetOobCode;

  UserRepository get userRepository => _userRepository;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  String? get resetEmail => _resetEmail;
  String? get resetOobCode => _resetOobCode;

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

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final credential = await _auth.signInWithPopup(provider);
      await _persistUser(credential.user, authProvider: 'google');
      return credential;
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
      return userCredential;
    } on GoogleSignInException {
      return null;
    }
  }

  Future<UserCredential> signInWithApple() async {
    final provider = AppleAuthProvider();
    provider.addScope('email');
    provider.addScope('name');

    final credential = kIsWeb
        ? await _auth.signInWithPopup(provider)
        : await _auth.signInWithProvider(provider);

    await _persistUser(credential.user, authProvider: 'apple');
    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();
    _resetEmail = trimmedEmail;
    _resetOobCode = null;
    await _localStorage.setPendingResetEmail(trimmedEmail);
    await _auth.sendPasswordResetEmail(email: trimmedEmail);
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
    await Future.wait([
      _auth.signOut(),
      if (!kIsWeb) _googleSignIn.signOut(),
    ]);
    await _localStorage.clearUserSession();
    await _clearResetState();
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
      await _userRepository.syncUserFromAuth(
        user: user,
        authProvider: _resolveAuthProvider(user),
      );
    } else {
      await _localStorage.clearUserSession();
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
}
