import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
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
    this.onProgressChanged,
  }) : _currentPhaseIndex = initialPhaseIndex;

  final RoleplayDialogueLessonModel lesson;
  final int initialPhaseIndex;
  final Future<List<String>> Function(RoleplayDialogueLessonModel)
      onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;

  int _currentPhaseIndex;
  int? _listeningLineIndex;
  bool _isListening = false;
  bool _isCompleting = false;
  int _autoSpeakToken = 0;

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
        complete: () => onLessonCompleted(lesson),
        buildScreen: (unlocked) => RoleplayDialogueCompleteScreen(
          lesson: lesson,
          newlyUnlocked: unlocked,
        ),
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
      final didSpeak = await textToSpeechService.speak(lines[i].text);
      if (!didSpeak) return;
    }

    if (token == _autoSpeakToken) {
      _clearListening();
    }
  }

  @override
  void dispose() {
    _autoSpeakToken++;
    textToSpeechService.stop();
    super.dispose();
  }
}
