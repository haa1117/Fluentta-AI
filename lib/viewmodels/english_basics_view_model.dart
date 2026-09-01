import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/english_basics_repository.dart';
import 'package:fluentta_ai/views/english_basics/english_basics_flow.dart';

class EnglishBasicsViewModel extends ChangeNotifier {
  EnglishBasicsViewModel(this._localStorage, this._repository) {
    refresh();
  }

  final LocalStorage _localStorage;
  final EnglishBasicsRepository _repository;

  bool _isLoading = true;
  String _pathTitle = '';
  List<EnglishBasicsLessonModel> _lessons = [];
  EnglishBasicsLessonModel? _todaysLesson;
  double _trackProgress = 0;

  bool get isLoading => _isLoading;
  String get pathTitle => _pathTitle;
  List<EnglishBasicsLessonModel> get lessons => _lessons;
  EnglishBasicsLessonModel? get todaysLesson => _todaysLesson;
  double get trackProgress => _trackProgress;

  String get goalId => _localStorage.englishGoal ?? 'exam';

  bool get hasCompletedToday {
    final lesson = _todaysLesson;
    if (lesson == null) return false;
    return lesson.status == LearningLessonStatus.completed;
  }

  bool get canStartOrResume {
    final lesson = _todaysLesson;
    if (lesson == null) return false;
    return lesson.status != LearningLessonStatus.locked &&
        lesson.status != LearningLessonStatus.completed;
  }

  String get actionLabel {
    final lesson = _todaysLesson;
    if (lesson == null) return 'Start Lesson';
    return switch (lesson.status) {
      LearningLessonStatus.inProgress => 'Resume',
      LearningLessonStatus.completed => 'Completed',
      _ => 'Start Lesson',
    };
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    final track = await _repository.loadTrack(goalId);
    _pathTitle = track.pathTitle;
    _lessons = await _repository.buildLessons(goalId);
    _todaysLesson = await _repository.getTodaysLesson(goalId);
    _trackProgress = await _repository.trackProgress(goalId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> openLessonFlow(BuildContext context) async {
    final lesson = _todaysLesson;
    if (lesson == null || !canStartOrResume) return;

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _repository.recordLessonStarted(
        goalId: goalId,
        lessonId: lesson.lessonId,
      );
    }

    if (!context.mounted) return;

    await EnglishBasicsFlow.open(
      context: context,
      goalId: goalId,
      lesson: lesson,
      repository: _repository,
      onFinished: refresh,
    );
  }
}
