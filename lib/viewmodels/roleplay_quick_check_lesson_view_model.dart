import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentta_ai/data/models/lesson_content_dto.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_complete_screen.dart';

class RoleplayQuickCheckLessonViewModel extends ChangeNotifier {
  RoleplayQuickCheckLessonViewModel({
    required this.lesson,
    required this.initialQuestionIndex,
    required this.onLessonCompleted,
    required this.progressSyncService,
    this.onProgressChanged,
  }) : _currentIndex = initialQuestionIndex;

  final RoleplayQuickCheckLessonModel lesson;
  final int initialQuestionIndex;
  final ValueChanged<RoleplayQuickCheckLessonModel> onLessonCompleted;
  final ProgressSyncService progressSyncService;
  final ValueChanged<int>? onProgressChanged;

  int _currentIndex;
  int? _selectedIndex;
  bool _answered = false;
  int? _lastWrongIndex;

  int get currentIndex => _currentIndex;
  int get totalQuestions => lesson.questions.length;
  int? get selectedIndex => _selectedIndex;
  bool get answered => _answered;
  bool get isFirstQuestion => _currentIndex == 0;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;

  double get lessonProgress => (_currentIndex + 1) / totalQuestions;

  ReadingQuestionModel get currentQuestion => lesson.questions[_currentIndex];

  String? get currentFeedback {
    if (_currentIndex >= lesson.feedbacks.length) return null;
    return lesson.feedbacks[_currentIndex];
  }

  String feedbackForSelection() {
    final dto = ReadingQuestionDto(
      prompt: currentQuestion.prompt,
      options: currentQuestion.options,
      correctIndex: currentQuestion.correctIndex,
      feedback: currentFeedback,
    );
    return dto.feedbackOrDefault();
  }

  bool get isSelectionCorrect =>
      _selectedIndex != null && _selectedIndex == currentQuestion.correctIndex;

  bool get hasWrongSelection =>
      _selectedIndex != null && !_answered && !isSelectionCorrect;

  String correctionFeedbackForSelection() {
    final correctAnswer =
        currentQuestion.options[currentQuestion.correctIndex];
    return 'Not quite. The correct answer is: $correctAnswer';
  }

  Future<void> _recordWrongAnswer(int optionIndex) async {
    if (_lastWrongIndex == optionIndex) return;
    _lastWrongIndex = optionIndex;
    HapticFeedback.heavyImpact();
    await progressSyncService.recordCorrections(1);
  }

  void selectOption(int index) {
    if (_answered) return;
    _selectedIndex = index;
    if (index == currentQuestion.correctIndex) {
      _answered = true;
      _lastWrongIndex = null;
    } else {
      unawaited(_recordWrongAnswer(index));
    }
    notifyListeners();
  }

  void previousQuestion() {
    if (isFirstQuestion) return;
    _currentIndex--;
    _resetQuestionState();
    notifyListeners();
  }

  Future<void> nextQuestion(BuildContext context) async {
    if (!_answered || !isSelectionCorrect) return;

    if (isLastQuestion) {
      onLessonCompleted(lesson);
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => RoleplayQuickCheckCompleteScreen(
            lessonNumber: lesson.number,
            lessonId: lesson.lessonId,
            completionSummary: lesson.completionSummary,
          ),
        ),
      );
      return;
    }

    _currentIndex++;
    onProgressChanged?.call(_currentIndex);
    _resetQuestionState();
    notifyListeners();
  }

  void _resetQuestionState() {
    _selectedIndex = null;
    _answered = false;
    _lastWrongIndex = null;
  }
}
