import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/lesson_content_dto.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_complete_screen.dart';

class RoleplayQuickCheckLessonViewModel extends ChangeNotifier {
  RoleplayQuickCheckLessonViewModel({
    required this.lesson,
    required this.initialQuestionIndex,
    required this.onLessonCompleted,
    this.onProgressChanged,
  }) : _currentIndex = initialQuestionIndex;

  final RoleplayQuickCheckLessonModel lesson;
  final int initialQuestionIndex;
  final ValueChanged<RoleplayQuickCheckLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  int _currentIndex;
  int? _selectedIndex;
  bool _answered = false;

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

  void selectOption(int index) {
    if (_answered) return;
    _selectedIndex = index;
    if (index == currentQuestion.correctIndex) {
      _answered = true;
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
            lessonTitle: lesson.title,
            questionCount: totalQuestions,
            completionTitle: lesson.completionTitle,
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
  }
}
