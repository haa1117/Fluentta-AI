import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

/// snake_case `lesson_state` value for a lesson tile's current status.
String lessonStateFor(LearningLessonStatus status) => switch (status) {
      LearningLessonStatus.completed => 'completed',
      LearningLessonStatus.inProgress => 'in_progress',
      LearningLessonStatus.notStarted => 'not_started',
      LearningLessonStatus.locked => 'locked',
    };

/// `entry_action` (start|resume|review) for opening a lesson in its current
/// status. Locked lessons are never openable, so callers only reach this for
/// notStarted/inProgress/completed.
String entryActionFor(LearningLessonStatus status) => switch (status) {
      LearningLessonStatus.completed => 'review',
      LearningLessonStatus.inProgress => 'resume',
      LearningLessonStatus.notStarted || LearningLessonStatus.locked =>
        'start',
    };
