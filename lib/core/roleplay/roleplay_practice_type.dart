enum RoleplayPracticeType {
  vocabulary,
  quickCheck;

  String get id => switch (this) {
        RoleplayPracticeType.vocabulary => 'roleplay_vocab',
        RoleplayPracticeType.quickCheck => 'roleplay_quick',
      };

  String get progressPrefix => switch (this) {
        RoleplayPracticeType.vocabulary => 'vocab',
        RoleplayPracticeType.quickCheck => 'quick',
      };
}
