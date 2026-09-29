import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_user_properties.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/user_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(
    this._authRepository,
    this._userRepository,
    this._localStorage,
    this._progressSyncService,
    this._localeViewModel,
  ) {
    _user = _authRepository.currentUser;
    _authSubscription = _authRepository.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        await _localStorage.saveUserSession(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
        );
        try {
          await _hydrateRemoteProfile(user.uid);
        } catch (error) {
          debugPrint('Auth profile hydrate skipped: $error');
        }
      } else {
        _firestoreUser = null;
        _progressSyncService.resetLocalCaches();
        await AnalyticsUserProperties.sync(_localStorage);
      }
      notifyListeners();
    });
    _loadFirestoreUser();
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;
  final ProgressSyncService _progressSyncService;
  final LocaleViewModel _localeViewModel;
  late final StreamSubscription<User?> _authSubscription;

  User? _user;
  UserModel? _firestoreUser;

  User? get user => _user;
  UserModel? get firestoreUser => _firestoreUser;
  bool get isAuthenticated => _user != null;

  String? get displayName =>
      _firestoreUser?.fullName ??
      _user?.displayName ??
      _localStorage.userDisplayName;

  String? get email =>
      _firestoreUser?.email ?? _user?.email ?? _localStorage.userEmail;

  String? get selectedLanguage => _localeViewModel.languageCode;

  Future<void> _applyAccountLanguage() async {
    final local = _localStorage.selectedLanguage;
    if (local != null && local.isNotEmpty) {
      await _localeViewModel.setLocale(local);
      return;
    }
    final remote = _firestoreUser?.selectedLanguage;
    if (remote == null || remote.isEmpty) return;
    await _localeViewModel.setLocale(remote);
  }

  bool get canChangePassword => _authRepository.canChangePassword;

  Future<void> _hydrateRemoteProfile(String uid) async {
    _firestoreUser = await _userRepository
        .getUser(uid)
        .timeout(const Duration(seconds: 3), onTimeout: () => _firestoreUser);
    await _userRepository
        .syncSetupFromFirestore(uid)
        .timeout(const Duration(seconds: 3), onTimeout: () => false);
    await _applyAccountLanguage();
    await _progressSyncService.pullAndMerge().timeout(
          const Duration(seconds: 4),
          onTimeout: () {},
        );
    await AnalyticsUserProperties.sync(
      _localStorage,
      user: _authRepository.currentUser,
    );
  }

  Future<void> _loadFirestoreUser() async {
    final uid = _user?.uid;
    if (uid == null) return;
    try {
      await _hydrateRemoteProfile(uid);
    } catch (error) {
      debugPrint('Auth profile load skipped: $error');
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _user = null;
    _firestoreUser = null;
    notifyListeners();
  }

  Future<void> deleteAccount({String? currentPassword}) async {
    await _authRepository.deleteAccount(currentPassword: currentPassword);
    _user = null;
    _firestoreUser = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    final user = _authRepository.currentUser;
    if (user != null) {
      await user.reload();
      _user = _authRepository.currentUser;
    }
    await _loadFirestoreUser();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
