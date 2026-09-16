import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_complete_screen.dart';

class GrammarLessonViewModel extends ChangeNotifier {
  GrammarLessonViewModel({
    required this.lesson,
    required this.initialStepIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    required this.progressSyncService,
    this.onProgressChanged,
  }) : _currentStepIndex = initialStepIndex;

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final Future<List<String>> Function(GrammarLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;
  final ProgressSyncService progressSyncService;

  int _currentStepIndex;
  int? _listeningExampleIndex;
  bool _isListening = false;
  bool _isCompleting = false;
  bool _practiceAnswered = false;
  String? _lastWrongAnswer;

  /// True once "Finish Lesson" has been tapped and the completion write is
  /// in flight — guards against rapid extra taps queuing up multiple pushes
  /// of the completion screen.
  bool get isCompleting => _isCompleting;

  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => lesson.steps.length;
  GrammarStepModel get currentStep => lesson.steps[_currentStepIndex];

  double get lessonProgress => (_currentStepIndex + 1) / totalSteps;

  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _currentStepIndex >= totalSteps - 1;

  bool get canProceed {
    if (!currentStep.isPracticeStep) return true;
    return _practiceAnswered;
  }

  /// True once the practice question has been answered CORRECTLY — a wrong
  /// guess shows a correction (via [practiceWrongFeedback]) but stays
  /// retry-able.
  bool get practiceAnswered => _practiceAnswered;

  String? practiceWrongFeedback(AppLocalizations l10n) {
    if (_lastWrongAnswer == null) return null;
    final answer = currentStep.practiceAnswer;
    if (answer == null || answer.isEmpty) return null;
    return l10n.notQuiteCorrectAnswer(answer);
  }

  void checkPracticeAnswer(String value) {
    if (_practiceAnswered) return;
    final answer = currentStep.practiceAnswer ?? '';
    final isCorrect = _normalize(value) == _normalize(answer);
    if (isCorrect) {
      _practiceAnswered = true;
      _lastWrongAnswer = null;
    } else if (_lastWrongAnswer != value) {
      _lastWrongAnswer = value;
      HapticFeedback.heavyImpact();
      unawaited(progressSyncService.recordCorrections(1));
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
        buildScreen: (unlocked) => GrammarLessonCompleteScreen(
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
    _currentStepIndex++;
    onProgressChanged?.call(_currentStepIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    textToSpeechService.stop();
    super.dispose();
  }
}
