import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';

class LessonUnlockLogic {
  LessonUnlockLogic._();

  static LearningLessonStatus statusForLesson({
    required int lessonNumber,
    required Map<String, LessonProgressModel> progressByLessonId,
    required String lessonId,
    required bool hasContent,
  }) {
    final saved = progressByLessonId[lessonId];
    if (saved != null) {
      return saved.status;
    }
    if (!hasContent) return LearningLessonStatus.locked;
    if (lessonNumber == 1) return LearningLessonStatus.notStarted;
    return LearningLessonStatus.locked;
  }

  static int progressIndexFor({
    required Map<String, LessonProgressModel> progressByLessonId,
    required String lessonId,
  }) {
    return progressByLessonId[lessonId]?.currentIndex ?? 0;
  }

  static String? nextLessonIdToUnlock({
    required String completedLessonId,
    required List<String> orderedLessonIds,
  }) {
    final index = orderedLessonIds.indexOf(completedLessonId);
    if (index < 0 || index >= orderedLessonIds.length - 1) return null;
    return orderedLessonIds[index + 1];
  }

  static Map<String, LessonProgressModel> applyCompletion({
    required Map<String, LessonProgressModel> current,
    required LessonProgressModel completed,
    String? unlockLessonId,
  }) {
    final updated = Map<String, LessonProgressModel>.from(current);
    updated[completed.lessonId] = completed;

    if (unlockLessonId != null) {
      final existing = updated[unlockLessonId];
      if (existing == null || existing.status == LearningLessonStatus.locked) {
        updated[unlockLessonId] = LessonProgressModel(
          lessonId: unlockLessonId,
          type: completed.type,
          cefrLevel: completed.cefrLevel,
          status: LearningLessonStatus.notStarted,
          currentIndex: 0,
          updatedAt: DateTime.now(),
        );
      }
    }

    return updated;
  }
}
