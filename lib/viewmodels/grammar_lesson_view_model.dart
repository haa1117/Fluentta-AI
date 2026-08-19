import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_complete_screen.dart';

class GrammarLessonViewModel extends ChangeNotifier {
  GrammarLessonViewModel({
    required this.lesson,
    required this.initialStepIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    this.onProgressChanged,
  }) : _currentStepIndex = initialStepIndex;

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final ValueChanged<GrammarLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;

  int _currentStepIndex;
  int? _listeningExampleIndex;
  bool _isListening = false;

  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => lesson.steps.length;
  GrammarStepModel get currentStep => lesson.steps[_currentStepIndex];

  double get lessonProgress => (_currentStepIndex + 1) / totalSteps;

  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _currentStepIndex >= totalSteps - 1;

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

  void nextStep(BuildContext context) {
    textToSpeechService.stop();
    _clearListening();

    if (isLastStep) {
      onLessonCompleted(lesson);
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => GrammarLessonCompleteScreen(lesson: lesson),
        ),
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
