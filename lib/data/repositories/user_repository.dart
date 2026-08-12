import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/user_model.dart';

class UserRepository {
  UserRepository(this._localStorage);

  final LocalStorage _localStorage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _usersCollection = 'users';

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection(_usersCollection);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _usersRef.doc(uid);

  Future<void> _ensureAuthTokenReady(User user) async {
    await user.getIdToken(true);
  }

  Future<void> syncUserFromAuth({
    required User user,
    required String authProvider,
    String? fullName,
  }) async {
    await _ensureAuthTokenReady(user);

    final docRef = _userDoc(user.uid);
    final snapshot = await docRef.get();
    final isNew = !snapshot.exists;

    final localLanguage = _localStorage.selectedLanguage ?? 'en';
    final localOnboardingComplete = _localStorage.isOnboardingComplete;

    final resolvedFullName = fullName?.trim().isNotEmpty == true
        ? fullName!.trim()
        : (user.displayName ?? '');

    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? resolvedFullName,
      fullName: resolvedFullName,
      selectedLanguage: localLanguage,
      onboardingComplete: localOnboardingComplete,
      authProvider: authProvider,
      photoUrl: user.photoURL,
    );

    try {
      await docRef.set(
        userModel.toFirestore(isNew: isNew),
        SetOptions(merge: true),
      );

      await syncLocalPreferencesToFirestore(user.uid);

      final saved = await docRef.get();
      if (!saved.exists) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'data-loss',
          message: 'User profile could not be verified after save.',
        );
      }

      if (kDebugMode) {
        debugPrint('Firestore: user saved → users/${user.uid}');
        debugPrint('Firestore data: ${saved.data()}');
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint('Firestore save failed: ${e.code} → ${e.message}');
      }
      rethrow;
    }
  }

  Future<void> createUserProfile({
    required User user,
    required String fullName,
    required String authProvider,
  }) async {
    await syncUserFromAuth(
      user: user,
      authProvider: authProvider,
      fullName: fullName,
    );
  }

  Future<void> updateLanguage({
    required String uid,
    required String languageCode,
  }) async {
    await _userDoc(uid).set(
      {
        'selectedLanguage': languageCode,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateOnboarding({
    required String uid,
    required bool isComplete,
  }) async {
    await _userDoc(uid).set(
      {
        'onboardingComplete': isComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> updateLastLogin(String uid) async {
    await _userDoc(uid).set(
      {
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<UserModel?> getUser(String uid) async {
    final snapshot = await _userDoc(uid).get();
    if (!snapshot.exists) return null;
    return UserModel.fromFirestore(snapshot);
  }

  Stream<UserModel?> watchUser(String uid) {
    return _userDoc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserModel.fromFirestore(snapshot);
    });
  }

  Future<void> syncLocalPreferencesToFirestore(String uid) async {
    await _userDoc(uid).set(
      {
        'selectedLanguage': _localStorage.selectedLanguage ?? 'en',
        'onboardingComplete': _localStorage.isOnboardingComplete,
        if (_localStorage.englishGoal != null)
          'englishGoal': _localStorage.englishGoal,
        if (_localStorage.englishLevel != null)
          'englishLevel': _localStorage.englishLevel,
        if (_localStorage.dailyGoalMinutes != null)
          'dailyGoalMinutes': _localStorage.dailyGoalMinutes,
        'setupComplete': _localStorage.isSetupComplete,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> saveSetupPreferences({
    required String uid,
    required String englishGoal,
    required String englishLevel,
    required int dailyGoalMinutes,
  }) async {
    await _localStorage.saveSetupPreferences(
      englishGoal: englishGoal,
      englishLevel: englishLevel,
      dailyGoalMinutes: dailyGoalMinutes,
    );

    await _userDoc(uid).set(
      {
        'englishGoal': englishGoal,
        'englishLevel': englishLevel,
        'dailyGoalMinutes': dailyGoalMinutes,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> completeSetup({
    required String uid,
    required String englishGoal,
    required String englishLevel,
    required int dailyGoalMinutes,
  }) async {
    await saveSetupPreferences(
      uid: uid,
      englishGoal: englishGoal,
      englishLevel: englishLevel,
      dailyGoalMinutes: dailyGoalMinutes,
    );

    await _localStorage.setSetupComplete();

    await _userDoc(uid).set(
      {
        'setupComplete': true,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> syncSetupFromFirestore(String uid) async {
    final user = await getUser(uid);
    if (user == null) return;

    if (user.englishGoal != null &&
        user.englishLevel != null &&
        user.dailyGoalMinutes != null) {
      await _localStorage.saveSetupPreferences(
        englishGoal: user.englishGoal!,
        englishLevel: user.englishLevel!,
        dailyGoalMinutes: user.dailyGoalMinutes!,
      );
    }

    if (user.setupComplete) {
      await _localStorage.setSetupComplete();
    }
  }
}
