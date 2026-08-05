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
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastLoginAt: lastLoginAt,
    );
  }
}
