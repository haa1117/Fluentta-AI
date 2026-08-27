import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
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
  final ValueChanged<RoleplayDialogueLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;

  int _currentPhaseIndex;
  int? _listeningLineIndex;
  bool _isListening = false;

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

  void previousPhase() {
    if (isFirstPhase) return;
    textToSpeechService.stop();
    _clearListening();
    _currentPhaseIndex--;
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  void nextPhase(BuildContext context) {
    if (!canProceed) return;

    textToSpeechService.stop();
    _clearListening();

    if (isLastPhase) {
      onLessonCompleted(lesson);
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => RoleplayDialogueCompleteScreen(lesson: lesson),
        ),
      );
      return;
    }
    _currentPhaseIndex++;
    onProgressChanged?.call(_currentPhaseIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    textToSpeechService.stop();
    super.dispose();
  }
}
