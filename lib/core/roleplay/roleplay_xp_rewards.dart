/// PRD 4.2.6 — Roleplay XP per module and lesson completion bonus.
class RoleplayXpRewards {
  RoleplayXpRewards._();

  static const int dialogue = 5;
  static const int vocabulary = 3;
  static const int comprehension = 5;
  static const int lessonCompleteBonus = 2;

  static const int totalPerLesson =
      dialogue + vocabulary + comprehension + lessonCompleteBonus;
}
