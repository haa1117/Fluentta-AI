import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  ) {
    _user = _authRepository.currentUser;
    _authSubscription = _authRepository.authStateChanges.listen((user) async {
      _user = user;
      if (user != null) {
        _firestoreUser = await _userRepository.getUser(user.uid);
        await _userRepository.syncSetupFromFirestore(user.uid);
        await _progressSyncService.pullAndMerge();
      } else {
        _firestoreUser = null;
      }
      notifyListeners();
    });
    _loadFirestoreUser();
  }

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;
  final ProgressSyncService _progressSyncService;
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

  String? get selectedLanguage =>
      _firestoreUser?.selectedLanguage ?? _localStorage.selectedLanguage;

  bool get canChangePassword => _authRepository.canChangePassword;

  Future<void> _loadFirestoreUser() async {
    final uid = _user?.uid;
    if (uid == null) return;
    _firestoreUser = await _userRepository.getUser(uid);
    await _userRepository.syncSetupFromFirestore(uid);
    await _progressSyncService.pullAndMerge();
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
