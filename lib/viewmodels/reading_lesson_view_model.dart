import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/views/reading/reading_lesson_complete_screen.dart';

class ReadingLessonViewModel extends ChangeNotifier {
  ReadingLessonViewModel({
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
  }) : _currentPhaseIndex = initialPhaseIndex;

  final ReadingLessonModel lesson;
  final int initialPhaseIndex;
  final ValueChanged<ReadingLessonModel> onLessonCompleted;

  int _currentPhaseIndex;

  int get currentPhaseIndex => _currentPhaseIndex;
  int get totalPhases => lesson.phases.length;
  ReadingPhaseModel get currentPhase => lesson.phases[_currentPhaseIndex];

  double get lessonProgress => (_currentPhaseIndex + 1) / totalPhases;

  bool get isFirstPhase => _currentPhaseIndex == 0;
  bool get isLastPhase => _currentPhaseIndex >= totalPhases - 1;

  void previousPhase() {
    if (isFirstPhase) return;
    _currentPhaseIndex--;
    notifyListeners();
  }

  void nextPhase(BuildContext context) {
    if (isLastPhase) {
      onLessonCompleted(lesson);
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => ReadingLessonCompleteScreen(lesson: lesson),
        ),
      );
      return;
    }
    _currentPhaseIndex++;
    notifyListeners();
  }
}
