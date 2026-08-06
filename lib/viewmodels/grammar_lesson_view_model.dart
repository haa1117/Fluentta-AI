import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_complete_screen.dart';

class GrammarLessonViewModel extends ChangeNotifier {
  GrammarLessonViewModel({
    required this.lesson,
    required this.initialStepIndex,
    required this.onLessonCompleted,
  }) : _currentStepIndex = initialStepIndex;

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final ValueChanged<GrammarLessonModel> onLessonCompleted;

  int _currentStepIndex;

  int get currentStepIndex => _currentStepIndex;
  int get totalSteps => lesson.steps.length;
  GrammarStepModel get currentStep => lesson.steps[_currentStepIndex];

  double get lessonProgress => (_currentStepIndex + 1) / totalSteps;

  bool get isFirstStep => _currentStepIndex == 0;
  bool get isLastStep => _currentStepIndex >= totalSteps - 1;

  void previousStep() {
    if (isFirstStep) return;
    _currentStepIndex--;
    notifyListeners();
  }

  void nextStep(BuildContext context) {
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
    notifyListeners();
  }
}
