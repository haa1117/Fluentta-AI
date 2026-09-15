import 'package:fluentta_ai/core/cefr/lesson_type.dart';

/// Core curriculum XP (matches [ProgressSyncService] lesson completion grants).
class LessonXpRewards {
  LessonXpRewards._();

  static const int vocabularyLesson = 20;
  static const int grammarLesson = 25;
  static const int readingLesson = 25;

  /// Default for grammar/reading complete screens and legacy callers.
  static const int coreLesson = grammarLesson;

  /// PRD 4.2.2 — bonus for finishing all 10 lessons in a core module.
  static const int coreModuleComplete = 50;

  static const int rewardedBoost = 5;

  static const Set<String> coreTypes = {
    'vocabulary',
    'grammar',
    'reading',
  };

  static int forLessonType(String type) {
    return switch (LessonType.fromId(type)) {
      LessonType.vocabulary => vocabularyLesson,
      LessonType.grammar => grammarLesson,
      LessonType.reading => readingLesson,
    };
  }
}
