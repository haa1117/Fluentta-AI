enum RoleplayPracticeType {
  dialogue,
  vocabulary,
  quickCheck;

  String get id => switch (this) {
        RoleplayPracticeType.dialogue => 'roleplay_dialogue',
        RoleplayPracticeType.vocabulary => 'roleplay_vocab',
        RoleplayPracticeType.quickCheck => 'roleplay_quick',
      };

  String get progressPrefix => switch (this) {
        RoleplayPracticeType.dialogue => 'dialogue',
        RoleplayPracticeType.vocabulary => 'vocab',
        RoleplayPracticeType.quickCheck => 'quick',
      };
}
