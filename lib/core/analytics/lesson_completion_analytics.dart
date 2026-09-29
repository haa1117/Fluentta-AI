import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

/// Parameters for the shared `lesson_completed` screen.
///
/// Built after completion has been persisted. [baseXpEarned] is the
/// catalogue base for a first claim, and 0 on review.
class LessonCompletionAnalytics {
  const LessonCompletionAnalytics({
    required this.learningArea,
    required this.lessonAttemptId,
    required this.cefrLevel,
    required this.moduleType,
    required this.lessonId,
    required this.lessonNumber,
    required this.baseXpEarned,
    required this.moduleCompletionBonusXp,
    required this.nextLessonState,
    required this.menuScreen,
    this.scenarioId,
    this.nextLessonId,
    this.nextLessonNumber,
    this.nextLessonScreen,
  });

  final String learningArea;
  final String lessonAttemptId;
  final String cefrLevel;
  final String moduleType;
  final String lessonId;
  final int lessonNumber;
  final int baseXpEarned;
  final int moduleCompletionBonusXp;
  final String nextLessonState;
  final String menuScreen;
  final String? scenarioId;
  final String? nextLessonId;
  final int? nextLessonNumber;
  final String? nextLessonScreen;

  factory LessonCompletionAnalytics.fromOutcome({
    required ProgressSyncService sync,
    required String learningArea,
    required String lessonAttemptId,
    required String cefrLevel,
    required String moduleType,
    required String lessonId,
    required int lessonNumber,
    required int catalogueBaseXp,
    required String menuScreen,
    String? scenarioId,
    String? nextLessonScreen,
    bool includeModuleBonus = true,
  }) {
    final isNew = sync.lastLessonCompletionIsNew;
    return LessonCompletionAnalytics(
      learningArea: learningArea,
      lessonAttemptId: lessonAttemptId,
      cefrLevel: cefrLevel.toLowerCase(),
      moduleType: moduleType,
      lessonId: lessonId,
      lessonNumber: lessonNumber,
      baseXpEarned: isNew ? catalogueBaseXp : 0,
      moduleCompletionBonusXp:
          isNew && includeModuleBonus ? sync.lastModuleCompletionBonusXp : 0,
      nextLessonState: sync.lastNextLessonState,
      menuScreen: menuScreen,
      scenarioId: scenarioId,
      nextLessonId: sync.lastNextLessonId,
      nextLessonNumber: sync.lastNextLessonNumber,
      nextLessonScreen: nextLessonScreen,
    );
  }

  Map<String, Object?> _shared() => {
        AnalyticsParams.learningArea: learningArea,
        AnalyticsParams.lessonAttemptId: lessonAttemptId,
        AnalyticsParams.cefrLevel: cefrLevel,
        AnalyticsParams.moduleType: moduleType,
        AnalyticsParams.lessonId: lessonId,
        AnalyticsParams.lessonNumber: lessonNumber,
        AnalyticsParams.scenarioId: scenarioId,
      };

  void logViewed() {
    AnalyticsService.instance.logScreenView('lesson_completed');
    AnalyticsService.instance.log(AnalyticsEvents.lessonCompletionViewed, {
      ..._shared(),
      AnalyticsParams.baseXpEarned: baseXpEarned,
      AnalyticsParams.moduleCompletionBonusXp: moduleCompletionBonusXp,
      AnalyticsParams.nextLessonState: nextLessonState,
    });
  }

  /// The primary button is labelled Start Next Lesson and returns to the
  /// module menu (the next lesson is not pushed from this screen).
  void logStartNext() {
    AnalyticsService.instance.log(AnalyticsEvents.startNextLessonClicked, {
      ..._shared(),
      AnalyticsParams.currentLessonId: lessonId,
      AnalyticsParams.nextLessonId: nextLessonId,
      AnalyticsParams.nextLessonNumber: nextLessonNumber,
      AnalyticsParams.destinationScreen: nextLessonId == null
          ? menuScreen
          : (nextLessonScreen ?? menuScreen),
    });
  }

  void logClosed() {
    AnalyticsService.instance.log(AnalyticsEvents.lessonCompletionClosed, {
      ..._shared(),
      AnalyticsParams.destinationScreen: menuScreen,
    });
  }
}
