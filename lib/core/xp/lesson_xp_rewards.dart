import 'package:fluentta_ai/core/cefr/lesson_type.dart';

/// Core curriculum XP (matches [ProgressSyncService] lesson completion grants).
class LessonXpRewards {
  LessonXpRewards._();

  static const int vocabularyLesson = 20;
  static const int grammarLesson = 25;
  static const int readingLesson = 25;

  /// Default for grammar/reading complete screens and legacy callers.
  static const int coreLesson = grammarLesson;

  static int forLessonType(String type) {
    return switch (LessonType.fromId(type)) {
      LessonType.vocabulary => vocabularyLesson,
      LessonType.grammar => grammarLesson,
      LessonType.reading => readingLesson,
    };
  }
}
