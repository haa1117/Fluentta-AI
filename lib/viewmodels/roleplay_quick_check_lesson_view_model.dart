import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/lesson_completion_analytics.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/utils/simple_uuid.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/data/models/lesson_content_dto.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_complete_screen.dart';

class RoleplayQuickCheckLessonViewModel extends ChangeNotifier {
  RoleplayQuickCheckLessonViewModel({
    required this.lesson,
    required this.initialQuestionIndex,
    required this.onLessonCompleted,
    required this.progressSyncService,
    required this.scenarioId,
    required this.cefrLevel,
    required this.entryAction,
    this.onProgressChanged,
  }) : _currentIndex = initialQuestionIndex,
       lessonAttemptId = generateUuidV4() {
    AnalyticsService.instance.logScreenView('role_play_comprehension_lesson');
    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonStarted, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.scenarioId: scenarioId,
      AnalyticsParams.cefrLevel: cefrLevel.toLowerCase(),
      AnalyticsParams.moduleType: 'comprehension',
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lessonNumber: lesson.number,
      AnalyticsParams.entryAction: entryAction,
      AnalyticsParams.contentStepCount: totalQuestions,
    });
    _logStepViewed();
  }

  final RoleplayQuickCheckLessonModel lesson;
  final int initialQuestionIndex;
  final Future<List<String>> Function(RoleplayQuickCheckLessonModel)
      onLessonCompleted;
  final ProgressSyncService progressSyncService;
  final String scenarioId;
  final String cefrLevel;
  final String entryAction;
  final String lessonAttemptId;
  final ValueChanged<int>? onProgressChanged;
  bool _completed = false;
  bool _exitLogged = false;
  int _incorrectAnswerCount = 0;
  final Map<int, int> _attemptsByQuestion = {};

  int _currentIndex;
  int? _selectedIndex;
  bool _answered = false;
  int? _lastWrongIndex;
  bool _isCompleting = false;

  /// True once the final question's continue has been tapped — guards
  /// against rapid extra taps queuing up multiple pushes of the completion
  /// screen.
  bool get isCompleting => _isCompleting;

  int get currentIndex => _currentIndex;
  int get totalQuestions => lesson.questions.length;
  int? get selectedIndex => _selectedIndex;
  bool get answered => _answered;
  bool get isFirstQuestion => _currentIndex == 0;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;

  double get lessonProgress => (_currentIndex + 1) / totalQuestions;

  ReadingQuestionModel get currentQuestion => lesson.questions[_currentIndex];

  String get _questionId => '${lesson.lessonId}_q_${_currentIndex + 1}';

  void _logStepViewed() {
    AnalyticsService.instance.log(AnalyticsEvents.lessonStepViewed, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.contentStepNumber: _currentIndex + 1,
      AnalyticsParams.contentStepCount: totalQuestions,
      AnalyticsParams.questionId: _questionId,
    });
  }

  void logExit(String exitMethod) {
    if (_completed || _exitLogged) return;
    _exitLogged = true;
    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonExited, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lastStepNumber: _currentIndex + 1,
      AnalyticsParams.incorrectAnswerCount: _incorrectAnswerCount,
      AnalyticsParams.exitMethod: exitMethod,
    });
  }

  String? get currentFeedback {
    if (_currentIndex >= lesson.feedbacks.length) return null;
    return lesson.feedbacks[_currentIndex];
  }

  String feedbackForSelection() {
    final dto = ReadingQuestionDto(
      prompt: currentQuestion.prompt,
      options: currentQuestion.options,
      correctIndex: currentQuestion.correctIndex,
      feedback: currentFeedback,
    );
    return dto.feedbackOrDefault();
  }

  bool get isSelectionCorrect =>
      _selectedIndex != null && _selectedIndex == currentQuestion.correctIndex;

  bool get hasWrongSelection =>
      _selectedIndex != null && !_answered && !isSelectionCorrect;

  String correctionFeedbackForSelection() {
    final correctAnswer =
        currentQuestion.options[currentQuestion.correctIndex];
    return 'Not quite. The correct answer is: $correctAnswer';
  }

  Future<void> _recordWrongAnswer(int optionIndex) async {
    if (_lastWrongIndex == optionIndex) return;
    _lastWrongIndex = optionIndex;
    HapticFeedback.heavyImpact();
    await progressSyncService.recordCorrections(1);
  }

  void selectOption(int index) {
    if (_answered) return;
    _selectedIndex = index;
    final attempt = (_attemptsByQuestion[_currentIndex] ?? 0) + 1;
    _attemptsByQuestion[_currentIndex] = attempt;
    final correct = index == currentQuestion.correctIndex;
    AnalyticsService.instance.log(AnalyticsEvents.comprehensionAnswerSubmitted, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.questionId: _questionId,
      AnalyticsParams.contentStepNumber: _currentIndex + 1,
      AnalyticsParams.answerOptionId: 'option_$index',
      AnalyticsParams.answerResult: correct ? 'correct' : 'incorrect',
      AnalyticsParams.attemptNumber: attempt,
    });
    if (correct) {
      _answered = true;
      _lastWrongIndex = null;
    } else {
      _incorrectAnswerCount++;
      AnalyticsService.instance.log(
        AnalyticsEvents.comprehensionGuidanceViewed,
        {
          AnalyticsParams.lessonAttemptId: lessonAttemptId,
          AnalyticsParams.lessonId: lesson.lessonId,
          AnalyticsParams.questionId: _questionId,
          AnalyticsParams.contentStepNumber: _currentIndex + 1,
          AnalyticsParams.attemptNumber: attempt,
        },
      );
      unawaited(_recordWrongAnswer(index));
    }
    notifyListeners();
  }

  void previousQuestion() {
    if (isFirstQuestion) return;
    _currentIndex--;
    _resetQuestionState();
    _logStepViewed();
    notifyListeners();
  }

  Future<void> nextQuestion(BuildContext context) async {
    if (!_answered || !isSelectionCorrect) return;

    if (isLastQuestion) {
      if (_isCompleting) return;
      _isCompleting = true;
      notifyListeners();
      await completeLessonAndNavigate(
        context: context,
        complete: () => onLessonCompleted(lesson),
        buildScreen: (unlocked, xpGranted) {
          _completed = true;
          final sync = context.read<ProgressSyncService>();
          if (sync.lastLessonCompletionIsNew) {
            AnalyticsService.instance.log(
              AnalyticsEvents.rolePlayLessonCompleted,
              {
                AnalyticsParams.lessonAttemptId: lessonAttemptId,
                AnalyticsParams.scenarioId: scenarioId,
                AnalyticsParams.cefrLevel: cefrLevel.toLowerCase(),
                AnalyticsParams.moduleType: 'comprehension',
                AnalyticsParams.lessonId: lesson.lessonId,
                AnalyticsParams.lessonNumber: lesson.number,
                AnalyticsParams.baseXpEarned: RoleplayXpRewards.comprehension,
                AnalyticsParams.incorrectAnswerCount: _incorrectAnswerCount,
                AnalyticsParams.nextLessonState: sync.lastNextLessonState,
              },
            );
          }
          return RoleplayQuickCheckCompleteScreen(
            lessonNumber: lesson.number,
            lessonId: lesson.lessonId,
            completionSummary: lesson.completionSummary,
            newlyUnlocked: unlocked,
            xpEarned: xpGranted,
            completionAnalytics: LessonCompletionAnalytics.fromOutcome(
              sync: sync,
              learningArea: 'role_play',
              lessonAttemptId: lessonAttemptId,
              cefrLevel: cefrLevel,
              moduleType: 'comprehension',
              lessonId: lesson.lessonId,
              lessonNumber: lesson.number,
              catalogueBaseXp: RoleplayXpRewards.comprehension,
              menuScreen: 'role_play_comprehension',
              scenarioId: scenarioId,
              nextLessonScreen: 'role_play_comprehension_lesson',
              includeModuleBonus: false,
            ),
          );
        },
        onFailed: () {
          _isCompleting = false;
          notifyListeners();
        },
      );
      return;
    }

    _currentIndex++;
    onProgressChanged?.call(_currentIndex);
    _resetQuestionState();
    _logStepViewed();
    notifyListeners();
  }

  void _resetQuestionState() {
    _selectedIndex = null;
    _answered = false;
    _lastWrongIndex = null;
  }

  @override
  void dispose() {
    logExit('screen_closed');
    super.dispose();
  }
}
