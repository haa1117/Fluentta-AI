import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/lesson_completion_analytics.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:provider/provider.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/simple_uuid.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_dialogue_complete_screen.dart';

class RoleplayDialogueLessonViewModel extends ChangeNotifier {
  RoleplayDialogueLessonViewModel({
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    required this.scenarioId,
    required this.cefrLevel,
    required this.entryAction,
    this.onProgressChanged,
  }) : _currentPhaseIndex = initialPhaseIndex,
       lessonAttemptId = generateUuidV4() {
    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonStarted, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.scenarioId: scenarioId,
      AnalyticsParams.cefrLevel: cefrLevel,
      AnalyticsParams.moduleType: 'dialogue',
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lessonNumber: lesson.number,
      AnalyticsParams.entryAction: entryAction,
      AnalyticsParams.contentStepCount: totalPhases,
    });
    _logStepViewed();
  }

  final RoleplayDialogueLessonModel lesson;
  final int initialPhaseIndex;
  final Future<List<String>> Function(RoleplayDialogueLessonModel, String)
      onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;
  final String scenarioId;
  final String cefrLevel;
  final String entryAction;

  /// Correlates every analytics event of this lesson attempt. A fresh retry
  /// after exiting gets a new id (a new ViewModel instance is created).
  final String lessonAttemptId;

  int _currentPhaseIndex;
  int? _listeningLineIndex;
  bool _isListening = false;
  bool _isCompleting = false;
  int _autoSpeakToken = 0;
  bool _completed = false;
  bool _exitLogged = false;

  /// True once "Finish Lesson" has been tapped — guards against rapid extra
  /// taps queuing up multiple pushes of the completion screen.
  bool get isCompleting => _isCompleting;

  int get currentPhaseIndex => _currentPhaseIndex;
  int get totalPhases => lesson.phases.length;
  ReadingPhaseModel get currentPhase => lesson.phases[_currentPhaseIndex];

  double get lessonProgress => (_currentPhaseIndex + 1) / totalPhases;

  bool get isFirstPhase => _currentPhaseIndex == 0;
  bool get isLastPhase => _currentPhaseIndex >= totalPhases - 1;
  bool get canProceed => true;

  void _logStepViewed() {
    AnalyticsService.instance.log(AnalyticsEvents.lessonStepViewed, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.contentStepNumber: _currentPhaseIndex + 1,
      AnalyticsParams.contentStepCount: totalPhases,
    });
  }

  /// Logs `role_play_lesson_exited` once, unless the lesson already
  /// completed. Safe to call multiple times (e.g. explicit back tap followed
  /// by the PopScope callback for the same pop).
  void logExit(String exitMethod) {
    if (_completed || _exitLogged) return;
    _exitLogged = true;
    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonExited, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lastStepNumber: _currentPhaseIndex + 1,
      AnalyticsParams.exitMethod: exitMethod,
    });
  }

  bool isLineListening(int lineIndex) {
    return _isListening && _listeningLineIndex == lineIndex;
  }

  Future<void> listenLine(
    BuildContext context,
    ReadingDialogueLineModel line,
    int lineIndex,
  ) async {
    if (isLineListening(lineIndex)) {
      _autoSpeakToken++;
      await textToSpeechService.stop();
      _clearListening();
      return;
    }

    final l10n = context.l10n;
    _autoSpeakToken++;
    await textToSpeechService.stop();
    _listeningLineIndex = lineIndex;
    _isListening = true;
    notifyListeners();

    AnalyticsService.instance.log(AnalyticsEvents.dialogueAudioPlayed, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.contentStepNumber: _currentPhaseIndex + 1,
      AnalyticsParams.speakerRole: line.isUser ? 'learner' : 'scenario_character',
      AnalyticsParams.playbackSource: 'manual_play',
    });

    final didSpeak = await textToSpeechService.speak(
      line.text,
      onComplete: _clearListening,
    );

    if (!didSpeak) {
      _clearListening();
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, l10n.listenUnavailable);
      }
    }
  }

  void _clearListening() {
    _isListening = false;
    _listeningLineIndex = null;
    notifyListeners();
  }

  void previousPhase() {
    if (isFirstPhase) return;
    _cancelAutoSpeak();
    _currentPhaseIndex--;
    onProgressChanged?.call(_currentPhaseIndex);
    _logStepViewed();
    notifyListeners();
  }

  Future<void> nextPhase(BuildContext context) async {
    if (!canProceed) return;

    _cancelAutoSpeak();

    if (isLastPhase) {
      if (_isCompleting) return;
      _isCompleting = true;
      notifyListeners();
      await completeLessonAndNavigate(
        context: context,
        complete: () async {
          final unlocked = await onLessonCompleted(lesson, lessonAttemptId);
          _completed = true;
          return unlocked;
        },
        buildScreen: (unlocked, xpGranted) {
          final sync = context.read<ProgressSyncService>();
          return RoleplayDialogueCompleteScreen(
            lesson: lesson,
            newlyUnlocked: unlocked,
            xpEarned: xpGranted,
            scenarioId: scenarioId,
            cefrLevel: cefrLevel,
            completionAnalytics: LessonCompletionAnalytics.fromOutcome(
              sync: sync,
              learningArea: 'role_play',
              lessonAttemptId: lessonAttemptId,
              cefrLevel: cefrLevel,
              moduleType: 'dialogue',
              lessonId: lesson.lessonId,
              lessonNumber: lesson.number,
              catalogueBaseXp: RoleplayXpRewards.dialogue,
              menuScreen: 'role_play_dialogue',
              scenarioId: scenarioId,
              nextLessonScreen: 'role_play_dialogue_lesson',
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
    final previousLineCount = currentPhase.lines.length;
    _currentPhaseIndex++;
    onProgressChanged?.call(_currentPhaseIndex);
    _logStepViewed();
    notifyListeners();
    unawaited(_speakUpcomingLines(fromIndex: previousLineCount));
  }

  void _cancelAutoSpeak() {
    _autoSpeakToken++;
    textToSpeechService.stop();
    _clearListening();
  }

  Future<void> _speakUpcomingLines({required int fromIndex}) async {
    final token = ++_autoSpeakToken;
    final phaseIndex = _currentPhaseIndex;
    final lines = currentPhase.lines;
    final start = fromIndex.clamp(0, lines.length);
    if (start >= lines.length) return;

    for (var i = start; i < lines.length; i++) {
      if (token != _autoSpeakToken || _currentPhaseIndex != phaseIndex) {
        return;
      }
      _listeningLineIndex = i;
      _isListening = true;
      notifyListeners();
      AnalyticsService.instance.log(AnalyticsEvents.dialogueAudioPlayed, {
        AnalyticsParams.lessonAttemptId: lessonAttemptId,
        AnalyticsParams.lessonId: lesson.lessonId,
        AnalyticsParams.contentStepNumber: _currentPhaseIndex + 1,
        AnalyticsParams.speakerRole:
            lines[i].isUser ? 'learner' : 'scenario_character',
        AnalyticsParams.playbackSource: 'automatic',
      });
      final didSpeak = await textToSpeechService.speak(lines[i].text);
      if (!didSpeak) return;
    }

    if (token == _autoSpeakToken) {
      _clearListening();
    }
  }

  @override
  void dispose() {
    // Fallback for any disposal path that isn't the explicit back button or
    // the PopScope system-pop callback (e.g. the route being removed some
    // other way).
    logExit('screen_closed');
    _autoSpeakToken++;
    textToSpeechService.stop();
    super.dispose();
  }
}
