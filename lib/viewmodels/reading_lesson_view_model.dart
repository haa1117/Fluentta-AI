import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/reading/reading_lesson_complete_screen.dart';

class ReadingLessonViewModel extends ChangeNotifier {
  ReadingLessonViewModel({
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    required this.progressSyncService,
    this.onProgressChanged,
  }) : _currentPhaseIndex = initialPhaseIndex;

  final ReadingLessonModel lesson;
  final int initialPhaseIndex;
  final Future<List<String>> Function(ReadingLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;
  final ProgressSyncService progressSyncService;

  int _currentPhaseIndex;
  int? _selectedOptionIndex;
  int? _listeningLineIndex;
  bool _isListening = false;
  bool _isCompleting = false;
  bool _answered = false;
  int? _lastWrongIndex;

  /// True once "Finish Lesson" has been tapped and the completion write is
  /// in flight — guards against a slow await letting rapid extra taps queue
  /// up multiple pushes of the completion screen.
  bool get isCompleting => _isCompleting;

  int get currentPhaseIndex => _currentPhaseIndex;
  int get totalPhases => lesson.phases.length;
  ReadingPhaseModel get currentPhase => lesson.phases[_currentPhaseIndex];
  int? get selectedOptionIndex => _selectedOptionIndex;

  /// True once the CORRECT option has been picked for the current question
  /// — a wrong pick shows a correction below but stays retry-able rather
  /// than locking the question.
  bool get answered => _answered;

  bool get isSelectionCorrect {
    final question = currentPhase.question;
    return _selectedOptionIndex != null &&
        question != null &&
        _selectedOptionIndex == question.correctIndex;
  }

  bool get hasWrongSelection =>
      _selectedOptionIndex != null && !_answered && !isSelectionCorrect;

  String correctionFeedbackForSelection(AppLocalizations l10n) {
    final question = currentPhase.question;
    if (question == null) return '';
    return l10n.notQuiteCorrectAnswer(question.options[question.correctIndex]);
  }

  /// 1-based position of the current question among this lesson's
  /// comprehension questions (for the "Question N" badge).
  int get questionNumber => lesson.phases
      .take(_currentPhaseIndex + 1)
      .where((p) => p.isQuestionPhase)
      .length;

  double get lessonProgress => (_currentPhaseIndex + 1) / totalPhases;

  bool get isFirstPhase => _currentPhaseIndex == 0;
  bool get isLastPhase => _currentPhaseIndex >= totalPhases - 1;

  bool get canProceed {
    if (!currentPhase.isQuestionPhase) return true;
    return _answered;
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
      await textToSpeechService.stop();
      _clearListening();
      return;
    }

    final l10n = context.l10n;
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

  void selectOption(int index) {
    if (_answered) return;
    final question = currentPhase.question;
    _selectedOptionIndex = index;
    if (question != null && index == question.correctIndex) {
      _answered = true;
      _lastWrongIndex = null;
    } else {
      unawaited(_recordWrongAnswer(index));
    }
    notifyListeners();
  }

  Future<void> _recordWrongAnswer(int optionIndex) async {
    if (_lastWrongIndex == optionIndex) return;
    _lastWrongIndex = optionIndex;
    HapticFeedback.heavyImpact();
    await progressSyncService.recordCorrections(1);
  }

  void _resetQuestionState() {
    _selectedOptionIndex = null;
    _answered = false;
    _lastWrongIndex = null;
  }

  void previousPhase() {
    if (isFirstPhase) return;
    textToSpeechService.stop();
    _clearListening();
    _currentPhaseIndex--;
    _resetQuestionState();
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  Future<void> nextPhase(BuildContext context) async {
    if (!canProceed) return;

    textToSpeechService.stop();
    _clearListening();

    if (isLastPhase) {
      if (_isCompleting) return;
      _isCompleting = true;
      notifyListeners();
      await completeLessonAndNavigate(
        context: context,
        complete: () => onLessonCompleted(lesson),
        buildScreen: (unlocked) => ReadingLessonCompleteScreen(
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
    _currentPhaseIndex++;
    _resetQuestionState();
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    textToSpeechService.stop();
    super.dispose();
  }
}
