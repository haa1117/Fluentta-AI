import 'package:fluentta_ai/core/cefr/lesson_type.dart';

/// Minutes credited toward the daily goal per activity type.
class DailyGoalRewards {
  DailyGoalRewards._();

  static const int englishBasicsLesson = 5;
  static const int coreLesson = 5;
  static const int roleplayModule = 3;
  static const int aiChatSession = 2;

  static int forLessonType(String type) {
    return switch (LessonType.fromId(type)) {
      LessonType.vocabulary => coreLesson,
      LessonType.grammar => coreLesson,
      LessonType.reading => coreLesson,
    };
  }
}
