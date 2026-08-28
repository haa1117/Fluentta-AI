import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
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
  final Future<void> Function(ReadingLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;
  final ProgressSyncService progressSyncService;

  int _currentPhaseIndex;
  int? _selectedOptionIndex;
  int? _listeningLineIndex;
  bool _isListening = false;

  int get currentPhaseIndex => _currentPhaseIndex;
  int get totalPhases => lesson.phases.length;
  ReadingPhaseModel get currentPhase => lesson.phases[_currentPhaseIndex];
  int? get selectedOptionIndex => _selectedOptionIndex;

  double get lessonProgress => (_currentPhaseIndex + 1) / totalPhases;

  bool get isFirstPhase => _currentPhaseIndex == 0;
  bool get isLastPhase => _currentPhaseIndex >= totalPhases - 1;

  bool get canProceed {
    if (!currentPhase.isQuestionPhase) return true;
    return _selectedOptionIndex != null;
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
    final question = currentPhase.question;
    if (currentPhase.isQuestionPhase &&
        question != null &&
        index != question.correctIndex) {
      unawaited(progressSyncService.recordCorrections(1));
    }
    _selectedOptionIndex = index;
    notifyListeners();
  }

  void previousPhase() {
    if (isFirstPhase) return;
    textToSpeechService.stop();
    _clearListening();
    _currentPhaseIndex--;
    _selectedOptionIndex = null;
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  Future<void> nextPhase(BuildContext context) async {
    if (!canProceed) return;

    textToSpeechService.stop();
    _clearListening();

    if (isLastPhase) {
      await onLessonCompleted(lesson);
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => ReadingLessonCompleteScreen(lesson: lesson),
        ),
      );
      return;
    }
    _currentPhaseIndex++;
    _selectedOptionIndex = null;
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    textToSpeechService.stop();
    super.dispose();
  }
}
