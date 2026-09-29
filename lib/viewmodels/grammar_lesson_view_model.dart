import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/lesson_completion_analytics.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/simple_uuid.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_complete_screen.dart';

class GrammarLessonViewModel extends ChangeNotifier {
  GrammarLessonViewModel({
    required this.lesson,
    required this.initialStepIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    required this.progressSyncService,
    required this.homeViewModel,
    required this.cefrLevel,
    required this.entryAction,
    this.onProgressChanged,
  }) : _currentStepIndex = initialStepIndex,
       lessonAttemptId = generateUuidV4() {
    AnalyticsService.instance.logScreenView('cefr_grammar_lesson');
    AnalyticsService.instance.log(AnalyticsEvents.cefrLessonStarted, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.cefrLevel: cefrLevel.toLowerCase(),
      AnalyticsParams.moduleType: 'grammar',
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lessonNumber: lesson.number,
      AnalyticsParams.entryAction: entryAction,
      AnalyticsParams.contentStepCount: totalSteps,
    });
    _logStepViewed();
  }

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final Future<List<String>> Function(GrammarLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;
  final ProgressSyncService progressSyncService;
  final HomeViewModel homeViewModel;
  final String cefrLevel;
  final String entryAction;
  final String lessonAttemptId;
  bool _completed = false;
  bool _exitLogged = false;

  int _currentStepIndex;
  int? _listeningExampleIndex;
  bool _isListening = false;
  bool _isCompleting = false;
  final Set<int> _practiceCorrectSteps = {};
  final Map<int, String> _practiceAnswers = {};
  final Map<int, String> _practiceWrongAnswers = {};

  /// True once "Finish Lesson" has been tapped and the completion write is
  /// in flight — guards against rapid extra taps queuing up multiple pushes
  /// of the completion screen.
  bool get isCompleting => _isCompleting;

  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => lesson.steps.length;

  String get _contentId => '${lesson.lessonId}_step_${_currentStepIndex + 1}';

  void _logStepViewed() {
    AnalyticsService.instance.log(AnalyticsEvents.lessonStepViewed, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.contentStepNumber: _currentStepIndex + 1,
      AnalyticsParams.contentStepCount: totalSteps,
      AnalyticsParams.contentId: _contentId,
    });
  }

  void logExit(String exitMethod) {
    if (_completed || _exitLogged) return;
    _exitLogged = true;
    AnalyticsService.instance.log(AnalyticsEvents.cefrLessonExited, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lastStepNumber: _currentStepIndex + 1,
      AnalyticsParams.exitMethod: exitMethod,
    });
  }
  GrammarStepModel get currentStep => lesson.steps[_currentStepIndex];

  double get lessonProgress => (_currentStepIndex + 1) / totalSteps;

  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _currentStepIndex >= totalSteps - 1;

  bool get canProceed {
    if (!currentStep.isPracticeStep) return true;
    return _practiceCorrectSteps.contains(_currentStepIndex);
  }

  /// True once the practice question has been answered CORRECTLY — a wrong
  /// guess shows a correction (via [practiceWrongFeedback]) but stays
  /// retry-able.
  bool get practiceAnswered =>
      _practiceCorrectSteps.contains(_currentStepIndex);

  String? get practiceSubmittedAnswer => _practiceAnswers[_currentStepIndex];

  String? practiceWrongFeedback(AppLocalizations l10n) {
    final wrong = _practiceWrongAnswers[_currentStepIndex];
    if (wrong == null) return null;
    final answer = currentStep.practiceAnswer;
    if (answer == null || answer.isEmpty) return null;
    return l10n.notQuiteCorrectAnswer(answer);
  }

  void checkPracticeAnswer(String value) {
    if (_practiceCorrectSteps.contains(_currentStepIndex)) return;
    final answer = currentStep.practiceAnswer ?? '';
    final isCorrect = _normalize(value) == _normalize(answer);
    if (isCorrect) {
      _practiceCorrectSteps.add(_currentStepIndex);
      _practiceAnswers[_currentStepIndex] = value.trim();
      _practiceWrongAnswers.remove(_currentStepIndex);
    } else if (_practiceWrongAnswers[_currentStepIndex] != value) {
      _practiceWrongAnswers[_currentStepIndex] = value;
      HapticFeedback.heavyImpact();
      unawaited(progressSyncService.recordCorrections(1));
      // Shared daily hearts: instant grammar correction (same pool as chat).
      if (!homeViewModel.hasUnlimitedHearts && homeViewModel.lives > 0) {
        unawaited(homeViewModel.useHeart());
      }
    }
    notifyListeners();
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'[.!?]+$'), '');

  bool isExampleListening(int exampleIndex) {
    return _isListening && _listeningExampleIndex == exampleIndex;
  }

  Future<void> listenExample(
    BuildContext context,
    GrammarExampleModel example,
    int exampleIndex,
  ) async {
    if (isExampleListening(exampleIndex)) {
      await textToSpeechService.stop();
      _clearListening();
      return;
    }

    final l10n = context.l10n;
    await textToSpeechService.stop();
    _listeningExampleIndex = exampleIndex;
    _isListening = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.grammarExampleAudioPlayed, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.contentStepNumber: _currentStepIndex + 1,
      AnalyticsParams.contentId: '${_contentId}_example_${exampleIndex + 1}',
    });

    final didSpeak = await textToSpeechService.speak(
      example.fullText,
      onComplete: _clearListening,
    );

    if (!didSpeak) {
      _clearListening();
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, l10n.listenUnavailable);
      }
      return;
    }

    if (context.mounted) {
      SnackbarHelper.showSuccess(context, l10n.playingWord(example.fullText));
    }
  }

  void _clearListening() {
    _isListening = false;
    _listeningExampleIndex = null;
    notifyListeners();
  }

  void previousStep() {
    if (isFirstStep) return;
    textToSpeechService.stop();
    _clearListening();
    _currentStepIndex--;
    onProgressChanged?.call(_currentStepIndex);
    _logStepViewed();
    notifyListeners();
  }

  Future<void> nextStep(BuildContext context) async {
    if (!canProceed) return;

    textToSpeechService.stop();
    _clearListening();

    if (isLastStep) {
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
            AnalyticsService.instance.log(AnalyticsEvents.cefrLessonCompleted, {
              AnalyticsParams.lessonAttemptId: lessonAttemptId,
              AnalyticsParams.cefrLevel: cefrLevel.toLowerCase(),
              AnalyticsParams.moduleType: 'grammar',
              AnalyticsParams.lessonId: lesson.lessonId,
              AnalyticsParams.lessonNumber: lesson.number,
              AnalyticsParams.baseXpEarned: LessonXpRewards.grammarLesson,
              AnalyticsParams.moduleCompletionBonusXp:
                  sync.lastModuleCompletionBonusXp,
              AnalyticsParams.nextLessonState: sync.lastNextLessonState,
            });
          }
          return GrammarLessonCompleteScreen(
            lesson: lesson,
            newlyUnlocked: unlocked,
            xpEarned: xpGranted,
            completionAnalytics: LessonCompletionAnalytics.fromOutcome(
              sync: sync,
              learningArea: 'cefr',
              lessonAttemptId: lessonAttemptId,
              cefrLevel: cefrLevel,
              moduleType: 'grammar',
              lessonId: lesson.lessonId,
              lessonNumber: lesson.number,
              catalogueBaseXp: LessonXpRewards.grammarLesson,
              menuScreen: 'cefr_grammar',
              nextLessonScreen: 'cefr_grammar_lesson',
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
    _currentStepIndex++;
    onProgressChanged?.call(_currentStepIndex);
    _logStepViewed();
    notifyListeners();
  }

  @override
  void dispose() {
    logExit('screen_closed');
    textToSpeechService.stop();
    super.dispose();
  }
}
