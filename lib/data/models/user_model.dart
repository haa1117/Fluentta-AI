import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.fullName,
    required this.selectedLanguage,
    required this.onboardingComplete,
    required this.authProvider,
    this.photoUrl,
    this.englishGoal,
    this.englishLevel,
    this.dailyGoalMinutes,
    this.setupComplete = false,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String fullName;
  final String selectedLanguage;
  final bool onboardingComplete;
  final String authProvider;
  final String? photoUrl;
  final String? englishGoal;
  final String? englishLevel;
  final int? dailyGoalMinutes;
  final bool setupComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      uid: data['uid'] as String? ?? doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      selectedLanguage: data['selectedLanguage'] as String? ?? 'ur',
      onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      authProvider: data['authProvider'] as String? ?? 'email',
      photoUrl: data['photoUrl'] as String?,
      englishGoal: data['englishGoal'] as String?,
      englishLevel: data['englishLevel'] as String?,
      dailyGoalMinutes: data['dailyGoalMinutes'] as int?,
      setupComplete: data['setupComplete'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore({bool isNew = false}) {
    final now = FieldValue.serverTimestamp();
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'fullName': fullName,
      'selectedLanguage': selectedLanguage,
      'onboardingComplete': onboardingComplete,
      'authProvider': authProvider,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (englishGoal != null) 'englishGoal': englishGoal,
      if (englishLevel != null) 'englishLevel': englishLevel,
      if (dailyGoalMinutes != null) 'dailyGoalMinutes': dailyGoalMinutes,
      'setupComplete': setupComplete,
      'updatedAt': now,
      'lastLoginAt': now,
      if (isNew) 'createdAt': now,
    };
  }

  UserModel copyWith({
    String? email,
    String? displayName,
    String? fullName,
    String? selectedLanguage,
    bool? onboardingComplete,
    String? authProvider,
    String? photoUrl,
    String? englishGoal,
    String? englishLevel,
    int? dailyGoalMinutes,
    bool? setupComplete,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      fullName: fullName ?? this.fullName,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      authProvider: authProvider ?? this.authProvider,
      photoUrl: photoUrl ?? this.photoUrl,
      englishGoal: englishGoal ?? this.englishGoal,
      englishLevel: englishLevel ?? this.englishLevel,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      setupComplete: setupComplete ?? this.setupComplete,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
    );
  }
}
